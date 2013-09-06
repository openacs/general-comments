# /packages/general-comments/www/index.tcl

ad_page_contract {
    General comments main page
    
    @author Phong Nguyen (phong@arsdigita.com)
    @author Pascal Scheffers (pascal@scheffers.net)
    @creation-date 2000-10-12
    @cvs-id $Id$
} { 
    {orderby {pretty_date*} }
} -properties {
    page_title:onevalue
    context:onevalue
    dimensional_bar:onevalue
    comments_table:onevalue
}

# authenticate the user
set user_id [auth::require_login]

# check for admin privileges
set package_id [ad_conn package_id]
set admin_p [permission::permission_p -object_id $package_id -privilege admin]

# return_url to be passed to various helper pages so that we return to
# this page with the proper parameters
set return_url [ns_urlencode index?[export_ns_set_vars url]]


set dimensional [list \
    [list approval "[_ general-comments.Status]" any [list \
        [list approved "[_ general-comments.approved]" {where "[db_map status_approved]"}] \
        [list unapproved "[_ general-comments.unapproved]" {where "[db_map status_unapproved]"}] \
        [list any "[_ general-comments.all]" {} ] \
    ]] \
    [list modified "[_ general-comments.Last_Modified]" 1m [list \
        [list 1d "[_ general-comments.last_24_hours]" {where "[db_map modified_last_24hours]"}] \
        [list 1w "[_ general-comments.last_week]" {where "[db_map modified_last_week]"}] \
        [list 1m "[_ general-comments.last_month]" {where "[db_map modified_last_month]"}] \
        [list any "[_ general-comments.all]" {} ] \
]]
]
set dimensional_bar [ad_dimensional $dimensional]

# ad_table definition
set table_def [list \
                   [list num "[_ general-comments.Num]" {} {<td>$Tcount</td>}] \
                   [list comment_id "[_ general-comments.ID]" {} \
                        {<td><a href="view-comment?comment_id=$comment_id">$comment_id</a></td>}] \
                   [list title "[_ general-comments.Title_1]" {} {}] \
                   [list approved_p "[_ general-comments.Approved]" {} 01] \
                   [list live_version_p "[_ general-comments.Has_live_version]" {} 01] \
                   [list pretty_date "[_ general-comments.Last_Modified]" {creation_date $order} {<td>[lc_time_fmt $creation_date "%x %X"]</td>}] \
]

# create the table to display the comments
set bind_ns_set [ad_tcl_vars_to_ns_set user_id]
set extra_var_list [list return_url $return_url]
set comments_table [ad_table -Torderby $orderby \
                        -Tmissing_text "<i>[_ general-comments.lt_No_comments_available]</i>" \
                        -Textra_vars $extra_var_list \
                        -bind $bind_ns_set \
                        comments_select {} $table_def]

set page_title "[_ general-comments.General_Comments]"
set context {}

ad_return_template

