codeunit 50016 "Sales Price Calc. Mgt. EventSu"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Price Calc. Mgt.", OnAfterFindSalesLineItemPrice, '', false, false)]
    local procedure "Sales Price Calc. Mgt._OnAfterFindSalesLineItemPrice"(var SalesLine: Record "Sales Line"; var TempSalesPrice: Record "Sales Price" temporary; var FoundSalesPrice: Boolean; CalledByFieldNo: Integer)
    begin
        if not FoundSalesPrice or ((CalledByFieldNo = SalesLine.FieldNo(Quantity)) or not (CalledByFieldNo = SalesLine.FieldNo("Variant Code"))) then begin
            SalesLine."Unit Price 2" := TempSalesPrice."Unit Price";
        end;
    end;

    var
        SalesPriceCalcMgt: Codeunit "Sales Price Calc. Mgt.";
}
