# /packages/general-comments/www/file-add.tcl

ad_page_contract {
    Creates a new file attachment
    
    @param parent_id The id of the comment to attach to
 
    @author Phong Nguyen (phong@arsdigita.com)
    @creation-date 2000-10-12
    @cvs-id $Id$
} {
    parent_id:notnull,integer
    {return_url {} }
} -properties {
    page_title:onevalue
    context_bar:onevalue
    parent_id:onevalue
    target:onevalue
    title:onevalue
    file_name:onevalue
} -validate {
    allow_file_attachments {
        set allow_files_p [ad_parameter AllowFileAttachmentsP {general-comments} {t}]
        if { $allow_files_p != "t" } {
            ad_complain "Attaching files to comments has been disabled."
        }
    }
}

# check to see if the user can add an attachment
ad_require_permission $parent_id write

# set variables for template
set attach_id [db_nextval acs_object_id_seq]
set page_title "Add a file attachment to comment #$parent_id"
set context_bar {[list "view-comment?comment_id=$parent_id" "Go back to comment"] "Add file attachment"}
set target "file-add-2"
set title ""
set file_name ""

ad_return_template "file-ae"



