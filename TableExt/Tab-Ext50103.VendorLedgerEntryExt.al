tableextension 50103 VendorLedgerEntryExt extends "Vendor Ledger Entry"
{
    fields
    {
        field(50000; "Bill To Customer"; Code[10])
        {
        }
        field(50094; "EFT Transaction Date"; Date)
        {
        }
        field(50095; "EFT No."; Code[20])
        {
        }
        field(50096; "EFT Time"; Time)
        {
        }
        field(50097; "EFT Date"; Date)
        {
        }
        field(50098; "EFT User ID"; Code[50])
        {
        }
        field(50100; "Bank Branch No."; Text[20])
        {
        }
        field(50101; "Bank Account No."; Text[30])
        {
        }
    }
}