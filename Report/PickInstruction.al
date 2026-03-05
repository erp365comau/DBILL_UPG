report 50034 "Pick Instruction Report"
{
    // Austral Sugeevan 01/07/2014 --> Added Item Tracking Lines Section
    // Austral Sugeevan 06/10/2014 >>> Added Cust. Order No. in RTC Design
    // Austral Sugeevan 01/12/2014 >>> Added Ship to Address
    // J10783 20180406 LK - ADD ORDER DATE TO LAYOUT HEADER
    // J15698 Austral Sugeevan 05/05/2021 >>> Skip fully invoiced lines
    DefaultLayout = RDLC;
    RDLCLayout = 'Report/PickInstruction.rdl';
    Caption = 'Pick Instruction';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(CopyLoop; Integer)
        {
            DataItemTableView = SORTING(Number);
            column(Number; Number)
            {
            }
            column(CompanyNameText; CompNameText)
            {
            }
            column(DateText; DateTxt)
            {
            }
            dataitem("Sales Header"; "Sales Header")
            {
                DataItemTableView = SORTING("Document Type", "No.")
                                    WHERE("Document Type" = CONST(Order));
                RequestFilterFields = "No.";
                column(No_SalesHeader; "No.")
                {
                    IncludeCaption = true;
                }
                column(CustomerNo_SalesHeader; "Sell-to Customer No.")
                {
                    IncludeCaption = true;
                }
                column(CustomerName_SalesHeader; "Sell-to Customer Name")
                {
                    IncludeCaption = true;
                }
                column(ExternalDocumentNo_SalesHeader; "External Document No.")
                {
                }
                column(OrderDate_SalesHeader; "Sales Header"."Order Date")
                {
                }
                column(RequestedDeliveryDate_SalesHeader; "Sales Header"."Requested Delivery Date")
                {
                }
                column(PromisedDeliveryDate_SalesHeader; "Sales Header"."Promised Delivery Date")
                {
                }
                column(ShiptoAddr_1__; ShipToAddr[1])
                {
                }
                column(ShiptoAddr_2__; ShipToAddr[2])
                {
                }
                column(ShiptoAddr_3__; ShipToAddr[3])
                {
                }
                dataitem("Sales Line"; "Sales Line")
                {
                    DataItemLink = "Document Type" = FIELD("Document Type"),
                                   "Document No." = FIELD("No.");
                    DataItemTableView = SORTING("Document Type", "Document No.", "Line No.")
                                        WHERE("Type" = CONST(Item));
                    column(LineNo_SalesLine; "Line No.")
                    {
                    }
                    column(ItemNo_SalesLine; "No.")
                    {
                        IncludeCaption = true;
                    }
                    column(Description_SalesLine; Description)
                    {
                        IncludeCaption = true;
                    }
                    column(VariantCode_SalesLine; "Variant Code")
                    {
                        IncludeCaption = true;
                    }
                    column(LocationCode_SalesLine; "Location Code")
                    {
                        IncludeCaption = true;
                    }
                    column(BinCode_SalesLine; "Bin Code")
                    {
                        IncludeCaption = true;
                    }
                    column(ShipmentDate_SalesLine; FORMAT("Shipment Date"))
                    {
                    }
                    column(Quantity_SalesLine; Quantity)
                    {
                        IncludeCaption = true;
                    }
                    column(UnitOfMeasure_SalesLine; "Unit of Measure")
                    {
                        IncludeCaption = true;
                    }
                    column(QuantityToShip_SalesLine; "Qty. to Ship")
                    {
                        IncludeCaption = true;
                    }
                    column(QuantityShipped_SalesLine; "Quantity Shipped")
                    {
                        IncludeCaption = true;
                    }
                    column(QtyToAsm; QtyToAsm)
                    {
                    }
                    column(NetWeight_SalesLine; NetWeight)
                    {
                    }
                    dataitem(ItemTrackingLines; Integer)
                    {
                        DataItemTableView = SORTING(Number);
                        column(TempItemTracking_LotNo__; TempItemTracking2."Lot No.")
                        {
                        }
                        column(TempItemTracking_ExpirationDate__; TempItemTracking2."Expiration Date")
                        {
                        }
                        column(TempItemTracking_QtyBase__; TempItemTracking2."Quantity (Base)")
                        {
                        }
                        column(TrackingSpecification_EntryNo__; TempItemTracking2."Entry No.")
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            //Austral Sugeevan 01/07/2014 --> Begin
                            IF Number = 1 THEN
                                TempItemTracking2.FIND('-')
                            ELSE
                                TempItemTracking2.NEXT;
                            //Austral Sugeevan 01/07/2014 --> End
                        end;

                        trigger OnPreDataItem()
                        begin
                            SETRANGE(Number, 1, TempItemTracking2.COUNT);//Austral Sugeevan 01/07/2014
                        end;
                    }
                    dataitem("Assembly Line"; "Assembly Line")
                    {
                        DataItemTableView = SORTING("Document Type", "Document No.", "Line No.");
                        column(No_AssemblyLine; "No.")
                        {
                            IncludeCaption = true;
                        }
                        column(Description_AssemblyLine; Description)
                        {
                            IncludeCaption = true;
                        }
                        column(VariantCode_AssemblyLine; "Variant Code")
                        {
                            IncludeCaption = true;
                        }
                        column(Quantity_AssemblyLine; Quantity)
                        {
                            IncludeCaption = true;
                        }
                        column(QuantityPer_AssemblyLine; "Quantity per")
                        {
                            IncludeCaption = true;
                        }
                        column(UnitOfMeasure_AssemblyLine; GetUOM("Unit of Measure Code"))
                        {
                        }
                        column(LocationCode_AssemblyLine; "Location Code")
                        {
                            IncludeCaption = true;
                        }
                        column(BinCode_AssemblyLine; "Bin Code")
                        {
                            IncludeCaption = true;
                        }
                        column(QuantityToConsume_AssemblyLine; "Quantity to Consume")
                        {
                            IncludeCaption = true;
                        }

                        trigger OnPreDataItem()
                        begin
                            IF NOT AsmExists THEN
                                CurrReport.BREAK;
                            SETRANGE("Document Type", AsmHeader."Document Type");
                            SETRANGE("Document No.", AsmHeader."No.");
                        end;
                    }

                    trigger OnAfterGetRecord()
                    var
                        AssembleToOrderLink: Record "Assemble-to-Order Link";
                    begin
                        //J15698 Austral Sugeevan 05/05/2021 >>>
                        IF (Type <> Type::" ") AND ("Quantity Invoiced" - Quantity = 0) THEN
                            CurrReport.SKIP;
                        //J15698 Austral Sugeevan 05/05/2021 <<<

                        AssembleToOrderLink.RESET;
                        AssembleToOrderLink.SETCURRENTKEY(Type, "Document Type", "Document No.", "Document Line No.");
                        AssembleToOrderLink.SETRANGE(Type, AssembleToOrderLink.Type::Sale);
                        AssembleToOrderLink.SETRANGE("Document Type", "Document Type");
                        AssembleToOrderLink.SETRANGE("Document No.", "Document No.");
                        AssembleToOrderLink.SETRANGE("Document Line No.", "Line No.");
                        AsmExists := AssembleToOrderLink.FINDFIRST;
                        QtyToAsm := 0;
                        IF AsmExists THEN
                            IF AsmHeader.GET(AssembleToOrderLink."Assembly Document Type", AssembleToOrderLink."Assembly Document No.") THEN
                                QtyToAsm := AsmHeader."Quantity to Assemble"
                            ELSE
                                AsmExists := FALSE;

                        //Austral Sugeevan 01/07/2014 --> Begin
                        CLEAR(SalesLineReserve);
                        TempItemTracking.DELETEALL;
                        SalesLine := "Sales Line";
                        //     SalesLineReserve.InitTrackingSpecification(SalesLine, TempItemTracking); ERP
                        SetSource(TempItemTracking, SalesLine."Shipment Date");
                        //Austral Sugeevan 01/07/2014 --> End

                        NetWeight := "Sales Line".Quantity * "Sales Line"."Net Weight";
                    end;
                }

                trigger OnAfterGetRecord()
                var
                    FormatAddr: Codeunit "Format Address";
                begin
                    LastEntryNo := 0;//Austral Sugeevan 01/07/2014
                    FormatAddr.SalesHeaderBillTo(CustAddr, "Sales Header");
                    FormatAddr.SalesHeaderShipTo(ShipToAddr, CustAddr, "Sales Header");  //Austral Sugeevan 01/12/2014 <<< ERP
                end;
            }

            trigger OnPreDataItem()
            begin
                SETRANGE(Number, 1, NoOfCopies + 1);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field("No of Copies"; NoOfCopies)
                    {
                        Caption = 'No of Copies';
                        ApplicationArea = all;
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
        OrderPickingListCaption = 'Pick Instruction';
        PageCaption = 'Page';
        ItemNoCaption = 'Item  No.';
        OrderNoCaption = 'Order No.';
        CustomerNoCaption = 'Customer No.';
        CustomerNameCaption = 'Customer Name';
        QtyToAssembleCaption = 'Quantity to Assemble';
        QtyAssembledCaption = 'Quantity Assembled';
        ShipmentDateCaption = 'Shipment Date';
        QtyPickedCaption = 'Quantity Picked';
        UOMCaption = 'Unit of Measure';
        QtyConsumedCaption = 'Quantity Consumed';
        CopyCaption = 'Copy';
        CustOrderNo = 'Cust. Order No. ';
        ShipToCaption = 'Ship To';
    }

    trigger OnPreReport()
    begin
        DateTxt := FORMAT(TODAY);
        CompNameText := COMPANYNAME;
    end;

    var
        AsmHeader: Record "Assembly Header";
        NoOfCopies: Integer;
        DateTxt: Text;
        CompNameText: Text;
        QtyToAsm: Decimal;
        AsmExists: Boolean;
        SalesLineReserve: Codeunit "Sales Line-Reserve";
        TempItemTracking: Record "Tracking Specification" temporary;
        SalesLine: Record "Sales Line";
        ForBinCode: Code[20];
        LastEntryNo: Integer;
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        FormRunMode: Option ,Reclass,"Combined Ship/Rcpt","Drop Shipment",Transfer;
        CurrentEntryStatus: Option Reservation,Tracking,Surplus,Prospect;
        CurrentSignFactor: Integer;
        CurrentSourceType: Integer;
        CurrentSourceCaption: Text[255];
        ExpectedReceiptDate: Date;
        ShipmentDate: Date;
        SourceQuantityArray: array[5] of Decimal;
        QtyPerUOM: Decimal;
        TempReservEntry: Record "Reservation Entry" temporary;
        CurrentSourceRowID: Text[100];
        SecondSourceRowID: Text[100];
        ItemTrackingCode: Record "Item Tracking Code";
        Item: Record Item;
        TempItemTracking2: Record "Tracking Specification" temporary;
        ShipToAddr: array[8] of Text[50];
        CustAddr: array[8] of Text[50];
        NetWeight: Decimal;

    procedure GetUOM(UOMCode: Code[10]): Text
    var
        UnitOfMeasure: Record "Unit of Measure";
    begin
        IF UnitOfMeasure.GET(UOMCode) THEN
            EXIT(UnitOfMeasure.Description);
        EXIT(UOMCode);
    end;

    procedure InitializeRequest(NewNoOfCopies: Integer)
    begin
        NoOfCopies := NewNoOfCopies;
    end;

    procedure SetSource(TrackingSpecification: Record "Tracking Specification"; AvailabilityDate: Date)
    var
        ReservEntry: Record "Reservation Entry";
        TempTrackingSpecification: Record "Tracking Specification" temporary;
        TempTrackingSpecification2: Record "Tracking Specification" temporary;
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        Controls: Option Handle,Invoice,Quantity,Reclass,LotSN;
    begin
        //Austral Sugeevan 01/07/2014 --> Begin
        GetItem(TrackingSpecification."Item No.");
        ForBinCode := TrackingSpecification."Bin Code";
        SetFilters(TrackingSpecification);
        TempTrackingSpecification.DELETEALL;

        TempReservEntry.DELETEALL;

        ReservEntry."Source Type" := TrackingSpecification."Source Type";
        ReservEntry."Source Subtype" := TrackingSpecification."Source Subtype";
        CurrentSignFactor := CreateReservEntry.SignFactor(ReservEntry);

        IF CurrentSignFactor < 0 THEN BEGIN
            ExpectedReceiptDate := 0D;
            ShipmentDate := AvailabilityDate;
        END ELSE BEGIN
            ExpectedReceiptDate := AvailabilityDate;
            ShipmentDate := 0D;
        END;

        ReservEntry.SETCURRENTKEY(
          "Source ID", "Source Ref. No.", "Source Type", "Source Subtype",
          "Source Batch Name", "Source Prod. Order Line", "Reservation Status");

        ReservEntry.SETRANGE("Source ID", TrackingSpecification."Source ID");
        ReservEntry.SETRANGE("Source Ref. No.", TrackingSpecification."Source Ref. No.");
        ReservEntry.SETRANGE("Source Type", TrackingSpecification."Source Type");
        ReservEntry.SETRANGE("Source Subtype", TrackingSpecification."Source Subtype");
        ReservEntry.SETRANGE("Source Batch Name", TrackingSpecification."Source Batch Name");
        ReservEntry.SETRANGE("Source Prod. Order Line", TrackingSpecification."Source Prod. Order Line");

        AddReservEntriesToTempRecSet(ReservEntry, TempTrackingSpecification, FALSE, 0);

        TempReservEntry.COPYFILTERS(ReservEntry);

        TrackingSpecification.SETCURRENTKEY(
          "Source ID", "Source Type", "Source Subtype",
          "Source Batch Name", "Source Prod. Order Line", "Source Ref. No.");

        TrackingSpecification.SETRANGE("Source ID", TrackingSpecification."Source ID");
        TrackingSpecification.SETRANGE("Source Type", TrackingSpecification."Source Type");
        TrackingSpecification.SETRANGE("Source Subtype", TrackingSpecification."Source Subtype");
        TrackingSpecification.SETRANGE("Source Batch Name", TrackingSpecification."Source Batch Name");
        TrackingSpecification.SETRANGE("Source Prod. Order Line", TrackingSpecification."Source Prod. Order Line");
        TrackingSpecification.SETRANGE("Source Ref. No.", TrackingSpecification."Source Ref. No.");

        IF TrackingSpecification.FINDSET THEN
            REPEAT
                TempTrackingSpecification := TrackingSpecification;
                TempTrackingSpecification.INSERT;
            UNTIL TrackingSpecification.NEXT = 0;

        AddToGlobalRecordSet(TempTrackingSpecification);
        //Austral Sugeevan 01/07/2014 --> End
    end;

    local procedure GetItem(ItemNo: Code[20])
    begin
        //Austral Sugeevan 01/07/2014 --> Begin
        IF Item."No." <> ItemNo THEN BEGIN
            Item.GET(ItemNo);
            IF ItemTrackingCode.Code <> Item."Item Tracking Code" THEN
                ItemTrackingCode.GET(Item."Item Tracking Code");
        END;
        //Austral Sugeevan 01/07/2014 --> End
    end;

    local procedure SetFilters(TrackingSpecification: Record "Tracking Specification")
    begin
        //Austral Sugeevan 01/07/2014 --> Begin
        WITH TrackingSpecification DO BEGIN
            SETCURRENTKEY("Source ID", "Source Type", "Source Subtype", "Source Batch Name", "Source Prod. Order Line", "Source Ref. No.");
            SETRANGE("Source ID", TrackingSpecification."Source ID");
            SETRANGE("Source Type", TrackingSpecification."Source Type");
            SETRANGE("Source Subtype", TrackingSpecification."Source Subtype");
            SETRANGE("Source Batch Name", TrackingSpecification."Source Batch Name");
            IF (TrackingSpecification."Source Type" = DATABASE::"Transfer Line") AND
               (TrackingSpecification."Source Subtype" = 1)
            THEN BEGIN
                SETFILTER("Source Prod. Order Line", '0 | ' + FORMAT(TrackingSpecification."Source Ref. No."));
                SETRANGE("Source Ref. No.");
            END ELSE BEGIN
                SETRANGE("Source Prod. Order Line", TrackingSpecification."Source Prod. Order Line");
                SETRANGE("Source Ref. No.", TrackingSpecification."Source Ref. No.");
            END;
            SETRANGE("Item No.", TrackingSpecification."Item No.");
            SETRANGE("Location Code", TrackingSpecification."Location Code");
            SETRANGE("Variant Code", TrackingSpecification."Variant Code");
        END;
        //Austral Sugeevan 01/07/2014 --> End
    end;

    local procedure AddReservEntriesToTempRecSet(var ReservEntry: Record "Reservation Entry"; var TempTrackingSpecification: Record "Tracking Specification" temporary; SwapSign: Boolean; Color: Integer)
    begin
        //Austral Sugeevan 01/07/2014 --> Begin
        IF ReservEntry.FINDSET THEN
            REPEAT
                IF Color = 0 THEN BEGIN
                    TempReservEntry := ReservEntry;
                    TempReservEntry.INSERT;
                END;
                IF (ReservEntry."Lot No." <> '') OR (ReservEntry."Serial No." <> '') THEN BEGIN
                    TempTrackingSpecification.TRANSFERFIELDS(ReservEntry);
                    // Ensure uniqueness of Entry No. by making it negative:
                    TempTrackingSpecification."Entry No." *= -1;
                    IF SwapSign THEN
                        TempTrackingSpecification."Quantity (Base)" *= -1;
                    IF Color <> 0 THEN BEGIN
                        TempTrackingSpecification."Quantity Handled (Base)" :=
                          TempTrackingSpecification."Quantity (Base)";
                        TempTrackingSpecification."Quantity Invoiced (Base)" :=
                          TempTrackingSpecification."Quantity (Base)";
                        TempTrackingSpecification."Qty. to Handle (Base)" := 0;
                        TempTrackingSpecification."Qty. to Invoice (Base)" := 0;
                    END;
                    TempTrackingSpecification."Buffer Status" := Color;
                    TempTrackingSpecification.INSERT;
                END;
            UNTIL ReservEntry.NEXT = 0;
        //Austral Sugeevan 01/07/2014 --> End
    end;

    local procedure AddToGlobalRecordSet(var TempTrackingSpecification: Record "Tracking Specification" temporary)
    var
        ExpDate: Date;
        EntriesExist: Boolean;
    begin
        //Austral Sugeevan 01/07/2014 --> Begin
        TempItemTracking2.DELETEALL;
        TempTrackingSpecification.SETCURRENTKEY("Lot No.", "Serial No.");
        IF TempTrackingSpecification.FIND('-') THEN
            REPEAT
                TempTrackingSpecification.SETRANGE("Lot No.", TempTrackingSpecification."Lot No.");
                TempTrackingSpecification.SETRANGE("Serial No.", TempTrackingSpecification."Serial No.");
                TempTrackingSpecification.CALCSUMS("Quantity (Base)", "Qty. to Handle (Base)",
                  "Qty. to Invoice (Base)", "Quantity Handled (Base)", "Quantity Invoiced (Base)");
                WITH TempItemTracking2 DO BEGIN
                    IF TempTrackingSpecification."Quantity (Base)" <> 0 THEN BEGIN
                        TempItemTracking2 := TempTrackingSpecification;

                        "Quantity (Base)" *= CurrentSignFactor;
                        "Qty. to Handle (Base)" *= CurrentSignFactor;
                        "Qty. to Invoice (Base)" *= CurrentSignFactor;
                        "Quantity Handled (Base)" *= CurrentSignFactor;
                        "Quantity Invoiced (Base)" *= CurrentSignFactor;
                        "Qty. to Handle" :=
                          CalcQty("Qty. to Handle (Base)");
                        "Qty. to Invoice" :=
                          CalcQty("Qty. to Invoice (Base)");
                        "Entry No." := NextEntryNo;

                        //     ExpDate := ItemTrackingMgt.ExistingExpirationDate("Item No.", "Variant Code", "Lot No.", "Serial No.", FALSE, EntriesExist); ERP

                        IF ExpDate <> 0D THEN BEGIN
                            "Expiration Date" := ExpDate;
                            "Buffer Status2" := "Buffer Status2"::"ExpDate blocked";
                        END;

                        INSERT;

                    END;

                    TempTrackingSpecification.FIND('+');
                    TempTrackingSpecification.SETRANGE("Lot No.");
                    TempTrackingSpecification.SETRANGE("Serial No.");
                END;
            UNTIL TempTrackingSpecification.NEXT = 0;
        //Austral Sugeevan 01/07/2014 --> End
    end;

    local procedure NextEntryNo(): Integer
    begin
        //Austral Sugeevan 01/07/2014 --> Begin
        LastEntryNo += 1;
        EXIT(LastEntryNo);
        //Austral Sugeevan 01/07/2014 --> End
    end;
}

