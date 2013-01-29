<%@page import="uk.ac.ebi.chebi.ontology.query.DLQueryServer"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"
	import="uk.ac.ebi.chebi.ontology.query.DLReasoner"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">


<head>
<!--  things I need for Biojs ChEBI component -->

<script language="JavaScript" type="text/javascript" src="js/Biojs.js"></script>
<script language="JavaScript" type="text/javascript" src="js/myChebiCompound.js"></script>

<link href="css/chebi.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" href="http://www.ebi.ac.uk/inc/css/contents.css"
	type="text/css" />
<link rel="stylesheet"
	href="http://www.ebi.ac.uk/inc/css/userstyles.css" type="text/css" />
<link rel="stylesheet" href="http://www.ebi.ac.uk/inc/css/sidebars.css"
	type="text/css" />
</head>

<table width="100%">
	<% 	
	String[] results = ((DLQueryServer) getServletContext().getAttribute( "server")).getResults(); //execute
	int p = Integer.parseInt(request.getParameter("page"));	
	%>
	
	<tbody>
		<tr>
			<td>
				<div style="float: left;">
					The query returned <b><%=results.length%></b> results. Showing
					results
					<%=(p>0) ? (p-1)*15+1 : 0 %>
					to
					<%=(p*15 < results.length) ? p*15 :  results.length%>.
				</div>
				<div style="float: right;">
					<script>
				function showPages(){
					var n = <%=(results.length-results.length%15)/15%>;
					if (0 < <%=results.length%15%>)
						n++;
					var currentPage = <%=p%>;
					var maxPagesToShow = 3;
					var x = currentPage;
					document.write("<a href=\"#\">\<\<</a>&nbsp;&nbsp;");
					document.write("<a href=\"#\">\<</a>&nbsp;&nbsp;");
					if (currentPage-maxPagesToShow > 0)
						document.write("<a href=\"#\">...</a>&nbsp;&nbsp;");
					while (maxPagesToShow-- > 0 && x-- > 1){
						document.write("<a href=\"#\">"+x+"</a>&nbsp;&nbsp;");;
					}
					document.write(currentPage+"&nbsp;&nbsp;");
					maxPagesToShow = 3;
					x = currentPage;
					while (maxPagesToShow-- > 0 && x++ < n){
						document.write("<a href=\"#\">"+x+"</a>&nbsp;&nbsp;");;
					}
					if (currentPage+maxPagesToShow < n)
						document.write("<a href=\"#\">...</a>&nbsp;&nbsp;");
					document.write("<a href=\"#\">\></a>&nbsp;&nbsp;");
					document.write("<a href=\"#\">\>\></a>&nbsp;&nbsp;");
					
				}
				showPages();
				</script>
				</div>
			</td>
		</tr>
	</tbody>
</table>
<BR />
<table width="100%" class="gridLayout">
	<tbody>
		<%
	//instantiates a table of the right size and with the needed div IDs
	String resString = java.util.Arrays.toString(results);
 	for (int i = 0; i < results.length && i < 15; i++) { // show results
		if(i%3 == 0 && i > 0)
			out.println("</tr><tr>\n");
    	out.println("<td id=\'testID" + i + "\' class=\"gridLayout\"></td>");
    }
 	out.println("</tr>");
%>
	
	<tbody>
</table>

<script>
function showResults(){
	var res = "<%=resString%>";
	var resArray = res.replace("[", "").replace("]", "").split(", ");
	var j = 0;
	while ((j < resArray.length && j < 15)) { // show results
		instance = new Biojs.ChEBICompound({
			   target: 'testID'+j,
			   id: resArray[j],
			   proxyUrl: './proxy.jsp'
			});
		j++;
    }
}
showResults();

</script>
