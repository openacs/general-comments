# /packages/general-comments/www/comment-edit-3.tcl

ad_page_contract {
    Creates a new revision of a comment.

    @author Phong Nguyen (phong@arsdigita.com)
    @author Pascal Scheffers (pascal@scheffers.net)
    @creation-date 2000-10-12
    @cvs-id $Id$
} {
    comment_id:integer,notnull
    title
    content:html
    comment_mime_type
    { return_url {} }
}

# check to see if the user can edit this comment
ad_require_permission $comment_id write

# authenticate the user
set user_id [ad_verify_and_get_user_id]

# insert the revision into the database
set is_live [ad_parameter AutoApproveCommentsP {general-comments} {t}]
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

ad_returnredirect "view-comment?[export_url_vars comment_id return_url]"
    
