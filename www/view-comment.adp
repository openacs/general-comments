<master>
<property name="title">@page_title@</property>
<property name="context">@context@</property>
<property name="return_url">@return_url@</property>
<property name="object_name">@object_name@</property>

<if @return_url@ ne "">
[<a href="@return_url@">Go back to where you were</a>]<br>
</if>

<blockquote>
<h4>@title@</h4>

@html_content@

<br><br>
<if @is_creator_p@ eq t>
  -- you 
    <a href="comment-edit?comment_id=@comment_id@&revision_id=@revision_id@&return_url=@return_url@">
  (edit your comment)</a><br><br>
</if>
<else>
  -- <a href="/shared/community-member?user_id=@creation_user@">@author@</a>
</else>

</blockquote>



<h4>Attachments</h4>
<ul>
  <% set counter 0 %>
  <multiple name=attachments>
    <% incr counter %>  
    <li>
    <if @is_creator_p@ eq t>
      ( <a href="file-edit?attach_id=@attachments.item_id@&parent_id=@comment_id@&return_url=@return_url@">edit</a> | 
<a href="delete-attachment?attach_id=@attachments.item_id@&parent_id=@comment_id@&return_url=@return_url@">delete</a> )
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
        ( <a href="url-edit?attach_id=@links.item_id@&parent_id=@comment_id@&return_url=@return_url@">edit</a> | 
<a href="delete-attachment?attach_id=@links.item_id@&parent_id=@comment_id@&return_url=@return_url@">delete</a> )
    </if>      
    <a href="@links.url@">@links.label@</a>
  </multiple>
  <if @counter@ eq 0>
    <li>no attachments
  </if>
</ul>

<if @is_creator_p@ eq t and @allow_attach_p@ eq t>
  <h4>Actions</h4>
  <ul>
    <if @allow_file_p@ eq t>
      <li><a href="file-add?parent_id=@comment_id@&return_url=@return_url@">Attach a file or picture</a><br>
    </if>
    <if @allow_link_p@ eq t>
      <li><a href="url-add?parent_id=@comment_id@&return_url=@return_url@">Attach a web link</a><br>  
    </if>
  </ul>
</if>

<if @write_perm_p@ eq 1>
  <h4>Revisions</h4>
  <ul>
    <multiple name=revisions>
      <if @revision_id@ eq @revisions.revision_id@>
          <li>@revisions.revision_date@
      </if>
      <else>
        <li><a href="view-comment?comment_id=@comment_id@&revision_id=@revisions.revision_id@&return_url=@return_url@">@revisions.revision_date@</a>
      </else>
      <if @revisions.revision_id@ eq @live_revision@>
        (live)
      </if>
    </multiple>
  </ul>
</if>

<if @live_revision@ ne @revision_id@>
  <font size=-1 color=red>
  This revision is not live.
  <if @admin_p@ eq 1>
    (<a href="admin/toggle-approval?comment_id=@comment_id@&revision_id=@revision_id@&return_url=../@return_url_view@">approve this revision</a>)
  </if>
  </font>
</if>
<else>
  <font size=-1 color=green>
  This revision is live.
  <if @admin_p@ eq 1>
    (<a href="admin/toggle-approval?comment_id=@comment_id@&revision_id=@revision_id@&return_url=../@return_url_view@">reject this revision</a>)
  </if>
  </font>
</else>  
