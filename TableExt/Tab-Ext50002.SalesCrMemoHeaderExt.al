tableextension 50002 SalesCrMemoHeaderExt extends "Sales Cr.Memo Header"
{
    fields
    {
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
        field(50305; "VMS-Old-CrMemo"; Boolean)
        {
        }
    }
}