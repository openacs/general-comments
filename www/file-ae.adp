<master>
<property name="title">@page_title@</property>
<property name="context">@context@</property>
<property name="parent_id">@parent_id@</property>

<form enctype=multipart/form-data method=POST action="@target@">
<%= [export_form_vars attach_id parent_id return_url] %>
<blockquote>
<table>
  <tr>
    <td valign=top align=right>Title:</td>
    <td><input size=40 name=title value="@title@"></td>
  </tr>
  <tr>
    <td valign=top align=right>Filename: </td>
    <td>
    <if @target@ eq file-add-2>
      <input type=file name=upload_file size=40><br>
      <font size=-1>Use the "Browse..." button to locate your file, then click "Open".</font>
     </if>
     <else>
       <b><code>@file_name@</code></b>
     </else>
    </td>
  </tr>
</table>
</blockquote>

<p>
<center>
<input type=submit value="Proceed">
</center>
</form>
