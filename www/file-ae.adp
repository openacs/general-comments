<master>
<property name="title">@page_title;noquote@</property>
<property name="context">@context;noquote@</property>
<property name="parent_id">@parent_id;noquote@</property>

<form enctype=multipart/form-data method=POST action="@target@">
<%= [export_form_vars attach_id parent_id return_url] %>
<blockquote>
<table>
  <tr>
    <td valign=top align=right>#general-comments.Title#</td>
    <td><input size=40 name=title value="@title@"></td>
  </tr>
  <tr>
    <td valign=top align=right>#general-comments.Filename# </td>
    <td>
    <if @target@ eq file-add-2>
      <input type=file name=upload_file size=40><br>
      <font size=-1>#general-comments.lt_Use_the_Browse_button#</font>
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
<input type=submit value="#general-comments.Proceed#">
</center>
</form>

