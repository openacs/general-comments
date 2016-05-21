# /packages/general-comments/www/comment-add-2.tcl

ad_page_contract {
    Confirms a comment for an object_id

    @author Phong Nguyen <phong@arsdigita.com>
    @author Pascal Scheffers (pascal@scheffers.net)
    @creation-date 2000-10-12
    @cvs-id $Id$
} {
    object_id:naturalnum,notnull
    { object_name "[acs_object_name $object_id]" }
    title:notnull
    content:html,notnull
    comment_mime_type:notnull
    { context_id:naturalnum "$object_id" }
    { category {} }
    { return_url:localurl {} }
} -properties {
    page_title:onevalue
    context:onevalue
    comment_mime_type:onevalue
    title:onevalue
    content:onevalue
    target:onevalue
    object_id:onevalue
    object_name:onevalue
    category:onevalue
    return_url:onevalue
}

# check to see if the user can create comments on this object
permission::require_permission -object_id $object_id -privilege general_comments_create

# ad_page_contract does not set object_name to
# [acs_object_name $object_id] if object_name is passed
# in as an empty string.
if { $object_name eq "" } {
    set object_name [acs_object_name $object_id]
}

set comment_id [db_nextval acs_object_id_seq]
set page_title "[_ general-comments.Confirm_comment_on] $object_name"
set context "\"[_ general-comments.Confirm_comment]\""
set target "comment-add-3"
set html_content [ad_html_text_convert -from $comment_mime_type -- $content]

ad_return_template "comment-ae-2"

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
