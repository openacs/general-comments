<?xml version="1.0"?>
<queryset>

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
