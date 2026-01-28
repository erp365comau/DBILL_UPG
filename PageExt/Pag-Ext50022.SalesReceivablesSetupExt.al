pageextension 50022 "Sales & Receivables SetupExt" extends "Sales & Receivables Setup"
{
    layout
    {
        addlast(General)
        {
            field("Invoice Text"; Rec."Invoice Text")
            {
                ApplicationArea = all;
            }
        }
        addbefore("Customer Group Dimension Code")
        {
            field("Statement Aging Length"; Rec."Statement Aging Length")
            {
                ApplicationArea = all;
            }
            field("E Mail Body"; Rec."E Mail Body")
            {
                ApplicationArea = all;
            }
            field(Subject; Rec.Subject)
            {
                ApplicationArea = all;
            }
            field("Statement All with Balance"; Rec."Statement All with Balance")
            {
                ApplicationArea = all;
            }
            field("Statement All with Entries"; Rec."Statement All with Entries")
            {
                ApplicationArea = all;
            }
        }
    }
}