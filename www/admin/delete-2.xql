<?xml version="1.0"?>
<queryset>

<fullquery name="delete_image_attachments">      
      <querytext>
      
    delete from images
    where image_id in (select latest_revision
                         from cr_items
                        where parent_id = :comment_id)

      </querytext>
</fullquery>

 
</queryset>
