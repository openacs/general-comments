# /packages/general-comments/www/comment-edit-2.tcl

ad_page_contract {
    Confirms a comment for an object_id

    @param comment_id The id of the comment to edit
    @param object_name The name of the object this comment refers to
    @param title The title of the comment
    @param content The actual comment
    @param mime_type The type of format for the comment

    @author Phong Nguyen <phong@arsdigita.com>
    @author Pascal Scheffers (pascal@scheffers.net)
    @creation-date 2000-10-12
    @cvs-id $Id$
} {
    comment_id:naturalnum,notnull
    object_id:naturalnum,notnull
    title:notnull,printable,string_length(max|200)
    content:notnull,html
    comment_mime_type:oneof(text/plain|text/html),notnull
    { return_url:localurl {} }
} -properties {
    page_title:onevalue
    context:onevalue
    mime_type:onevalue
    title:onevalue
    content:onevalue
    target:onevalue
}


# check to see if the user can edit this comment
permission::require_permission -object_id $comment_id -privilege write

set page_title "[_ general-comments.Confirm_comment_on]: [acs_object_name $object_id]"
set context "\"[_ general-comments.Confirm_comment]\""
set target "comment-edit-3"

set html_content [ad_html_text_convert -from $comment_mime_type -- $content]

ad_return_template "comment-ae-2"
    


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
