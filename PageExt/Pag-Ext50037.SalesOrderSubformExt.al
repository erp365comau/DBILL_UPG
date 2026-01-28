pageextension 50037 SalesOrderSubformExt extends "Sales Order Subform"
{
    layout
    {
        modify("Unit Price")
        {
            StyleExpr = StyleTxt;
        }
    }
    trigger OnAfterGetRecord()
    begin
        StyleTxt := Rec.SetStyle;
    end;

    var
        StyleTxt: Text[30];
}
