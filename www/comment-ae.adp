<master>
<property name="doc(title)">@page_title;literal@</property>
<property name="context">@context;literal@</property>
<property name="focus">comment.title</property>

<form action="@target@" method="post" name="comment" class="margin-form">
<div>
  <%= [export_vars -form {comment_id object_id object_name context_id return_url}] %>
</div>
<div class="form-item-wrapper">
  <label for="title" class="form-label">
    #general-comments.Title#
  </label>
  <div class="form-widget">
    <input id="title" type="text" name="title" maxlength="200" size="50" value="@title@">
  </div>
</div>
<div class="form-item-wrapper">
  <label for="content" class="form-label">
    #general-comments.Comment#
  </label>
  <div class="form-widget">
    <textarea id="content" name="content" cols="80" rows="20">@content@</textarea>
  </div>
</div>
<div class="form-item-wrapper">
  <label for="comment_mime_type" class="form-label">
    #general-comments.Text_above_is#
  </label>
  <div class="form-widget">
  <select id="comment_mime_type" name="comment_mime_type">
    <if @comment_mime_type@ eq text/html >
      <option value="text/plain">#general-comments.Plain_text#</option>
      <option selected value="text/html">#general-comments.HTML#</option>
    </if>
    <else>
      <option selected value="text/plain">#general-comments.Plain_text#</option>
      <option value="text/html">#general-comments.HTML#</option>
    </else>
  </select>
  </div>
</div>

<div class="form-button">
  <input type="submit" name="submit" value="#general-comments.Proceed#">
</div>
</form>




