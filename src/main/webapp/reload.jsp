<%@page import="uk.ac.ebi.chebi.ontology.query.DLQueryServer"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"
	import="uk.ac.ebi.chebi.ontology.query.DLReasoner"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
</head>

<% 
//DLQueryServer serv = (DLQueryServer) getServletContext().getAttribute("server");
//serv.reloadOntology();
//serv.reloadReasoner(); 
try{
 DLQueryServer serv = DLQueryServer.getServerInstance();
 getServletContext().setAttribute( "server", serv);
    if(serv.isLoaded()){
        out.println("Successfully loaded the ontology");
    }else{
        out.println("Loading ontology failed, please check log.");
    }
}catch (Exception e){
    e.printStackTrace();
    out.println(e.getCause());
}

%>

</body>
</html>