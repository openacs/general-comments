<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="insert_image">      
      <querytext>

             select acs_message__new_image (
                    /* message_id     => */ :parent_id,
                    /* image_id       => */ :attach_id,
                    /* file_name      => */ :client_filename,
                    /* title          => */ :title,
                    /* description    => */ NULL,
                    /* mime_type      => */ :guessed_file_type,
                    /* data           => */ NULL,
                    /* width          => */ :original_width,
                    /* height         => */ :original_height,
                    /* create_date    => */ current_timestamp,
                    /* creation_user  => */ :user_id,
                    /* creation_ip    => */ :creation_ip,
                    /* is_live        => */ :is_live,
                    /* storage_type   => */ 'file'
            );
        
      </querytext>
</fullquery>

 
<fullquery name="insert_file">      
      <querytext>
            select acs_message__new_file (
                    /* message_id     => */ :parent_id,
                    /* file_id        => */ :attach_id,
                    /* file_name      => */ :client_filename,
                    /* title          => */ :title,
                    /* description    => */ NULL,
                    /* mime_type      => */ :guessed_file_type,
                    /* data           => */ NULL,
                    /* creation_date  => */ current_timestamp,
                    /* creation_user  => */ :user_id,
                    /* creation_ip    => */ :creation_ip,
                    /* is_live        => */ :is_live,
                    /* storage_type   => */ 'file'
            );
      </querytext>
</fullquery>

 
<fullquery name="get_revision">      
      <querytext>
        select content_item__get_latest_revision(:attach_id) as revision_id
      </querytext>
</fullquery>

<fullquery name="set_content_size">
      <querytext>
	update cr_revisions
 	set content = '$tmp_filename',
	    content_length = $tmp_size
        where revision_id = :revision_id
      </querytext>
</fullquery>

</queryset>
