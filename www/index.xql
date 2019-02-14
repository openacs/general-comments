<?xml version="1.0"?>
<queryset>

  <partialquery name="status_approved">      
    <querytext>
      (i.live_revision is not null and
         i.live_revision = r.revision_id)
    </querytext>
  </partialquery>

  <partialquery name="status_unapproved">      
    <querytext>
      (i.live_revision is null or
         i.live_revision <> r.revision_id)
    </querytext>
  </partialquery>

  <partialquery name="modified_last_24hours">      
    <querytext>

      creation_date > current_timestamp - interval '1' day

    </querytext>
  </partialquery>

  <partialquery name="modified_last_week">      
    <querytext>

      creation_date > current_timestamp - interval '7' day

    </querytext>
  </partialquery>

  <partialquery name="modified_last_month">      
    <querytext>

      creation_date > current_timestamp - interval '30' day
      
    </querytext>
  </partialquery>

  <fullquery name="comments_select">
    <querytext>
     select g.comment_id,
            r.title, 
            i.live_revision is not null as live_version_p,
            i.live_revision is not null and
               i.live_revision = r.revision_id as approved_p,
            o.creation_date
      from general_comments g,
           cr_items i,
           cr_revisions r,
           acs_objects o
     where g.comment_id = i.item_id and
           r.revision_id = o.object_id and
           r.revision_id = i.latest_revision and 
           o.creation_user = :user_id
          [ad_dimensional_sql $dimensional]
     [template::list::orderby_clause -orderby -name comments_list]
    </querytext>
  </fullquery>
  
  
</queryset>
