# /packages/general-comments/www/url-add.tcl

ad_page_contract {
    Attaches a url to a comment

    @param parent_id The id of the comment to attach to
    
    @author Phong Nguyen (phong@arsdigita.com)
    @author Pascal Scheffers (pascal@scheffers.net)
    @creation-date 2000-10-12
    @cvs-id $Id$
} {
    parent_id:notnull,integer
    { return_url {} }
} -properties {
    page_title:onevalue
    context:onevalue
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
            ad_complain "[_ general-comments.lt_Attaching_links_to_co]"
        }
    }
}

# check to see if the user can add an attachment
ad_require_permission $parent_id write

# set variables for template
set attach_id [db_nextval acs_object_id_seq]
set page_title "[_ general-comments.lt_Add_url_attachment_to] #$parent_id"
set context [list [list "view-comment?comment_id=$parent_id" "[_ general-comments.Go_back_to_comment]"] "[_ general-comments.Add_url_comment]"]
set target "url-add-2"
set label ""
set url ""

ad_return_template "url-ae"



