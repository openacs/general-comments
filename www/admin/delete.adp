<master src="master">
<property name="page_title">@page_title@</property>
<property name="context_bar">@context_bar@</property>

<form action=delete-2 method=post>
<%= [export_form_vars comment_id return_url] %>
Do you really wish to delete the following comment and its attachments?
<blockquote>
  <b>@title@</b> (<a href="../view-comment?comment_id=@comment_id@">details</a>)<br><br>
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
<input type=submit name=submit value="Proceed">
<input type=submit name=submit value="Cancel">
</center>
</form>

