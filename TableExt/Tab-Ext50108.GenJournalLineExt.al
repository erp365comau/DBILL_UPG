tableextension 50108 "GenJournalLineExt" extends "Gen. Journal Line"
{
    fields
    {
        field(50001; "Description2"; Text[50])
        {
        }
        field(50093; "Hash Total"; Code[7])
        {
        }
        field(50094; "EFT Transaction Date"; Date)
        {
        }
        field(50095; "EFT No."; Code[20])
        {
        }
        field(50096; "EFT Time"; Time)
        {
        }
        field(50097; "EFT Date"; Date)
        {
        }
        field(50098; "EFT User ID"; Code[50])
        {
        }
        field(50099; "EFT Exported"; Boolean)
        {
        }
        modify("Creditor No.")
        {
            trigger OnAfterValidate()
            begin
                IF ("Creditor No." <> '') AND ("Recipient Bank Account" <> '') THEN
                    FIELDERROR("Recipient Bank Account",
                      STRSUBSTNO(FieldIsNotEmptyErr, FIELDCAPTION("Creditor No."), FIELDCAPTION("Recipient Bank Account")));
            end;
        }
        modify("Recipient Bank Account")
        {
            trigger OnAfterValidate()
            begin
                IF ("Recipient Bank Account" <> '') AND ("Creditor No." <> '') THEN
                    FIELDERROR("Creditor No.",
                      STRSUBSTNO(FieldIsNotEmptyErr, FIELDCAPTION("Recipient Bank Account"), FIELDCAPTION("Creditor No.")));
            end;
        }
    }
    trigger OnBeforeModify()
    begin
        TESTFIELD("EFT Exported", FALSE);
    end;

    trigger OnBeforeDelete()
    begin
        TESTFIELD("EFT Exported", FALSE);
    end;

    trigger OnBeforeRename()
    begin
        TESTFIELD("EFT Exported", FALSE);
    end;

    var
        fieldIsNotEmptyErr: Label '%1 cannot be used while %2 has a value.';
        NotExistErr: Label 'Document No. %1 does not exist or is already closed.';
        DocNoFilterErr: Label 'The document numbers cannot be renumbered while there is an active filter on the Document No. field.';

}