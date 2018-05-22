<master>
<property name="doc(title)">@page_title;literal@</property>
<property name="context">@context;literal@</property>
<property name="return_url">@return_url;literal@</property>
<property name="object_name">@object_name;literal@</property>

<if @return_url@ ne "">
<p>[<a href="@return_url@">#general-comments.lt_Go_back_to_where_you_#</a>]</p>
</if>

<h1>@title@</h1>

@html_content;noquote@

<if @is_creator_p;literal@ true>
  <p>
  -- #general-comments.you#
    <a href="@comment_edit_url@">
  #general-comments.edit_your_comment#</a>
  </p>
</if>
<else>
  <p>-- <a href="/shared/community-member?user_id=@creation_user@">@author@</a></p>
</else>

<h2>#general-comments.Attachments#</h2>
<ul>
  <% set counter 0 %>
  <multiple name=attachments>
    <% incr counter %>
    <li>
    <if @is_creator_p;literal@ true>
      ( <a href="@attachments.file_edit_url@">#general-comments.edit#</a> | <a href="@attachments.delete_attachment_url@">#general-comments.delete#</a> )
    </if>
    <if @attachments.mime_type@ eq image/gif or @attachments.mime_type@ eq image/jpeg>
      @attachments.title@
      (<a href="@attachments.view_image_url@">@attachments.name@</a>)
    </if>
    <else>
      @attachments.title@
      (<a href="file-download?item_id=@attachments.item_id@">@attachments.name@</a>)
    </else>
  </multiple>
  <multiple name=links>
    <% incr counter %>
    <li>
    <if @is_creator_p;literal@ true>
        ( <a href="links.url_edit_url@">#general-comments.edit#</a> | <a href="@links.delete_attachment_url@">#general-comments.delete#</a> )
    </if>
    <a href="@links.url@">@links.label@</a>
  </multiple>
  <if @counter@ eq 0>
    <li>#general-comments.no_attachments#
  </if>
</ul>

<if @is_creator_p;literal@ true and @allow_attach_p;literal@ true>
  <h2>#general-comments.Actions#</h2>
  <ul>
    <if @allow_file_p;literal@ true>
      <li><a href="@action_file_add_url@">#general-comments.lt_Attach_a_file_or_pict#</a><br>
    </if>
    <if @allow_link_p;literal@ true>
      <li><a href="@action_url_add_url@">#general-comments.Attach_a_web_link#</a><br>
    </if>
  </ul>
</if>

<if @write_perm_p;literal@ true>
  <h2>#general-comments.Revisions#</h2>
  <ul>
    <multiple name=revisions>
      <if @revision_id@ eq @revisions.revision_id@>
          <li>@revisions.revision_date@
      </if>
      <else>
        <li><a href="@revisions.view_comment_url@">@revisions.revision_date@</a>
      </else>
      <if @revisions.revision_id@ eq @live_revision@>
        #general-comments.live#
      </if>
    </multiple>
  </ul>
</if>

  <p><span style="color:@font_color@">@pre_text@</span>
  <if @admin_p;literal@ true>
    (<a href="@admin_toggle_url@">@admin_toggle_text@</a>)
  </if>
  </p>
