# /packages/general-comments/www/delete-attachment-2.tcl

ad_page_contract {
    Deletes an attachment
    
    @param attach_id The id of the attachment to delete
    @param parent_id The id of the comment this attachment refers to
    @param submit    Determines the action to take

    @author Phong Nguyen (phong@arsdigita.com)
    @author Pascal Scheffers (pascal@scheffers.net)
    @creation-date 2000-10-12
    @cvs-id $Id$
} {
    attach_id:integer,notnull
    parent_id:integer,notnull
    submit:notnull
    { return_url {} }
}

# check for permissions
ad_require_permission $attach_id delete

# all of this messy code will be replaced by
# a single content_item.delete after the bug fix
# is released

#Commented out during i18n convertion, Steffen
#if { $submit == "Proceed" } {


    # get the type of the attachment
    db_1row get_type {
        select content_type
          from cr_items
         where item_id = :attach_id
    }    
    if { $content_type == "content_revision" } {
        # get the mime_type
        db_1row get_mime_type {
            select mime_type
              from cr_revisions
             where item_id = :attach_id
               and revision_id = content_item.get_latest_revision (:attach_id)
        }
        if { $mime_type == "image/jpeg" || $mime_type == "image/gif" } {
            # delete row from images table, we should only have one row
            # this is only temporary until CR provides a delete image function
            db_dml delete_image_row {
                delete from images
                 where image_id = content_item.get_latest_revision(:attach_id)
            }
            db_exec_plsql delete_image {
                begin
                    acs_message.delete_image(:attach_id);
                end;
            }
        } else {
            db_exec_plsql delete_attachment {
                begin
                   acs_message.delete_file(:attach_id);
                end;
            }
        }
    } elseif { $content_type == "content_extlink" } {
        db_exec_plsql delete_extlink {
            begin
                content_extlink.del(:attach_id);
            end;
        }
    } 

#/ i18n
#}

ad_returnredirect "view-comment?comment_id=$parent_id&[export_url_vars return_url]"








