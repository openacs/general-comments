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
ad_require_permission $comment_id read
set write_perm_p [ad_permission_p $comment_id write]
set admin_p [ad_permission_p $package_id admin]

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
    if { ![db_0or1row get_revision_comment {
           select g.object_id,
	          g.comment_id,
	          content_item.get_live_revision(g.comment_id) as live_revision,
                  r.revision_id,
                  r.title,
	          r.content, 
	          r.mime_type, 
	          o.creation_user,
	          o.creation_date,
	          acs_object.name(o.creation_user) as author
             from general_comments g,
                  cr_revisions r,
                  acs_objects o
            where g.comment_id = o.object_id and
                  g.comment_id = r.item_id and
	          r.revision_id = :revision_id
    }] } {
        ad_return_complaint 1 "[_ general-comments.lt_The_comment_id_does_n]"
    }

} else {
    # get live revision data from the database
    if { ![db_0or1row get_comment {
           select g.object_id,
	          g.comment_id,
	          r.revision_id as live_revision,
	          r.revision_id,
                  r.title,
	          r.content, 
	          r.mime_type, 
	          o.creation_user,
	          o.creation_date,
	          acs_object.name(o.creation_user) as author
             from general_comments g,
                  acs_objects o, 
	          cr_revisions r
            where g.comment_id = :comment_id and
                  g.comment_id = o.object_id and
                  g.comment_id = r.item_id and
	          r.revision_id = content_item.get_live_revision(:comment_id)
    }] } {
        ad_return_complaint 1 "[_ general-comments.lt_The_comment_id_does_n]"
    }
}

db_multirow attachments get_attachments {
   select r.title,
          r.mime_type,
          i.name,
          i.item_id
     from cr_items i,
          cr_revisions r
    where i.parent_id = :comment_id and
          r.revision_id = i.live_revision
}

db_multirow links get_links {
    select i.item_id,
           e.label,
           e.url
      from cr_items i, cr_extlinks e
     where i.parent_id = :comment_id and
           e.extlink_id = i.item_id
}
           
db_multirow revisions get_revisions {
    select r.revision_id,
           to_char(o.creation_date, 'MM-DD-YY HH24:MI:SS') as revision_date
      from cr_revisions r,
           acs_objects o
     where r.item_id = :comment_id and
           o.object_id = r.revision_id
     order by o.creation_date desc
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
set return_url_view "[ad_urlencode view-comment?[export_ns_set_vars url]]"
set is_creator_p "f"
if { $user_id == $creation_user } {
    set is_creator_p "t"
}

set html_content [ad_html_text_convert -from $mime_type -- $content]

ad_return_template
