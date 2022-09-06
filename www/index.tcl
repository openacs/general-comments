# /packages/general-comments/www/index.tcl

ad_page_contract {
    General comments main page

    @author Phong Nguyen (phong@arsdigita.com)
    @author Pascal Scheffers (pascal@scheffers.net)
    @creation-date 2000-10-12
    @cvs-id $Id$
} -query {
    {orderby:token,optional}
    {approval "any"}
    {modified "any"}
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
set return_url [ad_return_url]

set user_name [person::name -person_id $user_id]

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

template::list::create -name comments_list \
    -multirow comments \
    -no_data "#general-comments.lt_No_comments_available#" \
    -html {style "margin: 0 auto"} \
    -elements {
        counter {
            label "#general-comments.Num#"
            display_template {@comments.rownum;literal@}
        }
        comment_id {
            label "#general-comments.ID#"
            display_template {<a href="view-comment?comment_id=@comments.comment_id@">@comments.comment_id@</a>}
            orderby {comment_id}
        }
        title {
            label "#general-comments.Title_1#"
            orderby {title}
        }
        approved_p {
            label "#general-comments.Approved#"
            html {align center}
            orderby {approved_p}
        }
        live_version_p {
            label "#general-comments.Has_live_version#"
            html {align center}
            orderby {approved_p}
        }
        pretty_date {
            label "#general-comments.Last_Modified#"
            orderby {creation_date}
        }
} -filters {approval {} modified {}}

set yes [_ acs-kernel.common_Yes]
set no  [_ acs-kernel.common_No]

db_multirow -extend {user_id return_url pretty_date} comments comments_select {} {
    set live_version_p [expr {$live_version_p ? $yes : $no}]
    set approved_p [expr {$approved_p ? $yes : $no}]
    set pretty_date [lc_time_fmt $creation_date "%x %X"]
}

set page_title [_ general-comments.General_Comments]
set context {}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
