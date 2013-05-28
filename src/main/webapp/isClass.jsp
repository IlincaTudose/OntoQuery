<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@page import="uk.ac.ebi.chebi.ontology.query.DLQueryServer"%>
<%@page import="org.apache.log4j.Logger"%>
<head>
<%
    Logger logger = Logger.getLogger( "isClass.jsp" );
    boolean isClassRes = false;
	System.out.println("LAST TOKEN: " + request.getParameter("text"));
	isClassRes = ((DLQueryServer) getServletContext().getAttribute( "server")).isClass(request.getParameter("text"));
    logger.info(isClassRes);

	%>
<script>
###<%=isClassRes%>###
</script>
</head>
