<master>
<property name="title">@page_title;noquote@</property>
<property name="context">@context;noquote@</property>


<p>
<table border=1 cellspacing=0 cellpadding=5>
<tr>
  <td colspan=2 align=center>#general-comments.lt_Current_values_for_Ge#</td></tr>
<tr>
  <td>package_id</td>
  <td>
    <if @package_id@ eq "">
      <i>#general-comments.lt_no_gc_package_instanc#</i>
    </if>
    <else>
      @package_id@
    </else></td></tr>
<tr>
  <td>package_url</td>
  <td>
    <if @package_url@ eq "">
      <i>#general-comments.gc_is_not_mounted#</i>
    </if>
    <else>
      <a href="@package_url@">@package_url@</a>
    </else></td></tr>
<tr>
  <td>AutoApproveCommentsP</td>
  <td>
    <if @auto_approve_comments_p@ eq "">
      <i>#general-comments.not_set#</i>
    </if>
    <else>
      <a href="/admin/site-map/parameter-set?package_id=@package_id@">
      @auto_approve_comments_p@</a>
    </else></td></tr>
<tr>
  <td>AllowFileAttachmentsP</td>
  <td>
    <if @allow_file_attachments_p@ eq "">
      <i>#general-comments.not_set#</i>
    </if>
    <else>
      <a href="/admin/site-map/parameter-set?package_id=@package_id@">
      @allow_file_attachments_p@</a>
    </else></td></tr>
<tr>
  <td>AllowLinkAttachmentsP</td>
  <td>
    <if @allow_link_attachments_p@ eq "">
      <i>#general-comments.not_set#</i>
    </if>
    <else>
      <a href="/admin/site-map/parameter-set?package_id=@package_id@">
      @allow_link_attachments_p@</a>
    </else></td></tr>
<tr>
  <td>MaxFileSize</td>
  <td>
    <if @max_file_size@ eq "">
      <i>#general-comments.not_set#</i>
    </if>
    <else>
      <a href="/admin/site-map/parameter-set?package_id=@package_id@">
      @max_file_size@</a>
    </else></td></tr>
</table>

<if @package_url@ ne "">
  <p>
  <h3>#general-comments.Comments#</h3>
  <ul>
    <if @comments@ eq "">
      <li>#general-comments.none#
    </if>
    <else>
      @comments@
   </else>
  </ul>
  <p>
  <h3>#general-comments.Full_Comments#</h3>
    <blockquote>
    <if @full_comments@ eq "">
      <li>#general-comments.none#
    </if>
    <else>
      @full_comments@
    </else>
    </blockquote>
  <p>
  @link@
</if>
<else>
  <p>
    #general-comments.if_general_comments_not_mounted#
  </p>
</else>

