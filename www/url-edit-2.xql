<?xml version="1.0"?>
<queryset>

<fullquery name="edit_url">      
      <querytext>
      
    update cr_extlinks
       set label = :label,
           url = :url
     where extlink_id = :attach_id

      </querytext>
</fullquery>

 
</queryset>
