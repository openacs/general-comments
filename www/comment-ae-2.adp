<master>
<property name="title">@page_title@</property>
<property name="context">@context@</property>

Here is how your comment would appear:

<blockquote>
<h4>@title@</h4>
@html_content@
</blockquote>

<if @mime_type@ eq text/html>
  Note: if the text above has lost all of its paragraph breaks then you
  probably should have selected "Plain Text" rather than HTML.  Use
  your browser's Back button to return to the submission form.
</if>
<else>
  Note: if the text above has a bunch of visible HTML tags then you probably
  should have selected "HTML" rather than "Plain Text".  Use your
  browser's Back button to return to the submission form.
</else>

<center>
<form action="@target@" method=post>
<%= [export_form_vars comment_id object_id object_name context_id title content comment_mime_type category return_url] %>
<input type=submit name=submit value="Confirm">
<p>
<input type="checkbox" name="attach_p" id="attach_ck"><label for="attach_ck">I would like to upload a file or add a link to my comment</label>
</form>
</center>

