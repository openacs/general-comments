<master>
<property name="title">@page_title;noquote@</property>
<property name="context">@context;noquote@</property>
<property name="parent_id">@parent_id;noquote@</property>

<form method=POST action= "@target@">
<%= [export_form_vars attach_id parent_id return_url] %>
<blockquote>
<table>
  <tr>
    <td valign=top align=right>#general-comments.Label# </td>
    <td><input type=text name=label size=40 value="@label@"></td>
  </tr>
  <tr>
    <td valign=top align=right>#general-comments.URL# </td>
    <td>
      <input size=40 name=url value="@url@"><br>
      <font size=-1>#general-comments.lt_Example_httpwwwarsdig#</font>
    </td>
  </tr>
</table>
<p>
<center>
<input type=submit value="#general-comments.Proceed#">
</center>
</blockquote>
</form>

