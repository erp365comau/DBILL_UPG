page 50002 "Product Group Code"
{
    ApplicationArea = All;
    Caption = 'Product Group Code';
    PageType = List;
    SourceTable = "Product Group Code";
    UsageCategory = Lists;
    //  CardPageId = "Product Group Code Card";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ApplicationArea = all;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}
