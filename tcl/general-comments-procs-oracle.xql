<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="general_comment_new.insert_comment">      
      <querytext>
      
        begin
            :1 := acs_message.new (
                message_id    => :comment_id,
                title         => :title,
                mime_type     => :comment_mime_type,
                data          => empty_blob(),
                context_id    => :context_id,
                creation_user => :user_id, 
                creation_ip   => :creation_ip,
                is_live       => :is_live,
		rfc822_id     => :rfc822_id
            );
        end;
    
      </querytext>
</fullquery>

<fullquery name="general_comment_new.set_content">      
      <querytext>
      
        update cr_revisions
           set content = empty_blob()
         where revision_id = :revision_id
     returning content into :1
    
      </querytext>
</fullquery>
 
</queryset>
