# /packages/general-comments/www/admin/delete.tcl

ad_page_contract {
    Delete a comment
    
    @param comment_id The id of the comment to delete

    @author Phong Nguyen (phong@arsdigita.com)
    @creation-date 2000-10-12
    @cvs-id $Id$
} {
    comment_id:integer,notnull
    { return_url {}}
} -properties {
    page_title:onevalue
    context_bar:onevalue
    title:onevalue
    comment_id:onevalue
    mime_type:onevalue
    content:onevalue
    creation_user:onevalue
    author:onevalue
    pretty_date:onevalue
    return_url:onevalue
}

# get data from database
set sql "
    select r.title,
           r.content,
           r.mime_type,
           o.creation_user,
           to_char(o.creation_date, 'MM-DD-YYYY') as pretty_date,
           acs_object.name(o.creation_user) as author
      from acs_objects o, 
           cr_revisions r, 
	   general_comments g
     where g.comment_id = :comment_id and 	 
           g.comment_id = o.object_id and
	   r.revision_id = content_item.get_latest_revision(g.comment_id)"

if { ![db_0or1row get_comment $sql] } {
    ad_return_complaint 1 "The comment_id does not refer to a valid comment."
}

set page_title "Delete a comment"
set context_bar {"Delete a comment"}

ad_return_template
