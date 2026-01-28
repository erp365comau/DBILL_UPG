pageextension 50003 "Customer ListExt" extends "Customer List"
{
    layout
    {
        addafter("Phone No.")
        {
            field(Balance; Rec.Balance)
            {
                ApplicationArea = all;
            }
        }
        addafter(Contact)
        {
            field(City; Rec.City)
            {
                ApplicationArea = all;
            }
        }
        addafter("Salesperson Code")
        {
            field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
            {
                ApplicationArea = all;
            }
            field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
            {
                ApplicationArea = all;
            }
        }

    }
}