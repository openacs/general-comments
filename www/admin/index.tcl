# /packages/general-comments/www/admin/index.tcl

ad_page_contract {
    General comments administration main page
    
    @author Phong Nguyen (phong@arsdigita.com)
    @author Pascal Scheffers (pascal@scheffers.net)
    @creation-date 2000-10-12
    @cvs-id $Id$
} { 
    {orderby {} }
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
set dimensional {
    {approval "Status" unapproved {
        {approved "approved" {where "[db_map status_approved]"} }
        {unapproved "unapproved" {where "[db_map status_unapproved]"} }
        {any "all" {} }
}   }
    {modified "Last Modified" any {
        {1d "last 24 hours" {where "[db_map modified_last_24hours]"}}
        {1w "last week" {where "[db_map modified_last_week]"}}
        {1m "last month" {where "[db_map modified_last_month]"}}
        {any "all" {} }
}   }
}
set dimensional_bar [ad_dimensional $dimensional]

# ad_table definition
set table_def {
    {num "Num" {} {<td>$Tcount</td>}}
    {comment_id "ID#" {} \
            {<td><a href="../view-comment?comment_id=$comment_id&return_url=admin/$return_url">$comment_id</a></td>}}
    {title "Title" {} {}}
    {author "Author" {upper(author) $order} \
            {<td><a href="/shared/community-member?user_id=$creation_user">$author</a></td>}}
    {approved_p "Approved" {} 01}
    {live_version_p "Has live version" {} 01}
    {pretty_date "Last Modified" {creation_date $order} {}}
    {actions "Actions" {} \
            {<td><a href="toggle-approval?comment_id=$comment_id&return_url=$return_url">
    [if {$approved_p} { 
        subst {reject}
    } else { 
        subst {approve}
    }]</a> | <a href="delete?comment_id=$comment_id&return_url=$return_url">delete</a></td>}}
}
    
# sql to retrieve comments
set sql "
    select g.comment_id,
           r.title, 
           acs_object.name(o.creation_user) as author,
           o.creation_user, 
           decode(i.live_revision,null,0,1) as live_version_p,
           decode(i.live_revision,r.revision_id,1,0) as approved_p, 
           to_char(o.creation_date, 'MM-DD-YYYY HH12:MI:AM') as pretty_date
      from general_comments g,
           cr_items i,
           cr_revisions r,
           acs_objects o
     where g.comment_id = i.item_id and
           r.revision_id = o.object_id and
           r.revision_id = content_item.get_latest_revision(g.comment_id)
          [ad_dimensional_sql $dimensional]
    [ad_order_by_from_sort_spec $orderby $table_def]
"

# create the table to display the comments
set extra_var_list [list return_url $return_url]

set comments_table [ad_table -Torderby $orderby \
	                     -Tmissing_text {<i>No comments available</i>} \
                             -Textra_vars $extra_var_list \
                             comments_select $sql $table_def]

set page_title "General Comments Administration"
set context {}

ad_return_template

