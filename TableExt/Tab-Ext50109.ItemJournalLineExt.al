tableextension 50109 ItemJournalLineExt extends "Item Journal Line"
{
    fields
    {
        field(50000; "Quantity Per"; Decimal)
        {
        }
        field(50001; "Routing Link Code"; Code[10])
        {
        }
        field(50002; "Output Quantity (Prod Jnl)"; Decimal)
        {
        }
        field(50003; "Shelf No."; Text[30])
        {
        }
    }
    procedure GetSKU(): Boolean
    begin
        IF (SKU."Location Code" = "Location Code") AND
           (SKU."Item No." = "Item No.") AND
           (SKU."Variant Code" = "Variant Code")
        THEN
            EXIT(TRUE);
        IF SKU.GET("Location Code", "Item No.", "Variant Code") THEN
            EXIT(TRUE);
        EXIT(FALSE);
    end;

    var
        SKU: Record "Stockkeeping Unit";
}