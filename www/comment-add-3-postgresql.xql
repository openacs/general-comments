<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="insert_comment">      
      <querytext>
	     select acs_message__new (
		:comment_id,		-- 1  p_message_id
		NULL, 			-- 2  p_reply_to
		current_timestamp,	-- 3  p_sent_date
		NULL, 			-- 4  p_sender
		NULL,			-- 5  p_rfc822_id
		:title,			-- 6  p_title
		NULL,			-- 7  p_description
		:comment_mime_type,	-- 8  p_mime_type
		NULL,			-- 9  p_text
		NULL, -- empty_blob(),		-- 10 p_data
		-4,			-- 11 p_parent_id
		:context_id,		-- 12 p_context_id
		:user_id,		-- 13 p_creation_user
		:creation_ip,		-- 14 p_creation_ip
		'acs_message',		-- 15 p_object_type
		:is_live		-- 16 p_is_live
	    )
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

 
<fullquery name="grant_permission">      
      <querytext>

        begin
            perform acs_permission__grant_permission (
                /* object_id  => */ :comment_id,
                /* grantee_id => */ :user_id,
                /* privilege  => */ 'read'
            );
            perform acs_permission__grant_permission (
                /* object_id  => */ :comment_id,
                /* grantee_id => */ :user_id,
                /* privilege  => */ 'write'
            );
	    return 0;
        end;
	
    
      </querytext>
</fullquery>

 
</queryset>
