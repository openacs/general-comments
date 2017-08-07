<master>
<property name="doc(title)">@page_title;literal@</property>
<property name="context">@context;literal@</property>
<property name="parent_id">@parent_id;literal@</property>

<form enctype="multipart/form-data" method=POST action="@target@">
<div><%= [export_vars -form {attach_id parent_id return_url}] %></div>

<table>
  <tr>
    <td valign="top" align="right">#general-comments.Title#</td>
    <td><input size="40" name="title" value="@title@"></td>
  </tr>
  <tr>
    <td valign="top" align="right">#general-comments.Filename# </td>
    <td>
    <if @target@ eq file-add-2>
      <input type="file" name="upload_file" size="40"><br>
      #general-comments.lt_Use_the_Browse_button#
     </if>
     <else>
       <strong><code>@file_name@</code></strong>
     </else>
    </td>
  </tr>
</table>

<p style="text-align:center">
<input type="submit" value="#general-comments.Proceed#">
</p>
</form>

