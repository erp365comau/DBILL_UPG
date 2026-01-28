pageextension 50010 "Sales Order SubformExt" extends "Sales Order Subform"
{
    layout
    {
        addafter("Line No.")
        {
            field("Unit Price 2"; Rec."Unit Price 2")
            {
                ApplicationArea = all;
            }
        }
        addlast(Control1)
        {
            field("VMS Label"; Rec."VMS Label")
            {
                ApplicationArea = all;
            }
        }
    }
}