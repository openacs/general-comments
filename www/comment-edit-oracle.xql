<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="get_latest_revision">      
      <querytext>
      select content_item.get_latest_revision(:comment_id) from dual
      </querytext>
</fullquery>

 
</queryset>
