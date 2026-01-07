sap.ui.define([
    "sap/ui/core/mvc/Controller",
    "sap/ui/core/UIComponent"
],
    /**
     * @param {typeof sap.ui.core.mvc.Controller} Controller
     */
    function (Controller, UIComponent) {
        "use strict";

        return Controller.extend("com.procurement.ui.controller.Home", {
            onInit: function () {

            },

            onPressCatalog: function () {
                var oRouter = UIComponent.getRouterFor(this);
                // Navigate to the same view ("RouteManualPR") but pass mode="catalog"
                oRouter.navTo("RouteManualPR", {
                    mode: "catalog"
                });
            },

            onPressManual: function () {
                var oRouter = UIComponent.getRouterFor(this);
                // Navigate to the same view ("RouteManualPR") but pass mode="manual"
                oRouter.navTo("RouteManualPR", {
                    mode: "manual"
                });
            },

            onPressHistory: function () {
                var oRouter = UIComponent.getRouterFor(this);
                oRouter.navTo("RouteRequisitionList");
            },

            onPressManager: function () {
                var oRouter = UIComponent.getRouterFor(this);
                oRouter.navTo("RouteManagerApprovals");
            }
        });
    }
);
