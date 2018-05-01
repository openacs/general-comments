
<property name="context">{/doc/general-comments {General Comments}} {Developer&#39;s guide}</property>
<property name="doc(title)">Developer&#39;s guide</property>
<master>
<div class="NAVHEADER"><table width="100%" border="0" cellpadding="0" cellspacing="0">
<tr><th colspan="3" align="center">General Comments</th></tr><tr>
<td width="10%" align="left" valign="bottom"><a href="index">Prev</a></td><td width="80%" align="center" valign="bottom"></td><td width="10%" align="right" valign="bottom"><a href="design">Next</a></td>
</tr>
</table></div>
<div class="chapter">
<h1><a name="dev-guide" id="dev-guide">Chapter 1. Developer&#39;s
guide</a></h1><div class="sect1">
<h1 class="sect1"><a name="requirements" id="requirements">1.1.
Requirements Document</a></h1><div class="sect2">
<h2 class="sect2"><a name="requirements-introduction" id="requirements-introduction">1.1.1. Introduction</a></h2><p>This is the requirements document for the General Comments
package for ACS 4.0. General Comments is an application that takes
advantage of the ACS Messaging service package.</p>
</div><div class="sect2">
<h2 class="sect2"><a name="requirements-vision-statement" id="requirements-vision-statement">1.1.2. Vision Statement</a></h2><p>User feedback and engagement is the very heart of a
collaborative community. General Comments allows users to comment
on any object in the community, such as articles, white papers,
press releases or pictures.</p><p>Comments are not limited to text, but can include attachments
such as links, pictures or other documents.</p><p>Users can edit their own comments and an administrator can
choose to moderate all or particular comments before they go live
on the site.</p>
</div><div class="sect2">
<h2 class="sect2"><a name="requirements-application-overview" id="requirements-application-overview">1.1.3. Application
Overview</a></h2><p>General Comments is an application package that relies on the
ACS Messaging package. Comments can be associated with any object
in ACS 4.0, which gives you the benefits of the Permission System.
Comments are stored as ACS Messages.</p><p>When a user creates a comment, General Comments stores the
comment as an ACS Message and associates the comment to the object
commented on. The value set by the administrator on whether
comments go live immediately or needs approval first is stored
along with the comment during this phase. After this, the user is
presented with a page that displays contents of the comment along
with revision history, attachments, and links to perform actions on
the comment such as adding attachments or editing the comment.</p>
</div><div class="sect2">
<h2 class="sect2"><a name="requirements-use-cases-and-user-scenarios" id="requirements-use-cases-and-user-scenarios">1.1.4. Use-cases and
User-scenarios</a></h2><p>This package supports empowering all users with the option of
adding comments to objects in the system, and editing their own
comments later on.</p><p><span class="phrase">A user adding a comment:</span></p><p>Nurse Nancy is browsing through an ACS 4.0 site that has a page
for medical emergencies. Upon reaching the bottom of the page,
Nancy sees a posting that reads, "<em class="emphasis">Please
help, my child has just swallowed some cleaning
solution!!!</em>". Nancy sees that this posting was made only
30 seconds ago and quickly posts a remedy for this situation. After
she makes her posting, she immediately revisits the page and
happily sees that her posting is already available.</p><p><span class="phrase">A user editing an old comment:</span></p><p>George Genius is reviewing all of the comments he has posted
over the last 24 hours. In one of his postings, George notices that
his mathematical formula for earthquake prediction was incorrect.
He then clicks on the edit link, makes changes to his formula and
submits his changes. Since comments are moderated, others will only
see his older incorrect version until his changes are approved.
George eagerly awaits for his changes to be approved so that he
won&#39;t be ridiculed by his colleagues for his mistakes.</p><p><span class="phrase">An administrator moderating:</span></p><p>Adam Admin is looking over all recently unnapproved changes to
comments. Adam sees that George Genius has made a correction to the
earthquake prediction formula in which he helped write. He believes
that the their original formaula is correct, so Adam does not
approve of the changes. Several days later, George barges into
Adam&#39;s office wondering why his changes were not approved.
After a few hours George convinces Adam that the new modifications
were correct, and so Adam approves George&#39;s comment.</p>
</div><div class="sect2">
<h2 class="sect2"><a name="requirements-related-links" id="requirements-related-links">1.1.5. Related Links</a></h2><ul>
<li><p><a href="design">Design Document</a></p></li><li><p><a href="/doc/acs-messaging/" target="_top">ACS
Messaging</a></p></li>
</ul>
</div><div class="sect2">
<h2 class="sect2"><a name="requirements-requirements-data-model" id="requirements-requirements-data-model">1.1.6. Requirements: Data
Model</a></h2><p>
<span class="phrase">10.0</span> Comments can be attached to any
object in the system.</p><p>
<span class="phrase">10.10</span> Maintain revisioning of
comments.</p><p>
<span class="phrase">10.20</span> Store comment as an
acs-message.</p><p>
<span class="phrase">10.30</span> Allow separation of comments
on an object.</p><p>
<span class="phrase">10.40</span> Allow file and url attachments
to comments.</p><p>
<span class="phrase">10.50</span> Allow limitations on size of
file attachments.</p><p>
<span class="phrase">10.60</span> Use permissioning system to
control creation of comments.</p>
</div><div class="sect2">
<h2 class="sect2"><a name="requirements-requirements-api" id="requirements-requirements-api">1.1.7. Requirements: API</a></h2><p>
<span class="phrase">20.0</span> A summary type function that
retrieves all comments for a particular object.</p><p>
<span class="phrase">20.10</span> A link function that generates
an appropriate link to add a comment.</p>
</div><div class="sect2">
<h2 class="sect2"><a name="requirements-requirements-interface" id="requirements-requirements-interface">1.1.8. Requirements:
Interface</a></h2><p><span class="phrase">The Community Member&#39;s
Interface</span></p><p>The user interface for community members is a set of HTML pages
that allow creation and editing of comments.</p><p>
<span class="phrase">30.0</span> Customized presentation.</p><p>
<span class="phrase">30.0.10</span> Show all comments that the
user created.</p><p>
<span class="phrase">30.0.20</span> Have sliders to show
approved/uapproved comments.</p><p>
<span class="phrase">30.0.30</span> Have sliders to show
comments by age.</p><p>
<span class="phrase">30.10</span> Comments can be viewed in
detail.</p><p>
<span class="phrase">30.20</span> Provide ways for a user to add
attachments to a comment.</p><p>
<span class="phrase">30.30</span> Allow editing of comments.</p><p>
<span class="phrase">30.40</span> Provide a way to display
attached images.</p><p>
<span class="phrase">30.50</span> Allow download of attached
files.</p><p><span class="phrase">The Administrator&#39;s
Interface</span></p><p>The user interface for administrative members is a set of HTML
pages that allows deletion and approval of comments.</p><p>
<span class="phrase">40.0</span> Customized presentation.</p><p>
<span class="phrase">40.0.10</span> Show all created
comments.</p><p>
<span class="phrase">40.0.20</span> Have sliders to show
approved/unapproved comments.</p><p>
<span class="phrase">40.0.30</span> Have sliders to show
comments by age.</p><p>
<span class="phrase">40.10</span> Allow deletion of
comments.</p>
</div><div class="sect2">
<h2 class="sect2"><a name="requirements-revision-history" id="requirements-revision-history">1.1.9. Revision History</a></h2><div class="informaltable">
<a name="AEN108" id="AEN108"></a><table border="1" class="CALSTABLE"><tbody>
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
</div><p>Last modified: $&zwnj;Id: dev-guide.html,v 1.2 2017/08/07 23:48:12
gustafn Exp $</p>
</div>
</div>
</div>
<div class="NAVFOOTER">
<hr align="left" width="100%"><table width="100%" border="0" cellpadding="0" cellspacing="0">
<tr>
<td width="33%" align="left" valign="top"><a href="index">Prev</a></td><td width="34%" align="center" valign="top"><a href="index">Home</a></td><td width="33%" align="right" valign="top"><a href="design">Next</a></td>
</tr><tr>
<td width="33%" align="left" valign="top">General Comments</td><td width="34%" align="center" valign="top"> </td><td width="33%" align="right" valign="top">Design Document</td>
</tr>
</table>
</div>
