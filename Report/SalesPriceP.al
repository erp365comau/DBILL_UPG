report 50013 "Sales Price - P"
{
    // J2528 Austral Sugeevan 09/06/2013 --> Created this report and removed Qty value field
    // J3352 Austral Sugeevan 01/07/2013 --> Added UOM Column
    DefaultLayout = RDLC;
    RDLCLayout = 'Report/SalesPriceP.rdl';
    ApplicationArea = all;
    Caption = 'Sales Price';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Customer; Customer)
        {
            RequestFilterFields = "No.";
            RequestFilterHeading = 'Customer';
            column(No__; "No.")
            {
            }
            column(Name__; Name)
            {
            }
            column(CompanyAddr1; CompanyAddr[1])
            {
            }
            column(CompanyAddr2; CompanyAddr[2])
            {
            }
            column(CompanyAddr3; CompanyAddr[3])
            {
            }
            column(CompanyAddr4; CompanyAddr[4])
            {
            }
            column(CompanyInfoPhoneNo; CompanyInfo."Phone No.")
            {
            }
            column(CompanyInfoHomePage; CompanyInfo."Home Page")
            {
            }
            column(CompanyInfoEmail; CompanyInfo."E-Mail")
            {
            }
            column(CompanyAddr5; CompanyAddr[5])
            {
            }
            column(CompanyInfo_FaxNo__; CompanyInfo."Fax No.")
            {
            }
            column(CompanyInfo_ABN__; CompanyInfo.ABN)
            {
            }
            column(CustAdd_1__; CustAddr[1])
            {
            }
            column(CustAdd_2__; CustAddr[2])
            {
            }
            column(CustAdd_3__; CustAddr[3])
            {
            }
            column(CustAdd_4__; CustAddr[4])
            {
            }
            column(CustAdd_5__; CustAddr[5])
            {
            }
            column(Contact__; Contact)
            {
            }
            column(PhoneNo__; "Phone No.")
            {
            }
            column(FaxNo__; "Fax No.")
            {
            }
            column(Email__; "E-Mail")
            {
            }
            column(CompanyInfo_Picture__; CompanyInfo.Picture)
            {
            }
            column(Date_Today__; TODAY)
            {
            }
            dataitem("Sales Price"; "Sales Price")
            {
                DataItemLink = "Sales Code" = FIELD("No.");
                column(SalesPrice_ItemNo__; "Item No.")
                {
                }
                column(Item_Description__; "Item Description")
                {
                }
                column(MinimumQuantity__; "Minimum Quantity")
                {
                }
                column(UnitPrice__; "Unit Price")
                {
                    DecimalPlaces = 2 : 4;
                }
                column(Item_Picture__; Item.Picture)
                {
                }
                column(SalesPrice_UOMCode__; "Unit of Measure Code")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    CLEAR(Item);
                    IF Item.GET("Item No.") THEN
                        Item.CALCFIELDS(Picture);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                IF RespCenter.GET("Responsibility Center") THEN BEGIN
                    FormatAddr.RespCenter(CompanyAddr, RespCenter);
                    CompanyInfo."Phone No." := RespCenter."Phone No.";
                    CompanyInfo."Fax No." := RespCenter."Fax No.";
                END ELSE BEGIN
                    FormatAddr.Company(CompanyAddr, CompanyInfo);
                END;

                FormatAddr.Customer(CustAddr, Customer);
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

    trigger OnInitReport()
    begin
        CompanyInfo.GET;
        //CompanyInfo.CALCFIELDS(Picture);
    end;

    var
        CompanyInfo: Record "Company Information";
        RespCenter: Record "Responsibility Center";
        CompanyAddr: array[8] of Text[50];
        FormatAddr: Codeunit "Format Address";
        CustAddr: array[8] of Text[50];
        Item: Record Item;
}

