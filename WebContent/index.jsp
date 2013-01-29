<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"
	import="uk.ac.ebi.chebi.ontology.query.DLQueryServer"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">


<html>
<head>

<link type="text/css" rel="stylesheet"
	href="//www.ebi.ac.uk/web_guidelines/css/mitigation/develop/ebi-mitigation.css" />
<link type="text/css" rel="stylesheet"
	href="//www.ebi.ac.uk/web_guidelines/css/mitigation/develop/embl-petrol-colours.css" />
<script defer="defer"
	src="//www.ebi.ac.uk/web_guidelines/js/cookiebanner.js"></script>
<script defer="defer" src="//www.ebi.ac.uk/web_guidelines/js/foot.js"></script>

<link rel="stylesheet" type="text/css" href="css/editBox.css">
<link rel="stylesheet" href="css/jquery/base/jquery.ui.all.css">
<link rel="stylesheet" href="css/jquery/base/jquery.ui.autocomplete.css">

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

	<!--  chebi header -->
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
					<td class="leftmenucell"><nobr>
							<a href="http://www.ebi.ac.uk/chebi/"> ChEBI Home </a>
						</nobr>
					</td>
					<td></td>
				</tr>
				<tr>
					<td></td>
					<td class="contentsarea">
						<div id="firstPageEditBox" style="height: 500px;">
							<center>
								<div id="editBoxDiv">
									<%@include file="userInput.jsp"%>
								</div>
							</center>
						</div>
					</td>
				</tr>
			</tbody>
		</table>

		<!-- chebi footer -->
		<div class="footerdiv" id="footerdiv">
			<div class="footer">
				<!-- Optional local footer (insert citation / project-specific copyright / etc here -->
				<!--
    <div id="local-footer" class="grid_24 clearfix">
    </div>
    -->
				<!-- End optional local footer -->

				<div id="global-footer" class="grid_24 clearfix">
					<div class="nav" id="global-nav-expanded">
						<div class="grid_4 alpha">
							<h3 class="embl-ebi">
								<a href="//www.ebi.ac.uk/" title="Go to the EMBL-EBI homepage">EMBL-EBI</a>
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
							Hinxton, Cambridgeshire, CB10 1SD, UK &nbsp; &nbsp; +44 (0)1223
							49 44 44</p>
						<p>
							Copyright &copy; EMBL-EBI 2013 | EBI is an Outstation of the <a
								href="http://www.embl.org">European Molecular Biology
								Laboratory </a> | <a href="/about/privacy">Privacy</a> | <a
								href="/about/cookies">Cookies</a> | <a
								href="/about/terms-of-use">Terms of use</a>
						</p>
					</div>

				</div>
			</div>
		</div>
		<!--  end of chebi footer -->


	</div>
	<!--  end of content div -->


</body>

</html>
