<master>
<property name="doc(title)">@page_title;literal@</property>
<property name="context">@context;literal@</property>


#general-comments.lt_Do_you_really_wish_to#

  <strong>@title@</strong> (<a href="../view-comment?comment_id=@comment_id@">#general-comments.details#</a>)<br><br>
  <if @mime_type@ eq text/plain>
    <%= [ad_text_to_html $content] %>
  </if>
  <else>
    @content@
  </else>
  <br><br>-- <a href="/shared/community-member?user_id=@creation_user@">@author@</a> 
  (@pretty_date@)  

<table>
<tr>
	<td>
		<form action=delete-2 method=post>
		<%= [export_vars -form {comment_id return_url}] %>
		<input type="submit" name="submit" value="#general-comments.Proceed#">
		</form>
	</td>

	<td>
		<form action="@return_url@">
		<input type="submit" name="submit" value="#general-comments.Cancel#">
		</form>
	</td
</tr>
</table>

</form>


