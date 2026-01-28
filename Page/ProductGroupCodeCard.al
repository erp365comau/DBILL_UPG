page 50003 "Product Group Code Card"
{
    ApplicationArea = All;
    Caption = 'Product Group Code Card';
    PageType = Card;
    SourceTable = "Product Group Code";
    
    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                
                field("Code"; Rec."Code")
                {
                }
                field(Description; Rec.Description)
                {
                }
            }
        }
    }
}
