<master src="master">
<property name="page_title">@page_title@</property>
<property name="context">@context@</property>

Do you really wish to delete this attachment?
<p>
<center>
<form action=delete-attachment-2 method=post>
<%= [export_form_vars attach_id parent_id return_url] %>
<input type=submit name=submit value="Proceed">
<input type=submit name=submit value="Cancel">
</form>
</center>

