pageextension 50018 "VAT EntriesExt" extends "VAT Entries"
{
    layout
    {
        addafter(Amount)
        {
            field("Amount 2"; Rec."Amount 2")
            {
                ApplicationArea = all;
            }
            field("Amount 3"; Rec."Amount 3")
            {
                ApplicationArea = all;
            }
        }
    }
}