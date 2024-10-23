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


ad_proc general_comments_new {
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
    Creates a comment and attaches it to a given object ID

    @return

    @error
} {

    # Generate a unique id for the message
    set rfc822_id [ns_uuid]

    db_transaction {

        db_exec_plsql insert_comment {}
        db_dml add_entry {}
        set revision_id [content::item::get_latest_revision \
                             -item_id $comment_id]
        db_dml set_content {} -blobs [list $content]

        # Grant the user sufficient permissions to
        # created comment. This is done here to ensure that
        # a fail on permissions granting will not leave
        # the comment with incorrect permissions.
        if {$user_id ne ""} {
            permission::grant -object_id $comment_id \
                -party_id $user_id \
                -privilege "read"

            permission::grant -object_id $comment_id \
                -party_id $user_id \
                -privilege "write"

        }
    }

    # Convert the comment to HTML
    if {$comment_mime_type ne "text/html"} {
        set content [ad_html_text_convert $content]
    }

    # Start notifications
    callback general_comments::notify_objects \
        -object_id $object_id \
        -comment $content \
        -title $title \
        -object_type [acs_object_type $object_id]

    return $revision_id
}

ad_proc -public general_comments_delete_messages {
    -package_id:required
} {
    Deletes all comments belonging to specified package.
} {
    foreach comment_id [db_list get_comments {
        select comment_id
        from general_comments c,
             acs_objects o
        where c.comment_id = o.object_id
          and o.package_id = :package_id
    }] {
        content::item::delete -item_id $comment_id
    }
}

ad_proc -public general_comments_get_comments {
    { -print_content_p:integer 0 }
    { -print_attachments_p:integer 0 }
    { -print_user_info_p:integer 1}
    { -context_id:integer,0..1 "" }
    { -my_comments_only_p:integer 0 }
    object_id:integer
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
    if { $package_url eq "" } {
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

    set sort_dir [expr {[string is true $recent_on_top_p] ? "desc" : "asc"}]

    # filter output to only see present user?
    set allow_my_comments_only_p [parameter::get \
                                      -package_id $package_id \
                                      -parameter "AllowDisplayMyCommentsLinkP" \
                                      -default t]

    set user_id [expr {[string is true $my_comments_only_p] &&
                       [string is true $allow_my_comments_only_p] ? [ad_conn user_id] : ""}]

    db_multirow -local -extend {
        pretty_date
        pretty_date2
        author_url
        view_url
    } comments get_comments_new [subst {
             select o.object_id as comment_id,
                    r.title,
                    r.mime_type,
                    o.creation_user,
                    o.creation_user as author,
                    o.creation_date,
                    case when :print_content_p = 1
                       then r.content
                       else [expr {[db_driverkey ""] eq "oracle" ? "empty_blob()" : "''"}] end as content,
                    ar.title as attachment_title,
                    ar.mime_type as attachment_mime_type,
                    coalesce(ae.label, ai.name) as attachment_name,
                    ai.item_id as attachment_item_id,
                    case when exists (select 1 from images
                             where image_id = ai.item_id) then 't' else 'f' end as image_p,
                    ae.url as attachment_url
               from cr_revisions r,
                    acs_objects o
                    left join cr_items ai on (:print_content_p = 1 and
                                              :print_attachments_p = 1 and
                                              o.object_id = ai.parent_id)
                    left join cr_revisions ar on ai.live_revision = ar.revision_id
                    left join cr_extlinks ae on ai.item_id = ae.extlink_id
              where o.object_id in (select comment_id
                                      from general_comments
                                     where object_id = :object_id)
                and r.revision_id = (select live_revision
                                       from cr_items
                                      where item_id = o.object_id)
                and (:context_id is null or o.context_id = :context_id)
                and (:user_id is null or o.creation_user = :user_id)
              order by o.creation_date $sort_dir
    }] {
        set author [person::name -person_id $author]

        if {$content ne ""} {
            set content [template::util::richtext::get_property html_value [list $content $mime_type]]
        }

        set pretty_date [lc_time_fmt $creation_date %x]
        set pretty_date2 [lc_time_fmt $creation_date "%q %X"]

        set author_url [export_vars -base /shared/community-member {{user_id $creation_user}}]
        set view_url [export_vars -base ${package_url}view-comment {comment_id return_url}]

        if {$image_p} {
            set attachment_url [export_vars -base ${package_url}view-image {{image_id $attachment_item_id} return_url}]
        } elseif {$attachment_url eq ""} {
            set attachment_url [export_vars -base ${package_url}file-download {{item_id $attachment_item_id}}]
        }
    }

    set template [acs_package_root_dir "general-comments"]/lib/comments.adp
    set template [template::themed_template $template]
    set code [template::adp_compile -file $template]
    set html [template::adp_eval code]

    return $html
}

ad_proc -public general_comments_create_link {
    -object_name
    { -link_text #general-comments.Add_comment# }
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
    if { $package_url eq "" } {
        return ""
    }

    # initialize variables
    if { ![info exists object_name] } { set object_name [acs_object_name $object_id] }
    if { ![info exists context_id] } { set context_id $object_id }

    set html [subst {<a href="[ns_quotehtml [export_vars -base ${package_url}comment-add {object_id
         object_name return_url context_id category}]]" $link_attributes>$link_text</a>}]

    return $html
}

ad_proc -public general_comments_package_url {} {
    Returns a URL pointing to the mounted general-comments package.
    Uses util_memoize for caching.
} {
    return [site_node::get_package_url -package_key "general-comments"]
}

#
# Package-specific page contract filter
#

ad_page_contract_filter general_comments_safe { name value } {
    Safety checks for content posted in a comment. These checks are
    package-specific, because content we may allow in other packages,
    e.g. via the AllowedTag parameter in acs-kernel, should not be
    allowed here.
} {
    #
    # We do not allow iframes or frames
    #
    if {[regexp -nocase {<(iframe|frame)} $value]} {
        ad_complain [_ acs-tcl.lt_name_contains_invalid]
        return 0
    }

    #
    # We do not allow any javascript in the content, including
    # event handlers.
    #
    if {![ad_dom_sanitize_html \
              -allowed_tags * \
              -allowed_attributes * \
              -allowed_protocols * \
              -html $value \
              -no_js \
              -validate]} {
        ad_complain [_ acs-tcl.lt_name_contains_invalid]
        return 0
    }

    return 1
}

##

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
                  append html [subst {
                      <li><a href="[ns_quotehtml [export_vars -base ${package_url}view-comment {comment_id return_url}]]">$title</a>
                      by $author, $creation_date<br>
                  }]
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

        set html [subst {<a href="[ns_quotehtml [export_vars -base ${package_url}comment-add {object_id
             object_name return_url context_id category}]]">$link_text</a>
        }]
        return $html
    }

}

#
# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
