<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="get_latest_revision">      
      <querytext>
      select content_item__get_latest_revision(:comment_id) 
      </querytext>
</fullquery>

 
</queryset>
