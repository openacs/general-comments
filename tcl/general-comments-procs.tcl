# /packages/general-comments/tcl/general-comments-procs.tcl

# Porting: Moved most queries from variables to in-line 
# for the QueryExtractor, appended '_deprecated' to 
# query-names in 'ad_proc -deprecated' functions. 
# Left one duplicate with 100% identical SQL (pascal) 

ad_library {
    Utility procs for general-comments

    @author Phong Nguyen <phong@arsdigita.com>
    @author Pascal Scheffers <pascal@scheffers.net>

    @creation-date 2000-10-12
    @cvs-id $Id$
}


ad_proc general_comment_new {
    -object_id:required
    -comment_id:required
    -title:required
    -comment_mime_type:required
    -context_id:required
    {-user_id ""}
    {-creation_ip ""}
    -is_live:required
    -category:required
    -content:required
} {

    db_transaction {
	db_exec_plsql insert_comment { }

	db_dml add_entry { }

	db_1row get_revision {}  

	db_dml set_content {} -blobs [list $content]

	# Grant the user sufficient permissions to 
	# created comment. This is done here to ensure that
	# a fail on permissions granting will not leave
	# the comment with incorrect permissions. 
	if {![empty_string_p $user_id]} {
	    permission::grant -object_id $comment_id \
		              -party_id $user_id \
		              -privilege "read"

	    permission::grant -object_id $comment_id \
		              -party_id $user_id \
		              -privilege "write"

	}
    }
    return $revision_id
}

ad_proc -public general_comments_get_comments {
    { -print_content_p 0 }
    { -print_attachments_p 0 }
    { -context_id "" }
    { -my_comments_only_p 0 }
    object_id 
    {return_url {}}
} {
    Generates a line item list of comments for the object_id.

    @param print_content_p Pass in 1 to print out content of comments.
    @param print_attachments_p Pass in 1 to print out attachments of comments, 
                               only works if print_content_p is 1. 
    @param context_id Show only comments with given context_id
    @param object_id The object_id to retrieve the comments for.
    @param return_url A url for the user to return to after viewing a comment.
} {

    # get the package url
    set package_url [general_comments_package_url]
    if { [empty_string_p $package_url] } {
        return ""
    }

    # package_id
    array set node_array [site_node::get -url $package_url]
    set package_id $node_array(package_id)

    # set ordering
    set recent_on_top_p [parameter::get \
                             -package_id $package_id \
                             -parameter "RecentOnTopP" \
                             -default f]

    if {[string is true $recent_on_top_p]} {
        set orderby "o.creation_date desc"
    } else {
        set orderby "o.creation_date"
    }

    # filter output to only see present user?
    set allow_my_comments_only_p [parameter::get \
                                      -package_id $package_id \
                                      -parameter "AllowDisplayMyCommentsLinkP" \
                                      -default t]

    if {[string is true $my_comments_only_p] && \
            [string is true $allow_my_comments_only_p]} {
        set my_comments_clause "and o.creation_user = :user_id"
    } else {
        set my_comments_clause ""
    }

    # initialize variables
    if { $print_content_p == 0 } {
        set content_select ""
        set content ""
    } else {
        set content_select [db_map content_select] ;# ", r.content"
    }

    if { ![empty_string_p $context_id] } {
        set context_clause "and o.context_id = :context_id"
    } else {
        set context_clause ""
    }
    
    set html ""
    db_foreach get_comments {} {
        # call on helper proc to print out comment
        append html [general_comments_print_comment $comment_id $title $mime_type \
                $creation_user $author $pretty_date $pretty_date2 $content \
                $print_content_p $print_attachments_p $package_url $return_url]
    }
    return $html
}

ad_proc -private general_comments_print_comment {
    comment_id
    title
    mime_type
    creation_user
    author
    pretty_date
    pretty_date2
    content
    print_content_p
    print_attachments_p
    package_url
    return_url
} {
    Helper proc to format and print out a single comment.
    @param comment_id The id of the comment.
    @param title The title of the comment.
    @param mime_type The mime_type of the comment.
    @param creation_user The creation user of the comment.
    @param author The name of the author.
    @param pretty_date A short pretty date of the comment.
    @param pretty_date2 A long pretty date of the comment.
    @param content The content of the comment.
    @param print_content_p Pass in 1 to print out content of comments.
    @param print_attachments_p Pass in 1 to print out attachments of comments.
    @param package_url The url to the mounted general-comments package instance.
    @param return_url A url for the user to return to after viewing a comment. 
} {

    # -- create query statements to retrieve attachments
    # PRS: Moved inline for QueryExtractor

    # This part is really ugly. This will remain here until we figure out a way to 
    # move this into a template.
    set html ""
    if { $print_content_p == 1 } {
        append html "<h4>$title</h4>\n"

        # convert to html
        set richtext_list [list $content $mime_type]
        append html [template::util::richtext::get_property html_value $richtext_list]

        if { $print_attachments_p == 1 } {
            set attachments_html ""
            db_foreach get_attachments "
	                    select r.title, r.mime_type,  i.name, i.item_id
	                      from cr_items i, cr_revisions r
	                     where i.parent_id = :comment_id 
                               and r.revision_id = i.live_revision" {

                append attachments_html "<li>$title "
                if { $mime_type == "image_gif" || $mime_type == "image/jpeg" } {
                    append attachments_html "(<a href=\"${package_url}view-image?image_id=$item_id&return_url=$return_url\">$name</a>)\n"
                } else {
                    append attachments_html "(<a href=\"${package_url}file-download?item_id=$item_id\">$name</a>)\n"
                }
            }

            db_foreach get_links "
	              select i.item_id, e.label, e.url
	                from cr_items i, cr_extlinks e
	               where i.parent_id = :comment_id and e.extlink_id = i.item_id" {
                append attachments_html "<li><a href=\"$url\">$label</a>\n"
            }
            if { ![empty_string_p $attachments_html] } {
                append html "<h5>[_ general-comments.Attachments]</h5>\n<ul>\n$attachments_html</ul>\n"
            }
        }
        append html "<p>-- <a href=\"/shared/community-member?user_id=$creation_user\">$author</a> [_ general-comments.on] $pretty_date2 (<a href=\"${package_url}view-comment?[export_url_vars comment_id return_url]\">[_ general-comments.view_details]</a>)</p>\n"
    } else {
        append html "<li><a href=\"${package_url}view-comment?[export_url_vars comment_id return_url]\">$title</a> [_ general-comments.by] <a href=\"/shared/community-member?user_id=$creation_user\">$author</a> [_ general-comments.on] $pretty_date<br>\n"
    }

    return $html
}


ad_proc -public general_comments_create_link {
    -object_name
    { -link_text {Add a comment} }
    -context_id
    { -category {} }
    { -link_attributes "" }
    object_id
    {return_url {}} 
} {
    Generates an html link to add a comment to an object.

    @param object_id   The object to comment on.
    @param return_url  A url for the user to return to after viewing a comment.
    @param object_name The name of the object.
    @param link_text   The text to display for the link.
    @param context_id  The context_id for the comment.
    @param category    A category to associate comment to.
    @param link_attributes  Some additional parameters for the link. Could be used
			to set the link title and other things like that. Ex. -link_attributes
			<i>{ title="My link title" }</i>
} {
    # get the package url
    set package_url [general_comments_package_url]
    if { [empty_string_p $package_url] } {
        return ""
    }

    # initialize variables
    if { ![info exists object_name] } { set object_name [acs_object_name $object_id] }
    if { ![info exists context_id] } { set context_id $object_id }

    set html "<a href=\"${package_url}comment-add?[export_url_vars object_id object_name return_url context_id category]\" $link_attributes>$link_text</a>"

    return $html
}

ad_proc -public general_comments_package_url {} {
    Returns a url pointing to the mounted general-comments package.
    Uses util_memoize for caching.
} {
    return [site_node::get_package_url -package_key "general-comments"]
}

# these are being replaced with the above procs
namespace eval general_comments {

ad_proc -deprecated get_comments {object_id return_url} {
    Generates a line item list of comments for the object_id.

    @param object_id The object_id to retrieve the comments for.
    @param return_url A url for the user to return to after viewing a comment.
    
    @see general_comments_get_comments
} {

    # get the package url
    set package_url [general_comments_package_url]

    set html ""
    db_foreach get_comments_deprecated "
             select g.comment_id,
                    r.title,
                    r.content,
                    r.mime_type,
                    o.creation_user,
                    to_char(o.creation_date, 'MM-DD-YYYY') as creation_date,
                    p.first_names || ' ' || p.last_name as author
               from general_comments g,
                    cr_items i,
                    cr_revisions r,
                    acs_objects o,
                    persons p
              where g.object_id = :object_id and
                    i.item_id = g.comment_id and
                    r.revision_id = i.live_revision and
                    o.object_id = g.comment_id and
                    p.person_id = o.creation_user
              order by creation_date" {
        append html "<li><a href=\"${package_url}view-comment?[export_url_vars comment_id return_url]\">$title</a> by $author, $creation_date<br>\n"
    }
    return "$html"
}

ad_proc -deprecated create_link {object_id object_name return_url link_text {context_id ""} {category ""}} {
    Generates an html link to add a comment to an object.
    @param object_id   The object to comment on.
    @param object_name The name of the object.
    @param return_url  A url for the user to return to after viewing a comment.
    @param link_text   The text to display for the link.
    @param category    A category to associate comment to.

    @see general_comments_create_link
} {
    # get the package url
    set package_url [general_comments_package_url]

    set html "<a href=\"${package_url}comment-add?[export_url_vars object_id object_name return_url context_id category]\">$link_text</a>"
    return $html
}

}
