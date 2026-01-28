tableextension 50005 VendorBankAccountExt extends "Vendor Bank Account"
{
    fields
    {
        field(50097; "EFT Name"; Text[50])
        {
            Caption = '';
            DataClassification = ToBeClassified;
        }
        field(50098; "Lodgment Reference"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50099; "EFT Default"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }
}