pageextension 50012 "User SetupExt" extends "User Setup"
{
    layout
    {
        addafter("Time Sheet Admin.")
        {
            field("E-Mail"; Rec."E-Mail")
            {
                ApplicationArea = all;
            }
            field("Recipient E-Mail"; Rec."Recipient E-Mail")
            {
                ApplicationArea = all;
            }
            field("Insert Allowed - Item"; Rec."Insert Allowed - Item")
            {
                ApplicationArea = all;
            }
            field("Modify Allowed - Item"; Rec."Modify Allowed - Item")
            {
                ApplicationArea = all;
            }
            field("Visible - Item Unit Cost"; Rec."Visible - Item Unit Cost")
            {
                ApplicationArea = all;
            }
        }
    }
}
