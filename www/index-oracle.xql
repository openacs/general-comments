<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="comments_select">      
      <querytext>

    select g.comment_id,
           r.title, 
           acs_object.name(o.creation_user) as author,
           o.creation_user, 
           decode(i.live_revision,null,0,1) as live_version_p,
           decode(i.live_revision,r.revision_id,1,0) as approved_p, 
           o.creation_date
      from general_comments g,
           cr_items i,
           cr_revisions r,
           acs_objects o
     where g.comment_id = i.item_id and
           r.revision_id = o.object_id and
           r.revision_id = content_item.get_latest_revision(g.comment_id) and
           o.creation_user = :user_id
          [ad_dimensional_sql $dimensional]
     [template::list::orderby_clause -orderby -name comments_list]
     
      </querytext>
</fullquery>

<partialquery name="modified_last_24hours">      
      <querytext>

		creation_date + 1 > sysdate

      </querytext>
</partialquery>

<partialquery name="modified_last_week">      
      <querytext>

		creation_date + 7 > sysdate

      </querytext>
</partialquery>

<partialquery name="modified_last_month">      
      <querytext>

		creation_date + 30 > sysdate

      </querytext>
</partialquery>
 


 
</queryset>
