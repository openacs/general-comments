# /packages/general-comments/www/url-edit-2.tcl

ad_page_contract {
    Creates a new revision of the url comment.

    @author Phong Nguyen (phong@arsdigita.com)
    @author Pascal Scheffers (pascal@scheffers.net)
    @creation-date 2000-10-12
    @cvs-id $Id$
} {
    attach_id:naturalnum,notnull
    parent_id:naturalnum,notnull
    label:printable,notnull
    url:printable,notnull,string_length(max|1000)
    { return_url:localurl {} }
} -validate {
    no_data_url {
        if {[string match "data:*" [string trim $url]]} {
            ad_complain [_ acs-templating.Invalid_url]
        }
    }
}


# authenticate the user
set user_id [ad_conn user_id]

# check to see if the user can edit this attachment
permission::require_permission -object_id $attach_id -privilege write

db_dml edit_url {
    update cr_extlinks
       set label = :label,
           url = :url
     where extlink_id = :attach_id
}

ad_returnredirect [export_vars -base view-comment {{comment_id $parent_id} return_url}]




# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
