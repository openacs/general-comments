# /packages/general-comments/www/test.tcl
 
ad_page_contract {
    Test page for general-comments

    @author Phong Nguyen (phong@arsdigita.com)
    @author Pascal Scheffers (pascal@scheffers.net)
    @creation-date 2000-10-12
    @cvs-id $Id$
} { 
} -properties {
    page_title:onevalue
    context:onevalue
    package_id:onevalue
    gc_package_id:onevalue
    package_url:onevalue
    gc_package_url:onevalue
    auto_approve_comments_p:onevalue
    allow_file_attachments_p:onevalue
    allow_link_attachments_p:onevalue
    max_file_size:onevalue
    comments:onevalue
    full_comments:onevalue
    link:onevalue
}    

set page_title "[_ general-comments.lt_Test_page_for_General]"
set context "\"[_ general-comments.test]\""

if { ![db_0or1row get_gc_package_id {
    select package_id
      from apm_packages
    where package_key = 'general-comments'
}] } {
    set package_id ""
}
set package_url [general_comments_package_url]

set auto_approve_comments_p [ad_parameter -package_id $package_id \
	AutoApproveCommentsP {general-comments} {}]
set allow_file_attachments_p [ad_parameter -package_id $package_id \
	AllowFileAttachmentsP {general-comments} {}]
set allow_link_attachments_p [ad_parameter -package_id $package_id \
	AllowLinkAttachmentsP {general-comments} {}]
set max_file_size [ad_parameter  -package_id $package_id \
	MaxFileSize {general-comments} {}]

set comments [general_comments_get_comments $package_id "${package_url}test"]
set full_comments [general_comments_get_comments -print_content_p 1 -print_attachments_p 1 $package_id "${package_url}test"]
set link [general_comments_create_link $package_id "${package_url}test" ]

ad_return_template
