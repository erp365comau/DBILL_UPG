report 90000 "GST PURCHASE FIX"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Report/GSTPURCHASEFIX.rdl';
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem("GST Purchase Entry"; "GST Purchase Entry")
        {

            trigger OnAfterGetRecord()
            begin
                RecGSTPurchaseEntry.SETFILTER("Entry No.", '<%1', "Entry No.");
                RecGSTPurchaseEntry.SETRANGE("Posting Date", "Posting Date");
                RecGSTPurchaseEntry.SETRANGE("Document No.", "Document No.");
                RecGSTPurchaseEntry.SETRANGE("Document Type", "Document Type");
                RecGSTPurchaseEntry.SETRANGE("Document Line No.", "Document Line No.");
                RecGSTPurchaseEntry.SETRANGE("Document Line Type", "Document Line Type");
                RecGSTPurchaseEntry.SETRANGE("Document Line Code", "Document Line Code");
                RecGSTPurchaseEntry.SETRANGE("Vendor No.", "Vendor No.");
                RecGSTPurchaseEntry.SETRANGE("GST Entry Type", "GST Entry Type");
                RecGSTPurchaseEntry.SETRANGE("Document Line Description", "Document Line Description");
                RecGSTPurchaseEntry.SETRANGE("GST Entry Type", "GST Entry Type");
                RecGSTPurchaseEntry.SETRANGE("GST Base", "GST Base");
                RecGSTPurchaseEntry.SETRANGE(Amount, Amount);

                IF RecGSTPurchaseEntry.FIND('-') THEN BEGIN
                    "To Delete" := TRUE;
                    MODIFY;
                END;
            end;

            trigger OnPreDataItem()
            begin
                MODIFYALL("To Delete", FALSE);
            end;
        }
    }
    requestpage
    {

        layout
        {
        }
        actions
        {
        }
    }
    labels
    {
    }

    var
        RecGSTPurchaseEntry: Record "GST Purchase Entry";
}

