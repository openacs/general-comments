--
-- packages/general-comments/sql/general-comments-drop.sql
--
-- @author Phong Nguyen phong@arsdigita.com
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
begin
    acs_privilege.remove_child('create','general_comments_create');
    acs_privilege.drop_privilege('general_comments_create');
end;
/

-- remove all comments from the system
declare
    cursor comment_cur is
        select comment_id
          from general_comments;
begin
    for comment_rec in comment_cur loop
        -- There is a bug in content_item.delete that results in
        -- referential integrity violations when deleting a content
        -- item that has an image attachment. This is a temporary fix
        -- until ACS 4.1 is released.
        delete from images
        where image_id in (select latest_revision
                             from cr_items
                            where parent_id = comment_rec.comment_id);

        acs_message.del(comment_rec.comment_id);
    end loop;
end;
/

drop table general_comments;
