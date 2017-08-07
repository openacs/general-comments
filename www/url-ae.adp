<master>
<property name="doc(title)">@page_title;literal@</property>
<property name="context">@context;literal@</property>
<property name="parent_id">@parent_id;literal@</property>

<form method=POST action= "@target@">
<div><%= [export_vars -form {attach_id parent_id return_url}] %></div>

<table>
  <tr>
    <td valign="top" align="right">#general-comments.Label# </td>
    <td><input type="text" name="label" size="40" value="@label@"></td>
  </tr>
  <tr>
    <td valign="top" align="right">#general-comments.URL# </td>
    <td>
      <input size="40" name="url" value="@url@"><br>
      #general-comments.lt_Example_httpwwwarsdig#
    </td>
  </tr>
</table>
<p style="text-align:center">
<input type="submit" value="#general-comments.Proceed#">
</p>
</form>

