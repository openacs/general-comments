
<property name="context">{/doc/general-comments {General Comments}} {Design Document}</property>
<property name="doc(title)">Design Document</property>
<master>
<div class="NAVHEADER"><table width="100%" border="0" cellpadding="0" cellspacing="0">
<tr><th colspan="3" align="center">General Comments</th></tr><tr>
<td width="10%" align="left" valign="bottom"><a href="dev-guide">Prev</a></td><td width="80%" align="center" valign="bottom">Chapter 1.
Developer&#39;s guide</td><td width="10%" align="right" valign="bottom"><a href="users-guide">Next</a></td>
</tr>
</table></div>
<div class="sect1">
<h1 class="sect1"><a name="design" id="design">1.2. Design
Document</a></h1><div class="sect2">
<h2 class="sect2"><a name="design-essentials" id="design-essentials">1.2.1. Essentials</a></h2><ul>
<li><p>User directory: /general-comments/</p></li><li><p>ACS administrator directory: /general-comments/admin/</p></li><li>
<p>Tcl API:</p><ul><li><p><a href="/api-doc/procs-file-view?path=packages/general-comments/tcl/general-comments-procs.tcl" target="_top">general-comments-procs.tcl</a></p></li></ul>
</li><li>
<p>PL/SQL API:</p><ul><li><p>none</p></li></ul>
</li><li>
<p>Data model:</p><ul>
<li><p><a href="/doc/sql/display-sql?url=general-comments-create.sql&amp;package_key=general-comments" target="_top">general-comments-create.sql</a></p></li><li><p><a href="/doc/sql/display-sql?url=general-comments-drop.sql&amp;package_key=general-comments" target="_top">general-comments-drop.sql</a></p></li>
</ul>
</li><li><p><a href="dev-guide">Requirements
Document</a></p></li>
</ul>
</div><div class="sect2">
<h2 class="sect2"><a name="design-introduction" id="design-introduction">1.2.2. Introduction</a></h2><p>General Comments enables all users in the community to add a
comment to any object in the system. Any comment can have files or
hyperlinks attached.</p><p>This package is intended to utilize the users' engagement in
the community by letting them voice their opinion on any topic
(object) on the site. Commenting an article, a press release or any
other object is never more than a click away.</p><p>Administrators can choose to put comments on hold until
they&#39;ve been approved or moderated.</p><p>User feedback is an invaluable resource for improvements. For
example, the usage of General Comments on documentation not only
allows feedback, it can shape, extend and refine draft ideas before
they are taken to the next level.</p>
</div><div class="sect2">
<h2 class="sect2"><a name="design-historical-considerations" id="design-historical-considerations">1.2.3. Historical
Considerations</a></h2><p>General Comments in ACS 4.0 differs from previous versions by
utilizing the ACS Object system, introduced in 4.0. The data-model
has been changed to accomodate this adoption.</p><p>In ACS 3.x, general comments did not have revisioning. Let&#39;s
assume that in an ACS 3.x installation, the policy for comments was
set to "closed", meaning comments must be approved by an
administrator before it goes live. The following unwanted scenario
could occur:</p><ul>
<li><p>A user posted a comment which was approved by the
administrator.</p></li><li><p>The user notices that there was a spelling error, and makes a
change to the posted comment.</p></li><li><p>From the time of the user&#39;s correction to the time the
adminstrator re-approves the comment, other users will not be able
to read the comment, since the new data replaced the old one.</p></li>
</ul><p>General Comments implements the revisioning feature provided by
the Content Repository. Users are able to view all of their
revisions for a comment, along with an indication of which revision
is live. This allows the contents of an older revision to be seen
by the public while a newer revision is awaiting adminstrative
approval.</p>
</div><div class="sect2">
<h2 class="sect2"><a name="design-competitive-analysis" id="design-competitive-analysis">1.2.4. Competitive Analysis</a></h2><p><em class="emphasis">not available</em></p>
</div><div class="sect2">
<h2 class="sect2"><a name="design-design-tradeoffs" id="design-design-tradeoffs">1.2.5. Design Tradeoffs</a></h2><p><em class="emphasis">not available</em></p>
</div><div class="sect2">
<h2 class="sect2"><a name="design-api" id="design-api">1.2.6.
API</a></h2><p><span class="phrase">Tcl API</span></p><p>There is one core procedure, <a href="/api-doc/proc-view?proc=general_comments_get_comments" target="_top">general_comments_get_comments</a>, that will show comments
on an object and make appropriate links to files from the
<kbd class="computeroutput">general-comments</kbd> package for
recording and editing user comments. An optional <kbd class="computeroutput">return_url</kbd> can be specified which will be
provided as a link to the user within the <kbd class="computeroutput">general-comments</kbd> pages. This is useful for
the user to return to the original page after making a comment.</p><p>The other procedure, <a href="/api-doc/proc-view?proc=general_comments_create_link" target="_top">general_comments_create_link</a>, is a wrapper procedure
that returns an html fragment for a link which points to the
location of the mounted <kbd class="computeroutput">general_comments</kbd> package. There are various
switches that will be useful to package developers:</p><ul>
<li><p>
<span class="phrase">object_name:</span> A name for the object
being commented on is displayed throughout the <kbd class="computeroutput">general-comments</kbd> pages. Defaults to
[acs_object_name].</p></li><li><p>
<span class="phrase">link_text:</span> The text of the link
returned. Defaults to "Add a comment".</p></li><li><p>
<span class="phrase">context_id:</span> The context_id to set
for the comment. Defaults to the object_id of the object being
commented on.</p></li><li><p>
<span class="phrase">category:</span> This feature is not
complete. The purpose is to allow separation of comments on the
same object into categories.</p></li>
</ul><p>A problem that may occur is when any of the two tcl procedures
are called when the <kbd class="computeroutput">general-comments</kbd> package is not mounted. Both
<kbd class="computeroutput">general_comments_get_comments</kbd> and
<kbd class="computeroutput">general_comments_create_link</kbd> needs
to find out the location of the mounted <kbd class="computeroutput">general-comments</kbd> instance to generate correct
links. In this case, both procedures will return nothing and log a
notice.</p><p>
<span class="phrase">Note:</span> In the alpha release of
<kbd class="computeroutput">general-comments</kbd>, the tcl
procedures were defined within a namespace and encountered problems
with the api browser not being able to display them properly. These
procedures have now been moved out of the namespace and the old
ones are marked as deprecated. The final version will completely
remove all traces of the namespace procedures.</p><p><span class="phrase">PL/SQL API</span></p><p>None. Uses PL/SQL functions provided by ACS Messaging.</p>
</div><div class="sect2">
<h2 class="sect2"><a name="design-data-model-discussion" id="design-data-model-discussion">1.2.7. Data Model
Discussion</a></h2><p>The majority of the functionality of general comments has been
merged with acs-messaging. Comments are stored as acs-messages.</p><p>The <kbd class="computeroutput">general_comments</kbd> table
extends <kbd class="computeroutput">acs_messages</kbd> to provide
categorization of comments on a particular object. <kbd class="computeroutput">general_comments</kbd> also stores the object_id of
the object the comment refers to. Relationships from attachments to
acs-message is done by using the <kbd class="computeroutput">cr_items.parent_id</kbd> column.</p><div class="mediaobject"><p><img src="design.gif"></p></div><p>A <kbd class="computeroutput">general-comment</kbd> can be
associated with any object in the system by using the <kbd class="computeroutput">general_comments.object_id</kbd> column. Because
each comment is itself an object, we could implement comments on
comments. However, this functionality is not needed in the
<kbd class="computeroutput">general-comments</kbd> model and the UI
does not support comments on comments.</p><p>There are three types of attachments a user can create: file,
image, and url. The underlying data representation of an attachment
is a content item with different content_types. File attachments
are stored with a content_revision type. Image attachments are
stored with a image type. Url attachments are stored with a
content_extlink type.</p><p>One problem we face is how to allow designers to modify the
presentation of the comments on an object without modifying tcl
code. The proc <kbd class="computeroutput">general_comments_get_comments</kbd> has html code
which should really be placed into a template. Karl Goldstein code
reviewed general comments and has an interesting solution:</p><ul>
<li><p>Add an <kbd class="computeroutput">-uplevel</kbd> parameter to
<kbd class="computeroutput">db_multirow</kbd>.</p></li><li><p>In the <kbd class="computeroutput">general_comments_get_comments</kbd> proc, create an
upleveled datasource.</p></li><li><p>From the <kbd class="computeroutput">.tcl</kbd> page, make a call
to <kbd class="computeroutput">general_comments_get_comments</kbd>,
which would set up the multirow datasource in the current
environment.</p></li><li><p>From the <kbd class="computeroutput">.adp</kbd> page, loop through
the multirow datasource.</p></li>
</ul>
</div><div class="sect2">
<h2 class="sect2"><a name="design-user-interface" id="design-user-interface">1.2.8. User Interface</a></h2><p>General Comments provides two similar sets of UIs for
adminstrators and normal users. The adminstrator UI allows
approval/unapproval of comments as well as deletion of comments.
The normal user UI presents to users all of their created comments,
with links to editing and creating attachments.</p>
</div><div class="sect2">
<h2 class="sect2"><a name="design-configurationparameters" id="design-configurationparameters">1.2.9.
Configuration/Parameters</a></h2><ul>
<li><p>
<kbd class="computeroutput">AutoApproveCommentsP:</kbd> Sets
whether comments go live immediately.</p></li><li><p>
<kbd class="computeroutput">AllowFileAttachmentsP:</kbd> Sets
whether files can be attached to comments.</p></li><li><p>
<kbd class="computeroutput">AllowLinkAttachmentsP:</kbd> Sets
whether links can be attached to comments.</p></li><li><p>
<kbd class="computeroutput">MaxFileSize:</kbd> Maximum file size
that can be uploaded in bytes.</p></li>
</ul>
</div><div class="sect2">
<h2 class="sect2"><a name="design-future-improvements" id="design-future-improvements">1.2.10. Future Improvements/Areas of
Likely Change</a></h2><ul>
<li><p>Subsite administration</p></li><li><p>Cascading parameters to depending packages.</p></li><li><p>Revisioning of attachments</p></li>
</ul>
</div><div class="sect2">
<h2 class="sect2"><a name="design-authors" id="design-authors">1.2.11. Authors</a></h2><ul><li><p><a href="mailto:phong\@arsdigita.com" target="_top">Phong
Nguyen</a></p></li></ul>
</div><div class="sect2">
<h2 class="sect2"><a name="design-revision-history" id="design-revision-history">1.2.12. Revision History</a></h2><div class="informaltable">
<a name="AEN294" id="AEN294"></a><table border="1" class="CALSTABLE"><tbody>
<tr>
<td align="center" valign="middle"><em class="emphasis">Document
Revision #</em></td><td align="center" valign="middle"><em class="emphasis">Action
Taken, Notes</em></td><td align="center" valign="middle"><em class="emphasis">When?</em></td><td align="center" valign="middle"><em class="emphasis">By
Whom?</em></td>
</tr><tr>
<td align="left" valign="middle">0.2</td><td align="left" valign="middle">Revision</td><td align="left" valign="middle">12/11/2000</td><td align="left" valign="middle">Phong Nguyen</td>
</tr><tr>
<td align="left" valign="middle">0.1</td><td align="left" valign="middle">Creation</td><td align="left" valign="middle">10/26/2000</td><td align="left" valign="middle">Phong Nguyen</td>
</tr>
</tbody></table>
</div><p>Last modified: $&zwnj;Id: design.html,v 1.2 2014/10/27 16:41:44
victorg Exp $</p>
</div>
</div>
<div class="NAVFOOTER">
<hr align="left" width="100%"><table width="100%" border="0" cellpadding="0" cellspacing="0">
<tr>
<td width="33%" align="left" valign="top"><a href="dev-guide">Prev</a></td><td width="34%" align="center" valign="top"><a href="index">Home</a></td><td width="33%" align="right" valign="top"><a href="users-guide">Next</a></td>
</tr><tr>
<td width="33%" align="left" valign="top">Developer&#39;s
guide</td><td width="34%" align="center" valign="top"><a href="dev-guide">Up</a></td><td width="33%" align="right" valign="top">User&#39;s guide</td>
</tr>
</table>
</div>
