<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="insert_comment">      
      <querytext>
      
    begin
        :1 := content_extlink.new (
                name            => :name,
                url             => :url,
                label           => :label,
                parent_id       => :parent_id,
                extlink_id      => :attach_id,
                creation_user   => :user_id,
                creation_ip     => :creation_ip
         );
    end;

      </querytext>
</fullquery>

 
</queryset>
