<?xml version="1.0"?>
<queryset>

<fullquery name="get_attachments">      
      <querytext>
      
   select r.title,
          r.mime_type,
          i.name,
          i.item_id
     from cr_items i,
          cr_revisions r
    where i.parent_id = :comment_id and
          r.revision_id = i.live_revision

      </querytext>
</fullquery>

 
<fullquery name="get_links">      
      <querytext>
      
    select i.item_id,
           e.label,
           e.url
      from cr_items i, cr_extlinks e
     where i.parent_id = :comment_id and
           e.extlink_id = i.item_id

      </querytext>
</fullquery>

 
<fullquery name="get_object_id">      
      <querytext>
      select object_id from general_comments where comment_id = :comment_id
      </querytext>
</fullquery>

 
<fullquery name="get_revisions">      
      <querytext>
      
    select r.revision_id,
           o.creation_date as revision_date
      from cr_revisions r,
           acs_objects o
     where r.item_id = :comment_id and
           o.object_id = r.revision_id
     order by o.creation_date desc

      </querytext>
</fullquery>
 
</queryset></queryset>
