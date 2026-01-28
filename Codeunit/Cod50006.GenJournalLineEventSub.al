codeunit 50006 "Gen Journal Line EventSub"
{
    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", OnAfterAccountNoOnValidateGetCustomerBalAccount, '', false, false)]
    local procedure "Gen. Journal Line_OnAfterAccountNoOnValidateGetCustomerBalAccount"(var GenJournalLine: Record "Gen. Journal Line"; var Customer: Record Customer; CallingFieldNo: Integer)
    begin
        GenJournalLine."Payment Method Code" := '';
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", OnAfterAccountNoOnValidateGetVendorBalAccount, '', false, false)]
    local procedure "Gen. Journal Line_OnAfterAccountNoOnValidateGetVendorBalAccount"(var GenJournalLine: Record "Gen. Journal Line"; var Vendor: Record Vendor; CallingFieldNo: Integer)
    begin
        GenJournalLine."Payment Method Code" := '';
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", OnBeforeCheckDocNoOnLines, '', false, false)]
    local procedure "Gen. Journal Line_OnBeforeCheckDocNoOnLines"(GenJournalLine: Record "Gen. Journal Line"; var IsHandled: Boolean)
    begin
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", OnBeforeValidateShortcutDimCode, '', false, false)]
    local procedure "Gen. Journal Line_OnBeforeValidateShortcutDimCode"(var GenJournalLine: Record "Gen. Journal Line"; var xGenJournalLine: Record "Gen. Journal Line"; FieldNumber: Integer; var ShortcutDimCode: Code[20]; var IsHandled: Boolean)
    begin
        GenJournalLine.TESTFIELD("EFT Exported", FALSE);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", OnBeforeLookupShortcutDimCode, '', false, false)]
    local procedure "Gen. Journal Line_OnBeforeLookupShortcutDimCode"(var GenJournalLine: Record "Gen. Journal Line"; xGenJournalLine: Record "Gen. Journal Line"; FieldNumber: Integer; var ShortcutDimCode: Code[20]; var IsHandled: Boolean)
    begin
        GenJournalLine.TESTFIELD("EFT Exported", FALSE);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", OnGetCustLedgerEntryOnAfterSetFilters, '', false, false)]
    local procedure "Gen. Journal Line_OnGetCustLedgerEntryOnAfterSetFilters"(var GenJournalLine: Record "Gen. Journal Line"; var CustLedgerEntry: Record "Cust. Ledger Entry")
    begin
        CustLedgerEntry.SETRANGE("Document Type", GenJournalLine."Document Type"::Invoice);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", OnBeforeGetVendLedgerEntry, '', false, false)]
    local procedure "Gen. Journal Line_OnBeforeGetVendLedgerEntry"(var GenJournalLine: Record "Gen. Journal Line"; var IsHandled: Boolean)
    begin
        if (GenJournalLine."Account Type" = GenJournalLine."Account Type"::Vendor) and (GenJournalLine."Account No." = '') and
         (GenJournalLine."Applies-to Doc. No." <> '')
      then begin
            VendLedgEntry.Reset();
            VendLedgEntry.SETRANGE("Document Type", GenJournalLine."Document Type"::Invoice);
            VendLedgEntry.SetRange("Document No.", GenJournalLine."Applies-to Doc. No.");
            VendLedgEntry.SetRange(Open, true);
            if not VendLedgEntry.FindFirst() then
                Error(NotExistErr, GenJournalLine."Applies-to Doc. No.");

            GenJournalLine.Validate("Account No.", VendLedgEntry."Vendor No.");

            if GenJournalLine.Amount = 0 then begin
                VendLedgEntry.CalcFields("Remaining Amount");

                if GenJournalLine."Posting Date" <= VendLedgEntry."Pmt. Discount Date" then
                    GenJournalLine.Amount := -(VendLedgEntry."Remaining Amount" - VendLedgEntry."Remaining Pmt. Disc. Possible")
                else
                    GenJournalLine.Amount := -VendLedgEntry."Remaining Amount";

                if GenJournalLine."Currency Code" <> VendLedgEntry."Currency Code" then
                    UpdateCurrencyCode(GenJournalLine, VendLedgEntry."Currency Code");

                SetAppliesToFields(GenJournalLine, VendLedgEntry."Document Type", VendLedgEntry."Document No.", VendLedgEntry."External Document No.");

                GenJnlBatch.Get(GenJournalLine."Journal Template Name", GenJournalLine."Journal Batch Name");
                if GenJnlBatch."Bal. Account No." <> '' then begin
                    GenJournalLine."Bal. Account Type" := GenJnlBatch."Bal. Account Type";
                    GenJournalLine.Validate("Bal. Account No.", GenJnlBatch."Bal. Account No.");
                end else
                    GenJournalLine.Validate(Amount);

            end;
        end;
        IsHandled := true;
    end;

    procedure UpdateCurrencyCode(GenJournalLine: Record "Gen. Journal Line"; NewCurrencyCode: Code[10])
    var
        ConfirmManagement: Codeunit "Confirm Management";
        FromCurrencyCode: Code[10];
        ToCurrencyCode: Code[10];
        IsHandled: Boolean;
    begin

        FromCurrencyCode := GenJournalLine.GetShowCurrencyCode(GenJournalLine."Currency Code");
        ToCurrencyCode := GenJournalLine.GetShowCurrencyCode(NewCurrencyCode);
        if not ConfirmManagement.GetResponseOrDefault(
             StrSubstNo(ChangeCurrencyQst, FromCurrencyCode, ToCurrencyCode), true)
        then
            Error(UpdateInterruptedErr);
        GenJournalLine.Validate("Currency Code", NewCurrencyCode);
    end;

    local procedure SetAppliesToFields(GenJournalLine: Record "Gen. Journal Line"; DocType: Enum "Gen. Journal Document Type"; DocNo: Code[20]; ExtDocNo: Code[35])
    begin
        UpdateDocumentTypeAndAppliesTo(GenJournalLine, DocType, DocNo);

        if (GenJournalLine."Applies-to Doc. Type" = GenJournalLine."Applies-to Doc. Type"::Invoice) and (GenJournalLine."Document Type" = GenJournalLine."Document Type"::Payment) then
            GenJournalLine."Applies-to Ext. Doc. No." := ExtDocNo;
    end;

    local procedure UpdateDocumentTypeAndAppliesTo(GenJournalLine: Record "Gen. Journal Line"; DocType: Enum "Gen. Journal Document Type"; DocNo: Code[20])
    begin
        GenJournalLine."Applies-to Doc. Type" := DocType;
        GenJournalLine."Applies-to Doc. No." := DocNo;
        GenJournalLine."Applies-to ID" := '';

        if GenJournalLine."Document Type" <> GenJournalLine."Document Type"::" " then
            exit;

        if not (GenJournalLine."Account Type" in [GenJournalLine."Account Type"::Customer, GenJournalLine."Account Type"::Vendor]) then
            exit;

        case GenJournalLine."Applies-to Doc. Type" of
            GenJournalLine."Applies-to Doc. Type"::Payment:
                GenJournalLine."Document Type" := GenJournalLine."Document Type"::Invoice;
            GenJournalLine."Applies-to Doc. Type"::"Credit Memo":
                GenJournalLine."Document Type" := GenJournalLine."Document Type"::Refund;
            GenJournalLine."Applies-to Doc. Type"::Invoice,
            GenJournalLine."Applies-to Doc. Type"::Refund:
                GenJournalLine."Document Type" := GenJournalLine."Document Type"::Payment;
        end;
    end;

    var

        VendLedgEntry: Record "Vendor Ledger Entry";
        GenJnlBatch: Record "Gen. Journal Batch";
        NotExistErr: Label 'Document number %1 does not exist or is already closed.', Comment = '%1=Document number';
        ChangeCurrencyQst: Label 'The Currency Code in the Gen. Journal Line will be changed from %1 to %2.\\Do you want to continue?', Comment = '%1=FromCurrencyCode, %2=ToCurrencyCode';
        UpdateInterruptedErr: Label 'The update has been interrupted to respect the warning.';

}
