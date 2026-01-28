tableextension 50101 CustomerExt extends Customer
{
    fields
    {
        field(50000; "Customer Bank Code"; Code[20])
        {
            TableRelation = "Bank Account"."No.";
        }
        field(50152; "MSDS/Quotes Email"; Text[80])
        {
        }
        field(50250; "Fax No. 2"; Text[30])
        {
        }
        field(50251; "E-Mail 2"; Text[80])
        {
        }
        field(50252; "Send Document Type"; Option)
        {
            OptionMembers = ,Mail,"E-mail",Fax;
        }
        field(50254; "Statement Style Filter"; Option)
        {
            OptionMembers = ,Balance,"Open Item";
        }
        field(50255; "Date From Filter"; Date)
        {
        }
        field(50256; "Date To Filter"; Date)
        {
        }
        field(50258; "Quote Document Type"; Option)
        {
            OptionMembers = ,Mail,"E-mail",Fax;
        }
        field(50260; "Sls. Cred. Memo Email Address"; Text[80])
        {
        }
        field(50261; "Statement Email Address"; Text[80])
        {
        }
        field(50262; "Sls. Invoice Email Address"; Text[80])
        {
        }
        field(50263; "Reminder Email Address"; Text[80])
        {
        }
        field(50300; "Customer TIN"; Text[50])
        {
        }
    }
}