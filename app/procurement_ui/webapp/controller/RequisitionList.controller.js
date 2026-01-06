sap.ui.define([
    "sap/ui/core/mvc/Controller",
    "sap/ui/core/UIComponent",
    "sap/ui/core/routing/History",
    "sap/m/MessageBox",
    "sap/m/MessageToast",
    "com/procurement/ui/model/formatter"
], function (Controller, UIComponent, History, MessageBox, MessageToast, formatter) {
    "use strict";

    return Controller.extend("com.procurement.ui.controller.RequisitionList", {
        formatter: formatter,

        onInit: function () {
            var oRouter = UIComponent.getRouterFor(this);
            oRouter.getRoute("RouteRequisitionList").attachPatternMatched(this._onObjectMatched, this);

            // Model for UI state (stock status per requisition)
            this.getView().setModel(new sap.ui.model.json.JSONModel({ stockStatus: {} }), "ui");
        },

        _onObjectMatched: function () {
            var oTable = this.byId("requisitionTable");
            if (oTable && oTable.getBinding("items")) {
                oTable.getBinding("items").refresh();
            }
            this._checkStockAvailability();
        },

        _checkStockAvailability: function () {
            // 1. Fetch Warehouse Data
            var oModel = this.getOwnerComponent().getModel();
            var oBindList = oModel.bindList("/Warehouse");

            oBindList.requestContexts().then(function (aWarehouseContexts) {
                var aWarehouseItems = aWarehouseContexts.map(ctx => ctx.getObject());

                // 2. Iterate over Table Items (we need to wait for them to load if not loaded)
                // For V4, we might need to query the headers again or rely on the table current view.
                // Let's hook into the table's "updateFinished" event in the view ideally, but here manual call.

                var oTable = this.byId("requisitionTable");
                var aItems = oTable.getItems();

                aItems.forEach(function (oItem) {
                    var oContext = oItem.getBindingContext();
                    if (!oContext) return;

                    var oReq = oContext.getObject();
                    // We need the sub-items. V4 context.getObject() might not have them if not expanded deep or loaded.
                    // If expanded, it should be there.

                    if (oReq.status === 'Approved') {
                        // Check items
                        // Note: V4 getObject() return structure depends on system. 
                        // If 'items' is a deferred structure, we might need requestObject().

                        oContext.requestObject().then(function (oFullReq) {
                            var bAllInStock = true;
                            var aReqItems = oFullReq.items || [];

                            if (aReqItems.length === 0) bAllInStock = false; // Empty?

                            aReqItems.forEach(function (reqItem) {
                                var oStock = aWarehouseItems.find(w => w.productName === reqItem.materialName); // Match by name
                                if (!oStock || oStock.quantity < reqItem.quantity) {
                                    bAllInStock = false;
                                }
                            });

                            // Update UI Model
                            // We need a unique key. requisitionHeaderID is unique.
                            // But binding path in XML is ${ui>stockStatus} which is simple property.
                            // Complex binding with keys is hard in XML without formatter.
                            // WORKAROUND: We will bind the Button visible property to a path that includes the ID,
                            // OR we assume we can set a property on a Client JSON 'vm' model map.
                            // Let's use the BindingContext of the row to attach a transient view model? No.
                            // Let's use the ID map.

                            // Actually, simpler:
                            var sStatus = bAllInStock ? "InStock" : "OutOfStock";
                            // We need to set this specific row's mode. 
                            // We can extend the JSON model to have keys matching the ID.
                            // ui>/stockStatus/PR-123 = 'InStock'

                            var oUiModel = this.getView().getModel("ui");
                            oUiModel.setProperty("/stockStatus/" + oReq.requisitionHeaderID, sStatus);

                        }.bind(this));
                    }
                }.bind(this));

            }.bind(this));
        },

        onNavBack: function () {
            var oHistory = History.getInstance();
            var sPreviousHash = oHistory.getPreviousHash();

            if (sPreviousHash !== undefined) {
                window.history.go(-1);
            } else {
                var oRouter = UIComponent.getRouterFor(this);
                oRouter.navTo("RouteHome", {}, true);
            }
        },

        onPressRequisition: function (oEvent) {
            var oItem = oEvent.getSource();
            var oContext = oItem.getBindingContext();
            var sID = oContext.getProperty("ID"); // Get the UUID

            var oRouter = UIComponent.getRouterFor(this);
            oRouter.navTo("RoutePRDetails", {
                requisitionId: sID
            });
        },

        onEditRequisition: function (oEvent) {
            // Re-use logic to go to details, maybe passing a flag in future?
            // For now, same as press.
            var oItem = oEvent.getSource();
            var oContext = oItem.getBindingContext();
            var sID = oContext.getProperty("ID");

            var oRouter = UIComponent.getRouterFor(this);
            oRouter.navTo("RoutePRDetails", {
                requisitionId: sID
            });
        },

        onDeleteRequisition: function (oEvent) {
            var oItem = oEvent.getSource();
            var oContext = oItem.getBindingContext();
            // var sRequisitionID = oContext.getProperty("requisitionHeaderID");

            MessageBox.confirm("Are you sure you want to delete this requisition?", {
                onClose: function (sAction) {
                    if (sAction === MessageBox.Action.OK) {
                        oContext.delete().then(function () {
                            MessageToast.show("Requisition deleted successfully.");
                        }).catch(function (oError) {
                            MessageBox.error("Error deleting requisition: " + oError.message);
                        });
                    }
                }
            });
        },

        onGeneratePO: function () {
            MessageToast.show("Generate Purchase Order: Under Construction");
        },

        onGoodsIssue: function () {
            MessageToast.show("Goods Issue for Warehouse: Under Construction");
        }
    });
});
