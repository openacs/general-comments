# /packages/general-comments/www/comment-add.tcl

ad_page_contract {
    Displays a form for adding a commment to a page

    @author Phong Nguyen <phong@arsdigita.com>
    @creation-date 2000-10-12
    @cvs-id $Id$
} { 
    object_id:integer,notnull
    { object_name "[acs_object_name $object_id]" }
    { context_id "$object_id" }
    { category "" }
    { return_url "" }
} -properties {
    page_title:onevalue
    context_bar:onevalue
    target:onevalue
    title:onevalue
    content:onevalue
    mime_type:onevalue
    object_id:onevalue
    object_name:onevalue
    context_id:onevalue
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

set page_title "Add a comment to: $object_name"
set context_bar {"Add comment"}
set target "comment-add-2"
set title ""
set content ""
set mime_type "text/plain"

ad_return_template "comment-ae"






