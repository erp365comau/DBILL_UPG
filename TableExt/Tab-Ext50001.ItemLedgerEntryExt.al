tableextension 50001 ItemLedgerEntryExt extends "Item Ledger Entry"
{
    fields
    {
        field(50000; "Bill To Customer"; Code[10])
        {
        }
        field(50001; "Product Group Code"; Code[20])
        {
            Caption = 'Product Group Code';
            FieldClass = FlowField;
            CalcFormula = Lookup(Item."Product Group Code" where("No." = field("Item No.")));
        }
    }
}
