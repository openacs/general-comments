<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="comments_select">      
      <querytext>
    select g.comment_id,
           r.title, 
           acs_object__name(o.creation_user) as author,
           o.creation_user, 
           case when i.live_revision = null then 0 else 1 end as live_version_p,
           case when i.live_revision = r.revision_id then 1 else 0 end as approved_p, 
           to_char(o.creation_date, 'MM-DD-YYYY HH12:MI:AM') as pretty_date,
           o.creation_date           
      from general_comments g,
           cr_items i,
           cr_revisions r,
           acs_objects o
     where g.comment_id = i.item_id and
           r.revision_id = o.object_id and
           r.revision_id = i.latest_revision
          [ad_dimensional_sql $dimensional]
    [template::list::orderby_clause -orderby -name comments_list]
      </querytext>
</fullquery>
 
</queryset>
