# /packages/general-comments/www/file-add-2.tcl

ad_page_contract {
    Creates a new file attachment

    @param attach_id A new id to create the file attachment with
    @param parent_id The id of the comment to attach file
    @param title The title of the file attachment
    @param upload_file The name of the file

    @author Phong Nguyen (phong@arsdigita.com)
    @author Pascal Scheffers (pascal@scheffers.net)
    @creation-date 2000-10-12
    @cvs-id $Id$
} {
    attach_id:naturalnum,notnull
    parent_id:naturalnum,notnull
    title:notnull
    upload_file:notnull
    upload_file.tmpfile:tmpfile
    { return_url:localurl {} }
} -validate {
    allow_file_attachments {
        set allow_files_p [parameter::get -parameter AllowFileAttachmentsP -default {t}]
        if { $allow_files_p != "t" } {
            ad_complain "[_ general-comments.lt_Attaching_files_to_co]"
        }
    }
    check_file_size {
        set tmp_size [file size ${upload_file.tmpfile}]
        set max_file_size [parameter::get -parameter MaxFileSize -default {0}]
        if { $tmp_size > $max_file_size && $max_file_size > 0 } {
            ad_complain "[_ general-comments.lt_Your_file_is_too_larg]  [_ general-comments.The_publisher_of] [ad_system_name] [_ general-comments.lt_has_chosen_to_limit_a] [lc_content_size_pretty -size $max_file_size].\n"
        }
        if { $tmp_size == 0 } {
            ad_complain "[_ general-comments.lt_Your_file_is_zero-len]\n"
        }
    }
}


# authenticate the user
set user_id [ad_conn user_id]

# check to see if the user can create comments
permission::require_permission -object_id $parent_id -privilege write

# get the file extension
set tmp_filename ${upload_file.tmpfile}
set file_extension [string tolower [file extension $upload_file]]

# remove the first . from the file extension
regsub {\.} $file_extension "" file_extension
set guessed_file_type [cr_filename_to_mime_type -create $upload_file]

# strip off the C:\directories... crud and just get the filename
if {![regexp {([^/\\]+)$} $upload_file match client_filename]} {
    # couldn't find a match
    set client_filename $upload_file
}

set what_aolserver_told_us ""
if { $file_extension eq "jpeg" || $file_extension eq "jpg" } {
    catch { set what_aolserver_told_us [ns_jpegsize $tmp_filename] }
} elseif { $file_extension eq "gif" } {
    catch { set what_aolserver_told_us [ns_gifsize $tmp_filename] }
}

# the AOLserver jpegsize command has some bugs where the height comes
# through as 1 or 2
if { $what_aolserver_told_us ne "" && [lindex $what_aolserver_told_us 0] > 10 && [lindex $what_aolserver_told_us 1] > 10 } {
    lassign $what_aolserver_told_us original_width original_height
} else {
    set original_width ""
    set original_height ""
}


# insert the file comment into the database
set creation_ip [ad_conn peeraddr]
set is_live "t"
db_transaction {
    if { $file_extension eq "jpeg" || $file_extension eq "jpg" || $file_extension eq "gif" } {
        db_exec_plsql insert_image {
             begin
                :1 := acs_message.new_image (
                    message_id     => :parent_id,
                    image_id       => :attach_id,
                    file_name      => :client_filename,
                    title          => :title,
                    mime_type      => :guessed_file_type,
                    content        => empty_blob(),
                    width          => :original_width,
                    height         => :original_height,
                    creation_user  => :user_id,
                    creation_ip    => :creation_ip,
                    is_live        => :is_live
            );
            end;
        }
    } else {
        db_exec_plsql insert_file {
            begin
                :1 := acs_message.new_file (
                    message_id     => :parent_id,
                    file_id        => :attach_id,
                    file_name      => :client_filename,
                    title          => :title,
                    mime_type      => :guessed_file_type,
                    content        => empty_blob(),
                    creation_user  => :user_id,
                    creation_ip    => :creation_ip,
                    is_live        => :is_live
            );
            end;
        }
    }

    db_1row get_revision {
        select content_item.get_latest_revision(:attach_id) as revision_id
        from dual
    }

#    db_dml set_content {
#    update cr_revisions
#        set content = empty_blob()
#        where revision_id = :revision_id
#        returning content into :1
#    } -blob_files [list $tmp_filename]

# DRB: Since we're using acs_message to store the file, it is automatically
# stuffed into the filesystem rather than database whether we need it or
# not.  This needs to be *changed* ... the whole way we read and write CR content
# based on storage type needs cleaning up.

    set tmp_filename [cr_create_content_file $attach_id $revision_id ${upload_file.tmpfile}]

    db_dml set_content_size ""

}

ad_returnredirect [export_vars -base view-comment {{comment_id $parent_id} return_url}]


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
