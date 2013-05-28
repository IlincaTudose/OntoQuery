<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@page import="uk.ac.ebi.chebi.ontology.query.DLQueryServer"%>
<%@page import="org.apache.log4j.Logger"%>
<head>
<%
    Logger logger = Logger.getLogger( "histToSession.jsp" );
//	session.setAttribute("queryHistory", "###");
	if (session.getAttribute("queryHistory") == null){
		// set the attribute, it's being called for the first time.
		session.setAttribute("queryHistory", "###");
	}
	String hist = (String)session.getAttribute("queryHistory");
	String add = request.getParameter("add");
	if (add.equalsIgnoreCase("true")){
		hist = hist.replace("###" + request.getParameter("query") + "###", "###");
		hist = "###" + request.getParameter("query") + hist;
		if (hist.split("###").length > 10){
			//splice
			hist = hist.substring(0, hist.lastIndexOf("###"));
		}
		// set the new list
		session.setAttribute("queryHistory", hist);
	}
    logger.info("history: "+ hist);
	%>
<script>
___<%=hist%>___
</script>
</head>