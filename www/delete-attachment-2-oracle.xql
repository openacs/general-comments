<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="get_mime_type">      
      <querytext>
      
            select mime_type
              from cr_revisions
             where item_id = :attach_id
               and revision_id = content_item.get_latest_revision (:attach_id)
        
      </querytext>
</fullquery>

 
<fullquery name="delete_image_row">      
      <querytext>
      
                delete from images
                 where image_id = content_item.get_latest_revision(:attach_id)
            
      </querytext>
</fullquery>

 
<fullquery name="delete_image">      
      <querytext>
      
                begin
                    acs_message.delete_image(:attach_id);
                end;
            
      </querytext>
</fullquery>

 
<fullquery name="delete_attachment">      
      <querytext>
      
                begin
                   acs_message.delete_file(:attach_id);
                end;
            
      </querytext>
</fullquery>

 
<fullquery name="delete_extlink">      
      <querytext>
      
            begin
                content_extlink.del(:attach_id);
            end;
        
      </querytext>
</fullquery>

 
</queryset>
