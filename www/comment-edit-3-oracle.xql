<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="insert_comment">      
      <querytext>
      
    begin
        :1 := acs_message.edit (
            message_id    => :comment_id,
            title         => :title,
            mime_type     => :mime_type,
            data          => empty_blob(),
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

 
</queryset>
