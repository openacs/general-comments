# /packages/general-comments/www/comment-edit-3.tcl

ad_page_contract {
    Creates a new revision of a comment.

    @author Phong Nguyen (phong@arsdigita.com)
    @author Pascal Scheffers (pascal@scheffers.net)
    @creation-date 2000-10-12
    @cvs-id $Id$
} {
    comment_id:naturalnum,notnull
    title:notnull,printable,string_length(max|200)
    content:html,notnull,general_comments_safe
    comment_mime_type:oneof(text/plain|text/html),notnull
    { return_url:localurl {} }
}

# check to see if the user can edit this comment
permission::require_permission -object_id $comment_id -privilege write

# authenticate the user
set user_id [ad_conn user_id]

# insert the revision into the database
set is_live [parameter::get -parameter AutoApproveCommentsP -default {t}]
set creation_ip [ad_conn peeraddr]
db_transaction {
  db_exec_plsql insert_comment {
    begin
        :1 := acs_message.edit (
            message_id    => :comment_id,
            title         => :title,
            mime_type     => :comment_mime_type,
            data          => empty_blob(),
            creation_user => :user_id,
            creation_ip   => :creation_ip,
            is_live       => :is_live
        );
    end;
  }

  db_1row get_revision { 
    select content_item.get_latest_revision(:comment_id) as revision_id
    from dual
  }

  db_dml set_content {
    update cr_revisions
    set content = empty_blob()
    where revision_id = :revision_id
    returning content into :1
  } -blobs [list $content]

}

ad_returnredirect [export_vars -base view-comment {comment_id return_url}]
    

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
