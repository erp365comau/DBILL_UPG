codeunit 50002 "Item EventSub"
{
    [EventSubscriber(ObjectType::Table, Database::Item, OnBeforeTestNoOpenDocumentsWithTrackingExist, '', false, false)]
    local procedure Item_OnBeforeTestNoOpenDocumentsWithTrackingExist(Item: Record Item; ItemTrackingCode2: Record "Item Tracking Code"; var IsHandled: Boolean)
    begin
        IsHandled := true;
    end;

}
