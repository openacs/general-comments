# /packages/general-comments/www/file-edit-2.tcl

ad_page_contract {
    Edit the title for a file attachment

    @param attach_id  The id of the attachment to edit
    @param parent_id  The id of the comment this attachment refers to
    @param title      The value of the new title

    @author Phong Nguyen (phong@arsdigita.com)
    @author Pascal Scheffers (pascal@scheffers.net)
    @creation-date 2000-10-12
    @cvs-id $Id$
} {
    attach_id:integer,notnull
    parent_id:integer,notnull
    title:notnull
    { return_url {} }
}

# check to see if the user can edit this comment
ad_require_permission $attach_id write

db_1row get_revision_id {
    select content_item.get_latest_revision(:attach_id) as revision_id from dual
}
db_dml edit_title {
    update cr_revisions
       set title = :title
     where revision_id = :revision_id
}
    
ad_returnredirect "view-comment?comment_id=$parent_id&[export_url_vars return_url]"



