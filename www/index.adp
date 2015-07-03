<master>
<property name="doc(title)">@page_title;literal@</property>
<property name="context">@context;literal@</property>

<if @admin_p@ eq 1>
  [ <a href="admin/">#general-comments.Administer#</a> ]
</if>
<p>
@dimensional_bar;noquote@
<p>

<listtemplate name="comments_list"></listtemplate>
