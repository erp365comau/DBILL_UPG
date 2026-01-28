pageextension 50021 "Phys. Inventory JournalExt" extends "Phys. Inventory Journal"
{
    layout
    {
        addafter("Item No.")
        {
            field("Shelf No."; Rec."Shelf No.")
            {
                ApplicationArea = all;
            }
        }
    }
}