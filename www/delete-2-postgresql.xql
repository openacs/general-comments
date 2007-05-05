<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="delete_comment">      
      <querytext>

    begin
        PERFORM acs_message__delete(:comment_id);
	return 1;
    end;

      </querytext>
</fullquery>

 
</queryset>
