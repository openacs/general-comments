<master>
<property name="doc(title)">@page_title;literal@</property>
<property name="context">@context;literal@</property>

#general-comments.lt_Do_you_really_wish_to_1#
<p>
<center>
<table>
<tr>
	<td>
		<form action=delete-attachment-2 method=post>
		<%= [export_vars -form {attach_id parent_id return_url}] %>
		<input type="submit" name="submit" value="#general-comments.Proceed#">
		</form>
	</td>

	<td>
		<form action="view-comment" method="get">
		<input type="hidden" name="comment_id" value="@parent_id@">
		<%= [export_vars -form {return_url}] %>
		<input type="submit" name="submit" value="#general-comments.Cancel#">
		</form>
	</td
</tr>
</table>
</center>


