# /packages/general-comments/www/url-edit-2.tcl

ad_page_contract {
    Creates a new revision of the url comment.

    @author Phong Nguyen (phong@arsdigita.com)
    @author Pascal Scheffers (pascal@scheffers.net)
    @creation-date 2000-10-12
    @cvs-id $Id$
} {
    attach_id:integer,notnull
    parent_id:integer,notnull
    label:notnull
    url:notnull
    { return_url {} }
}

# authenticate the user
set user_id [ad_verify_and_get_user_id]

# check to see if the user can edit this attachment
ad_require_permission $attach_id write

db_dml edit_url {
    update cr_extlinks
       set label = :label,
           url = :url
     where extlink_id = :attach_id
}

ad_returnredirect "view-comment?comment_id=$parent_id&[export_url_vars return_url]"



