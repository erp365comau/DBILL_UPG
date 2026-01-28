pageextension 50007 "Item ListExt" extends "Item List"
{
    layout
    {
        addafter("Item Category Code")
        {
            field("Product Group Code"; Rec."Product Group Code")
            {
                ApplicationArea = all;
            }
        }
        addafter("Created From Nonstock Item")
        {
            field(Inventory; Rec.Inventory)
            {
                ApplicationArea = all;
            }
        }
        addafter("Item Tracking Code")
        {
            field("Qty. on Purch. Order"; Rec."Qty. on Purch. Order")
            {
                ApplicationArea = all;
            }
            field("Qty. on Sales Order"; Rec."Qty. on Sales Order")
            {
                ApplicationArea = all;
            }
            field("Qty. on Prod. Order"; Rec."Qty. on Prod. Order")
            {
                ApplicationArea = all;
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
    begin
        Rec.SETRANGE(Blocked, FALSE);
        UserSetup.GET(USERID);
        UnitCostVisible := UserSetup."Visible - Item Unit Cost";
    end;

    var
        UserSetup: Record "User Setup";
        UnitCostVisible: Boolean;
}
