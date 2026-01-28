tableextension 50102 VendorExt extends Vendor
{
    fields
    {
        field(50250; "Fax No. 2"; Text[30])
        {
        }
        field(50251; "E-Mail 2"; Text[80])
        {
        }
        field(50252; "PO Document Type"; Option)
        {
            OptionMembers = ,Mail,"E-mail",Fax;
        }
        field(50253; "Remittance Document Type"; Option)
        {
            OptionMembers = ,Mail,"E-mail",Fax;
        }
        field(50254; "PO Email Address"; Text[80])
        {
        }
        field(50255; "Remittance Email Address"; Text[80])
        {
        }
    }
}