<?xml version="1.0"?>
<queryset>

<fullquery name="get_comment">      
      <querytext>
      
          select label,
                 url
            from cr_extlinks
           where extlink_id = :attach_id

      </querytext>
</fullquery>

 
</queryset>
