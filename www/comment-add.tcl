# /packages/general-comments/www/comment-add.tcl

ad_page_contract {
    Displays a form for adding a comment to a page

    @author Phong Nguyen <phong@arsdigita.com>
    @author Pascal Scheffers (pascal@scheffers.net)
    @creation-date 2000-10-12
    @cvs-id $Id$
} { 
    object_id:naturalnum,notnull
    { object_name "[acs_object_name $object_id]" }
    { context_id:naturalnum "$object_id" }
    { category "" }
    { return_url:localurl "" }
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
