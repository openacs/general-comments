--
-- packages/general-comments/sql/general-comments-create.sql
--
-- @author Phong Nguyen (phong@arsdigita.com)
-- @creation-date 2000-10-12
--
-- @cvs-id $Id$
--
-- General comments: Commenting facility for any object in ACS 4.0
-- 

-- create a table to extend cr_items
create table general_comments (
    comment_id  constraint general_comments_comment_id_fk
                references acs_messages (message_id) on delete cascade 
                constraint general_comments_pk
                primary key,
    object_id   constraint general_comments_object_id_fk
	        references acs_objects (object_id) on delete cascade,
    category    varchar2(1000)
);
comment on table general_comments is '
    Extends the acs_messages table to hold item level data.
'; 
comment on column general_comments.object_id is '
    The id of the object to associate message with
';
comment on column general_comments.category is '
    This feature is not complete. The purpose is to allow separation of 
    comments into categories.  
';

-- create an index on foreign key constraint
create index general_comments_object_id_idx on general_comments (object_id);

-- define and grant privileges
declare
    registered_users acs_objects.object_id%TYPE;
    default_context  acs_objects.object_id%TYPE;
begin

    -- retreive object ids for magic objects
    registered_users := acs.magic_object_id('registered_users');
    default_context  := acs.magic_object_id('default_context');

    -- create privileges
    acs_privilege.create_privilege('general_comments_create');

    -- associte privileges to global privileges
    acs_privilege.add_child('create','general_comments_create');
    
    -- allow registered users to create comments
    acs_permission.grant_permission (
       object_id  => default_context,
       grantee_id => registered_users,
       privilege  => 'general_comments_create'
    );

end;
/
show errors

-- NOTE: this is only temporary until we figure out how
--       packages will register child types to an acs-message
begin

    content_type.register_child_type (
        parent_type => 'acs_message_revision',
        child_type  => 'content_revision'
    );
    content_type.register_child_type (
        parent_type => 'acs_message_revision',
        child_type  => 'image'
    );
    content_type.register_child_type (
        parent_type => 'acs_message_revision',
        child_type  => 'content_extlink'
    );

end;
/
show errors


