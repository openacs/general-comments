<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="insert_comment">      
      <querytext>
    declare 
		v_revision_id integer;
    begin
        select acs_message__edit (
            /* message_id    => */ :comment_id,
            /* title         => */ :title,
	    /* p_description    */ NULL, 
            /* mime_type     => */ :comment_mime_type,
	    /* text	        */ NULL,
            /* data          => */ NULL, 	-- was empty_blob(),
	    /* creation_date    */ now(),
            /* creation_user => */ :user_id,
            /* creation_ip   => */ :creation_ip,
            /* is_live       => */ :is_live
        ) into v_revision_id;

	return v_revision_id;
    end;
  
      </querytext>
</fullquery>

 
<fullquery name="get_revision">      
      <querytext>
       
    select content_item__get_latest_revision(:comment_id) as revision_id
    
  
      </querytext>
</fullquery>

 
<fullquery name="set_content">      
      <querytext>

        update cr_revisions
           set content = :content
         where revision_id = :revision_id
  
      </querytext>
</fullquery>

 
</queryset>
