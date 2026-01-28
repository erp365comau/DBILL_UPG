codeunit 50010 "Production Order EventSub"
{
    [EventSubscriber(ObjectType::Table, Database::"Production Order", OnBeforeAssignItemNo, '', false, false)]
    local procedure "Production Order_OnBeforeAssignItemNo"(var ProdOrder: Record "Production Order"; xProdOrder: Record "Production Order"; var Item: Record Item; CallingFieldNo: Integer)
    begin
        MfgSetup.GET;
        ProdOrder."Location Code" := MfgSetup."Default Location";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Production Order", OnGetDefaultBinOnBeforeThirdPrioritySetBinCode, '', false, false)]
    local procedure "Production Order_OnGetDefaultBinOnBeforeThirdPrioritySetBinCode"(var ProductionOrder: Record "Production Order"; xProductionOrder: Record "Production Order"; var IsHandled: Boolean)
    var
        ProdOrderWarehouseMgt: Codeunit "Prod. Order Warehouse Mgt.";
    begin
        IF (ProductionOrder."Location Code" <> '') AND (ProductionOrder."Source No." <> '') THEN BEGIN
            GetLocation(ProductionOrder."Location Code");
            IF Location."Bin Mandatory" AND NOT Location."Directed Put-away and Pick" THEN
                ProdOrderWarehouseMgt.GetDefaultBin(ProductionOrder."Source No.", '', ProductionOrder."Location Code", ProductionOrder."Bin Code");
        END;
    end;

    local procedure GetLocation(LocationCode: Code[10])
    begin
        if Location.Code <> LocationCode then
            Location.Get(LocationCode);
    end;


    var
        MfgSetup: Record "Manufacturing Setup";
        Location: Record Location;
}
