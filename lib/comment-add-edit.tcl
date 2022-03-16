ad_include_contract {
    UI to create or edit a comment
} {
    comment_id:naturalnum,optional
    object_id:naturalnum,optional
    context_id:naturalnum,optional
    { category "" }
    { object_name "" }
    { revision_id:naturalnum {} }
    { return_url:localurl {} }
} -properties {
    page_title:onevalue
    context:onevalue
    target:onevalue
    title:onevalue
    content:onevalue
    comment_mime_type:onevalue
    object_id:onevalue
    object_name:onevalue
    context_id:onevalue
    category:onevalue
    comment_id:onevalue
    revision_id:onevalue
    return_url:onevalue
} -validate {
    comment_or_object {
        if {![info exists object_id] &&
            ![info exists comment_id]} {
            ad_complain [_ acs-tcl.lt_You_must_supply_a_val [list formal_name object_id]]
            ad_complain [_ acs-tcl.lt_You_must_supply_a_val [list formal_name comment_id]]
            return
        }
    }
}

set new_p [expr {![info exists comment_id]}]

if {!$new_p} {
    db_1row get_comment_info {
        select g.object_id,
               r.title,
               r.content,
               r.mime_type as comment_mime_type
          from general_comments g,
               cr_revisions r
         where g.comment_id = :comment_id and
               r.revision_id = coalesce(:revision_id,
                                        (select revision_id
                                           from cr_revisions lr,
                                                acs_objects o
                                          where lr.revision_id = o.object_id
                                          order by o.creation_date desc
                                          fetch first 1 rows only))
    }
}

if {![info exists context_id]} {
    set context_id $object_id
}

if { $object_name eq "" } {
    set object_name [acs_object_name $object_id]
}

if {$new_p} {
    # check to see if the user can create comments on this object
    permission::require_permission \
        -object_id $object_id \
        -privilege general_comments_create

    set page_title "[_ general-comments.Add_a_comment_to]: $object_name"
    set context "\"[_ general-comments.Add_comment]\""
    set target "comment-add-2"

} else {
    # check to see if the user can edit this comment
    permission::require_permission \
        -object_id $comment_id \
        -privilege write

    set page_title "[_ general-comments.Edit_comment_on]: $object_name"
    set context "\"[_ general-comments.Edit_comment]\""
    set target "comment-edit-2"
}

ad_form -name addedit -action $target \
    -edit_buttons [list \
                       [list [_ general-comments.Proceed] "ok"] \
                      ] \
    -export {
        comment_id
        object_id
        object_name
        context_id
        return_url
    } \
    -form {

        {title:text
            {label "#general-comments.Title#"}
            {html {size 50 maxlength 200}}
        }
        {content:text(textarea)
            {label "#general-comments.Comment#"}
            {html {rows 20 cols 80}}
        }
        {comment_mime_type:text(select),optional
            {label ""}
            {options {
                {"[_ general-comments.Plain_text]" "text/plain"}
                {"[_ general-comments.HTML]" "text/html"}}
            }
            {value "text/plain"}
        }

    } -on_request {
        if {!$new_p} {
            db_1row get_comment_info {
                select g.object_id,
                       r.title,
                       r.content,
                       r.mime_type as comment_mime_type
                  from general_comments g,
                       cr_revisions r
                 where g.comment_id = :comment_id and
                       r.revision_id = coalesce(:revision_id,
                                                (select revision_id
                                                   from cr_revisions lr,
                                                        acs_objects o
                                                  where lr.revision_id = o.object_id
                                                  order by o.creation_date desc
                                                  fetch first 1 rows only))
            }
        }
    } -on_submit {}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
