# /packages/general-comments/www/file-download.tcl

ad_page_contract {
    Downloads a file

    @param item_id The id of the file attachment

    @author Phong Nguyen (phong@arsdigita.com)
    @author Pascal Scheffers (pascal@scheffers.net)
    @creation-date 2000-10-12
    @cvs-id $Id$
} {
    item_id:notnull
}

# check for permissions
ad_require_permission $item_id read

cr_write_content -item_id $item_id
