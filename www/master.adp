<master>
<property name="title">@page_title@</property>
<if @focus@ not nil><property name="focus">@focus@</property></if>

<h2>@page_title@</h2>
<%= [eval ad_context_bar $context_bar] %>
<hr>
<slave>
