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
                    to_char(o.creation_date, 'MM-DD-YYYY') as pretty_date,
                    to_char(o.creation_date, 'Month DD, YYYY HH12:MI PM') as pretty_date2
                    $content_select
               from general_comments g,
                    cr_revisions r,
                    acs_objects o
              where g.object_id = :object_id and
                    r.revision_id = content_item__get_live_revision(g.comment_id) and
                    o.object_id = g.comment_id
              order by o.creation_date
      </querytext>
</fullquery>

 
<fullquery name="general_comments_package_url_not_cached.get_package_url">      
      <querytext>
      
             select site_node__url(s.node_id) as package_url
               from site_nodes s, apm_packages a
              where s.object_id = a.package_id and
                    lower(a.package_key) = 'general-comments'
                    LIMIT 1
      </querytext>
</fullquery>

 
<fullquery name="get_comments.get_package_url_deprecated">      
      <querytext>
      
             select site_node__url(s.node_id)
               from site_nodes s, apm_packages a
              where s.object_id = a.package_id and
                    a.package_key = 'general-comments'
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

 
<fullquery name="get_comments.get_package_url_deprecated">      
      <querytext>
      
             select site_node__url(s.node_id)
               from site_nodes s, apm_packages a
              where s.object_id = a.package_id and
                    a.package_key = 'general-comments'
      </querytext>
</fullquery>

 
</queryset>
