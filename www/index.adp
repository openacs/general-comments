<master>
<property name="title">@page_title;noquote@</property>
<property name="context">@context;noquote@</property>

<if @admin_p@ eq 1>
  [ <a href="admin/">#general-comments.Administer#</a> ]
</if>
<p>
@dimensional_bar;noquote@
<p>
@comments_table;noquote@





