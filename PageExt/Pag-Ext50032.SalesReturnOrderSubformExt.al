pageextension 50032 SalesReturnOrderSubformExt extends "Sales Return Order Subform"
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
