# /packages/general-comments/www/admin/delete-attachment.tcl

ad_page_contract {
    Delete an attachment
    
    @param attach_id The id of the file attachment to delete
    @param parent_id The id of the comment this attachment refers to
    
    @author Phong Nguyen (phong@arsdigita.com)
    @creation-date 2000-10-12
    @cvs-id $Id$
} {
    attach_id:integer,notnull
    parent_id:integer,notnull
    { return_url {} }
} -properties {
    page_title:onevalue
    context_bar:onevalue
    attach_id:onevalue
    parent_id:onevalue
    return_url:onevalue
}

# check for permissions
ad_require_permission $attach_id delete

# set template variables
set page_title "Delete attachment"
set context_bar {"Delete attachment"}

ad_return_template