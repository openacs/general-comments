<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="general_comments_get_comments.get_comments">      
      <querytext>
      
             select g.comment_id,
                    r.title,
                    r.mime_type,
                    o.creation_user,
                    acs_object.name(o.creation_user) as author,
                    o.creation_date
                    $content_select
               from general_comments g,
                    cr_revisions r,
                    acs_objects o
              where g.object_id = :object_id and
                    r.revision_id = content_item.get_live_revision(g.comment_id) and
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

 
<fullquery name="general_comment_new.get_revision">      
      <querytext>
      
        select content_item.get_latest_revision(:comment_id) as revision_id
        from dual
    
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
