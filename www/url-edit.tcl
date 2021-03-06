ad_page_contract {
    Edits a URL comment

    @author Phong Nguyen (phong@arsdigita.com)
    @author Pascal Scheffers (pascal@scheffers.net)
    @creation-date 2000-10-12
    @cvs-id $Id$
} {
    attach_id:naturalnum,notnull
    parent_id:naturalnum,notnull
    { return_url:localurl {} }
} -properties {
    page_title:onevalue
    context:onevalue
    parent_id:onevalue
    target:onevalue
    label:onevalue
    url:onevalue
}

# check to see if the user can edit this attachment
permission::require_permission -object_id $attach_id -privilege write

# get the values from the database
if { ![db_0or1row get_comment {
          select label,
                 url
            from cr_extlinks
           where extlink_id = :attach_id
}] } {
    ad_return_complaint 1 "The attach_id does not refer to a valid url attachment."
    ad_script_abort
}

set page_title "[_ general-comments.lt_Edit_url_attachment_o] #$parent_id"
set context [list [list "view-comment?comment_id=$parent_id" "[_ general-comments.Go_back_to_comment]"] "[_ general-comments.Edit_url_attachment]"]
set target "url-edit-2"

ad_return_template "url-ae"

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
