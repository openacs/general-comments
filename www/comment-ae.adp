<master src="master">
<property name="page_title">@page_title@</property>
<property name="context">@context@</property>
<property name="focus">comment.title</property>

@page_title@

<blockquote>
<form action="@target@" method="post" name="comment">
<%= [export_form_vars comment_id object_id object_name context_id return_url] %>
Title:<br>
<input type=text name=title maxlength=200 size=50 value="@title@">
<p>
Comment:<br>
<textarea name=content cols=80 rows=20 wrap=soft>@content@</textarea><br>
Text above is
<select name=comment_mime_type>
<if @comment_mime_type@ eq text/html >
  <option value="text/plain">Plain text</option>
  <option selected value="text/html">HTML</option>
</if>
<else>
  <option selected value="text/plain">Plain text</option>
  <option value="text/html">HTML</option>
</else>

</select>
</blockquote>
<br>
<center>
<input type=submit name=submit value="Proceed">
</center>
</form>



