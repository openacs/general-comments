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
    comment_id:integer,notnull
    object_id:integer,notnull
    title:notnull
    content:notnull,html
    comment_mime_type
    { return_url {} }
} -properties {
    page_title:onevalue
    context:onevalue
    mime_type:onevalue
    title:onevalue
    content:onevalue
    target:onevalue
}

# check to see if the user can edit this comment
ad_require_permission $comment_id write

set page_title "[_ general-comments.Confirm_comment_on]: [acs_object_name $object_id]"
set context "\"[_ general-comments.Confirm_comment]\""
set target "comment-edit-3"

set html_content [ad_html_text_convert -from $comment_mime_type -- $content]

ad_return_template "comment-ae-2"
    

