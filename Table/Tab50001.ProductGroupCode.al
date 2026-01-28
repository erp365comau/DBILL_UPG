table 50001 "Product Group Code"
{
    Caption = 'Product Group Code';
    DataClassification = ToBeClassified;
    LookupPageId = "Product Group Code";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
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
