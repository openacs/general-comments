# /packages/general-comments/www/admin/toggle-approval.tcl

ad_page_contract {
    Toggles the approval state of a comment
    
    @param comment_id The id of the comment
    
    @author Phong Nguyen (phong@arsdigita.com)
    @author Pascal Scheffers (pascal@scheffers.net)
    @creation-date 2000-10-12
    @cvs-id $Id$
} {
    comment_id:integer,notnull
    {revision_id {}}
    {return_url {}}
}

# get the live revision of the item for comparison
set live_revision [db_string get_live_revision \
        "select content_item.get_live_revision(:comment_id) from dual"]

# if the user did not pass in a revision_id, then
# assume that the user wishes to toggle the approval
# state of the latest revision
if { [empty_string_p $revision_id] } {
    set revision_id [db_string get_latest_revision \
        "select content_item.get_latest_revision(:comment_id) from dual"]
}

# if the current live revision is not the same as the passed in
# revision then set the passed in revision as live
if { $live_revision != $revision_id } {
    db_exec_plsql set_live_revisions {
	begin
	  content_item.set_live_revision(:revision_id);
        end;
    }

# if the current live revision is the same as the passed in
# revision, then unset it
} else {
    db_exec_plsql unset_live_revisions {
	begin
	  content_item.unset_live_revision(:comment_id);
        end;
    }
}

ad_returnredirect $return_url
