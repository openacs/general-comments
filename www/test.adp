<master>
<property name="title">@page_title@</property>

<h2>@page_title@</h2>
<%= [eval ad_context_bar $context_bar] %>
<hr>

<p>
<table border=1 cellspacing=0 cellpadding=5>
<tr>
  <td colspan=2 align=center>Current values for General Comments package</td></tr>
<tr>
  <td>package_id</td>
  <td>
    <if @package_id@ eq "">
      <i>no gc package instance</i>
    </if>
    <else>
      @package_id@
    </else></td></tr>
<tr>
  <td>package_url</td>
  <td>
    <if @package_url@ eq "">
      <i>gc is not mounted</i>
    </if>
    <else>
      <a href="@package_url@">@package_url@</a>
    </else></td></tr>
<tr>
  <td>AutoApproveCommentsP</td>
  <td>
    <if @auto_approve_comments_p@ eq "">
      <i>not set</i>
    </if>
    <else>
      <a href="/admin/site-map/parameter-set?package_id=@package_id@">
      @auto_approve_comments_p@</a>
    </else></td></tr>
<tr>
  <td>AllowFileAttachmentsP</td>
  <td>
    <if @allow_file_attachments_p@ eq "">
      <i>not set</i>
    </if>
    <else>
      <a href="/admin/site-map/parameter-set?package_id=@package_id@">
      @allow_file_attachments_p@</a>
    </else></td></tr>
<tr>
  <td>AllowLinkAttachmentsP</td>
  <td>
    <if @allow_link_attachments_p@ eq "">
      <i>not set</i>
    </if>
    <else>
      <a href="/admin/site-map/parameter-set?package_id=@package_id@">
      @allow_link_attachments_p@</a>
    </else></td></tr>
<tr>
  <td>MaxFileSize</td>
  <td>
    <if @max_file_size@ eq "">
      <i>not set</i>
    </if>
    <else>
      <a href="/admin/site-map/parameter-set?package_id=@package_id@">
      @max_file_size@</a>
    </else></td></tr>
</table>

<if @package_url@ ne "">
  <p>
  <h3>Comments</h3>
  <ul>
    <if @comments@ eq "">
      <li>none
    </if>
    <else>
      @comments@
   </else>
  </ul>
  <p>
  <h3>Full Comments</h3>
    <blockquote>
    <if @full_comments@ eq "">
      <li>none
    </if>
    <else>
      @full_comments@
    </else>
    </blockquote>
  <p>
  @link@
</if>
<else>
  <p>If <code>general-comments</code> is not mounted and 
  calls are made to <code>general_comments_get_comments</code> 
  or <code>general_comments_create_link</code>, then an error 
  will be logged. This is because these calls output hyperlinks 
  that would need to reference a mounted <code>general-comments</code> 
  package instance.</font>
</else>
