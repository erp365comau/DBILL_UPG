tableextension 50006 VATAmountLineExt extends "VAT Amount Line"
{
    fields
    {
        field(50300; "VMS Label"; Text[200])
        {
        }
    }
    procedure VATAmountText2(): Text[30];
    begin

        IF FIND('-') THEN
            IF NEXT = 0 THEN
                IF "VAT %" <> 0 THEN
                    EXIT(STRSUBSTNO(Text006, "VAT %"));
        EXIT(Text007);
    end;

    var
        Text006: label '%1 VAT';
        Text007: Label 'VAT Amount';
}
