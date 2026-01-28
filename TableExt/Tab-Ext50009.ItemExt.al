tableextension 50009 ItemExt extends Item
{

    fields
    {
        field(50000; "Product Group Code"; Code[20])
        {
            Caption = 'Product Group Code';
            TableRelation = "Product Group Code"."Code";
        }
        modify("No.")
        {
            Width = 20;
        }
        modify(Description)
        {
            Width = 100;
        }
        modify("Base Unit of Measure")
        {
            Width = 20;
        }
        modify("Price/Profit Calculation")
        {
            trigger OnAfterValidate()
            begin
                IF "Price Includes VAT" AND
                   (Rec."Price/Profit Calculation" < "Price/Profit Calculation"::"No Relationship")
                THEN BEGIN
                    VATPostingSetup.GET("VAT Bus. Posting Gr. (Price)", "VAT Prod. Posting Group");
                    CASE VATPostingSetup."VAT Calculation Type" OF
                        VATPostingSetup."VAT Calculation Type"::"Reverse Charge VAT":
                            VATPostingSetup."VAT %" := 0;
                        VATPostingSetup."VAT Calculation Type"::"Sales Tax":
                            ERROR(
                              Text006,
                              VATPostingSetup.FIELDCAPTION("VAT Calculation Type"),
                              VATPostingSetup."VAT Calculation Type");
                    END;
                END ELSE
                    CLEAR(VATPostingSetup);

                CASE "Price/Profit Calculation" OF
                    "Price/Profit Calculation"::"Profit=Price-Cost":
                        IF "Unit Price" <> 0 THEN
                            IF "Unit Cost" = 0 THEN
                                "Profit %" := 0
                            ELSE
                                "Profit %" :=
                                  ROUND(
                                    100 * (1 - "Unit Cost" /
                                           ("Unit Price" / (1 + VATPostingSetup."VAT %" / 100))), 0.00001)
                        ELSE
                            "Profit %" := 0;
                    "Price/Profit Calculation"::"Price=Cost+Profit":
                        IF "Profit %" < 100 THEN BEGIN
                            GetGLSetup;
                            "Unit Price" :=
                              ROUND(
                                ("Unit Cost" / (1 - "Profit %" / 100)) *
                                (1 + VATPostingSetup."VAT %" / 100),
                                GLSetup."Unit-Amount Rounding Precision");
                        END;
                END;
            end;
        }
        modify("Item Tracking Code")
        {
            trigger OnAfterValidate()
            var
                myInt: Integer;
            begin

            end;
        }
    }
    trigger OnBeforeInsert()
    begin
        CheckModifyAllowed(0);
    end;

    trigger OnBeforeModify()
    begin
        CheckModifyAllowed(1);
    end;

    trigger OnBeforeDelete()
    begin
        CheckModifyAllowed(1);
    end;

    trigger OnBeforeRename()
    begin
        CheckModifyAllowed(1);
    end;



    local procedure GetGLSetup()
    begin
        IF NOT GLSetupRead THEN
            GLSetup.GET;
        GLSetupRead := TRUE;
    end;

    procedure PlanningTransferShptQty() Sum: Decimal
    var
        ReqLine: Record "Requisition Line";
    begin
        ReqLine.SETCURRENTKEY(Type, "No.", "Variant Code", "Transfer-from Code", "Transfer Shipment Date");
        ReqLine.SETRANGE("Replenishment System", ReqLine."Replenishment System"::Transfer);
        ReqLine.SETRANGE(Type, ReqLine.Type::Item);
        ReqLine.SETRANGE("No.", "No.");
        COPYFILTER("Variant Filter", ReqLine."Variant Code");
        COPYFILTER("Location Filter", ReqLine."Transfer-from Code");
        COPYFILTER("Date Filter", ReqLine."Transfer Shipment Date");
        IF ReqLine.ISEMPTY THEN
            EXIT;

        IF ReqLine.FINDSET THEN
            REPEAT
                Sum += ReqLine."Quantity (Base)";
            UNTIL ReqLine.NEXT = 0;
    end;

    procedure PlanningReleaseQty() Sum: Decimal
    var
        ReqLine: Record "Requisition Line";
    begin
        ReqLine.SETCURRENTKEY(Type, "No.", "Variant Code", "Location Code");
        ReqLine.SETRANGE(Type, ReqLine.Type::Item);
        ReqLine.SETRANGE("No.", "No.");
        COPYFILTER("Variant Filter", ReqLine."Variant Code");
        COPYFILTER("Location Filter", ReqLine."Location Code");
        COPYFILTER("Date Filter", ReqLine."Starting Date");
        COPYFILTER("Global Dimension 1 Filter", ReqLine."Shortcut Dimension 1 Code");
        COPYFILTER("Global Dimension 2 Filter", ReqLine."Shortcut Dimension 2 Code");
        IF ReqLine.ISEMPTY THEN
            EXIT;
        IF ReqLine.FINDSET THEN
            REPEAT
                Sum += ReqLine."Quantity (Base)";
            UNTIL ReqLine.NEXT = 0;
    end;

    procedure CalcSalesReturn(): Decimal
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.SETCURRENTKEY("Document Type", Type, "No.", "Variant Code", "Drop Shipment", "Location Code", "Shipment Date");
        SalesLine.SETRANGE("Document Type", SalesLine."Document Type"::"Return Order");
        SalesLine.SETRANGE(Type, SalesLine.Type::Item);
        SalesLine.SETRANGE("No.", "No.");
        SalesLine.SETFILTER("Location Code", GETFILTER("Location Filter"));
        SalesLine.SETFILTER("Drop Shipment", GETFILTER("Drop Shipment Filter"));
        SalesLine.SETFILTER("Variant Code", GETFILTER("Variant Filter"));
        SalesLine.SETFILTER("Shipment Date", GETFILTER("Date Filter"));
        SalesLine.CALCSUMS("Outstanding Qty. (Base)");
        EXIT(SalesLine."Outstanding Qty. (Base)");
    end;

    procedure CalcPlanningWorksheetQty(): Decimal
    var
        RequisitionLine: Record "Requisition Line";
    begin
        RequisitionLine.SETRANGE(Type, RequisitionLine.Type::Item);
        RequisitionLine.SETRANGE("No.", "No.");
        RequisitionLine.SETFILTER("Variant Code", GETFILTER("Variant Filter"));
        RequisitionLine.SETFILTER("Location Code", GETFILTER("Location Filter"));
        RequisitionLine.SETFILTER("Shortcut Dimension 1 Code", GETFILTER("Global Dimension 1 Filter"));
        RequisitionLine.SETFILTER("Shortcut Dimension 2 Code", GETFILTER("Global Dimension 2 Filter"));
        RequisitionLine.SETFILTER("Due Date", GETFILTER("Date Filter"));
        RequisitionLine.SETRANGE("Planning Line Origin", RequisitionLine."Planning Line Origin"::Planning);
        RequisitionLine.CALCSUMS("Quantity (Base)");
        EXIT(RequisitionLine."Quantity (Base)");
    end;

    procedure CalcResvQtyOnSalesReturn(): Decimal
    var
        ReservationEntry: Record "Reservation Entry";
    begin
        ReservationEntry.SETCURRENTKEY(
          "Item No.", "Source Type", "Source Subtype", "Reservation Status",
          "Location Code", "Variant Code", "Shipment Date", "Expected Receipt Date");
        ReservationEntry.SETRANGE("Item No.", "No.");
        ReservationEntry.SETRANGE("Source Type", DATABASE::"Sales Line");
        ReservationEntry.SETRANGE("Source Subtype", 5); // return order
        ReservationEntry.SETRANGE("Reservation Status", ReservationEntry."Reservation Status"::Reservation);
        ReservationEntry.SETFILTER("Location Code", GETFILTER("Location Filter"));
        ReservationEntry.SETFILTER("Variant Code", GETFILTER("Variant Filter"));
        ReservationEntry.SETFILTER("Expected Receipt Date", GETFILTER("Date Filter"));
        ReservationEntry.CALCSUMS("Quantity (Base)");
        EXIT(ReservationEntry."Quantity (Base)");
    end;

    procedure CalcPurchReturn(): Decimal
    var
        PurchLine: Record "Purchase Line";
    begin
        PurchLine.SETCURRENTKEY("Document Type", Type, "No.", "Variant Code", "Drop Shipment", "Location Code", "Expected Receipt Date");
        PurchLine.SETRANGE("Document Type", PurchLine."Document Type"::"Return Order");
        PurchLine.SETRANGE(Type, PurchLine.Type::Item);
        PurchLine.SETRANGE("No.", "No.");
        PurchLine.SETFILTER("Location Code", GETFILTER("Location Filter"));
        PurchLine.SETFILTER("Drop Shipment", GETFILTER("Drop Shipment Filter"));
        PurchLine.SETFILTER("Variant Code", GETFILTER("Variant Filter"));
        PurchLine.SETFILTER("Expected Receipt Date", GETFILTER("Date Filter"));
        PurchLine.CALCSUMS("Outstanding Qty. (Base)");
        EXIT(PurchLine."Outstanding Qty. (Base)");
    end;

    procedure CalcResvQtyOnPurchReturn(): Decimal
    var
        ReservationEntry: Record "Reservation Entry";
    begin
        ReservationEntry.SETCURRENTKEY(
          "Item No.", "Source Type", "Source Subtype", "Reservation Status",
          "Location Code", "Variant Code", "Shipment Date", "Expected Receipt Date");
        ReservationEntry.SETRANGE("Item No.", "No.");
        ReservationEntry.SETRANGE("Source Type", DATABASE::"Purchase Line");
        ReservationEntry.SETRANGE("Source Subtype", 5);
        ReservationEntry.SETRANGE("Reservation Status", ReservationEntry."Reservation Status"::Reservation);
        ReservationEntry.SETFILTER("Location Code", GETFILTER("Location Filter"));
        ReservationEntry.SETFILTER("Variant Code", GETFILTER("Variant Filter"));
        ReservationEntry.SETFILTER("Shipment Date", GETFILTER("Date Filter"));
        ReservationEntry.CALCSUMS("Quantity (Base)");
        EXIT(-ReservationEntry."Quantity (Base)");
    end;


    procedure CheckModifyAllowed(ChangeType: Integer)
    var
        UserSetup: Record "User Setup";
    begin

        IF NOT UserSetup.GET(USERID) THEN
            ERROR('Change is not allowed');

        CASE ChangeType OF
            0:
                BEGIN
                    IF NOT UserSetup."Insert Allowed - Item" THEN
                        ERROR(Text50000, 'Insert', USERID);
                END;
            1:
                BEGIN
                    IF NOT UserSetup."Modify Allowed - Item" THEN
                        ERROR(Text50000, 'Modify', USERID);
                END;
        END;
    end;



    var
        GLSetup: Record "General Ledger Setup";
        VATPostingSetup: Record "VAT Posting Setup";
        GLSetupRead: Boolean;
        Text006: Label 'Prices including VAT cannot be calculated when %1 is %2.';
        Text50000: Label '%1 is not allowed for user %2.';


}
