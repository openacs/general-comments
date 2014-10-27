# /packages/general-comments/www/admin/delete.tcl

ad_page_contract {
    Delete a comment
    
    @param comment_id The id of the comment to delete

    @author Phong Nguyen (phong@arsdigita.com)
    @author Pascal Scheffers (pascal@scheffers.net)
    @creation-date 2000-10-12
    @cvs-id $Id$
} {
    comment_id:naturalnum,notnull
    { return_url {}}
} -properties {
    page_title:onevalue
    context:onevalue
    title:onevalue
    comment_id:onevalue
    mime_type:onevalue
    content:onevalue
    creation_user:onevalue
    author:onevalue
    pretty_date:onevalue
    return_url:onevalue
}

permission::require_permission -party_id [ad_conn user_id] -object_id $comment_id -privilege "write"
set revision_id [content::item::get_best_revision -item_id $comment_id]
# get data from database
set sql "
    select r.title,
           r.content,
           r.mime_type,
           o.creation_user,
           to_char(o.creation_date, 'MM-DD-YYYY') as pretty_date
      from acs_objects o, 
           cr_revisions r, 
	   general_comments g
     where g.comment_id = :comment_id and 	 
           g.comment_id = o.object_id and
	   r.revision_id = $revision_id"

if { ![db_0or1row get_comment $sql] } {
    ad_return_complaint 1 "[_ general-comments.lt_The_comment_id_does_n]"
}

set author [person::name -person_id $creation_user]
set page_title "[_ general-comments.Delete_a_comment]"
set context [list "[_ general-comments.Delete_a_comment]"]

ad_return_template
