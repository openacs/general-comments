<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="general_comments_get_comments.get_comments">      
      <querytext>
      
             select g.comment_id,
                    r.title,
                    r.mime_type,
                    o.creation_user,
                    acs_object__name(o.creation_user) as author,
                    o.creation_date
                    $content_select
               from general_comments g,
                    cr_revisions r,
                    acs_objects o
              where g.object_id = :object_id and
                    r.revision_id = content_item__get_live_revision(g.comment_id) and
                    o.object_id = g.comment_id
                    $context_clause
                    $my_comments_clause
              order by $orderby
      </querytext>
</fullquery>

 

 
<fullquery name="get_comments.get_comments_deprecated">      
      <querytext>
      
             select g.comment_id,
                    r.title,
                    r.content,
                    r.mime_type,
                    o.creation_user,
                    to_char(o.creation_date, 'MM-DD-YYYY') as creation_date,
                    p.first_names || ' ' || p.last_name as author
               from general_comments g,
                    cr_items i,
                    cr_revisions r,
                    acs_objects o,
                    persons p
              where g.object_id = :object_id and
                    i.item_id = g.comment_id and
                    r.revision_id = i.live_revision and
                    o.object_id = g.comment_id and
                    p.person_id = o.creation_user
              order by creation_date
      </querytext>
</fullquery>

 

<fullquery name="general_comment_new.insert_comment">      
      <querytext>
	     select acs_message__new (
		:comment_id,		-- 1  p_message_id
		NULL, 			-- 2  p_reply_to
		current_timestamp,	-- 3  p_sent_date
		NULL, 			-- 4  p_sender
		:rfc822_id,	        -- 5  p_rfc822_id
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

 
<fullquery name="general_comment_new.get_revision">      
      <querytext>
      
        select content_item__get_latest_revision(:comment_id) as revision_id
        
    
      </querytext>
</fullquery>

 
<fullquery name="general_comment_new.set_content">      
      <querytext>
    
        update cr_revisions
           set content = :content
         where revision_id = :revision_id
       
      </querytext>
</fullquery>
 
</queryset>
