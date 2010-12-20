<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="get_latest_revision">      
      <querytext>
      
            select content_item.get_latest_revision(:comment_id) from dual
	
      </querytext>
</fullquery>

 
<fullquery name="get_revision_comment">      
      <querytext>
      
           select g.object_id,
	          g.comment_id,
	          content_item.get_live_revision(g.comment_id) as live_revision,
                  r.revision_id,
                  r.title,
	          r.content, 
	          r.mime_type as comment_mime_type, 
	          o.creation_user,
	          o.creation_date,
	          acs_object.name(o.creation_user) as author
             from general_comments g,
                  cr_revisions r,
                  acs_objects o
            where g.comment_id = o.object_id and
                  g.comment_id = r.item_id and
	          r.revision_id = :revision_id
    
      </querytext>
</fullquery>

 
<fullquery name="get_comment">      
      <querytext>
      
           select g.object_id,
	          g.comment_id,
	          r.revision_id as live_revision,
	          r.revision_id,
                  r.title,
	          r.content, 
	          r.mime_type as comment_mime_type, 
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
    
      </querytext>
</fullquery>

 
</queryset>
