# /packages/general-comments/www/view-comment.tcl

ad_page_contract {
    Views a comment
    
    @author Phong Nguyen (phong@arsdigita.com)
    @author Pascal Scheffers (pascal@scheffers.net)
    @creation-date 2000-10-12
    @cvs-id $Id$
} { 
    comment_id:notnull
    { revision_id {} }
    { object_name {} }
    { return_url {} }
} -properties {
    page_title:onevalue
    context:onevalue
    return_url:onevalue
    object_name:onevalue
    title:onevalue
    mime_type:onevalue
    content:onevalue
    user_id:onevalue
    creation_user:onevalue
    comment_id:onevalue
    revision_id:onevalue    
    attachments:multirow
    write_perm_p:onevalue
    revisions:multirow
    admin_p:onevalue
    return_url_view:onevalue
}

# authenticate the user
set user_id [ad_conn user_id]

# check for permissions
set package_id [ad_conn package_id]
permission::require_permission -object_id $comment_id -privilege read
set write_perm_p [permission::permission_p -object_id $comment_id -privilege write]
set admin_p [permission::permission_p -object_id $package_id -privilege admin]

# if the user has write permissions then allow
# viewing of selected revision
if { $write_perm_p == 1 } {
    if { [empty_string_p $revision_id] } {
	# get the latest revision
	set revision_id [db_string get_latest_revision {
            select content_item.get_latest_revision(:comment_id) from dual
	}]
    }
    # get revision data from the database
    if { ![db_0or1row get_revision_comment {}] } {
        ad_return_complaint 1 "[_ general-comments.lt_The_comment_id_does_n]"
    }

} else {
    # get live revision data from the database
    if { ![db_0or1row get_comment {}] } {
        ad_return_complaint 1 "[_ general-comments.lt_The_comment_id_does_n]"
    }
}

db_multirow -extend {file_edit_url delete_attachment_url view_image_url} attachments get_attachments {
   select r.title,
          r.mime_type,
          i.name,
          i.item_id
     from cr_items i,
          cr_revisions r
    where i.parent_id = :comment_id and
          r.revision_id = i.live_revision
} {
    set file_edit_url [export_vars -base "file-edit" {{attach_id $item_id} {parent_id $comment_id} return_url}]
    set delete_attachment_url [export_vars -base "delete-attachment" {{attach_id $item_id} {parent_id $comment_id} return_url}]
    set view_image_url [export_vars -base "view-image" {{image_id $item_id} {return_url return_url_view}}]
}

db_multirow -extend {url_edit_url delete_attachment_url} links get_links {
    select i.item_id,
           e.label,
           e.url
      from cr_items i, cr_extlinks e
     where i.parent_id = :comment_id and
           e.extlink_id = i.item_id
} {
    set url_edit_url [export_vars -base "url-edit" {{attach_id $item_id} {parent_id $comment_id} return_url}]
    set delete_attachment_url [export_vars -base "delete-attachment" {{attach_id $item_id} {parent_id $comment_id} return_url}]
}

db_multirow -extend {view_comment_url} revisions get_revisions {*SQL*} { 
    set revision_date [lc_time_fmt $revision_date %c]
    set view_comment_url [export_vars -base "view-comment" {comment_id revision_id return_url}]
}

set allow_file_p [ad_parameter AllowFileAttachmentsP {general-comments} {t}]
set allow_link_p [ad_parameter AllowLinkAttachmentsP {general-comments} {t}]
set allow_attach_p "t"
if { $allow_file_p == "f" && $allow_link_p == "f" } {
    set allow_attach_p "f"
}
set comment_on_id [db_string get_object_id "select object_id from general_comments where comment_id = :comment_id"]
set page_title "[_ general-comments.View_comment_on]: [acs_object_name $comment_on_id]"
set context "\"[_ general-comments.View_comment]\""
set return_url_view "view-comment?[export_ns_set_vars url]"
set is_creator_p "f"
if { $user_id == $creation_user } {
    set is_creator_p "t"
}

if { $comment_mime_type ne "text/html" } {
    set html_content "<p>[ad_html_text_convert -from $comment_mime_type -- $content]</p>"
} else {
    set html_content $content
}

set comment_edit_url [export_vars -base "comment-edit" {comment_id revision_id return_url}]

# Actions section
set action_file_add_url [export_vars -base "file-add" {{parent_id $comment_id} return_url}]
set action_url_add_url [export_vars -base "url-add" {{parent_id $comment_id} return_url}]

# Revisions section
set return_url_view "../${return_url_view}"
if { $live_revision ne $revision_id } {
    set font_color "red"
    set pre_text [_ general-comments.lt_This_revision_is_not_]
    set admin_toggle_url [export_vars -base "admin/toggle-approval" {comment_id revision_id {return_url $return_url_view}}]
    set admin_toggle_text [_ general-comments.lt_approve_this_revision]
} else {
    set font_color "green"
    set pre_text [_ general-comments.lt_This_revision_is_live]
    set admin_toggle_url [export_vars -base "admin/toggle-approval" {comment_id revision_id {return_url $return_url_view}}]
    set admin_toggle_text [_ general-comments.reject_this_revision]
}

ad_return_template
