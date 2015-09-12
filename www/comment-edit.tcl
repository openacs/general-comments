# /packages/general-comments/www/comment-edit.tcl

ad_page_contract {
    Displays a form for editing a commment
    
    @param comment_id The id of the comment to edit
    
    @author Phong Nguyen (phong@arsdigita.com)
    @author Pascal Scheffers (pascal@scheffers.net)
    @creation-date 2000-10-12
    @cvs-id $Id$
} { 
    comment_id:naturalnum,notnull
    { revision_id:naturalnum {} }
    { return_url {} }
} -properties {
    page_title:onevalue
    context:onevalue
    target:onevalue
    title:onevalue
    content:onevalue
    comment_mime_type:onevalue
    comment_id:onevalue
    revision_id:onevalue
    return_url:onevalue
}

# check to see if the user can edit this comment
permission::require_permission -object_id $comment_id -privilege write

# if revision_id is not passed in, assume that the user
# wishes to edit the latest revision
if { $revision_id eq "" } {
    set revision_id [db_string get_latest_revision \
            "select content_item.get_latest_revision(:comment_id) from dual"]
}

# get the values from the database
if { ![db_0or1row get_comment {
    select g.object_id,
           r.title,
           r.content,
           r.mime_type as comment_mime_type
      from general_comments g,
           cr_revisions r
     where g.comment_id = :comment_id and
           r.revision_id = :revision_id
}] } {
    ad_return_complaint 1 "The comment_id does not refer to a valid comment."
}

set page_title "[_ general-comments.Edit_comment_on]: [acs_object_name $object_id]"
set context "\"[_ general-comments.Edit_comment]\""
set target "comment-edit-2"

ad_return_template "comment-ae"



# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
