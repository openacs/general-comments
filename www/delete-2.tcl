# /packages/general-comments/www/admin/delete-2.tcl

ad_page_contract {
    Deletes a comment and its attachments
    
    @param comment_id The id of the comment to delete
    
    @author Phong Nguyen (phong@arsdigita.com)
    @author Pascal Scheffers (pascal@scheffers.net)
    @creation-date 2000-10-12
    @cvs-id $Id$
} {
    comment_id:naturalnum,notnull
    { return_url {} }
}

# There is a bug in content_item.delete that results in
# referential integrity violations when deleting a content
# item that has an image attachment. This is a temporary fix
# until ACS 4.1 is released.
db_dml delete_image_attachments {
    delete from images
    where image_id in (select latest_revision
                         from cr_items
                        where parent_id = :comment_id)
}

# Only need to call on acs_message.delete since
# deletion of row from general_comments table
# relies on "on delete cascade"
db_exec_plsql delete_comment {}

ad_returnredirect $return_url


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
