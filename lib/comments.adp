<%
   # usages of the comments already wrap this HTML in a ul tag
%>
<multiple name="comments">
  <if @print_content_p;literal@ true>
    <h4>@comments.title@</h4>
    @comments.content@
    <if @print_attachments_p@ true and @comments.attachment_url;literal@ ne "">
      <h5>#general-comments.Attachments#</h5>
      <ul>
        <group column="comment_id">
          <li><a href="@comments.attachment_url@">
            @comments.attachment_name@
          </a></li>
        </group>
      </ul>
    </if>
    <p>--
       <a href="@comments.author_url@">@comments.author@</a>
       #general-comments.on# @comments.pretty_date2@
       (<a href="@comments.view_url@">#general-comments.view_details#</a>)
    </p>
  </if>
  <else>
    <li>
      <a href="@comments.view_url@">@comments.title@</a>
      <if @print_user_info_p;literal@ true>
        #general-comments.by# <a href="@comments.author_url@">@comments.author@</a>
        #general-comments.on# @comments.pretty_date@
      </if>
    </li>
  </else>
</multiple>
