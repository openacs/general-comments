<?xml version="1.0"?>
<queryset>

<fullquery name="get_comment">      
      <querytext>
      
    select g.object_id,
           r.title,
           r.content,
           r.mime_type as comment_mime_type
      from general_comments g,
           cr_revisions r
     where g.comment_id = :comment_id and
           r.revision_id = :revision_id

      </querytext>
</fullquery>

 
</queryset>
