# /packages/general-comments/www/comment-add-2.tcl

ad_page_contract {
    Confirms a comment for an object_id

    @author Phong Nguyen <phong@arsdigita.com>
    @author Pascal Scheffers (pascal@scheffers.net)
    @creation-date 2000-10-12
    @cvs-id $Id$
} {
    object_id:integer,notnull
    { object_name "[acs_object_name $object_id]" }
    title:notnull
    content:html,notnull
    { mime_type {text/plain} }
    { context_id "$object_id" }
    { category {} }
    { return_url {} }
} -properties {
    page_title:onevalue
    context_bar:onevalue
    mime_type:onevalue
    title:onevalue
    content:onevalue
    target:onevalue
    object_id:onevalue
    object_name:onevalue
    category:onevalue
    return_url:onevalue
}

# check to see if the user can create comments on this object
ad_require_permission $object_id general_comments_create

# ad_page_contract does not set object_name to
# [acs_object_name $object_id] if object_name is passed
# in as an empty string.
if { [empty_string_p $object_name] } {
    set object_name [acs_object_name $object_id]
}

set comment_id [db_nextval acs_object_id_seq]
set page_title "Confirm comment on $object_name"
set context_bar {"Confirm comment"}
set target "comment-add-3"

ad_return_template "comment-ae-2"
