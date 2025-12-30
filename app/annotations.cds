using { procurement_RequisitionSrv } from '../srv/service.cds';

annotate procurement_RequisitionSrv.RequisitionHeader with @UI.HeaderInfo: { TypeName: 'Requisition Header', TypeNamePlural: 'Requisition Headers', Title: { Value: requisitionHeaderID } };
annotate procurement_RequisitionSrv.RequisitionHeader with {
  ID @UI.Hidden @Common.Text: { $value: requisitionHeaderID, ![@UI.TextArrangement]: #TextOnly }
};
annotate procurement_RequisitionSrv.RequisitionHeader with @UI.Identification: [{ Value: requisitionHeaderID }];
annotate procurement_RequisitionSrv.RequisitionHeader with {
  requisitionHeaderID @title: 'ID';
  requestor @title: 'Requestor';
  requestType @title: 'Request Type';
  selectedVendor @title: 'Selected Vendor';
  totalValue @title: 'Total Value';
  status @title: 'Status';
  createdAt @title: 'Created At';
  createdBy @title: 'Created By';
  modifiedAt @title: 'Modified At';
  modifiedBy @title: 'Modified By'
};

annotate procurement_RequisitionSrv.RequisitionHeader with @UI.LineItem: [
 { $Type: 'UI.DataField', Value: requisitionHeaderID },
 { $Type: 'UI.DataField', Value: requestor },
 { $Type: 'UI.DataField', Value: requestType },
 { $Type: 'UI.DataField', Value: selectedVendor },
 { $Type: 'UI.DataField', Value: totalValue },
 { $Type: 'UI.DataField', Value: status }
];

annotate procurement_RequisitionSrv.RequisitionHeader with @UI.FieldGroup #Main: {
  $Type: 'UI.FieldGroupType', Data: [
 { $Type: 'UI.DataField', Value: requisitionHeaderID },
 { $Type: 'UI.DataField', Value: requestor },
 { $Type: 'UI.DataField', Value: requestType },
 { $Type: 'UI.DataField', Value: selectedVendor },
 { $Type: 'UI.DataField', Value: totalValue },
 { $Type: 'UI.DataField', Value: status },
 { $Type: 'UI.DataField', Value: createdAt },
 { $Type: 'UI.DataField', Value: createdBy },
 { $Type: 'UI.DataField', Value: modifiedAt },
 { $Type: 'UI.DataField', Value: modifiedBy }
  ]
};

annotate procurement_RequisitionSrv.RequisitionHeader with {
  items @Common.Label: 'Items'
};

annotate procurement_RequisitionSrv.RequisitionHeader with @UI.Facets: [
  { $Type: 'UI.ReferenceFacet', ID: 'Main', Label: 'General Information', Target: '@UI.FieldGroup#Main' },
  { $Type : 'UI.ReferenceFacet', ID : 'RequisitionItem', Target : 'items/@UI.LineItem' }
];

annotate procurement_RequisitionSrv.RequisitionHeader with @UI.SelectionFields: [
  requisitionHeaderID
];

annotate procurement_RequisitionSrv.RequisitionItem with @UI.HeaderInfo: { TypeName: 'Requisition Item', TypeNamePlural: 'Requisition Items', Title: { Value: requisitionItemID } };
annotate procurement_RequisitionSrv.RequisitionItem with {
  ID @UI.Hidden @Common.Text: { $value: requisitionItemID, ![@UI.TextArrangement]: #TextOnly }
};
annotate procurement_RequisitionSrv.RequisitionItem with @UI.Identification: [{ Value: requisitionItemID }];
annotate procurement_RequisitionSrv.RequisitionItem with {
  header @Common.ValueList: {
    CollectionPath: 'RequisitionHeader',
    Parameters    : [
      {
        $Type            : 'Common.ValueListParameterInOut',
        LocalDataProperty: header_ID, 
        ValueListProperty: 'ID'
      },
      {
        $Type            : 'Common.ValueListParameterDisplayOnly',
        ValueListProperty: 'requisitionHeaderID'
      },
      {
        $Type            : 'Common.ValueListParameterDisplayOnly',
        ValueListProperty: 'requestor'
      },
      {
        $Type            : 'Common.ValueListParameterDisplayOnly',
        ValueListProperty: 'requestType'
      },
      {
        $Type            : 'Common.ValueListParameterDisplayOnly',
        ValueListProperty: 'selectedVendor'
      },
      {
        $Type            : 'Common.ValueListParameterDisplayOnly',
        ValueListProperty: 'totalValue'
      },
      {
        $Type            : 'Common.ValueListParameterDisplayOnly',
        ValueListProperty: 'status'
      },
      {
        $Type            : 'Common.ValueListParameterDisplayOnly',
        ValueListProperty: 'createdAt'
      },
      {
        $Type            : 'Common.ValueListParameterDisplayOnly',
        ValueListProperty: 'createdBy'
      },
      {
        $Type            : 'Common.ValueListParameterDisplayOnly',
        ValueListProperty: 'modifiedAt'
      },
      {
        $Type            : 'Common.ValueListParameterDisplayOnly',
        ValueListProperty: 'modifiedBy'
      },
    ],
  }
};
annotate procurement_RequisitionSrv.RequisitionItem with {
  requisitionItemID @title: 'ID';
  materialName @title: 'Material Name';
  quantity @title: 'Quantity';
  price @title: 'Price';
  costCenter @title: 'Cost Center'
};

annotate procurement_RequisitionSrv.RequisitionItem with @UI.LineItem: [
 { $Type: 'UI.DataField', Value: requisitionItemID },
 { $Type: 'UI.DataField', Value: materialName },
 { $Type: 'UI.DataField', Value: quantity },
 { $Type: 'UI.DataField', Value: price },
 { $Type: 'UI.DataField', Value: costCenter }
];

annotate procurement_RequisitionSrv.RequisitionItem with @UI.FieldGroup #Main: {
  $Type: 'UI.FieldGroupType', Data: [
 { $Type: 'UI.DataField', Value: requisitionItemID },
 { $Type: 'UI.DataField', Value: materialName },
 { $Type: 'UI.DataField', Value: quantity },
 { $Type: 'UI.DataField', Value: price },
 { $Type: 'UI.DataField', Value: costCenter }
  ]
};

annotate procurement_RequisitionSrv.RequisitionItem with {
  header @Common.Text: { $value: header.requisitionHeaderID, ![@UI.TextArrangement]: #TextOnly }
};

annotate procurement_RequisitionSrv.RequisitionItem with {
  header @Common.Label: 'Header'
};

annotate procurement_RequisitionSrv.RequisitionItem with @UI.Facets: [
  { $Type: 'UI.ReferenceFacet', ID: 'Main', Label: 'General Information', Target: '@UI.FieldGroup#Main' }
];

annotate procurement_RequisitionSrv.RequisitionItem with @UI.SelectionFields: [
  header_ID
];

annotate procurement_RequisitionSrv.VendorCatalogA with @UI.HeaderInfo: { TypeName: 'Vendor Catalog A', TypeNamePlural: 'Vendor Catalog A', Title: { Value: vendorCatalogAID } };
annotate procurement_RequisitionSrv.VendorCatalogA with {
  ID @UI.Hidden @Common.Text: { $value: vendorCatalogAID, ![@UI.TextArrangement]: #TextOnly }
};
annotate procurement_RequisitionSrv.VendorCatalogA with @UI.Identification: [{ Value: vendorCatalogAID }];
annotate procurement_RequisitionSrv.VendorCatalogA with {
  vendorCatalogAID @title: 'ID';
  productName @title: 'Product Name';
  description @title: 'Description';
  unitPrice @title: 'Unit Price';
  stockLevel @title: 'Stock Level';
  category @title: 'Category'
};

annotate procurement_RequisitionSrv.VendorCatalogA with @UI.LineItem: [
 { $Type: 'UI.DataField', Value: vendorCatalogAID },
 { $Type: 'UI.DataField', Value: productName },
 { $Type: 'UI.DataField', Value: description },
 { $Type: 'UI.DataField', Value: unitPrice },
 { $Type: 'UI.DataField', Value: stockLevel },
 { $Type: 'UI.DataField', Value: category }
];

annotate procurement_RequisitionSrv.VendorCatalogA with @UI.FieldGroup #Main: {
  $Type: 'UI.FieldGroupType', Data: [
 { $Type: 'UI.DataField', Value: vendorCatalogAID },
 { $Type: 'UI.DataField', Value: productName },
 { $Type: 'UI.DataField', Value: description },
 { $Type: 'UI.DataField', Value: unitPrice },
 { $Type: 'UI.DataField', Value: stockLevel },
 { $Type: 'UI.DataField', Value: category }
  ]
};

annotate procurement_RequisitionSrv.VendorCatalogA with @UI.Facets: [
  { $Type: 'UI.ReferenceFacet', ID: 'Main', Label: 'General Information', Target: '@UI.FieldGroup#Main' }
];

annotate procurement_RequisitionSrv.VendorCatalogA with @UI.SelectionFields: [
  vendorCatalogAID
];

annotate procurement_RequisitionSrv.VendorCatalogB with @UI.HeaderInfo: { TypeName: 'Vendor Catalog B', TypeNamePlural: 'Vendor Catalog B', Title: { Value: vendorCatalogBID } };
annotate procurement_RequisitionSrv.VendorCatalogB with {
  ID @UI.Hidden @Common.Text: { $value: vendorCatalogBID, ![@UI.TextArrangement]: #TextOnly }
};
annotate procurement_RequisitionSrv.VendorCatalogB with @UI.Identification: [{ Value: vendorCatalogBID }];
annotate procurement_RequisitionSrv.VendorCatalogB with {
  vendorCatalogBID @title: 'ID';
  productName @title: 'Product Name';
  description @title: 'Description';
  unitPrice @title: 'Unit Price';
  stockLevel @title: 'Stock Level';
  category @title: 'Category'
};

annotate procurement_RequisitionSrv.VendorCatalogB with @UI.LineItem: [
 { $Type: 'UI.DataField', Value: vendorCatalogBID },
 { $Type: 'UI.DataField', Value: productName },
 { $Type: 'UI.DataField', Value: description },
 { $Type: 'UI.DataField', Value: unitPrice },
 { $Type: 'UI.DataField', Value: stockLevel },
 { $Type: 'UI.DataField', Value: category }
];

annotate procurement_RequisitionSrv.VendorCatalogB with @UI.FieldGroup #Main: {
  $Type: 'UI.FieldGroupType', Data: [
 { $Type: 'UI.DataField', Value: vendorCatalogBID },
 { $Type: 'UI.DataField', Value: productName },
 { $Type: 'UI.DataField', Value: description },
 { $Type: 'UI.DataField', Value: unitPrice },
 { $Type: 'UI.DataField', Value: stockLevel },
 { $Type: 'UI.DataField', Value: category }
  ]
};

annotate procurement_RequisitionSrv.VendorCatalogB with @UI.Facets: [
  { $Type: 'UI.ReferenceFacet', ID: 'Main', Label: 'General Information', Target: '@UI.FieldGroup#Main' }
];

annotate procurement_RequisitionSrv.VendorCatalogB with @UI.SelectionFields: [
  vendorCatalogBID
];

