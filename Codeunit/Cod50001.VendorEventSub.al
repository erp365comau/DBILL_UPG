codeunit 50001 "Vendor EventSub"
{
    [EventSubscriber(ObjectType::Table, Database::Vendor, OnBeforeCalcOverdueBalance, '', false, false)]
    local procedure Vendor_OnBeforeCalcOverdueBalance(var Vendor: Record Vendor; var OverdueBalance: Decimal; var IsHandled: Boolean)
    var
        VendLedgerEntry: Record "Vendor Ledger Entry";
    begin
        VendLedgerEntry.SETCURRENTKEY("Vendor No.", Open, Positive, "Due Date", "Currency Code");
        VendLedgerEntry.SETRANGE("Vendor No.", Vendor."No.");
        VendLedgerEntry.SETRANGE(Open, TRUE);
        VendLedgerEntry.SETFILTER("Due Date", '<%1', WORKDATE);
        VendLedgerEntry.SETAUTOCALCFIELDS("Remaining Amt. (LCY)");
        IF VendLedgerEntry.FINDSET THEN
            REPEAT
                OverDueBalance += VendLedgerEntry."Remaining Amt. (LCY)";
            UNTIL VendLedgerEntry.NEXT = 0;

        IsHandled := true;
    end;

}
