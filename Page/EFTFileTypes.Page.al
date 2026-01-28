page 50099 "EFT File Types"
{
    Caption = 'EFT File Types';
    PageType = Card;
    SourceTable = "EFT File Type";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = all;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                }
                field("EFT Nos."; Rec."EFT Nos.")
                {
                    ApplicationArea = all;
                }
                field("Transaction Code"; Rec."Transaction Code")
                {
                    ApplicationArea = all;
                }
            }
        }

        /*  actions
         {
             area(processing)
             {
                 action("File Template")
                 {
                     Caption = 'File Template';
                     Promoted = true;
                     PromotedCategory = Process;
                     RunObject = Page 50098;
                     RunPageLink = Field1 = FIELD (Code);
                     RunPageView = SORTING (Field1, Field2, Field3);
                 }
             }
         } */
    }
}