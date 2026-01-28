codeunit 50012 "Gen Jnl POst EventSub"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", OnPostBankAccOnBeforeBankAccLedgEntryInsert, '', false, false)]
    local procedure "Gen. Jnl.-Post Line_OnPostBankAccOnBeforeBankAccLedgEntryInsert"(var BankAccountLedgerEntry: Record "Bank Account Ledger Entry"; var GenJournalLine: Record "Gen. Journal Line"; BankAccount: Record "Bank Account"; var TempGLEntryBuf: Record "G/L Entry" temporary; var NextTransactionNo: Integer; GLRegister: Record "G/L Register"; Balancing: Boolean)
    var
        BankAcc: Record "Bank Account";
        WHTPostingSetup: Record "WHT Posting Setup";
        BankLedgrWHTAmount: Decimal;
    begin
        WHTPostingSetup.Get(GenJournalLine."WHT Business Posting Group", GenJournalLine."WHT Product Posting Group");
        BankAcc.Get(GenJournalLine."Account No.");
        IF BankAcc."Currency Code" <> '' THEN BEGIN
            BankLedgrWHTAmount :=
              ROUND(GenJournalLine.Amount * WHTPostingSetup."WHT %" / 100);
            BankAccountLedgerEntry.Amount := GenJournalLine.Amount - BankLedgrWHTAmount;
        end;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", OnAfterInitVendLedgEntry, '', false, false)]
    local procedure "Gen. Jnl.-Post Line_OnAfterInitVendLedgEntry"(var VendorLedgerEntry: Record "Vendor Ledger Entry"; GenJournalLine: Record "Gen. Journal Line"; var GLRegister: Record "G/L Register")
    begin
        VendorLedgerEntry."EFT Transaction Date" := GenJournalLine."EFT Transaction Date";
        VendorLedgerEntry."EFT No." := GenJournalLine."EFT No.";
        VendorLedgerEntry."EFT Time" := GenJournalLine."EFT Time";
        VendorLedgerEntry."EFT Date" := GenJournalLine."EFT Date";
        VendorLedgerEntry."EFT User ID" := GenJournalLine."EFT User ID";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", OnPostBankAccOnAfterBankAccLedgEntryInsert, '', false, false)]
    local procedure "Gen. Jnl.-Post Line_OnPostBankAccOnAfterBankAccLedgEntryInsert"(var Sender: Codeunit "Gen. Jnl.-Post Line"; var BankAccountLedgerEntry: Record "Bank Account Ledger Entry"; var GenJournalLine: Record "Gen. Journal Line"; BankAccount: Record "Bank Account")
    begin
        IF GenJournalLine."Bank Payment Type" = GenJournalLine."Bank Payment Type"::EFT THEN
            GenJournalLine.TESTFIELD("EFT Exported", TRUE);
    end;




}
