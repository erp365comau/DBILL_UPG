codeunit 50015 "Production Journal Mgt EventSu"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Production Journal Mgt", OnBeforeInsertConsumptionJnlLine, '', false, false)]
    local procedure "Production Journal Mgt_OnBeforeInsertConsumptionJnlLine"(var ItemJournalLine: Record "Item Journal Line"; ProdOrderComp: Record "Prod. Order Component"; ProdOrderLine: Record "Prod. Order Line"; Level: Integer)
    begin
        ItemJournalLine."Quantity Per" := ProdOrderComp."Quantity per";
        ItemJournalLine."Routing Link Code" := ProdOrderComp."Routing Link Code";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Production Journal Mgt", OnBeforeInsertOutputJnlLine, '', false, false)]
    local procedure "Production Journal Mgt_OnBeforeInsertOutputJnlLine"(var ItemJournalLine: Record "Item Journal Line"; ProdOrderRtngLine: Record "Prod. Order Routing Line"; ProdOrderLine: Record "Prod. Order Line")
    var
        QtyToPost: Decimal;
    begin
        if (ProdOrderRtngLine."Flushing Method" <> ProdOrderRtngLine."Flushing Method"::Manual) or
          (PresetOutputQuantity = PresetOutputQuantity::"Zero on All Operations") or
          ((PresetOutputQuantity = PresetOutputQuantity::"Zero on Last Operation") and
           IsLastOperation(ProdOrderRtngLine)) or
          ((ProdOrderRtngLine."Prod. Order No." = '') and
           (PresetOutputQuantity <> PresetOutputQuantity::"Expected Quantity")) or
          (ProdOrderRtngLine."Routing Status" = ProdOrderRtngLine."Routing Status"::Finished)
       then
            QtyToPost := 0
        else
            if ProdOrderRtngLine."Prod. Order No." <> '' then
                CalculateQtyToPostForProdOrder(ProdOrderLine, ProdOrderRtngLine, QtyToPost)
            else
                // No Routing Line
                QtyToPost := ProdOrderLine."Remaining Quantity";

        if QtyToPost < 0 then
            QtyToPost := 0;

        ItemJournalLine."Routing Link Code" := ProdOrderRtngLine."Routing Link Code";
        ItemJournalLine.VALIDATE("Run Time", QtyToPost);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Production Journal Mgt", OnInsertOutputItemJnlLineOnAfterAssignTimes, '', false, false)]
    local procedure "Production Journal Mgt_OnInsertOutputItemJnlLineOnAfterAssignTimes"(var ItemJournalLine: Record "Item Journal Line"; ProdOrderLine: Record "Prod. Order Line"; ProdOrderRoutingLine: Record "Prod. Order Routing Line"; var QtyToPost: Decimal)
    begin
        ItemJournalLine."Routing Link Code" := ProdOrderRoutingLine."Routing Link Code";
        ItemJournalLine.VALIDATE("Run Time", QtyToPost);
    end;

    local procedure IsLastOperation(ProdOrderRoutingLine: Record "Prod. Order Routing Line") Result: Boolean
    begin
        Result := ProdOrderRoutingLine."Next Operation No." = '';
    end;

    local procedure CalculateQtyToPostForProdOrder(ProdOrderLine: Record "Prod. Order Line"; ProdOrderRoutingLine: Record "Prod. Order Routing Line"; var QtyToPost: Decimal)
    var
        MfgCostCalcMgt: Codeunit "Mfg. Cost Calculation Mgt.";
    begin
        QtyToPost :=
            MfgCostCalcMgt.CalcQtyAdjdForRoutingScrap(
                ProdOrderLine."Quantity (Base)",
                ProdOrderRoutingLine."Scrap Factor % (Accumulated)",
                ProdOrderRoutingLine."Fixed Scrap Qty. (Accum.)") -
            MfgCostCalcMgt.CalcActOutputQtyBase(ProdOrderLine, ProdOrderRoutingLine);
        QtyToPost := QtyToPost / ProdOrderLine."Qty. per Unit of Measure";
    end;

    var

        PresetOutputQuantity: Option "Expected Quantity","Zero on All Operations","Zero on Last Operation";

}
