<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="insert_comment">      
      <querytext>
    declare 
	v_extlink_id cr_extlinks.extlink_id%TYPE;
	
    begin
	select content_extlink__new (
                /* name            => */ :name,
                /* url             => */ :url,
                /* label           => */ :label,
		/* description        */ NULL,
                /* parent_id       => */ :parent_id,
                /* extlink_id      => */ :attach_id,
		/* creation_date      */ now(),
                /* creation_user   => */ :user_id,
                /* creation_ip     => */ :creation_ip
         ) into v_extlink_id;

	return v_extlink_id;
    end;

      </querytext>
</fullquery>

 
</queryset>
