tableextension 50104 SalesHeaderExt extends "Sales Header"
{
    fields
    {
        field(50000; "Validity"; Option)
        {
            OptionMembers = "7 Days","30 Days";
        }
        field(50001; "Shipping Mark"; Code[20])
        {
        }
        field(50002; "Vessel No."; Code[20])
        {
        }
        field(50003; "Voyage No."; Code[20])
        {
        }
        field(50004; "Seal No."; Code[20])
        {
        }
        field(50005; "Container No."; Code[20])
        {
        }
        field(50300; "VMS-Ref No."; Text[100])
        {
        }
        field(50301; "VMS-SDC-Invoice No."; Text[100])
        {
        }
        field(50303; "VMS-SDC-Error"; Boolean)
        {
        }
        field(50304; "VMS-SDC-Error ID"; Integer)
        {
        }
        field(50305; "Unit Price Changed"; Boolean)
        {
        }
        modify("Prepayment No. Series")
        {
            trigger OnAfterValidate()
            begin
                IF "Prepayment No. Series" <> '' THEN BEGIN
                    SalesSetup.GET;
                    SalesSetup.TESTFIELD("Posted Prepmt. Inv. Nos.");
                    NoSeries.TestManual(SalesSetup."Posted Prepmt. Inv. Nos.", "Prepayment No. Series");
                END;
                TESTFIELD("Prepayment No.", '');
            end;
        }
        modify("Prepmt. Cr. Memo No. Series")
        {
            trigger OnAfterValidate()
            begin
                IF "Prepmt. Cr. Memo No." <> '' THEN BEGIN
                    SalesSetup.GET;
                    SalesSetup.TESTFIELD("Posted Prepmt. Cr. Memo Nos.");
                    NoSeries.TestManual(SalesSetup."Posted Prepmt. Cr. Memo Nos.", "Prepmt. Cr. Memo No.");
                END;
                TESTFIELD("Prepmt. Cr. Memo No.", '');
            end;
        }
        modify("Direct Debit Mandate ID")
        {
            trigger OnAfterValidate()
            begin
                ShowDirectDebitMandates;
            end;
        }
    }
    procedure ShowDirectDebitMandates()
    var
        SEPADirectDebitMandate: Record "SEPA Direct Debit Mandate";
        SEPADirectDebitMandates: Page "SEPA Direct Debit Mandates";
    begin
        Rec.TESTFIELD("Bill-to Customer No.");
        SEPADirectDebitMandate.SETRANGE("Customer No.", "Bill-to Customer No.");
        IF "Direct Debit Mandate ID" <> '' THEN
            SEPADirectDebitMandate.GET("Direct Debit Mandate ID");
        SEPADirectDebitMandates.SETTABLEVIEW(SEPADirectDebitMandate);
        SEPADirectDebitMandates.SETRECORD(SEPADirectDebitMandate);
        IF SEPADirectDebitMandates.RUNMODAL = ACTION::OK THEN BEGIN
            SEPADirectDebitMandates.GETRECORD(SEPADirectDebitMandate);
            "Direct Debit Mandate ID" := SEPADirectDebitMandate.ID;
        END;
    end;


    procedure ZeroAmountInLines()
    begin
        SalesLine.SetSalesHeader(SalesHeader);
        SalesLine.SETRANGE("Document Type", "Document Type");
        SalesLine.SETRANGE("Document No.", "No.");
        SalesLine.SETFILTER(Type, '>0');
        SalesLine.SETFILTER(Quantity, '<>0');
        IF SalesLine.FINDSET(TRUE) THEN
            REPEAT
                SalesLine.Amount := 0;
                SalesLine."Amount Including VAT" := 0;
                SalesLine."VAT Base Amount" := 0;
                SalesLine.InitOutstandingAmount;
                SalesLine.MODIFY;
            UNTIL SalesLine.NEXT = 0;
    end;

    procedure CreateInvtPutAwayPick()
    var
        WhseRequest: Record "Warehouse Request";
    begin
        if "Document Type" = "Document Type"::Order then
            if not IsApprovedForPosting() then
                exit;

        TestField(Status, Status::Released);

        WhseRequest.Reset();
        WhseRequest.SetCurrentKey("Source Document", "Source No.");
        case "Document Type" of
            "Document Type"::Order:
                WhseRequest.SetRange("Source Document", WhseRequest."Source Document"::"Sales Order");
            "Document Type"::"Return Order":
                WhseRequest.SetRange("Source Document", WhseRequest."Source Document"::"Sales Return Order");
        end;
        WhseRequest.SetRange("Source No.", "No.");
        REPORT.RunModal(REPORT::"Create Invt Put-away/Pick/Mvmt", true, false, WhseRequest);
    end;


    var
        NoSeries: Codeunit "No. Series";
}