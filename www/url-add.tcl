# /packages/general-comments/www/url-add.tcl

ad_page_contract {
    Attaches a url to a comment

    @param parent_id The id of the comment to attach to
    
    @author Phong Nguyen (phong@arsdigita.com)
    @creation-date 2000-10-12
    @cvs-id $Id$
} {
    parent_id:notnull,integer
    { return_url {} }
} -properties {
    page_title:onevalue
    context_bar:onevalue
    parent_id:onevalue
    target:onevalue
    label:onevalue
    url:onevalue
    parent_id:onevalue
    return_url:onevalue
} -validate {
    allow_link_attachments {
        set allow_links_p [ad_parameter AllowLinkAttachmentsP {general-comments} {t}]
        if { $allow_links_p != "t" } {
            ad_complain "Attaching links to comments has been disabled."
        }
    }
}

# check to see if the user can add an attachment
ad_require_permission $parent_id write

# set variables for template
set attach_id [db_nextval acs_object_id_seq]
set page_title "Add url attachment to comment #$parent_id"
set context_bar {[list "view-comment?comment_id=$parent_id" "Go back to comment"] "Add url comment"}
set target "url-add-2"
set label ""
set url ""

ad_return_template "url-ae"



