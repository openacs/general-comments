<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="get_revision_id">      
      <querytext>
      
    select content_item.get_latest_revision(:attach_id) as revision_id from dual

      </querytext>
</fullquery>

 
</queryset>
