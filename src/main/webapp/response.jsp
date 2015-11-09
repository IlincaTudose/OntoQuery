<%@page import="uk.ac.ebi.chebi.ontology.query.DLQueryServer" %>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1"
         import="uk.ac.ebi.chebi.ontology.query.DLReasoner" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">


<%
    String dlQuery = request.getParameter("hiddenQuery");
    DLQueryServer server = ((DLQueryServer) getServletContext().getAttribute("server"));
%>

<!-- chebi header -->
<%@ include file="header.html" %>

<!-- things I need for Biojs ChEBI component -->
<script language="JavaScript" type="text/javascript" src="js/Biojs.js"></script>
<script language="JavaScript" type="text/javascript" src="js/myChebiCompound.js"></script>

<!-- Styling for ChEBI like results -->
<%--<link href="css/chebi.css" rel="stylesheet" type="text/css"/>--%>
<%--<link rel="stylesheet" href="http://www.ebi.ac.uk/inc/css/userstyles.css" type="text/css"/>--%>

<style>

    .gridLayoutCellTitle {
        /*font-size:medium;*/
        vertical-align: top;
        padding-left: 10px;
        padding-top: 5px;
    }

    .gridLayoutCellItems {
        height:200px;
        min-width: 110px;
        vertical-align: top;
    }

    .gridLayoutCellWrap {
        border: 1px solid #adadaf;
        border-collapse: separate;
        border-spacing: 0;
        border-radius: 10px;
        -moz-border-radius: 10px;
        -webkit-border-radius: 10px;
    }

    .gridLayoutPagination {
        background-color: rgba(141, 193, 232, 0.24);
        font-size:medium;
        padding: 5px;
        border-radius: 5px;
        -webkit-border-radius: 5px;
        padding-bottom: 25px;
        margin-left:15px;
        margin-right:10px;
    }
</style>



<div id="content" role="main" class="grid_24 clearfix">

    <div id="breadcrumbs">
        <p><a href="/chebi/init.do">ChEBI</a> > tools > <a href="/chebi/tools/ontoquery">OntoQuery</a> </p>
    </div>
    <h2 class="entry-title" style="text-align: center"><a href="/chebi/tools/ontoquery" title="Back to OntoQuery homepage">OntoQuery</a></h2>

    <!-- Results -->
    <div>
        <%
            // parse query
            String whateverErrorIGet = "";
            DLQueryServer  serverInstance = ((DLQueryServer) getServletContext().getAttribute("server"));
            try {
                serverInstance.hasValidSyntax(dlQuery);
            } catch (Exception e) {
                e.printStackTrace();
                whateverErrorIGet = e.getMessage();
            }
            serverInstance.computeDLQueryResults(dlQuery);//run the query
            String[] results = serverInstance.getResults(); //execute
            session.setAttribute("exportContent", serverInstance.getExportContent());
        %>
    </div>
    <div style="margin-bottom: 20px;">
        <span style="padding-left: 15px;margin-right: 5px;">Your query was <b><%=dlQuery%></b>.</span>
        <div class="small-boxed-section icon icon-functional" data-icon="=" style="float: right;margin-right:10px; " id="downloadsTab"><a href="getTsv">Download your results</a></div>
    </div>
    <div id="upperTable" class="gridLayoutPagination" style="visibility: hidden" width="100%">
        <div id="resultsStatsDiv" style="float: left;"></div>
        <div id="pageNumberDiv" style="float: right;"></div>
    </div>

    <table id="chebiResultTable">
        <table>
            <div id="errorDiv">
                <script type="text/javascript">
                    var errors = "<%=whateverErrorIGet%>";
                    if (errors !== "") {
                        document.write("<p class=\"errorStyle\"> Error: </p>");
                        document.write(errors);
                    }
                </script>
            </div>

            <script type="text/javascript">

                var resultsNumber = <%=results.length%>;
                var res = "<%=java.util.Arrays.toString(results)%>";
                var resArray = res.replace("[", "").replace("]", "").split(", ");
                var resultsPerPage =  (resArray[0].indexOf('CHEBI') >= 0) ? 20 : 60;

                pushToHistory("<%=dlQuery%>", errors, resultsNumber);

                // show results the first time
                function showResults() {
                    if (resultsNumber == 0) {
                        document.getElementById("upperTable").style.visibility = "visible";
                        $(document.getElementById("resultsStatsDiv")).empty();
                        document.getElementById("resultsStatsDiv").innerHTML = "Sorry no results found for your query.";
                        document.getElementById("downloadsTab").style.display = "none";
                    }
                    else loadResults(1);
                }

                // load results page
                function loadResults(pageNumber) {
                    var from = (pageNumber > 0 ? (pageNumber - 1) * resultsPerPage + 1 : 0 );
                    var to = (pageNumber * resultsPerPage < resultsNumber ? pageNumber * resultsPerPage : resultsNumber);
                    showResultsNumber(from, to);
                    var n = (resultsNumber - resultsNumber % resultsPerPage) / resultsPerPage;
                    if (0 < resultsNumber % resultsPerPage)
                        n++;
                    showPages(pageNumber, n);
                    fillResultTable(from, to);


                }

                // fill chebi style result table
                function fillResultTable(from, to) {
                    var table = document.getElementById("chebiResultTable");
                    $(table).empty();
                    // add all the cells needed
                    var row; // local variable for current row in the table (each row has 3 columns)
                    for (var i = 0; i < resultsPerPage && i <= (to - from); i++) { // show results
                        if (i % 4 == 0) {
                            // open new row
                            row = jQuery("<tr></tr>").appendTo(table);
                        }
                        // add cell
                        jQuery("<td id=\'testID" + i + "\' class=\".omega.grid_5\" style=\"max-width: 275px;\"></td>").appendTo(row);
                        // fill the cell
                        if (resArray[0].indexOf('CHEBI') >= 0) {
                            instance = new Biojs.ChEBICompound({
                                target: 'testID' + i,
                                id: resArray[from + i - 1], // first fr4om value is 1 but we need to go from position 0 in the array.
                                proxyUrl: './proxy.jsp'
                            });
                        }
                        else {
                            var content = document.getElementById('testID' + i);
                            content.innerHTML = resArray[from + i - 1];
                        }
                    }
                }

                // total result no  & results shown
                function showResultsNumber(from, to) {
                    $(document.getElementById("resultsStatsDiv")).empty();
                    document.getElementById("resultsStatsDiv").innerHTML = "<b>" + resultsNumber + "</b> entries found, displaying " + from + " to " + to + ".";
                }

                // generate page numbers upper right side
                function showPages(currentPage, n) {
                    var maxPagesToShow = 3;
                    var x = currentPage;
                    document.getElementById("upperTable").style.visibility = "visible";
                    var container = document.getElementById("pageNumberDiv");
                    $(document.getElementById("pageNumberDiv")).empty();

                    if(currentPage != 1) {
                        // <<
                        jQuery("<a href=\"#\" onclick=\"loadResults(" + 1 + ")\"><span class=\"firstPageActive\"></span></a>").appendTo(container);
                        jQuery("<b>&nbsp;&nbsp;</b>").appendTo(container);
                        // <
                        var prev = (x - 1 > 0 ? x - 1 : 1 );
                        jQuery("<a href=\"#\" onclick=\"loadResults(" + prev + ")\"><span class=\"previousPageActive\"></span></a>").appendTo(container);
                        jQuery("<b>&nbsp;&nbsp;</b>").appendTo(container);
                        // ...
                        if (currentPage - maxPagesToShow > 1) {
                            jQuery("<a href=\"#\" onclick=\"loadResults(" + prev + ")\">...</a>").appendTo(container);
                            jQuery("<b>&nbsp;&nbsp;</b>").appendTo(container);
                        }

                    }
                    // i-3  i-2  i-1
                    maxPagesToShow = 3;
                    while (maxPagesToShow != 0) {
                        if (currentPage - maxPagesToShow > 0) {
                            jQuery("<a href=\"#\" onclick=\"loadResults(" + (currentPage - maxPagesToShow) + ")\">" + (currentPage - maxPagesToShow) + "</a>").appendTo(container);
                            jQuery("<b>&nbsp;&nbsp;</b>").appendTo(container);
                        }
                        maxPagesToShow--;
                    }
                    jQuery("<b>" + currentPage + "</b>").appendTo(container);
                    jQuery("<b>&nbsp;&nbsp;</b>").appendTo(container);
                    maxPagesToShow = 3;
                    x = currentPage;
                    while (maxPagesToShow-- > 0 && x++ < n) {
                        jQuery("<a href=\"#\" onclick=\"loadResults(" + x + ")\">" + x + "</a>").appendTo(container);
                        jQuery("<b>&nbsp;&nbsp;</b>").appendTo(container);
                    }

                    if(currentPage != n){
                        var next = (currentPage + 1 < n ? currentPage + 1 : n );
                        if (currentPage + maxPagesToShow < n)
                            jQuery("<a href=\"#\" onclick=\"loadResults(" + next + ")\">...</a>").appendTo(container);
                        jQuery("<b>&nbsp;&nbsp;</b>").appendTo(container);

                        jQuery("<a href=\"#\" onclick=\"loadResults(" + next + ")\"><span class=\"nextPageActive\"></span></a>").appendTo(container);
                        jQuery("<b>&nbsp;&nbsp;</b>").appendTo(container);

                        jQuery("<a href=\"#\" onclick=\"loadResults(" + n + ")\"><span class=\"lastPageActive\"></span></a>").appendTo(container);
                        jQuery("<b>&nbsp;&nbsp;</b>").appendTo(container);
                    }
                }

                showResults();
            </script>
</div>

<!-- Chebi footer -->
<%@ include file="footer.html" %>

</div>
</body>

</html>