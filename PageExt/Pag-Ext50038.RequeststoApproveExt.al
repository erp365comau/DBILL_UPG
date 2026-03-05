pageextension 50038 RequeststoApproveExt extends "Requests to Approve"
{
    layout
    {
        addbefore(Comment)
        {

            field("Approval Code"; Rec."Approval Code")
            {
                ApplicationArea = All;
            }
        }
    }
}
