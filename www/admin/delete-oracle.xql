<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="get_comment"> 
           <querytext>

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
	   r.revision_id = content_item.get_latest_revision(g.comment_id)

      </querytext>

</fullquery>

 
 
</queryset>
