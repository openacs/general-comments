<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="comments_select">      
      <querytext>
     select * from (
     select g.comment_id,
           r.title, 
           acs_object__name(o.creation_user) as author,
           o.creation_user, 
	   case when i.live_revision=null then 0 else 1 end as live_version_p,
	   case when i.live_revision=r.revision_id then 0 else 1 end as approved_p,
           o.creation_date    
      from general_comments g,
           cr_items i,
           cr_revisions r,
           acs_objects o
     where g.comment_id = i.item_id and
           r.revision_id = o.object_id and
           r.revision_id = i.latest_revision and 
           o.creation_user = :user_id
          [ad_dimensional_sql $dimensional]) as unordered
     [template::list::orderby_clause -orderby -name comments_list]
      </querytext>
</fullquery>


<partialquery name="modified_last_24hours">      
      <querytext>

		creation_date > now() - '1 days'::interval 

      </querytext>
</partialquery>

<partialquery name="modified_last_week">      
      <querytext>

		creation_date > now() - '7 days'::interval 

      </querytext>
</partialquery>

<partialquery name="modified_last_month">      
      <querytext>

		creation_date > now() - '30 days'::interval

      </querytext>
</partialquery>
 
</queryset>
