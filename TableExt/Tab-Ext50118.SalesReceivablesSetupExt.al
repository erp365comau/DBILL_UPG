tableextension 50118 SalesReceivablesSetupExt extends "Sales & Receivables Setup"
{
    fields
    {
        field(50001; "Invoice Text"; Code[20])
        {
        }
        field(50035; "Statement Aging Length"; Code[10])
        {
        }
        field(50058; "E Mail Body"; Text[250])
        {
        }
        field(50059; "Subject"; Text[100])
        {
        }
        field(50060; "Statement All with Balance"; Boolean)
        {
        }
        field(50061; "Statement All with Entries"; Boolean)
        {
        }
        field(50300; "VMS ESDC IP Address"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(50301; "VMS Payment Type"; Option)
        {
            OptionMembers = Other,Cash,Card,Check,WireTransfer,Voucher,MobileMoney;
        }
        field(50302; "VMS Training Invoice"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50303; "VMS PAC"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50304; "VMS Cashier TIN"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50305; "VMS Certificate Name"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(50306; "VMS Smart Card PIN"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50307; "E-SDC Connection"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50308; "VMS Disable Apply Entry"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }
}