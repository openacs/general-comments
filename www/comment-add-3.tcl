# /packages/general-comments/www/comment-add-3.tcl

ad_page_contract {
    Inserts a comment for object_id into the database

    @author Phong Nguyen <phong@arsdigita.com>
    @author Pascal Scheffers (pascal@scheffers.net)
    @creation-date 2000-10-12
    @cvs-id $Id$
} {
    comment_id:naturalnum,notnull
    object_id:naturalnum,notnull
    title:notnull,printable,string_length(max|200)
    content:html,notnull,general_comments_safe
    comment_mime_type:notnull,printable
    { context_id:naturalnum "$object_id" }
    { category "" }
    { return_url:localurl "" }
    { attach_p:boolean,notnull "f" }
} -validate {
    comment_mime_type_allowed -requires {comment_mime_type:notnull comment_mime_type:printable} {
        if {$comment_mime_type ni {"text/plain" "text/html"}} {
            ad_complain [_ acs-tcl.lt_name_is_not_valid [list name comment_mime_type]]
            return
        }
    }
}

set user_id [ad_conn user_id]

# check to see if the user can create comments on this object
permission::require_permission \
    -party_id $user_id \
    -object_id $object_id \
    -privilege general_comments_create

# insert the comment into the database
set creation_ip [ad_conn peeraddr]
set is_live [parameter::get -parameter AutoApproveCommentsP -default {t}]

general_comments_new \
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
    ad_returnredirect [export_vars -base view-comment { comment_id return_url }]
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
