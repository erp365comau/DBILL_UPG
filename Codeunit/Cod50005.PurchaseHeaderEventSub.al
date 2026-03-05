codeunit 50005 "Purchase Header EventSub"
{
    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", OnBeforeConfirmDeletion, '', false, false)]
    local procedure "Purchase Header_OnBeforeConfirmDeletion"(var PurchaseHeader: Record "Purchase Header"; var Result: Boolean; var IsHandled: Boolean)
    begin
        if PurchaseHeader.Status <> PurchaseHeader.Status::Open then
            Error(Text009, PurchaseHeader."No.", PurchaseHeader.Status);
    end;


    var
        Text009: Label 'You cannot delete Purchase Order %1 because its status is %2. Only Open orders can be deleted.';
}
