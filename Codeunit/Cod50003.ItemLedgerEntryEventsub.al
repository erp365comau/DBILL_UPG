codeunit 50003 "Item Ledger Entry Eventsub"
{
    [EventSubscriber(ObjectType::Table, Database::"Item Ledger Entry", OnBeforeVerifyOnInventory, '', false, false)]
    local procedure "Item Ledger Entry_OnBeforeVerifyOnInventory"(var ItemLedgerEntry: Record "Item Ledger Entry"; var IsHandled: Boolean; ErrorMessageText: Text)
    var
        Item: Record Item;
    begin
        IF NOT ItemLedgerEntry.Open THEN
            EXIT;
        IF ItemLedgerEntry.Quantity >= 0 THEN
            EXIT;
        CASE ItemLedgerEntry."Entry Type" OF
            ItemLedgerEntry."Entry Type"::"Negative Adjmt.", ItemLedgerEntry."Entry Type"::Consumption, ItemLedgerEntry."Entry Type"::"Assembly Consumption":
                IF ItemLedgerEntry."Source Type" = ItemLedgerEntry."Source Type"::Item THEN
                    ERROR(IsNotOnInventoryErr, ItemLedgerEntry."Item No.");
            ItemLedgerEntry."Entry Type"::Transfer:
                ERROR(IsNotOnInventoryErr, ItemLedgerEntry."Item No.");
            ELSE BEGIN
                Item.GET(ItemLedgerEntry."Item No.");
                IF Item.PreventNegativeInventory THEN
                    ERROR(IsNotOnInventoryErr, ItemLedgerEntry."Item No.");
            END;
        END;
        IsHandled := true;
    end;

    var
        IsNotOnInventoryErr: label 'You have insufficient quantity of Item %1 on inventory.';
}
