using { Procurement_Requisition as my } from '../db/schema.cds';

@path: '/service/procurement_Requisition'
@requires: 'authenticated-user'
service procurement_RequisitionSrv {
  @odata.draft.enabled
  @odata.draft.bypass
  entity RequisitionHeader as projection on my.RequisitionHeader;
  entity RequisitionItem as projection on my.RequisitionItem;
  @odata.draft.enabled
  entity VendorCatalogA as projection on my.VendorCatalogA;
  @odata.draft.enabled
  entity VendorCatalogB as projection on my.VendorCatalogB;
}