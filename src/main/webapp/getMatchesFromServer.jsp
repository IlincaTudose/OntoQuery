<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@page import="uk.ac.ebi.chebi.ontology.query.DLQueryServer"%>
<head>
<%
	String classNames = ((DLQueryServer) getServletContext().getAttribute( "server")).getMatchingClassNames(request.getParameter("text"));
	%>
<script>
___<%=classNames%>___
</script>
</head>