<master src="master">
<property name="page_title">@page_title@</property>
<property name="context_bar">@context_bar@</property>
<property name="parent_id">@parent_id@</property>

<form method=POST action= "@target@">
<%= [export_form_vars attach_id parent_id return_url] %>
<blockquote>
<table>
  <tr>
    <td valign=top align=right>Label: </td>
    <td><input type=text name=label size=40 value="@label@"></td>
  </tr>
  <tr>
    <td valign=top align=right>URL: </td>
    <td>
      <input size=40 name=url value="@url@"><br>
      <font size=-1>Example: http://www.arsdigita.com/</font>
    </td>
  </tr>
</table>
<p>
<center>
<input type=submit value="Proceed">
</center>
</blockquote>
</form>
