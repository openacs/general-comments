<master src="master">
<property name="page_title">@page_title@</property>
<property name="context_bar">@context_bar@</property>

Here is how your comment would appear:

<if @mime_type@ eq text/html>
  <blockquote>
  <h4>@title@</h4>
  @content@
  </blockquote>

  Note: if the text above has lost all of its paragraph breaks then you
  probably should have selected "Plain Text" rather than HTML.  Use
  your browser's Back button to return to the submission form.
</if>
<else>
  <blockquote>
  <h4>@title@</h4>
  <%= [util_convert_plaintext_to_html $content] %>
  </blockquote>

  Note: if the text above has a bunch of visible HTML tags then you probably
  should have selected "HTML" rather than "Plain Text".  Use your
  browser's Back button to return to the submission form.
</else>

<center>
<form action="@target@" method=post>
<%= [export_form_vars comment_id object_id object_name context_id title content mime_type category return_url] %>
<input type=submit name=submit value="Confirm">
</form>
</center>

