# /packages/general-comments/www/file-download.tcl

ad_page_contract {
    Downloads a file

    @param item_id The id of the file attachment

    @author Phong Nguyen (phong@arsdigita.com)
    @creation-date 2000-10-12
    @cvs-id $Id$
} {
    item_id:notnull
}

# check for permissions
ad_require_permission $item_id read

# get the mime_type for the item
if { ![db_0or1row get_mime_type {
          select mime_type
            from cr_revisions
           where revision_id = content_item.get_live_revision(:item_id)
}] } {
    ad_return_complaint 1 "The item_id does not refer to a valid file attachment."
}

ReturnHeaders $mime_type

db_write_blob get_file "
    select content
      from cr_revisions
     where revision_id = content_item.get_live_revision($item_id)"
