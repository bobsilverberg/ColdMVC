<cfoutput>
<each in="#posts#" value="post">
	<cfinclude template="_post.cfm" />
</each>

<cfif arrayIsEmpty(posts)>
	There are no posts
</cfif>

<br />

</cfoutput>