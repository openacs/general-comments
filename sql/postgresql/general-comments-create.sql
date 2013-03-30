--
-- packages/general-comments/sql/general-comments-create.sql
--
-- @author Phong Nguyen (phong@arsdigita.com)
-- @author Pascal Scheffers (pascal@scheffers.net)
-- @creation-date 2000-10-12
--
-- @cvs-id $Id$
--
-- General comments: Commenting facility for any object in ACS 4.0
-- 

-- create a table to extend cr_items
create table general_comments (
    comment_id  integer  constraint general_comments_comment_id_fk
                references acs_messages (message_id) on delete cascade 
                constraint general_comments_pk
                primary key,
    object_id   integer constraint general_comments_object_id_fk
	        references acs_objects (object_id) on delete cascade,
    category    varchar(1000)
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

CREATE OR REPLACE FUNCTION inline_0 () RETURNS integer AS $$
-- define and grant privileges
BEGIN

    -- create privileges
    PERFORM acs_privilege__create_privilege('general_comments_create', null, null);

    PERFORM acs_privilege__add_child('annotate', 'general_comments_create');

    return 0;
END;
$$ LANGUAGE plpgsql;

select inline_0 ();

drop function inline_0 ();

-- show errors

-- NOTE: this is only temporary until we figure out how
--       packages will register child types to an acs-message
CREATE OR REPLACE FUNCTION inline_1 () RETURNS integer AS $$
BEGIN

    PERFORM content_type__register_child_type (
        /* parent_type => */ 'acs_message_revision',
        /* child_type  => */ 'content_revision',
	'generic', 0, null
    );
    PERFORM content_type__register_child_type (
        /* parent_type => */ 'acs_message_revision',
        /* child_type  => */ 'image',
	'generic', 0, null
    );
    PERFORM content_type__register_child_type (
        /* parent_type => */ 'acs_message_revision',
        /* child_type  => */ 'content_extlink',
	'generic', 0, null
    );
    return 0;
END;
$$ LANGUAGE plpgsql;

select inline_1 ();

drop function inline_1 ();

-- show errors


