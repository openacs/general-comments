<master>
<property name="title">@page_title;noquote@</property>
<property name="context">@context;noquote@</property>
<property name="return_url">@return_url;noquote@</property>
<property name="object_name">@object_name;noquote@</property>

<if @return_url@ ne "">
[<a href="@return_url@">#general-comments.lt_Go_back_to_where_you_#</a>]<br>
</if>

<blockquote>
<h4>@title@</h4>

@html_content;noquote@

<br><br>
<if @is_creator_p@ eq t>
  -- #general-comments.you#
    <a href="comment-edit?comment_id=@comment_id@&revision_id=@revision_id@&return_url=@return_url@">
  #general-comments.edit_your_comment#</a><br><br>
</if>
<else>
  -- <a href="/shared/community-member?user_id=@creation_user@">@author@</a>
</else>

</blockquote>



<h4>#general-comments.Attachments#</h4>
<ul>
  <% set counter 0 %>
  <multiple name=attachments>
    <% incr counter %>  
    <li>
    <if @is_creator_p@ eq t>
      ( <a href="file-edit?attach_id=@attachments.item_id@&parent_id=@comment_id@&return_url=@return_url@">#general-comments.edit#</a> | 
<a href="delete-attachment?attach_id=@attachments.item_id@&parent_id=@comment_id@&return_url=@return_url@">#general-comments.delete#</a> )
    </if>
    <if @attachments.mime_type@ eq image/gif or @attachments.mime_type@ eq image/jpeg>
      @attachments.title@ 
      (<a href="view-image?image_id=@attachments.item_id@&return_url=@return_url_view@">@attachments.name@</a>)
    </if>
    <else>
      @attachments.title@ 
      (<a href="file-download?item_id=@attachments.item_id@">@attachments.name@</a>)
    </else>
  </multiple>
  <multiple name=links>
    <% incr counter %>
    <li>
    <if @is_creator_p@ eq t>
        ( <a href="url-edit?attach_id=@links.item_id@&parent_id=@comment_id@&return_url=@return_url@">#general-comments.edit#</a> | 
<a href="delete-attachment?attach_id=@links.item_id@&parent_id=@comment_id@&return_url=@return_url@">#general-comments.delete#</a> )
    </if>      
    <a href="@links.url@">@links.label@</a>
  </multiple>
  <if @counter@ eq 0>
    <li>#general-comments.no_attachments#
  </if>
</ul>

<if @is_creator_p@ eq t and @allow_attach_p@ eq t>
  <h4>#general-comments.Actions#</h4>
  <ul>
    <if @allow_file_p@ eq t>
      <li><a href="file-add?parent_id=@comment_id@&return_url=@return_url@">#general-comments.lt_Attach_a_file_or_pict#</a><br>
    </if>
    <if @allow_link_p@ eq t>
      <li><a href="url-add?parent_id=@comment_id@&return_url=@return_url@">#general-comments.Attach_a_web_link#</a><br>  
    </if>
  </ul>
</if>

<if @write_perm_p@ eq 1>
  <h4>#general-comments.Revisions#</h4>
  <ul>
    <multiple name=revisions>
      <if @revision_id@ eq @revisions.revision_id@>
          <li>@revisions.revision_date@
      </if>
      <else>
        <li><a href="view-comment?comment_id=@comment_id@&revision_id=@revisions.revision_id@&return_url=@return_url@">@revisions.revision_date@</a>
      </else>
      <if @revisions.revision_id@ eq @live_revision@>
        #general-comments.live#
      </if>
    </multiple>
  </ul>
</if>

<if @live_revision@ ne @revision_id@>
  <font size=-1 color=red>
  #general-comments.lt_This_revision_is_not_#
  <if @admin_p@ eq 1>
    (<a href="admin/toggle-approval?comment_id=@comment_id@&revision_id=@revision_id@&return_url=../@return_url_view@">#general-comments.lt_approve_this_revision#</a>)
  </if>
  </font>
</if>
<else>
  <font size=-1 color=green>
  #general-comments.lt_This_revision_is_live#
  <if @admin_p@ eq 1>
    (<a href="admin/toggle-approval?comment_id=@comment_id@&revision_id=@revision_id@&return_url=../@return_url_view@">#general-comments.reject_this_revision#</a>)
  </if>
  </font>
</else>  

