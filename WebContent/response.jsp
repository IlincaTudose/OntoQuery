<%@page import="uk.ac.ebi.chebi.ontology.query.DLQueryServer"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"
	import="uk.ac.ebi.chebi.ontology.query.DLReasoner"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">



<%
String dlQuery = request.getParameter("hiddenQuery");		
DLQueryServer server = ((DLQueryServer) getServletContext().getAttribute( "server"));
%>

<html>
<head>
<!-- things for chebi header & footer -->
<link type="text/css" rel="stylesheet"
	href="//www.ebi.ac.uk/web_guidelines/css/mitigation/develop/ebi-mitigation.css" />
<link type="text/css" rel="stylesheet"
	href="//www.ebi.ac.uk/web_guidelines/css/mitigation/develop/embl-petrol-colours.css" />
<script defer="defer"
	src="//www.ebi.ac.uk/web_guidelines/js/cookiebanner.js"></script>
<script defer="defer" src="//www.ebi.ac.uk/web_guidelines/js/foot.js"></script>

	
<!--  things I need for Biojs ChEBI component -->
<script language="JavaScript" type="text/javascript" src="js/Biojs.js"></script>
<script language="JavaScript" type="text/javascript"
	src="js/myChebiCompound.js"></script>
<!-- Styling for ChEBI like results -->
<link href="css/chebi.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet"
	href="http://www.ebi.ac.uk/inc/css/userstyles.css" type="text/css" />
<!--  The custom query edit box -->
<link rel="stylesheet" type="text/css" href="css/editBox.css">
<link rel="stylesheet" href="css/jquery/base/jquery.ui.all.css">
<link rel="stylesheet" href="css/jquery/base/jquery.ui.autocomplete.css">
<!-- Generals  -->
<script src="http://code.jquery.com/jquery-1.8.3.min.js"></script>
<script src="js/editbox.js"></script>
<script src="js/jquery.idle-timer.js"></script>
<script src="js/globalVariables.js"></script>
<script src="js/jquery.ui.core.js"></script>
<script src="js/jquery.ui.widget.js"></script>
<script src="js/jquery.ui.position.js"></script>
<script src="js/jquery.ui.menu.js"></script>
<script src="js/jquery.ui.autocomplete.js"></script>

</head>

<body>
	<!-- Chebi header -->
	<div class="headerdiv" id="headerdiv">
		<div class="header">
			<div id="global-masthead" class="masthead grid_24">
				<!--This has to be one line and no newline characters-->
				<a href="//www.ebi.ac.uk/" title="Go to the EMBL-EBI homepage"><img
					src="//www.ebi.ac.uk/web_guidelines/images/logos/EMBL-EBI/EMBL_EBI_Logo_white.png"
					alt="EMBL European Bioinformatics Institute" /></a>

				<div class="nav">
					<ul id="global-nav">
						<!-- set active class as appropriate -->
						<li class="first active" id="services"><a
							href="//www.ebi.ac.uk/services">Services</a></li>
						<li id="research"><a href="//www.ebi.ac.uk/research">Research</a></li>
						<li id="training"><a href="//www.ebi.ac.uk/training">Training</a></li>
						<li id="industry"><a href="//www.ebi.ac.uk/industry">Industry</a></li>
						<li id="about" class="last"><a href="//www.ebi.ac.uk/about">About
								us</a></li>
					</ul>
				</div>
			</div>

			<div id="local-masthead" class="masthead grid_24">

				<!-- local-title -->
				<!-- NB: for additional title style patterns, see http://frontier.ebi.ac.uk/web/style/patterns -->

				<div class="grid_24 alpha omega" id="local-title">
					<h1>
						<a href="index.jsp" title="Back to ChEBI OntoQuery homepage">ChEBI
							OntoQuery</a>
					</h1>
				</div>

				<!-- /local-title -->

			</div>
		</div>
	</div>

	<!--  end of chebi header -->
	<div id="content">
	
	<br/>
		<table class="contentspane" id="contentspane"
			summary="The main content pane of the page" style="width: 100%">
			<tbody>
				<tr>
					<td class="leftmargin"><nobr>
							<a href="http://www.ebi.ac.uk/chebi/"> ChEBI Home </a>
						</nobr></td>
					<td></td>
				</tr>
				<tr>
					<td></td>
					<td>
						<div style="min-height: 400px;">
							<p></p>
							<%@include file="userInput.jsp"%>


							<!--  Show query string again. -->
							<BR />

							<!-- Results -->
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<%
		// parse query
			String whateverErrorIGet = ""; 
			try{
				((DLQueryServer) getServletContext().getAttribute( "server")).hasValidSyntax(dlQuery);
			}catch (Exception e){
				e.printStackTrace();
				whateverErrorIGet = e.getMessage();
			}
			((DLQueryServer) getServletContext().getAttribute( "server")).computeDLQueryResults(dlQuery); //run the query
		 	String[] results = ((DLQueryServer) getServletContext().getAttribute( "server")).getResults(); //execute
		%>
							</table>
							<table width="100%">
								<tbody>
									<tr>
										<td>Your query was <b><%=dlQuery%></b>.
										</td>
									</tr>
								</tbody>
							</table>


							<table id="upperTable" style="visibility: hidden" width="100%">
								<tbody>
									<tr>
										<td>
											<div id="resultsStatsDiv" style="float: left;"></div>
											<div id="pageNumberDiv" style="float: right;"></div>
										</td>
									</tr>
								</tbody>
							</table>

							<BR />

							<table width="100%" class="gridLayout">
								<tbody id="chebiResultTable">
								<tbody>
							</table>


							<div id="errorDiv">
								<script>
			var errors = "<%=whateverErrorIGet%>";
			if ( errors !== ""){
				document.write("<p class=\"errorStyle\"> Error: </p>");
				document.write(errors);
			}
			</script>
							</div>

							<script>
		var resultsNumber = <%=results.length%>;
		var res = "<%=java.util.Arrays.toString(results)%>";
		var resArray = res.replace("[", "").replace("]", "").split(", ");
		
		// show results the first time
		function shwoResults(){
			if (resultsNumber == 0){
				document.getElementById("upperTable").style.visibility = "visible";
				$(document.getElementById("resultsStatsDiv")).empty();
				document.getElementById("resultsStatsDiv").innerHTML = "Your query returned <b>0</b> results.";
			}
			else loadResults (1);
		}
		
		// load results page
		function loadResults (pageNumber){
			var from = (pageNumber > 0 ? (pageNumber - 1) * 15 + 1 : 0 );
			var to = (pageNumber * 15 < resultsNumber ? pageNumber * 15 : resultsNumber);
			showResultsNumber(from, to);
			var n = (resultsNumber - resultsNumber % 15) / 15;
			if (0 < resultsNumber%15)
				n++;
			showPages(pageNumber, n);
			fillResultTable(from, to);
			}
		
		// fill chebi style result table
		function fillResultTable(from, to){
			var table = document.getElementById("chebiResultTable");
			$(table).empty();
			// add all the cells needed
			var row; // local variable for current row in the table (each row has 3 columns)
			for (var i = 0; i < 15 && i <= (to - from); i++) { // show results
				if(i % 3 == 0 ){
					// open new row	
					row = jQuery("<tr></tr>").appendTo(table);
				}
				// add cell
				jQuery("<td id=\'testID" + i + "\' class=\"gridLayout\"></td>").appendTo(row);
				// fill the cell
				instance = new Biojs.ChEBICompound({
					   target: 'testID'+i,
					   id: resArray[from + i - 1], // first fr4om value is 1 but we need to go from position 0 in the array.
					   proxyUrl: './proxy.jsp'
					});
		    }
		}
		
		// total result no  & results shown
		function showResultsNumber(from , to ){
			$(document.getElementById("resultsStatsDiv")).empty();
			document.getElementById("resultsStatsDiv").innerHTML =  "Your query returned <b>" + resultsNumber + "</b> results. Showing results " + from + " to " + to + ".";
		}
		
		// generate page numbers upper right side
		function showPages(currentPage, n){
			var maxPagesToShow = 3;
			var x = currentPage;
			document.getElementById("upperTable").style.visibility="visible";
			var container = document.getElementById("pageNumberDiv");
			$(document.getElementById("pageNumberDiv")).empty();
			// <<
			jQuery("<a href=\"#\" onclick=\"loadResults(" + 1 + ")\">\<\<</a>").appendTo(container);
			jQuery("<b>&nbsp;&nbsp;</b>").appendTo(container);
			// <
			var prev = (x - 1 > 0 ? x - 1 : 1 );
			jQuery("<a href=\"#\" onclick=\"loadResults(" + prev + ")\">\<</a>").appendTo(container);
			jQuery("<b>&nbsp;&nbsp;</b>").appendTo(container);
			// ...
			if (currentPage - maxPagesToShow > 1){
				jQuery("<a href=\"#\" onclick=\"loadResults(" + prev + ")\">...</a>").appendTo(container);
				jQuery("<b>&nbsp;&nbsp;</b>").appendTo(container);
			}
			// i-3  i-2  i-1
			maxPagesToShow = 3;
			while (maxPagesToShow != 0 ){
				if ( currentPage - maxPagesToShow > 0){
					jQuery("<a href=\"#\" onclick=\"loadResults(" + (currentPage - maxPagesToShow) + ")\">" + (currentPage - maxPagesToShow) + "</a>").appendTo(container);
					jQuery("<b>&nbsp;&nbsp;</b>").appendTo(container);
				}
				maxPagesToShow--;
			}
			jQuery("<b>" + currentPage + "</b>").appendTo(container);
			jQuery("<b>&nbsp;&nbsp;</b>").appendTo(container);
			maxPagesToShow = 3;
			x = currentPage;
			while (maxPagesToShow-- > 0 && x++ < n ){
				jQuery("<a href=\"#\" onclick=\"loadResults(" + x + ")\">" + x + "</a>").appendTo(container);
				jQuery("<b>&nbsp;&nbsp;</b>").appendTo(container);
			}
			var next = (currentPage + 1 < n ? currentPage + 1 : n );	
			if (currentPage + maxPagesToShow < n)
				jQuery("<a href=\"#\" onclick=\"loadResults(" + next + ")\">...</a>").appendTo(container);
			jQuery("<b>&nbsp;&nbsp;</b>").appendTo(container);
			
			jQuery("<a href=\"#\" onclick=\"loadResults(" + next + ")\">\></a>").appendTo(container);
			jQuery("<b>&nbsp;&nbsp;</b>").appendTo(container);
			
			jQuery("<a href=\"#\" onclick=\"loadResults(" + n + ")\">\>\></a>").appendTo(container);
			jQuery("<b>&nbsp;&nbsp;</b>").appendTo(container);
		}
		
		shwoResults();
		</script>
						</div>
					</td>
				</tr>
			</tbody>
		</table>


		<!-- Chebi footer -->
		<table class="footerpane" id="footerpane"
			summary="The main footer pane of the page">
			<tr>
				<td colspan="4" class="footerrow">
					<div class="footerdiv" id="footerdiv">
						<div class="footer">
							<div id="global-footer" class="grid_24 clearfix">
								<div class="nav" id="global-nav-expanded">
									<div class="grid_4 alpha">
										<h3 class="embl-ebi">
											<a href="//www.ebi.ac.uk/"
												title="Go to the EMBL-EBI homepage">EMBL-EBI</a>
										</h3>
									</div>

									<div class="grid_4">
										<h3 class="services">
											<a href="//www.ebi.ac.uk/services">Services</a>
										</h3>
									</div>

									<div class="grid_4">
										<h3 class="research">
											<a href="//www.ebi.ac.uk/research">Research</a>
										</h3>
									</div>

									<div class="grid_4">
										<h3 class="training">
											<a href="//www.ebi.ac.uk/training">Training</a>
										</h3>
									</div>

									<div class="grid_4">
										<h3 class="industry">
											<a href="//www.ebi.ac.uk/industry">Industry</a>
										</h3>
									</div>

									<div class="grid_4 omega">
										<h3 class="about">
											<a href="//www.ebi.ac.uk/about">About us</a>
										</h3>
									</div>
								</div>

								<div class="section" id="ebi-footer-meta">
									<p class="address">EMBL-EBI, Wellcome Trust Genome Campus,
										Hinxton, Cambridgeshire, CB10 1SD, UK &nbsp; &nbsp; +44
										(0)1223 49 44 44</p>
									<p>
										Copyright &copy; EMBL-EBI 2012 | EBI is an Outstation of the <a
											href="http://www.embl.org">European Molecular Biology
											Laboratory</a> | <a href="/about/privacy">Privacy</a> | <a
											href="/about/cookies">Cookies</a> | <a
											href="/about/terms-of-use">Terms of use</a>
									</p>
								</div>
							</div>
						</div>
					</div>


				</td>
			</tr>
		</table>
		<!--  end of chebi footer -->

	</div>
	<!-- end of content -->
</body>

</html>