tableextension 50114 SalesInvoiceHeaderExt extends "Sales Invoice Header"
{
    fields
    {
        field(50001; "Shipping Mark"; Code[20])
        {
        }
        field(50002; "Vessel No."; Code[20])
        {
        }
        field(50003; "Voyage No."; Code[20])
        {
        }
        field(50004; "Seal No."; Code[20])
        {
        }
        field(50005; "Container No."; Code[20])
        {
        }
        field(50006; "Promised Delivery Date"; Date)
        {
        }
        field(50300; "VMS-Ref No."; Text[100])
        {
        }
        field(50301; "VMS-SDC-Invoice No."; Text[100])
        {
        }
        field(50302; "VMS-SDC-Invoice No.First"; Text[100])
        {
        }
        field(50303; "VMS-SDC-Error"; Boolean)
        {
        }
        field(50304; "VMS-SDC-Error ID"; Integer)
        {
        }
        field(50305; "VMS-Old Invoice"; Boolean)
        {
        }
    }
}