codeunit 50019 "Item Card EventSub"
{
    /*  [EventSubscriber(ObjectType::Page, Page::"Item Card", OnAfterInitControls, '', false, false)]
     local procedure "Item Card_OnAfterInitControls"(var Sender: Page "Item Card")
     begin
         UnitCostVisible := TRUE;
     end; */

    var
        UserSetup: Record "User Setup";
        UnitCostEnable: Boolean;
        UnitCostVisible: Boolean;

}
