<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="get_live_revision">      
      <querytext>
      select content_item.get_live_revision(:comment_id) from dual
      </querytext>
</fullquery>

 
<fullquery name="get_latest_revision">      
      <querytext>
      select content_item.get_latest_revision(:comment_id) from dual
      </querytext>
</fullquery>

 
<fullquery name="set_live_revisions">      
      <querytext>
      
	begin
	  content_item.set_live_revision(:revision_id);
        end;
    
      </querytext>
</fullquery>

 
<fullquery name="unset_live_revisions">      
      <querytext>
      
	begin
	  content_item.unset_live_revision(:comment_id);
        end;
    
      </querytext>
</fullquery>

 
</queryset>
