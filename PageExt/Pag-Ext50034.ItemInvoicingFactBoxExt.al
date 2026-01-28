pageextension 50034 ItemInvoicingFactBoxExt extends "Item Invoicing FactBox"
{
    layout
    {
        modify("Unit Cost")
        {
            visible = UnitCostVisible;
        }
        modify("Standard Cost")
        {
            visible = UnitCostVisible;
        }
    }
    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        UserSetup.GET(USERID);
        UnitCostVisible := UserSetup."Visible - Item Unit Cost";
    end;

    var
        UserSetup: Record "User Setup";
        UnitCostVisible: Boolean;
}
