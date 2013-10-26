# /packages/general-comments/www/comment-add-3.tcl

ad_page_contract {
    Inserts a comment for object_id into the database

    @author Phong Nguyen <phong@arsdigita.com>
    @author Pascal Scheffers (pascal@scheffers.net)
    @creation-date 2000-10-12
    @cvs-id $Id$
} {
    comment_id:integer,notnull
    object_id:integer,notnull
    title:notnull
    content:html,notnull
    comment_mime_type
    { context_id "$object_id" }
    { category "" }
    { return_url "" }
    { attach_p "f" }
}    

# This authentication actually is not necessary anymore due to the fact that we already check for the permission
# afterwards, so it should be enough to query the user_id from the connection to allow anonymous users who have
# create permissions to access the site.

# authenticate the user
# set user_id [auth::require_login]

set user_id [ad_conn user_id]

# check to see if the user can create comments on this object
permission::require_permission -object_id $object_id -privilege general_comments_create

# insert the comment into the database
set creation_ip [ad_conn peeraddr]
set is_live [parameter::get -parameter AutoApproveCommentsP -default {t}]

general_comment_new \
    -object_id $object_id \
    -comment_id $comment_id \
    -title $title \
    -comment_mime_type $comment_mime_type \
    -context_id $context_id \
    -user_id $user_id \
    -creation_ip $creation_ip \
    -is_live $is_live \
    -category $category \
    -content $content

if { $attach_p == "f" && $return_url ne "" } {
    ad_returnredirect $return_url
} else {
    ad_returnredirect "view-comment?[export_vars { comment_id return_url }]"
}
