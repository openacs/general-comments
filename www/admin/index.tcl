# /packages/general-comments/www/admin/index.tcl

ad_page_contract {
    General comments administration main page
    
    @author Phong Nguyen (phong@arsdigita.com)
    @author Pascal Scheffers (pascal@scheffers.net)
    @creation-date 2000-10-12
    @cvs-id $Id$
}  -query { 
    {orderby:optional}
    {approval "any"}
    {modified "any"}
} -properties {
    page_title:onevalue
    context:onevalue
    dimensional_bar:onevalue
    comments_table:onevalue
}

# return_url to be passed to various helper pages so that we return to
# this page with the proper parameters
set return_url [ad_urlencode index?[export_ns_set_vars url]]

# dimensional slider definition
set dimensional [list \
    [list approval "[_ general-comments.Status]" unapproved [list \
        [list approved "[_ general-comments.approved]" {where "[db_map status_approved]"} ] \
        [list unapproved "[_ general-comments.unapproved]" {where "[db_map status_unapproved]"} ] \
        [list any "[_ general-comments.all]" {} ] \
    ]] \
    [list modified "[_ general-comments.Last_Modified]" any [list \
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
	}
        comment_id {
	    label "#general-comments.ID#"
	    display_template {<a href="../view-comment?comment_id=@comments.comment_id@">@comments.comment_id@</a>}
	    orderby {comment_id}
	}
	title {
	    label "#general-comments.Title_1#"
	    orderby {title}
	}
	approved_p_pretty {
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
	actions {
	    label "#general-comments.Actions#"
	    display_template {
		<a href="toggle-approval?comment_id=@comments.comment_id@&return_url=@comments.return_url@">
		<if @comments.approved_p@>#general-comments.reject#</if><else>#general-comments.approve#</else></a> |
		<a href="delete?comment_id=@comments.comment_id@&return_url=@comments.return_url@">[_ general-comments.delete]</a>
	    }
	}
    } -filters {approval {} modified {}} 

set count 0
db_multirow -extend {user_id return_url counter approved_p_pretty pretty_date} comments comments_select {} {
    set counter [incr count]
    set pretty_date [lc_time_fmt $creation_date "%x %X"]
    set approved_p_pretty [util_PrettyTclBoolean $approved_p]
    set live_version_p [util_PrettyTclBoolean $live_version_p]
}

set page_title "[_ general-comments.lt_General_Comments_Admi]"
set context {}

ad_return_template

