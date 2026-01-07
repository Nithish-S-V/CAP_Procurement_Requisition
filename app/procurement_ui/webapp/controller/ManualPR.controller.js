sap.ui.define([
    "sap/ui/core/mvc/Controller",
    "sap/ui/core/UIComponent",
    "sap/ui/model/json/JSONModel",
    "sap/ui/core/routing/History",
    "sap/m/MessageToast"
],
    /**
     * @param {typeof sap.ui.core.mvc.Controller} Controller
     */
    function (Controller, UIComponent, JSONModel, History, MessageToast) {
        "use strict";

        return Controller.extend("com.procurement.ui.controller.ManualPR", {
            onInit: function () {
                var oRouter = UIComponent.getRouterFor(this);
                // We need to listen to the route match to capture arguments
                oRouter.getRoute("RouteManualPR").attachPatternMatched(this._onObjectMatched, this);

                var oViewModel = new JSONModel({
                    currencyCode: "USD",
                    isManual: true, // Default
                    selectedMaterialID: null
                });
                this.getView().setModel(oViewModel, "viewModel"); // Changed from "view" to match XML usage

                var oFormModel = new JSONModel({
                    materialName: "",
                    quantity: 1,
                    price: null,
                    vendor: ""
                });
                this.getView().setModel(oFormModel, "form");
            },

            _onObjectMatched: function (oEvent) {
                var oArgs = oEvent.getParameter("arguments");
                var sMode = oArgs.mode || "manual"; // Default to manual if not provided

                var oViewModel = this.getView().getModel("viewModel");
                oViewModel.setProperty("/isManual", sMode === "manual");

                // Reset form on entry
                this._resetForm();
            },

            onMaterialSelect: function (oEvent) {
                var oItem = oEvent.getParameter("selectedItem");
                if (!oItem) return;

                var oContext = oItem.getBindingContext();
                // We need to request the object if using OData V4 list binding, 
                // but ComboBox list binding usually loads data. 
                // Let's assume standard synchronous access or promise if V4 context.

                // V4 Context:
                var oData = oContext.getObject();

                // If getObject() returns undefined (V4 sometimes), we might need requestObject().
                if (!oData) {
                    oContext.requestObject().then(function (oObj) {
                        this._fillCatalogItem(oObj);
                    }.bind(this));
                } else {
                    this._fillCatalogItem(oData);
                }
            },

            _fillCatalogItem: function (oData) {
                var oFormModel = this.getView().getModel("form");
                var oViewModel = this.getView().getModel("viewModel");

                // Update Form
                oFormModel.setProperty("/materialName", oData.description);

                // Auto-fill and lock price (assuming some standard price exists, else default)
                // Schema for 'Materials' doesn't have price. 
                // Let's assume a default or fetch from Catalog tables if linked.
                // For now, allow edit or set dummy.
                oFormModel.setProperty("/price", 100.00); // Dummy default for catalog

                this.byId("priceInput").setEditable(false);

                oViewModel.setProperty("/selectedMaterialID", oData.ID);
            },

            onManualInputChange: function (oEvent) {
                var sText = oEvent.getParameter("value");
                var oViewModel = this.getView().getModel("viewModel");

                this.byId("priceInput").setEditable(true);
                oViewModel.setProperty("/selectedMaterialID", null);
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

            onAddToRequest: function () {
                var oFormModel = this.getView().getModel("form");
                var oViewModel = this.getView().getModel("viewModel");
                var oData = oFormModel.getData();

                // Validate
                if (!oData.materialName || !oData.quantity || !oData.price) {
                    MessageToast.show("Please fill in all required fields.");
                    return;
                }

                var oCartModel = this.getOwnerComponent().getModel("cart");
                if (!oCartModel.getProperty("/items")) {
                    oCartModel.setProperty("/items", []);
                }

                var aItems = oCartModel.getProperty("/items") || [];
                var sMaterialID = oViewModel.getProperty("/selectedMaterialID");
                var bIsManual = oViewModel.getProperty("/isManual");

                // Add to cart with new array ref
                var aNewItems = aItems.concat([{
                    productId: sMaterialID ? sMaterialID : "MANUAL-" + Date.now(),
                    productName: oData.materialName, // Maps to materialDescription
                    description: (bIsManual ? "Manual Entry: " : "Catalog Item: ") + oData.materialName,
                    price: parseFloat(oData.price),
                    quantity: parseInt(oData.quantity),
                    costCenter: "",
                    vendorId: oData.vendor || "33300002",
                    type: bIsManual ? 'Manual' : 'Catalog',
                    material_ID: sMaterialID // Store association ID
                }]);

                oCartModel.setProperty("/items", aNewItems);

                // Update total
                var fTotal = 0;
                aNewItems.forEach(function (item) {
                    fTotal += (parseFloat(item.price) * item.quantity);
                });
                oCartModel.setProperty("/total", fTotal.toFixed(2));

                MessageToast.show("Added item to request.");
                this._resetForm();
            },

            _resetForm: function () {
                var oFormModel = this.getView().getModel("form");
                var oViewModel = this.getView().getModel("viewModel");

                oFormModel.setData({
                    materialName: "",
                    quantity: 1,
                    price: null,
                    vendor: ""
                });

                oViewModel.setProperty("/selectedMaterialID", null);

                // Reset UI state
                var oPriceInput = this.byId("priceInput");
                if (oPriceInput) oPriceInput.setEditable(true);
            },

            onGoToCart: function () {
                var oRouter = UIComponent.getRouterFor(this);
                oRouter.navTo("RouteReview");
            }
        });
    }
);
