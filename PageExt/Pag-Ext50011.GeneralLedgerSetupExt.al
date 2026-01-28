pageextension 50011 "General Ledger SetupExt" extends "General Ledger Setup"
{
    layout
    {
        addbefore("Bank Account Nos.")
        {
            field("PDF Printer Name"; Rec."PDF Printer Name")
            {
                ApplicationArea = all;
            }
            field("PDF Printer Austral Type"; Rec."PDF Printer Austral Type")
            {
                ApplicationArea = all;
            }
            field("Copy Email To Recipient"; Rec."Copy Email To Recipient")
            {
                ApplicationArea = all;
            }
            field("Copy To Generic Mailbox"; Rec."Copy To Generic Mailbox")
            {
                ApplicationArea = all;
            }
            field("Override E-Mail address"; Rec."Override E-Mail address")
            {
                ApplicationArea = all;
            }
        }
    }
}
