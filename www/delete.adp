<master>
<property name="title">@page_title;noquote@</property>
<property name="context">@context;noquote@</property>


#general-comments.lt_Do_you_really_wish_to#
<blockquote>
  <b>@title@</b> (<a href="../view-comment?comment_id=@comment_id@">#general-comments.details#</a>)<br><br>
  <if @mime_type@ eq text/plain>
    <%= [util_convert_plaintext_to_html $content] %>
  </if>
  <else>
    @content@
  </else>
  <br><br>-- <a href="/shared/community-member?user_id=@creation_user@">@author@</a> 
  (@pretty_date@)  
</blockquote>
<center>
<table>
<tr>
	<td>
		<form action=delete-2 method=post>
		<%= [export_form_vars comment_id return_url] %>
		<input type=submit name=submit value="#general-comments.Proceed#">
		</form>
	</td>

	<td>
		<form action="@return_url@">
		<input type=submit name=submit value="#general-comments.Cancel#">
		</form>
	</td
</tr>
</table>
</center>
</form>


