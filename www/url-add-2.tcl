# /packages/general-comments/www/url-add-2.tcl

ad_page_contract {
    Inserts a url for object_id into the database
    
    @author Phong Nguyen (phong@arsdigita.com)
    @author Pascal Scheffers (pascal@scheffers.net)
    @creation-date 2000-10-12
    @cvs-id $Id$
} {
    attach_id:integer,notnull
    parent_id:integer,notnull
    label:notnull
    url:notnull
    { return_url {} }
} -validate {
    allow_link_attachments {
        set allow_links_p [ad_parameter AllowLinkAttachmentsP {general-comments} {t}]
        if { $allow_links_p != "t" } {
            ad_complain "[_ general-comments.lt_Attaching_links_to_co]"
        }
    }
}

# authenticate the user
set user_id [ad_verify_and_get_user_id]

# check to see if the user can add an attachment
ad_require_permission $parent_id write

# insert the url into database 
set creation_ip [ad_conn peeraddr]
set name "extlink_$attach_id"
db_exec_plsql insert_comment {
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
}

ad_returnredirect "view-comment?comment_id=$parent_id&[export_url_vars return_url]"






