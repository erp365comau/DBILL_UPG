codeunit 50009 "Tracking Specification EventSu"
{
    [EventSubscriber(ObjectType::Table, Database::"Tracking Specification", OnBeforeTestApplyToItemLedgEntry, '', false, false)]
    local procedure "Tracking Specification_OnBeforeTestApplyToItemLedgEntry"(var TrackingSpecification: Record "Tracking Specification"; ItemLedgerEntry: Record "Item Ledger Entry"; var IsHandled: Boolean)
    begin
        ItemLedgerEntry.TestField("Item No.", TrackingSpecification."Item No.");
        ItemLedgerEntry.TestField(Positive, true);
        ItemLedgerEntry.TestField("Variant Code", TrackingSpecification."Variant Code");
        ItemLedgerEntry.TestTrackingEqualToTrackingSpec(TrackingSpecification);

        IsHandled := true;
    end;

}
