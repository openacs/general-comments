# /packages/general-comments/www/admin/delete-attachment.tcl

ad_page_contract {
    Delete an attachment
    
    @param attach_id The id of the file attachment to delete
    @param parent_id The id of the comment this attachment refers to
    
    @author Phong Nguyen (phong@arsdigita.com)
    @author Pascal Scheffers (pascal@scheffers.net)
    @creation-date 2000-10-12
    @cvs-id $Id$
} {
    attach_id:naturalnum,notnull
    parent_id:naturalnum,notnull
    { return_url {} }
} -properties {
    page_title:onevalue
    context:onevalue
    attach_id:onevalue
    parent_id:onevalue
    return_url:onevalue
}

# check for permissions
permission::require_permission -object_id $attach_id -privilege delete

# set template variables
set page_title "[_ general-comments.Delete_attachment]"
set context "\"[_ general-comments.Delete_attachment]\""

ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
