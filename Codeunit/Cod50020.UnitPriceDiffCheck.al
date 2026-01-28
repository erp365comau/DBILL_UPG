codeunit 50020 UnitPriceDiffCheck
{
    trigger OnRun()
    var
        SH: Record "Sales Header";
    begin
        if SH.FindSet() then
            repeat
                if HasUnitPriceDifference(SH) then begin
                    SH."Unit Price Changed" := true;
                    SH.Modify();
                end;
            until SH.Next() = 0;
    end;

    local procedure HasUnitPriceDifference(SH: Record "Sales Header"): Boolean
    var
        SL: Record "Sales Line";
    begin
        SL.SetRange("Document Type", SH."Document Type");
        SL.SetRange("Document No.", SH."No.");

        if SL.FindSet() then
            repeat
                if SL."Unit Price" < SL."Unit Price 2" then begin
                    SL."Price Changed" := true;
                    SL.Modify();
                    exit(true);
                end;
            until SL.Next() = 0;

        exit(false);
    end;
}
