page 50000 "Approval Entries-Credit Limits"
{
    Caption = 'Approval Entries';
    Editable = false;
    PageType = List;
    SourceTable = "Approval Entry";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Overdue; Overdue)
                {
                    Caption = 'Overdue';
                    Editable = false;
                    ToolTip = 'Overdue Entry';
                    ApplicationArea = all;
                }
                field("Table ID"; Rec."Table ID")
                {
                    ApplicationArea = all;
                }
                field("Limit Type"; Rec."Limit Type")
                {
                    ApplicationArea = all;
                }
                field("Approval Type"; Rec."Approval Type")
                {
                    ApplicationArea = all;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = all;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = all;
                }
                field("Sequence No."; Rec."Sequence No.")
                {
                    ApplicationArea = all;
                }
                field("Approval Code"; Rec."Approval Code")
                {
                    ApplicationArea = all;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                }
                field("Sender ID"; Rec."Sender ID")
                {
                    ApplicationArea = all;
                }
                field("Salespers./Purch. Code"; Rec."Salespers./Purch. Code")
                {
                    ApplicationArea = all;
                }
                field("Approver ID"; Rec."Approver ID")
                {
                    ApplicationArea = all;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = all;
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    ApplicationArea = all;
                }
                field("Available Credit Limit (LCY)"; Rec."Available Credit Limit (LCY)")
                {
                    ApplicationArea = all;
                }
                field("Date-Time Sent for Approval"; Rec."Date-Time Sent for Approval")
                {
                    ApplicationArea = all;
                }
                field("Last Date-Time Modified"; Rec."Last Date-Time Modified")
                {
                    ApplicationArea = all;
                }
                field("Last Modified By ID"; Rec."Last Modified By User ID")
                {
                    ApplicationArea = all;
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = all;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = all;
                }
            }
            /* area(factboxes)
            {
                systempart(; Links)
                {
                    Visible = false;
                }
                systempart(; Notes)
                {
                    Visible = true;
                } */
        }
    }
    actions
    {
        area(navigation)
        {
            group("&Show")
            {
                Caption = '&Show';
                Image = View;
                /* action(Document)
                {
                    Caption = 'Document';
                    Image = Document;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        ShowDocument;
                    end;
                } */
                action(Comments)
                {
                    ApplicationArea = all;
                    Caption = 'Comments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page 660;
                    RunPageLink = "Table ID" = FIELD("Table ID"),
                                  "Document Type" = FIELD("Document Type"),
                                  "Document No." = FIELD("Document No.");
                    RunPageView = SORTING("Table ID", "Document Type", "Document No.");
                }
                action("O&verdue Entries")
                {
                    ApplicationArea = all;
                    Caption = 'O&verdue Entries';
                    Image = OverdueEntries;

                    trigger OnAction()
                    begin
                        Rec.SETFILTER(Status, '%1|%2', Rec.Status::Created, Rec.Status::Open);
                        Rec.SETFILTER("Due Date", '<%1', TODAY);
                    end;
                }
                action("All Entries")
                {
                    ApplicationArea = all;
                    Caption = 'All Entries';
                    Image = Entries;

                    trigger OnAction()
                    begin
                        Rec.SETRANGE(Status);
                        Rec.SETRANGE("Due Date");
                    end;
                }
            }
        }
        area(processing)
        {
            /* action(Approve)
            {
                Caption = '&Approve';
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = ApproveVisible;

                trigger OnAction()
                var
                    ApprovalEntry: Record "Approval Entry";
                begin
                    CurrPage.SETSELECTIONFILTER(ApprovalEntry);
                    IF ApprovalEntry.FIND('-') THEN
                        REPEAT
                            ApprovalMgt.ApproveApprovalRequest(ApprovalEntry);
                        UNTIL ApprovalEntry.NEXT = 0;
                end;
            } */
            /* action(Reject)
            {
                Caption = '&Reject';
                Image = Reject;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = RejectVisible;

                trigger OnAction()
                var
                    ApprovalEntry: Record "454";
                    ApprovalSetup: Record "452";
                    ApprovalCommentLine: Record "455";
                    ApprovalComment: Page "660";
                begin
                    CurrPage.SETSELECTIONFILTER(ApprovalEntry);
                    IF ApprovalEntry.FIND('-') THEN
                        REPEAT
                            IF NOT ApprovalSetup.GET THEN
                                ERROR(Text004);
                            IF ApprovalSetup."Request Rejection Comment" = TRUE THEN BEGIN
                                ApprovalCommentLine.SETRANGE("Table ID", ApprovalEntry."Table ID");
                                ApprovalCommentLine.SETRANGE("Document Type", ApprovalEntry."Document Type");
                                ApprovalCommentLine.SETRANGE("Document No.", ApprovalEntry."Document No.");
                                ApprovalComment.SETTABLEVIEW(ApprovalCommentLine);
                                IF ApprovalComment.RUNMODAL = ACTION::OK THEN
                                    ApprovalMgt.RejectApprovalRequest(ApprovalEntry);
                            END ELSE
                                ApprovalMgt.RejectApprovalRequest(ApprovalEntry);

                        UNTIL ApprovalEntry.NEXT = 0;
                end;
            } */
            /*  action("&Delegate")
             {
                 Caption = '&Delegate';
                 Image = Delegate;
                 Promoted = true;
                 PromotedCategory = Process;
                 PromotedIsBig = true;

                 trigger OnAction()
                 var
                     ApprovalEntry: Record "454";
                     TempApprovalEntry: Record "454";
                     ApprovalSetup: Record "452";
                 begin
                     CurrPage.SETSELECTIONFILTER(ApprovalEntry);

                     CurrPage.SETSELECTIONFILTER(TempApprovalEntry);
                     IF TempApprovalEntry.FINDFIRST THEN BEGIN
                         TempApprovalEntry.SETFILTER(Status, '<>%1', TempApprovalEntry.Status::Open);
                         IF NOT TempApprovalEntry.ISEMPTY THEN
                             ERROR(Text001);
                     END;

                     IF ApprovalEntry.FIND('-') THEN BEGIN
                         IF ApprovalSetup.GET THEN;
                         IF Usersetup.GET(USERID) THEN;
                         IF (ApprovalEntry."Sender ID" = Usersetup."User ID") OR
                            (ApprovalSetup."Approval Administrator" = Usersetup."User ID") OR
                            (ApprovalEntry."Approver ID" = Usersetup."User ID")
                         THEN
                             REPEAT
                                 ApprovalMgt.DelegateApprovalRequest(ApprovalEntry);
                             UNTIL ApprovalEntry.NEXT = 0;
                     END;

                     MESSAGE(Text002);
                 end;
             } */
        }
    }
    trigger OnAfterGetRecord()
    begin
        Overdue := Overdue::" ";
        IF FormatField(Rec) THEN
            Overdue := Overdue::Yes;
    end;

    trigger OnInit()
    begin
        RejectVisible := TRUE;
        ApproveVisible := TRUE;
    end;

    trigger OnOpenPage()
    var
        Filterstring: Text;
    begin
        /*
        IF Usersetup.GET(USERID) THEN BEGIN
          FILTERGROUP(2);
          Filterstring := GETFILTERS;
          FILTERGROUP(0);
          IF STRLEN(Filterstring) = 0 THEN BEGIN
            FILTERGROUP(2);
            SETCURRENTKEY("Approver ID");
            IF Overdue = Overdue::Yes THEN
             // SETRANGE("Approver ID",Usersetup."User ID");
                SETRANGE("Approval Code",'S-O-CREDITLIMIT');
            SETRANGE(Status,Status::Open);
            FILTERGROUP(0);
          END ELSE
            SETCURRENTKEY("Table ID","Document Type","Document No.");
        END;
         */
        //SETRANGE("Approval Code",'S-O-CREDITLIMIT');
        Rec.SETRANGE(Status, Rec.Status::Open);

    end;

    var
        Usersetup: Record "User Setup";
        ApprovalMgt: Codeunit "Approvals Mgmt.";
        Text001: Label 'You can only delegate open approval entries.';
        Text002: Label 'The selected approval(s) have been delegated. ';
        Overdue: Option Yes," ";
        Text004: Label 'Approval Setup not found.';
        ApproveVisible: Boolean;
        RejectVisible: Boolean;

    procedure Setfilters(TableId: Integer; DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order"; DocumentNo: Code[20])
    begin
        IF TableId <> 0 THEN BEGIN
            Rec.FILTERGROUP(2);
            Rec.SETCURRENTKEY("Table ID", "Document Type", "Document No.");
            Rec.SETRANGE("Table ID", TableId);
            Rec.SETRANGE("Document Type", DocumentType);
            IF DocumentNo <> '' THEN
                Rec.SETRANGE("Document No.", DocumentNo);
            Rec.FILTERGROUP(0);
        END;

        ApproveVisible := FALSE;
        RejectVisible := FALSE;
    end;

    procedure FormatField(Rec: Record "Approval Entry") OK: Boolean
    begin
        IF Rec.Status IN [Rec.Status::Created, Rec.Status::Open] THEN BEGIN
            IF Rec."Due Date" < TODAY THEN
                EXIT(TRUE);

            EXIT(FALSE);
        END;
    end;

    procedure CalledFrom()
    begin
        Overdue := Overdue::" ";
    end;
}

