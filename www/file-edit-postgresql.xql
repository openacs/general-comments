<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="get_comment">      
      <querytext>
      
  select r.title,
         i.name as file_name
    from cr_items i, cr_revisions r
   where i.item_id = :attach_id and
         r.revision_id = content_item__get_latest_revision(i.item_id)

      </querytext>
</fullquery>

 
</queryset>
