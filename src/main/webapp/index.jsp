<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"
         import="uk.ac.ebi.chebi.ontology.query.DLQueryServer"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@ include file="header.html" %>
<!--  end of chebi header -->

<div id="content" role="main" class="grid_24 clearfix">

    <div id="breadcrumbs">
        <p><a href="/chebi/init.do">ChEBI</a> > tools > OntoQuery </p>
    </div>
    <h2 class="entry-title" style="text-align: center">OntoQuery</h2>
    <div id="firstPageEditBox" style="padding-bottom: 15px;vertical-align: middle">
        <div id="editBoxDiv" >
            <%@ include file="userInput.jsp" %>
        </div>
        <div style="margin: -20px 15px;">
            <p><h3 class="icon icon-generic" data-icon=";">Quick tips:</h3></p>

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

            <p> For further information, please click <a href="OntoQueryHelp.jsp" target="_blank" title="Click here to go to the OntoQuery tutorial page."> tutorial page</a>.
            </p>
        </div>

    </div>

    <!-- chebi footer -->
    <%@ include file="footer.html" %>

    <%--</div>--%>
    <!--  end of content div -->
</div>

</div>
</body>

</html>