<master>
<property name="doc(title)">@page_title;literal@</property>
<property name="context">@context;literal@</property>

#general-comments.lt_Here_is_how_your_comm#

<h4>@title@</h4>
@html_content;noquote@

<if @mime_type@ eq text/html>
  #general-comments.lt_Note_if_the_text_abov#
</if>
<else>
  #general-comments.lt_Note_if_the_text_abov_1#
</else>

<form action="@target@" method=post>
<%= [export_vars -form {comment_id object_id object_name context_id title content comment_mime_type category return_url}] %>
<input type="submit" name="submit" value="#general-comments.Confirm#">
<p>
<input type="checkbox" name="attach_p" id="attach_ck"><label for="attach_ck">#general-comments.lt_I_would_like_to_uploa#</label>
</form>


