<?xml version="1.0"?>
<queryset>

<partialquery name="general_comments_get_comments.content_select">
       <querytext>

		, r.content

       </querytext>
</partialquery>

<fullquery name="general_comments_print_comment.get_attachments">      
      <querytext>
      
	                    select r.title, r.mime_type,  i.name, i.item_id
	                      from cr_items i, cr_revisions r
	                     where i.parent_id = :comment_id 
                               and r.revision_id = i.live_revision
      </querytext>
</fullquery>

 
<fullquery name="general_comments_print_comment.get_links">      
      <querytext>
      
	              select i.item_id, e.label, e.url
	                from cr_items i, cr_extlinks e
	               where i.parent_id = :comment_id and e.extlink_id = i.item_id
      </querytext>
</fullquery>

<fullquery name="general_comment_new.add_entry">      
      <querytext>
      
        insert into general_comments
            (comment_id,
             object_id,
             category)
        values
            (:comment_id,
             :object_id,
             :category)
    
      </querytext>
</fullquery>

 
</queryset>
