<master>
<property name="title">@page_title;noquote@</property>
<property name="context">@context;noquote@</property>

#general-comments.lt_Do_you_really_wish_to_1#
<p>
<center>
<table>
<tr>
	<td>
		<form action=delete-attachment-2 method=post>
		<%= [export_form_vars attach_id parent_id return_url] %>
		<input type=submit name=submit value="#general-comments.Proceed#">
		</form>
	</td>

	<td>
		<form action="view-comment" method="get">
		<input type=hidden name="comment_id" value="@parent_id@">
		<%= [export_form_vars return_url] %>
		<input type=submit name=submit value="#general-comments.Cancel#">
		</form>
	</td
</tr>
</table>
</center>


