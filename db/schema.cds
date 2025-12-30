namespace Procurement_Requisition;
using { cuid, managed } from '@sap/cds/common';

@assert.unique: { requisitionHeaderID: [requisitionHeaderID] }
entity RequisitionHeader : cuid, managed {
  requisitionHeaderID: String(36) @mandatory;
  requestor: String(100);
  requestType: String(20);
  selectedVendor: String(100);
  totalValue: Decimal(10,2);
  status: String(20);
  items: Composition of many RequisitionItem on items.header = $self;
}

@assert.unique: { requisitionItemID: [requisitionItemID] }
entity RequisitionItem : cuid {
  requisitionItemID: String(36) @mandatory;
  materialName: String(100);
  quantity: Integer;
  price: Decimal(10,2);
  costCenter: String(100);
  header: Association to RequisitionHeader;
}

@assert.unique: { vendorCatalogAID: [vendorCatalogAID] }
entity VendorCatalogA : cuid {
  vendorCatalogAID: String(36) @mandatory;
  productName: String(100);
  description: String(500);
  unitPrice: Decimal(10,2);
  stockLevel: Integer;
  category: String(100);
}

@assert.unique: { vendorCatalogBID: [vendorCatalogBID] }
entity VendorCatalogB : cuid {
  vendorCatalogBID: String(36) @mandatory;
  productName: String(100);
  description: String(500);
  unitPrice: Decimal(10,2);
  stockLevel: Integer;
  category: String(100);
}

