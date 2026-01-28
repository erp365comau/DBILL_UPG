table 50009 "EFT File Type"
{
    Caption = 'EFT File Type';


    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(2; Description; Text[60])
        {
            Caption = 'Description';
        }
        field(3; "EFT Nos."; Code[10])
        {
            Caption = 'EFT Nos.';
        }
        field(4; "Transaction Code"; Code[5])
        {
            Caption = 'Transaction Code';
        }
    }
    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
}