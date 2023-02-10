# /packages/general-comments/www/view-comment.tcl

ad_page_contract {
    Views a comment
    
    @author Phong Nguyen (phong@arsdigita.com)
    @author Pascal Scheffers (pascal@scheffers.net)
    @creation-date 2000-10-12
    @cvs-id $Id$
} { 
    comment_id:naturalnum,notnull
    { revision_id:naturalnum,optional {} }
    { object_name {} }
    { return_url:localurl {} }
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

set live_revision [content::item::get_live_revision -item_id $comment_id]

# if the user has write permissions then allow
# viewing of selected revision
if { !$write_perm_p } {
    # get live revision
    set revision_id $live_revision
} elseif { $revision_id eq "" } {
    # get the latest revision
    set revision_id [content::item::get_latest_revision -item_id $comment_id]
}

# get revision data from the database
if { ![db_0or1row get_revision_comment {
           select g.object_id,
	          g.comment_id,
                  r.revision_id,
                  r.title,
	          r.content, 
	          r.mime_type as comment_mime_type, 
	          o.creation_user,
	          o.creation_date
             from general_comments g,
                  cr_revisions r,
                  acs_objects o
            where g.comment_id = o.object_id and
                  g.comment_id = r.item_id and
	          r.revision_id = :revision_id
}] } {
    ad_return_complaint 1 "[_ general-comments.lt_The_comment_id_does_n]"
    ad_script_abort
}

set author [person::name -person_id $creation_user]

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

db_multirow -unclobber -extend {view_comment_url} revisions get_revisions {
    select r.revision_id,
           o.creation_date as revision_date
      from cr_revisions r,
           acs_objects o
     where r.item_id = :comment_id and
           o.object_id = r.revision_id
     order by o.creation_date desc    
} { 
    set revision_date [lc_time_fmt $revision_date %c]
    set view_comment_url [export_vars -base "view-comment" {comment_id revision_id return_url}]
}

set allow_file_p [parameter::get -parameter AllowFileAttachmentsP -default {t}]
set allow_link_p [parameter::get -parameter AllowLinkAttachmentsP -default {t}]
set allow_attach_p [expr { !($allow_file_p == "f" && $allow_link_p == "f")}]
set comment_on_id [db_string get_object_id {
    select object_id from general_comments
    where comment_id = :comment_id
}]
set page_title "[_ general-comments.View_comment_on]: [acs_object_name $comment_on_id]"
set context "\"[_ general-comments.View_comment]\""
set return_url_view [ad_return_url]
set is_creator_p [expr {$user_id == $creation_user}]

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

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
