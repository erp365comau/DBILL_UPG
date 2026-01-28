pageextension 50025 "Value EntriesExt" extends "Value Entries"
{
    layout
    {
        addafter("Valuation Date")
        {
            field("Item IPG"; Rec."Item IPG")
            {
                ApplicationArea = all;
            }
        }
    }
}