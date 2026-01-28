tableextension 50110 UserSetupExt extends "User Setup"
{
    fields
    {
        field(50000; "Recipient E-Mail"; Text[100])
        {
        }
        field(50300; "VMS PAC"; Code[50])
        {
        }
        field(50301; "VMS Cashier TIN"; Code[50])
        {
        }
        field(50302; "VMS Certificate Name"; Text[200])
        {
        }
        field(50303; "VMS Smart Card PIN"; Text[100])
        {
        }
        field(50304; "Insert Allowed - Item"; Boolean)
        {
        }
        field(50305; "Modify Allowed - Item"; Boolean)
        {
        }
        field(50306; "Visible - Item Unit Cost"; Boolean)
        {
        }
        field(50307; "VMS ESDC IP Address"; Text[200])
        {
        }
    }
}