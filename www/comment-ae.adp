<master>
<property name="title">@page_title;noquote@</property>
<property name="context">@context;noquote@</property>
<property name="focus">comment.title</property>

<blockquote>
<form action="@target@" method="post" name="comment">
<%= [export_form_vars comment_id object_id object_name context_id return_url] %>
#general-comments.Title#<br>
<input type=text name=title maxlength=200 size=50 value="@title@">
<p>
#general-comments.Comment#<br>
<textarea name=content cols=80 rows=20 wrap=soft>@content@</textarea><br>
#general-comments.Text_above_is#
<select name=comment_mime_type>
<if @comment_mime_type@ eq text/html >
  <option value="text/plain">#general-comments.Plain_text#</option>
  <option selected value="text/html">#general-comments.HTML#</option>
</if>
<else>
  <option selected value="text/plain">#general-comments.Plain_text#</option>
  <option value="text/html">#general-comments.HTML#</option>
</else>

</select>
</blockquote>
<br>
<center>
<input type=submit name=submit value="#general-comments.Proceed#">
</center>
</form>




