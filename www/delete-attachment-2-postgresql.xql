<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="get_mime_type">      
      <querytext>
      
            select mime_type
              from cr_revisions
             where item_id = :attach_id
               and revision_id = content_item__get_latest_revision (:attach_id)
        
      </querytext>
</fullquery>

 
<fullquery name="delete_image_row">      
      <querytext>
      
                delete from images
                 where image_id = content_item__get_latest_revision(:attach_id)
            
      </querytext>
</fullquery>

 
<fullquery name="delete_image">      
      <querytext>

         select acs_message__delete_image(:attach_id);
            
      </querytext>
</fullquery>

 
<fullquery name="delete_attachment">      
      <querytext>

         select acs_message__delete_file(:attach_id);
            
      </querytext>
</fullquery>

 
<fullquery name="delete_extlink">      
      <querytext>

            begin
                perform content_extlink__delete(:attach_id);
		return 0;
            end;
        
      </querytext>
</fullquery>

 
</queryset>
