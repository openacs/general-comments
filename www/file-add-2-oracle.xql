<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="insert_image">      
      <querytext>
      
             begin
                :1 := acs_message.new_image (
                    message_id     => :parent_id,
                    image_id       => :attach_id,
                    file_name      => :client_filename,
                    title          => :title,
                    mime_type      => :guessed_file_type,
                    content        => empty_blob(),
                    width          => :original_width,
                    height         => :original_height,
                    creation_user  => :user_id,
                    creation_ip    => :creation_ip,
                    is_live        => :is_live
            );
            end;
        
      </querytext>
</fullquery>

 
<fullquery name="insert_file">      
      <querytext>
      
            begin
                :1 := acs_message.new_file (
                    message_id     => :parent_id,
                    file_id        => :attach_id,
                    file_name      => :client_filename,
                    title          => :title,
                    mime_type      => :guessed_file_type,
                    content        => empty_blob(),
                    creation_user  => :user_id,
                    creation_ip    => :creation_ip,
                    is_live        => :is_live
            );
            end;
        
      </querytext>
</fullquery>

 
<fullquery name="get_revision">      
      <querytext>
      
        select content_item.get_latest_revision(:attach_id) as revision_id
        from dual
    
      </querytext>
</fullquery>

<fullquery name="set_content_size">
      <querytext>
      
	update cr_revisions
 	set filename = '$tmp_filename',
	    content_length = $tmp_size
	where revision_id = :revision_id

      </querytext>
</fullquery>
 
</queryset>
