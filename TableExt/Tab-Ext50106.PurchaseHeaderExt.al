tableextension 50106 PurchaseHeaderExt extends "Purchase Header"
{
    fields
    {
        field(50001; "Shipping Agent Code"; Code[10])
        {
        }
        field(50002; "Shipping Agent Service"; Code[10])
        {
        }
        modify("Prepayment No. Series")
        {
            trigger OnAfterValidate()
            begin
                if "Prepayment No. Series" <> '' then begin
                    PurchSetup.Get();
                    PurchSetup.TestField("Posted Prepmt. Inv. Nos.");
                    NoSeries.TestManual(PurchSetup."Posted Prepmt. Inv. Nos.", Rec."Prepayment No. Series");
                end;
                TestField("Prepayment No. Series", '');
            end;
        }
        modify("Prepmt. Cr. Memo No. Series")
        {
            trigger OnAfterValidate()
            var
                myInt: Integer;
            begin
                IF "Prepmt. Cr. Memo No. Series" <> '' THEN BEGIN
                    PurchSetup.GET;
                    PurchSetup.TESTFIELD("Posted Prepmt. Cr. Memo Nos.");
                    NoSeries.TestManual(PurchSetup."Posted Prepmt. Cr. Memo Nos.", "Prepmt. Cr. Memo No. Series");
                end;
            end;
        }
    }
    trigger OnAfterInsert()
    begin
        "Assigned User ID" := USERID;
    end;

    var
        NoSeries: Codeunit "No. Series";
}