# /packages/general-comments/www/file-add-2.tcl

ad_page_contract {
    Creates a new file attachment

    @param attach_id A new id to create the file attachment with
    @param parent_id The id of the comment to attach file
    @param title The title of the file attachment
    @param upload_file The name of the file

    @author Phong Nguyen (phong@arsdigita.com)
    @creation-date 2000-10-12
    @cvs-id $Id$
} {
    attach_id:integer,notnull
    parent_id:integer,notnull
    title:notnull
    upload_file:notnull
    upload_file.tmpfile:tmpfile
    { return_url {} }
} -validate {
    allow_file_attachments {
        set allow_files_p [ad_parameter AllowFileAttachmentsP {general-comments} {t}]
        if { $allow_files_p != "t" } {
            ad_complain "Attaching files to comments has been disabled."            
        }
    }
    check_file_size {
        set tmp_filename ${upload_file.tmpfile}
        set n_bytes [file size $tmp_filename]
        set max_file_size [ad_parameter MaxFileSize {general-comments} {0}]
        if { $n_bytes > $max_file_size && $max_file_size > 0 } {
            ad_complain "Your file is too large.  The publisher of [ad_system_name] has chosen to limit attachments to [util_commify_number $max_file_size] bytes.\n"
        }
        if { $n_bytes == 0 } {
            ad_complain "Your file is zero-length.  Either you attempted to upload a zero length file, a file which does not exists, or something went wrong during the transfer.\n"
        }
    }
}

# authenticate the user
set user_id [ad_verify_and_get_user_id]

# check to see if the user can create comments
ad_require_permission $parent_id write

# get the file extension
set tmp_filename ${upload_file.tmpfile}
set file_extension [string tolower [file extension $upload_file]]

# remove the first . from the file extension
regsub {\.} $file_extension "" file_extension
set guessed_file_type [ns_guesstype $upload_file]

# if the guessed_file_type is not an entry in 
# cr_mime_types, then set it as null
if { ![db_0or1row is_mime_type_valid {
    select mime_type
      from cr_mime_types
    where mime_type = :guessed_file_type }] } {
      set guessed_file_type [db_null]
}

# strip off the C:\directories... crud and just get the file name
if ![regexp {([^/\\]+)$} $upload_file match client_filename] {
    # couldn't find a match
    set client_filename $upload_file
}

set what_aolserver_told_us ""
if { $file_extension == "jpeg" || $file_extension == "jpg" } {
    catch { set what_aolserver_told_us [ns_jpegsize $tmp_filename] }
} elseif { $file_extension == "gif" } {
    catch { set what_aolserver_told_us [ns_gifsize $tmp_filename] }
}

# the AOLserver jpegsize command has some bugs where the height comes 
# through as 1 or 2 
if { ![empty_string_p $what_aolserver_told_us] && [lindex $what_aolserver_told_us 0] > 10 && [lindex $what_aolserver_told_us 1] > 10 } {
    set original_width [lindex $what_aolserver_told_us 0]
    set original_height [lindex $what_aolserver_told_us 1]
} else {
    set original_width ""
    set original_height ""
}


# insert the file comment into the database
set creation_ip [ad_conn peeraddr]
set is_live "t"
db_transaction {
    if { $file_extension == "jpeg" || $file_extension == "jpg" || $file_extension == "gif" } {
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
  
    db_1row get_revisoin {
        select content_item.get_latest_revision(:attach_id) as revision_id
        from dual
    }
    
    db_dml set_content {
    update cr_revisions
        set content = empty_blob()
        where revision_id = :revision_id
        returning content into :1
    } -blob_files [list $tmp_filename]
}

ad_returnredirect "view-comment?comment_id=$parent_id&[export_url_vars return_url]"
