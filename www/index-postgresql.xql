<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="comments_select">      
      <querytext>

     select g.comment_id,
           r.title, 
           acs_object__name(o.creation_user) as author,
           o.creation_user, 
	   case when i.live_revision=null then 0 else 1 end as live_version_p,
	   case when i.live_revision=r.revision_id then 0 else 1 end as approved_p,
           to_char(o.creation_date, 'MM-DD-YYYY HH12:MI:AM') as pretty_date
      from general_comments g,
           cr_items i,
           cr_revisions r,
           acs_objects o
     where g.comment_id = i.item_id and
           r.revision_id = o.object_id and
           r.revision_id = content_item__get_latest_revision(g.comment_id) and
           o.creation_user = :user_id
          [ad_dimensional_sql $dimensional]
    [ad_order_by_from_sort_spec $orderby $table_def]

      </querytext>
</fullquery>


<partialquery name="modified_last_24hours">      
      <querytext>

		creation_date + '1 days'::interval > now()

      </querytext>
</partialquery>

<partialquery name="modified_last_week">      
      <querytext>

		creation_date + '7 days'::interval > now()

      </querytext>
</partialquery>

<partialquery name="modified_last_month">      
      <querytext>

		creation_date + '30 days'::interval > now()

      </querytext>
</partialquery>
 
</queryset>
