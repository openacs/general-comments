<?xml version="1.0"?>
<queryset>

<fullquery name="is_mime_type_valid">      
      <querytext>
      
    select mime_type
      from cr_mime_types
    where mime_type = :guessed_file_type 
      </querytext>
</fullquery>

 
</queryset>
