<?xml version="1.0"?>
<queryset>

<fullquery name="edit_title">      
      <querytext>
      
    update cr_revisions
       set title = :title
     where revision_id = :revision_id

      </querytext>
</fullquery>

 
</queryset>
