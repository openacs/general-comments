<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="delete_comment">      
      <querytext>
      
    begin
        acs_message.del(:comment_id);
    end;

      </querytext>
</fullquery>

 
</queryset>
