# /packages/general-comments/www/admin/index.tcl

ad_page_contract {
    General comments administration main page
    
    @author Phong Nguyen (phong@arsdigita.com)
    @author Pascal Scheffers (pascal@scheffers.net)
    @creation-date 2000-10-12
    @cvs-id $Id$
}  -query { 
    {orderby:token,optional}
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
set return_url [ad_return_url]

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
            display_template {@comments.rownum;literal@}
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
	author {
	    label "#general-comments.Author#"
	    orderby {(select first_names || last_name
                      from persons
                      where person_id = o.creation_user)}
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
	actions {
	    label "#general-comments.Actions#"
	    display_template {
		<a href="toggle-approval?comment_id=@comments.comment_id@&return_url=@comments.return_url@">
		<if @comments.approved_p;literal@ true>#general-comments.reject#</if><else>#general-comments.approve#</else></a> |
		<a href="delete?comment_id=@comments.comment_id@&return_url=@comments.return_url@">[_ general-comments.delete]</a>
	    }
	}
    } -filters {approval {} modified {}} 

set yes [_ acs-kernel.common_Yes]
set no  [_ acs-kernel.common_No]

db_multirow -extend {
    user_id
    return_url
    pretty_date
    author
} comments comments_select [subst {
    select g.comment_id,
           r.title, 
           o.creation_user, 
           i.live_revision is not null as live_version_p,
           i.live_revision = r.revision_id as approved_p,
           to_char(o.creation_date, 'MM-DD-YYYY HH12:MI:AM') as pretty_date,
           o.creation_date           
      from general_comments g,
           cr_items i,
           cr_revisions r,
           acs_objects o
     where g.comment_id = i.item_id and
           r.revision_id = o.object_id and
           r.revision_id = i.latest_revision
          [ad_dimensional_sql $dimensional]
    [template::list::orderby_clause -orderby -name comments_list]    
}] {
    set author [person::name -person_id $creation_user]
    set live_version_p [expr {$live_version_p ? $yes : $no}]
    set approved_p [expr {[string is true -strict $approved_p] ? $yes : $no}]
    set pretty_date [lc_time_fmt $creation_date "%x %X"]
}

set page_title "[_ general-comments.lt_General_Comments_Admi]"
set context {}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
