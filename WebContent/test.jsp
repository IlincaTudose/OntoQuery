<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<!--  things I need for Biojs ChEBI component -->

<script language="JavaScript" type="text/javascript" src="js/Biojs.js"></script>
<script language="JavaScript" type="text/javascript"
	src="js/myChebiCompound.js"></script>
<script language="JavaScript" type="text/javascript"
	src="js/jquery-1.6.4.js"></script>

<link href="css/chebi.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" href="http://www.ebi.ac.uk/inc/css/contents.css"
	type="text/css" />
<link rel="stylesheet"
	href="http://www.ebi.ac.uk/inc/css/userstyles.css" type="text/css" />
<link rel="stylesheet" href="http://www.ebi.ac.uk/inc/css/sidebars.css"
	type="text/css" />


<!-- End of things I need for Biojs ChEBI component -->


</head>

<body>

	<table id="upperTable" style="visibility: hidden">
		<tbody>
			<tr>
				<td>
					<div id="resultsStatsDiv" style="float: left;"></div>
					<div id="pageNumberDiv" style="float: right;"></div>
				</td>
			</tr>
		</tbody>
	</table>


	<script>
var resultsNumber = 700;
// build the result table from js 


// load results page
function loadResults (pageNumber){
	showResultsNumber(pageNumber);
	var n = (resultsNumber - resultsNumber % 15) / 15;
	if (0 < resultsNumber%15)
		n++;
	showPages(pageNumber, n);
	fillResultTable(pageNumber);
	}
	
function fillResultTable(page){
	
}

function showResultsNumber(page){
	var from = (page > 0 ? (page - 1) * 15 + 1 : 0 );
	var to = (page * 15 < resultsNumber ? page * 15 : resultsNumber);
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
	jQuery("<a href=\"#\" onclick=\"loadResults(" + prev + ")\">...</a>").appendTo(container);
	jQuery("<b>&nbsp;&nbsp;</b>").appendTo(container);
	// i-3 i-2 i-1
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
// fill result table


loadResults(1);
</script>
</body>
</html>