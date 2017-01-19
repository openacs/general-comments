<master>
<property name="doc(title)">@page_title;literal@</property>
<property name="context">@context;literal@</property>

<if @admin_p;literal@ true>
  <div style="float: right;">[ <a href="admin/">#general-comments.Administer#</a> ]</div>
</if>
<h1>#general-comments.Comments_of#</h1>
<p>
@dimensional_bar;noquote@
<p>

<listtemplate name="comments_list"></listtemplate>
