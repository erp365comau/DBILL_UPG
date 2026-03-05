pageextension 50037 PostedSalesInvoiceSubformExt extends "Posted Sales Invoice Subform"
{
    layout
    {
        addlast(Control1)
        {
            field("VMS Label"; Rec."VMS Label")
            {
                ApplicationArea = all;
            }
            field("VMS Label Description"; Rec."VMS Label Description")
            {
                ApplicationArea = All;
            }
        }
    }
}
