<master>
<property name="doc(title)">@page_title;literal@</property>
<property name="context">@context;literal@</property>


<p>
<table border="1" cellspacing="0" cellpadding="5">
<tr>
  <td colspan="2" align="center">#general-comments.lt_Current_values_for_Ge#</td></tr>
<tr>
  <td>package_id</td>
  <td>
    <if @package_id@ eq "">
      <em>#general-comments.lt_no_gc_package_instanc#</em>
    </if>
    <else>
      @package_id@
    </else></td></tr>
<tr>
  <td>package_url</td>
  <td>
    <if @package_url@ eq "">
      <em>#general-comments.gc_is_not_mounted#</em>
    </if>
    <else>
      <a href="@package_url@">@package_url@</a>
    </else></td></tr>
<tr>
  <td>AutoApproveCommentsP</td>
  <td>
    <if @auto_approve_comments_p@ eq "">
      <em>#general-comments.not_set#</em>
    </if>
    <else>
      <a href="@params_url@">
      @auto_approve_comments_p@</a>
    </else></td></tr>
<tr>
  <td>AllowFileAttachmentsP</td>
  <td>
    <if @allow_file_attachments_p@ eq "">
      <em>#general-comments.not_set#</em>
    </if>
    <else>
      <a href="@params_url@">
      @allow_file_attachments_p@</a>
    </else></td></tr>
<tr>
  <td>AllowLinkAttachmentsP</td>
  <td>
    <if @allow_link_attachments_p@ eq "">
      <em>#general-comments.not_set#</em>
    </if>
    <else>
      <a href="@params_url@">
      @allow_link_attachments_p@</a>
    </else></td></tr>
<tr>
  <td>MaxFileSize</td>
  <td>
    <if @max_file_size@ eq "">
      <em>#general-comments.not_set#</em>
    </if>
    <else>
      <a href="@params_url@">
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

    <if @full_comments@ eq "">
      <li>#general-comments.none#
    </if>
    <else>
      @full_comments@
    </else>

  <p>
  @link@
</if>
<else>
  <p>
    #general-comments.if_general_comments_not_mounted#
  </p>
</else>

