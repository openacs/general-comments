<?xml version="1.0"?>
<queryset>

<fullquery name="get_image">      
      <querytext>
      
    select i.name,
           r.title,
           m.width,
           m.height
      from cr_items i, 
           cr_revisions r, 
           images m
     where i.item_id = :image_id and
           r.revision_id = i.live_revision and
           r.revision_id = m.image_id

      </querytext>
</fullquery>

 
</queryset>
