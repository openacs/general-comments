<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="insert_comment">      
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
                is_live       => :is_live
            );
        end;
    
      </querytext>
</fullquery>

 
<fullquery name="get_revision">      
      <querytext>
      
        select content_item.get_latest_revision(:comment_id) as revision_id
        from dual
    
      </querytext>
</fullquery>

 
<fullquery name="set_content">      
      <querytext>
      
        update cr_revisions
           set content = empty_blob()
         where revision_id = :revision_id
     returning content into :1
    
      </querytext>
</fullquery>

 
<fullquery name="grant_permission">      
      <querytext>
      
        begin
            acs_permission.grant_permission (
                object_id  => :comment_id,
                grantee_id => :user_id,
                privilege  => 'read'
            );
            acs_permission.grant_permission (
                object_id  => :comment_id,
                grantee_id => :user_id,
                privilege  => 'write'
            );
        end;
    
      </querytext>
</fullquery>

 
</queryset>
