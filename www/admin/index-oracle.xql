<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="comments_select">      
      <querytext>
      
    select g.comment_id,
           r.title, 
           acs_object.name(o.creation_user) as author,
           o.creation_user, 
           case when i.live_revision = null then 0 else 1 end as live_version_p,
           case when i.live_revision = r.revision_id then 1 else 0 end as approved_p, 
           to_char(o.creation_date, 'MM-DD-YYYY HH12:MI:AM') as pretty_date
      from general_comments g,
           cr_items i,
           cr_revisions r,
           acs_objects o
     where g.comment_id = i.item_id and
           r.revision_id = o.object_id and
           r.revision_id = content_item.get_latest_revision(g.comment_id)
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
