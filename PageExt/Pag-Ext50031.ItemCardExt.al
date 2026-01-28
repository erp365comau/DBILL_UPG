pageextension 50031 ItemCardExt extends "Item Card"
{

    layout
    {
        addafter("Item Category Code")
        {
            field("Product Group Code"; Rec."Product Group Code")
            {
                ApplicationArea = all;
                Caption = 'Product Group Code';
            }
        }
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
