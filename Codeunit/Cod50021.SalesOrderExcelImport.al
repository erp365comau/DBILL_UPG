codeunit 50021 "Sales Order Excel Import"
{
    procedure CreateExcel(Forecast: Code[10]; AdjFactor: Decimal; SelectOption: Integer)
    begin
        ReadExcelSheet();
    end;

    procedure ReadExcelSheet()
    var
        FileName: Text[100];
        SheetName: Text[100];
        FileMgt: Codeunit "File Management";
        IStream: InStream;
        FromFile: Text[100];
    begin
        UploadIntoStream(UploadExcelMsg, '', '', FromFile, IStream);
        if FromFile <> '' then begin
            FileName := FileMgt.GetFileName(FromFile);
            SheetName := ExcelBuffer.SelectSheetsNameStream(IStream);
        end else
            Error(NoFileFoundMsg);

        ExcelBuffer.Reset();
        ExcelBuffer.DeleteAll();
        ExcelBuffer.OpenBookStream(IStream, SheetName);
        ExcelBuffer.ReadSheet();
        GetLastRowandColumn;

        FOR X := 2 TO TotalRows DO
            InsertData(X);

        ExcelBuffer.DELETEALL;

        MESSAGE('Import is Completed');
    end;

    LOCAL procedure GetLastRowandColumn()
    begin
        ExcelBuffer.SETRANGE("Row No.", 1);
        TotalColumns := ExcelBuffer.COUNT;

        ExcelBuffer.RESET;
        IF ExcelBuffer.FINDLAST THEN
            TotalRows := ExcelBuffer."Row No.";
    end;

    LOCAL procedure InsertData(RowNo: Integer)
    begin
        IF (OrdNo <> GetValueAtCell(RowNo, 1)) and (ExtNo <> GetValueAtCell(RowNo, 2)) THEN BEGIN
            InsertSalesHeader(RowNo);
            ExtNo := GetValueAtCell(RowNo, 2);
            OrdNo := GetValueAtCell(RowNo, 1);
        END;
        InsertSalesLine(RowNo);
    end;

    LOCAL procedure GetValueAtCell(RowNo: Integer; ColNo: Integer): Text
    var
        ExcelBuffer1: Record "Excel Buffer";
        IsEmpty: Boolean;
    begin
        if ExcelBuffer1.GET(RowNo, ColNo) then
            if IsEmpty then
                exit('')
            else
                EXIT(ExcelBuffer1."Cell Value as Text");
    end;

    procedure InsertSalesHeader(RowNo: Integer)
    var
        ShipmentDate: Date;
        OrderDate: Date;
    begin
        CLEAR(SalesHeader);
        if GetValueAtCell(RowNo, 1) <> '' then begin
            SalesHeader.RESET;
            SalesReceivablesSetup.GET();
            SalesReceivablesSetup.TESTFIELD("Order Nos.");
            SalesHeader.LOCKTABLE;
            SalesHeader.INIT;
            SalesHeader.VALIDATE("Document Type", SalesHeader."Document Type"::Order);
            SalesHeader.VALIDATE("No.", NoSeriesMgt.GetNextNo(SalesReceivablesSetup."Order Nos.", TODAY, TRUE));
            SalesHeader.VALIDATE("Sell-to Customer No.", GetValueAtCell(RowNo, 1));
            SalesHeader.Validate("External Document No.", GetValueAtCell(RowNo, 2));
            SalesHeader.INSERT(TRUE);
        end;
    end;

    LOCAL procedure InsertSalesLine(RowNo: Integer)
    var
        Qty: Decimal;
        UnitPrice: Decimal;
        LineDiscount: Decimal;
        LineAmount: Decimal;
    begin
        if GetValueAtCell(RowNo, 1) <> '' then begin
            LineNo += 10000;
            SalesLine.INIT;
            SalesLine.VALIDATE("Document Type", SalesHeader."Document Type");
            SalesLine.VALIDATE("Document No.", SalesHeader."No.");
            SalesLine."Line No." := LineNo;
            SalesLine.VALIDATE(Type, SalesLine.Type::Item);
            SalesLine.VALIDATE("No.", GetValueAtCell(RowNo, 4));
            EVALUATE(Qty, GetValueAtCell(RowNo, 5));
            SalesLine.VALIDATE(Quantity, Qty);
            if GetValueAtCell(RowNo, 6) <> '' then begin
                EVALUATE(UnitPrice, GetValueAtCell(RowNo, 6));
                SalesLine.VALIDATE("Unit Price", UnitPrice);
            end;
            Item.GET(SalesLine."No.");
            SalesLine.VALIDATE("Sell-to Customer No.", GetValueAtCell(RowNo, 1));
            Customer.GET(SalesLine."Sell-to Customer No.");
            SalesLine."Gen. Bus. Posting Group" := Customer."Gen. Bus. Posting Group";
            SalesLine."VAT Bus. Posting Group" := Customer."VAT Bus. Posting Group";
            SalesLine."Gen. Prod. Posting Group" := Item."Gen. Prod. Posting Group";
            SalesLine."VAT Prod. Posting Group" := Item."VAT Prod. Posting Group";
            VATPostingSetup.GET(SalesLine."VAT Bus. Posting Group", SalesLine."VAT Prod. Posting Group");
            SalesLine."VAT Calculation Type" := VATPostingSetup."VAT Calculation Type";
            SalesLine.INSERT(TRUE);
        end;
    end;

    var
        UploadExcelMsg: Label 'Please Choose the Excel file.';
        NoFileFoundMsg: Label 'No Excel file found!';
        ExcelImportSuccess: Label 'Excel is successfully imported.';
        ExcelBuffer: Record "Excel Buffer";
        X: Integer;
        TotalRows: Integer;
        TotalColumns: Integer;
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        LineNo: Integer;
        ServerFileName: Text;
        FileManagement: Codeunit "File Management";
        SheetName: Text;
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        NoSeriesMgt: Codeunit "No. Series";
        ExtNo: Code[10];
        OrdNo: Code[20];
        Item: Record Item;
        Customer: Record Customer;
        VATPostingSetup: Record "VAT Posting Setup";
}