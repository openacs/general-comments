--
-- packages/general-comments/sql/general-comments-drop.sql
--
-- @author Phong Nguyen phong@arsdigita.com
-- @author Pascal Scheffers (pascal@scheffers.net)
-- @creation-date 2000-10-12
--
-- @cvs-id $Id$
--

-- revoke all 'general_comments_create' permissions
delete from 
    acs_permissions
where 
    privilege = 'general_comments_create';

-- remove create privilege from the system
-- begin
    select acs_privilege__remove_child('create','general_comments_create');
    select acs_privilege__drop_privilege('general_comments_create');
-- end;
-- /

-- remove all comments from the system
create function inline_0 ()
returns integer as '
declare 
    comment_rec RECORD; 
begin

    FOR comment_rec IN select comment_id from general_comments LOOP

        -- There is a bug in content_item.delete that results in
        -- referential integrity violations when deleting a content
        -- item that has an image attachment. This is a temporary fix
        -- until ACS 4.1 is released.

     /* 
        delete from images
        where image_id in (select latest_revision
                            from cr_items
                            where parent_id = comment_rec.comment_id); 
      */

        perform acs_message__delete(comment_rec.comment_id);

    END LOOP;

    return 0;
end;' language 'plpgsql';

select inline_0 ();

drop function inline_0 ();

-- /

drop table general_comments;

