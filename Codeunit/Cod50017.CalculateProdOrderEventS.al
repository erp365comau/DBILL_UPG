codeunit 50017 "Calculate Prod. Order EventS"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Calculate Prod. Order", OnTransferRoutingOnbeforeValidateDirectUnitCost, '', false, false)]
    local procedure "Calculate Prod. Order_OnTransferRoutingOnbeforeValidateDirectUnitCost"(var ProdOrderRoutingLine: Record "Prod. Order Routing Line"; ProdOrderLine: Record "Prod. Order Line"; RoutingLine: Record "Routing Line")
    begin
        IF RoutingLine."Next Operation No." = '' THEN
            ProdOrderRoutingLine."Routing Status" := ProdOrderRoutingLine."Routing Status"::Finished;
    end;
}
