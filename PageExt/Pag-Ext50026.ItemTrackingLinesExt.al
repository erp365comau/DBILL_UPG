pageextension 50026 "Item Tracking LinesExt" extends "Item Tracking Lines"
{
    layout
    {
        addafter("New Lot No.")
        {
            field("Plan Exp Date"; Rec."Plan Exp Date")
            {
                ApplicationArea = all;
            }
        }
    }
}