pageextension 50027 "Item Invoicing FactBoxExt" extends "Item Invoicing FactBox"
{
    trigger OnOpenPage()
    begin
        UserSetup.GET(USERID);
        UnitCostVisible := UserSetup."Visible - Item Unit Cost";
    end;

    var
        UserSetup: Record "User Setup";
        UnitCostVisible: Boolean;
}
