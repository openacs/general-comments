# /packages/general-comments/www/file-edit.tcl

ad_page_contract {
    Edits a file comment

    @param attach_id The id of the attachment to edit
    @param parent_id The id of the comment this attachment refers to

    @author Phong Nguyen (phong@arsdigita.com)
    @author Pascal Scheffers (pascal@scheffers.net)
    @creation-date 2000-10-12
    @cvs-id $Id$
} {
    attach_id:integer,notnull
    parent_id:integer,notnull
    { return_url {} }
} -properties {
    page_title:onevalue
    context:onevalue
    parent_id:onevalue
    target:onevalue
    title:onevalue
    file_name:onevalue
}

# check to see if the user can edit this comment
ad_require_permission $attach_id write

# get the values from the database
db_1row get_comment {
  select r.title,
         i.name as file_name
    from cr_items i, cr_revisions r
   where i.item_id = :attach_id and
         r.revision_id = content_item.get_latest_revision(i.item_id)
}

# set variables for template
set page_title "[_ general-comments.lt_Edit_file_attachment_] #$parent_id"
set context [list [list "view-comment?comment_id=$parent_id" "[_ general-comments.Go_back_to_comment]"] "[_ general-comments.Edit_file_attachment]"]
set target "file-edit-2"

ad_return_template "file-ae"
