# /packages/general-comments/www/comment-add-3.tcl

ad_page_contract {
    Inserts a comment for object_id into the database

    @author Phong Nguyen <phong@arsdigita.com>
    @creation-date 2000-10-12
    @cvs-id $Id$
} {
    comment_id:integer,notnull
    object_id:integer,notnull
    title:notnull
    content:html,notnull
    { mime_type "text/plain" }
    { context_id "$object_id" }
    { category "" }
    { return_url "" }
}    

# authenticate the user
set user_id [ad_verify_and_get_user_id]

# check to see if the user can create comments on this object
ad_require_permission $object_id general_comments_create

# insert the comment into the database
set creation_ip [ad_conn peeraddr]
set is_live [ad_parameter AutoApproveCommentsP {general-comments} {t}]
db_transaction {
    db_exec_plsql insert_comment {
        begin
            :1 := acs_message.new (
                message_id    => :comment_id,
                title         => :title,
                mime_type     => :mime_type,
                data          => empty_blob(),
                context_id    => :context_id,
                creation_user => :user_id, 
                creation_ip   => :creation_ip,
                is_live       => :is_live
            );
        end;
    }

    db_dml add_entry {
        insert into general_comments
            (comment_id,
             object_id,
             category)
        values
            (:comment_id,
             :object_id,
             :category)
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

    # Grant the user sufficient permissions to 
    # created comment. This is done here to ensure that
    # a fail on permissions granting will not leave
    # the comment with incorrect permissions. 
    db_exec_plsql grant_permission {
        begin
            acs_permission.grant_permission (
                object_id  => :comment_id,
                grantee_id => :user_id,
                privilege  => 'read'
            );
            acs_permission.grant_permission (
                object_id  => :comment_id,
                grantee_id => :user_id,
                privilege  => 'write'
            );
        end;
    }
}

ad_returnredirect "view-comment?[export_url_vars comment_id return_url]"

    
