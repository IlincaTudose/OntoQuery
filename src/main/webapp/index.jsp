<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1"
         import="uk.ac.ebi.chebi.ontology.query.DLQueryServer"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@ include file="header.html" %>
<!--  end of chebi header -->

<div id="content">
    <br/>
    <table class="contentspane" id="contentspane" summary="The main content pane of the page" style="width: 100%">
        <tbody>
        <tr>
            <td class="leftmenucell" id="leftmenucell">
                <%--<%@ include file="menu.html" %>--%>
            </td>
            <td></td>
            <td id="contentsarea" class="contentsarea" style="border-left: 1px solid #dedede;">
                <%--<div class="breadcrumbs">
                    <a href="http://www.ebi.ac.uk/" class="firstbreadcrumb">EBI</a><a href ="http://www.ebi.ac.uk/Databases/">Databases</a><a href ="http://www.ebi.ac.uk/Databases/smallmolecules.html">Small Molecules</a><a href="http://www.ebi.ac.uk/chebi">ChEBI</a><a href="/chebi/tools/ontoquery">OntoQuery</a>
                </div>
                <h1 class="local-header"><a href="/chebi/tools/ontoquery" title="Back to OntoQuery homepage">OntoQuery</a></h1>
               --%> <div id="firstPageEditBox" style="min-height: 500px;vertical-align: middle">
                    <div id="editBoxDiv">
                        <%@ include file="userInput.jsp" %>
                    </div>
                    <p> Examples: "
                        <a href="response.jsp?submit=Submit&hiddenQuery=has_postsynaptic_terminal_in+some+medulla+&page=1" class="recentQueries">
                            <span class="relationStyle">has_postsynaptic_terminal_in </span>
                            <span class="restriction">some </span>
                            <span class="classStyle">medulla</span>
                        </a>" &nbsp; &nbsp; or &nbsp; &nbsp;
                        "<a href="response.jsp?submit=Submit&hiddenQuery=%28+has_postsynaptic_terminal_in+some+lobula+%29+and+has_presynaptic_terminal_in+some+medulla+&page=1" class="recentQueries">
                            <span class="paranthesis">(</span>
                            <span class="classStyle">has_postsynaptic_terminal_in </span>
                            <span class="restriction">some </span>
                            <span class="classStyle">lobula </span>
                            <span class="paranthesis">) </span>
                            <span class="booleanConstructor">and </span>
                            <span class="relationStyle">has_presynaptic_terminal_in </span>
                            <span class="restriction">some </span>
                            <span class="classStyle">medulla </span>
                        </a>" .</p>
                    <br/>
                    <br/>
                    <h3>Quick tips:</h3>

                    <ul>
                        <li><b>Spaces</b> in entity names are replaced with
                            underscores (e.g. "chemical entity" will become
                            "chemical_entity")</li>
                        <li>If you use <b>brackets</b> to group more complex
                            expressions you need to separate them by spaces (before and
                            after) so that they don't get confused with the brackets in the
                            chemical formulas and names
                        </li>
                        <li>At the moment a single <b>restriction</b> is availabe :<b>
                            <span class="restriction"> some </span>
                        </b></li>
                        <li><b> Restrictions </b> are always required between a
                            relation and a class (e.g. <b><span class="relationStyle">has_part</span>
                                <span class="restriction"> some </span> <span
                                        class="classStyle">chloride</span></b>)</li>
                        <li><b>Boolean binary constructors</b> are: <b><span
                                class="booleanConstructor">or</span></b>, <b><span
                                class="booleanConstructor">and</span></b></li>
                        <li><b>Boolean binary contructors</b> are always requested
                            between 2 class expressions (e.g. <b><span
                                    class="classStyle">chemical_entity</span> <span
                                    class="booleanConstructor"> and</span> <span
                                    class="relationStyle">has_part</span> <span
                                    class="restriction"> some </span> <span class="classStyle">chloride</span></b>)</li>
                        <li><b><span class="booleanConstructor">Not</span></b> is
                            the only <b>boolean unary constructor</b> (i.e. it accepts only a single operand) and is defined under
                            the <a href="http://en.wikipedia.org/wiki/Open_world_assumption">open world assumption</a></li>
                    </ul>

                    <p> For further information, click <a href="OntoQueryHelp.jsp" target="_blank"
                                                          title="Click here to go to the OntoQuery tutorial page.">
                        <img src="http://www.ebi.ac.uk/inc/images/icon_help.gif"
                             height="20" width="20" border="0"></a>.
                    </p>

                </div>
            </td>
        </tr>
        </tbody>
    </table>

    <!-- chebi footer -->
    <%--<%@ include file="footer.html" %>--%>

</div>
<!--  end of content div -->


</body>

</html>
