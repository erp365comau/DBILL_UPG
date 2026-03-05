pageextension 50010 "Sales Order SubformExt" extends "Sales Order Subform"
{
    layout
    {
        modify("Unit Price")
        {
            StyleExpr = StyleTxt;
        }
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
            field("VMS Label Description"; Rec."VMS Label Description")
            {
                ApplicationArea = All;
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        StyleTxt := Rec.SetStyle;
    end;

    var
        StyleTxt: Text[30];
}