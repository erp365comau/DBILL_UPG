tableextension 50115 SalesInvoiceLineExt extends "Sales Invoice Line"
{
    fields
    {
        field(50000; "Outstanding Quantity"; Decimal)
        {
        }
        field(50002; "Ordered Qty."; Decimal)
        {
        }
        field(50300; "VMS Label"; Text[200])
        {
            CalcFormula = Lookup("VAT Posting Setup"."VMS Label" WHERE("VAT Prod. Posting Group" = FIELD("VAT Prod. Posting Group"),
                                                                       "VAT Bus. Posting Group" = FIELD("VAT Bus. Posting Group")));
            FieldClass = FlowField;
        }
        field(50301; "VMS Label Description"; Text[200])
        {
            CalcFormula = Lookup("VAT Posting Setup"."VMS Label Description" WHERE("VAT Prod. Posting Group" = FIELD("VAT Prod. Posting Group"),
                                                                                    "VAT Bus. Posting Group" = FIELD("VAT Bus. Posting Group")));
            FieldClass = FlowField;
        }
    }
}
