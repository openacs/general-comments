<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="get_live_revision">      
      <querytext>
      select content_item__get_live_revision(:comment_id) 
      </querytext>
</fullquery>

 
<fullquery name="get_latest_revision">      
      <querytext>
      select content_item__get_latest_revision(:comment_id) 
      </querytext>
</fullquery>

 
<fullquery name="set_live_revisions">      
      <querytext>

	begin
	  PERFORM content_item__set_live_revision(:revision_id);
	  return 0;
        end;
    
      </querytext>
</fullquery>

 
<fullquery name="unset_live_revisions">      
      <querytext>

	begin
	  PERFORM content_item__unset_live_revision(:comment_id);
	  return 0;
        end;
    
      </querytext>
</fullquery>

 
</queryset>
