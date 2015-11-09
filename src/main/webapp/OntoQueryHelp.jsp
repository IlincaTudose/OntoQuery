<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>


<%@ include file="header.html" %>

	<div id="content">
		<br/>
		<table class="contentspane" id="contentspane" summary="The main content pane of the page" style="width: 100%">
			<tbody>
				<tr>
                    <td class="leftmenucell" id="leftmenucell">
                        <%@ include file="menu.html" %>
                    </td>
					<td style="border-left: 1px solid #dedede; padding-left: 10px;">
                    <div class="breadcrumbs">
                        <a href="http://www.ebi.ac.uk/" class="firstbreadcrumb">EBI</a><a href ="http://www.ebi.ac.uk/Databases/">Databases</a><a href ="http://www.ebi.ac.uk/Databases/smallmolecules.html">Small Molecules</a><a href="http://www.ebi.ac.uk/chebi">ChEBI</a><a href="/chebi/tools/ontoquery">OntoQuery</a>
                    </div>
                    <h1 class="local-header"><a href="/chebi/tools/ontoquery" title="Back to OntoQuery homepage">OntoQuery</a></h1>

						<div id="helpContent">

							<h3>OntoQuery Tutorial</h3>

							<p>The OntoQuery is an online <a href="http://en.wikipedia.org/wiki/Web_Ontology_Language">OWL</a>
								query tool meant to ease your experience of retrieving data from
								ChEBI while enhancing the power of the existing advanced tool
								search. You should however keep in mind that this is a strict
								ontology search and thus any information outside our ontology
								will not be searchable using this tool (e.g. the structures).</p>

							<p>This is a quick tutorial to give you an overview of our
								tool's functions and help you write the queries, if you are not
								familiar with the OWL Manchester syntax.</p>

							<p>Please also keep in mind that we only present here the
								features of the tool which are of interest in the context of
								ChEBI's expressivity.</p>


							<h3>OntoQuery Tour</h3>


							<img src="images/1.png"> <img src="images/2.png"> <img src="images/historyBox.png">

							<h3>Query Syntax</h3>

							<p>
								For writing the queries we use the <b>Manchester syntax</b>
								which an intuitive and compact syntax for class expressions,
								designed for OWL ontologies. The OWL expressivity is higher than
								ChEBI's and therefore we will only show here the small subset of 
								expressions that one can build using Manchester syntax, that are relevant to ChEBI. 
								For more information about the Machester syntax please visit the corresponding <a
									href="http://www.w3.org/TR/owl2-manchester-syntax/">W3
									page</a> or <a
									href="http://www.co-ode.org/resources/reference/manchester_syntax/">CO-ODE
									page</a>.
							</p>


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
									the <a href="http://en.wikipedia.org/wiki/Open_world_assumption">open world assumtion</a></li>
							</ul>


							<h3>Examples (Based on ChEBI Onto)</h3>

							<p>We feel the best way to teach something is by example, so
								let us take some. We recommend that you build the queries
								yourself instead of just copy-pasting our solutions, so that you
								can get a feeling of our OntoQuery tool. Let's suppose we are
								interested in one of the following:</p>
							<br />
							<h3>1. all di- and trisaccharide derivatives which are
								methyl glycosides .</h3>
							<p>This query is quite intuitive to build and as you might
								notice when trying it yourself, the autosuggest helps you a lot
								building it. An possible solution is:
							<p>
							<p class="solution">
								<span class="paranthesis">( </span> <span class="classStyle">disaccharide_derivative
								</span> <span class="booleanConstructor">or </span> <span
									class="classStyle">trisaccharide_derivative </span> <span
									class="paranthesis">) </span> <span class="booleanConstructor">and
								</span> <span class="classStyle">methyl_glycoside </span>
							</p>
							<p>
								An equivalent formulation would be the one below, where the
								parenthesis are optional because <span
									class="booleanConstructor">and </span> has precedence over <span
									class="booleanConstructor">or</span>, as multiplication takes precedence 
									over addition in mathematics.
							</p>
							<p class="solution">
								<span class="paranthesis">( </span> <span class="classStyle">disaccharide_derivative
								</span> <span class="booleanConstructor">and </span> <span
									class="classStyle">methyl_glycoside </span> <span
									class="paranthesis">) </span> <span class="booleanConstructor">or
								</span> <span class="paranthesis">( </span> <span class="classStyle">trisaccharide_derivative
								</span> <span class="booleanConstructor">and </span> <span
									class="classStyle">methyl_glycoside </span> <span
									class="paranthesis">) </span>
							</p>
							<br />

							<h3>2. all secondary metabolites which are also coumarins or
								phenols</h3>
							<p>A possible solution is:</p>
							<p class="solution">
								<span class="paranthesis">( </span> <span class="classStyle">phenols
								</span> <span class="booleanConstructor">or </span> <span
									class="classStyle">coumarins </span> <span class="paranthesis">)
								</span> <span class="booleanConstructor">and </span> <span
									class="relationStyle">has_role </span> <span
									class="restriction">some </span> <span class="classStyle">secondary_metabolite</span>
							</p>
							<p>
								You might be tempted to write directly "<b><span
									class="booleanConstructor">and </span> <span class="classStyle">secondary_metabolite</span></b>"
								instead of "<b><span class="booleanConstructor">and </span>
									<span class="relationStyle">has_role </span> <span
									class="restriction">some </span> <span class="classStyle">secondary_metabolite</span></b>",
								but there will be no results for this query. This happens
								because <b><span class="classStyle">secondary_metabolite</span></b>
								is a <b><span class="classStyle">role</span></b> in ChEBI, 
								whereas phenols and coumarins are <b><span class="classStyle">chemical_entities</span></b>.
								Roles and chemical entities are disjoint in ChEBI, which means
								no entity can be at the same time both a role and a chemical
								entity. The existence of roles is something you must keep in
								mind and the best way to check is to search for the entity of
								interest in ChEBI and check whether it is a <b><span
									class="classStyle">role</span></b> or <b><span class="classStyle">chemical_entity</span></b>.
							</p>
							<br />

							<h3>3. all pyrimidines or phenols which have antibacterial
								properties</h3>
							A possible solution would be:
							<p class="solution">
								<span class="paranthesis">( </span> <span class="classStyle">pyrimidines
								</span> <span class="booleanConstructor">or </span> <span
									class="classStyle">phenols </span> <span class="paranthesis">)
								</span> <span class="booleanConstructor">and </span> <span
									class="relationStyle">has_role </span> <span
									class="restriction">some </span> <span class="classStyle">antibacterial_agent</span>
							</p>
							Although you might not know the exact name of a particular class in ChEBI (in this case, antibacterial_agent), 
							simply typing part of the name (e.g. 'antib') into the edit box will cause the correct name to appear in the 
							suggestions list. <br />

							<h3>4. all insecticides or acaricides which can also be used
								as fungicides</h3>
							<p>A possible solution is:</p>
							<p class="solution">
								<span class="paranthesis">( </span> <span class="classStyle">chemical_entity
								</span> <span class="booleanConstructor">and </span> <span
									class="relationStyle">has_role </span> <span
									class="restriction">some </span> <span class="paranthesis">(
								</span> <span class="classStyle">insecticide </span> <span
									class="booleanConstructor">or </span> <span class="classStyle">acaricide
								</span> <span class="paranthesis">) </span> <span class="paranthesis">)
								</span> <span class="booleanConstructor">and </span> <span
									class="relationStyle">has_role </span> <span
									class="restriction">some </span> <span class="classStyle">fungicide</span>

							</p>
							<br />

							<p>These were just a few examples to show you the process of
								building a query. They were all pretty easy queries but the
								complexity of the query you might build is arbitrary and providing you 
								group your sub-queries correctly there is nothing to stop you from successfully 
								building and running queries several lines in length.</p>

							<h3>Try It Yourself</h3>

							We hope that you now feel prepared to try building some queries
							on your own. We have a further three exercises.

							<h3>1. Find all lactams that are antibiotics</h3>
							<p class="solution" id="s1" style="visibility: hidden;">
								<span class="classStyle">lactam </span> <span
									class="booleanConstructor">and </span> <span
									class="relationStyle">has_role </span> <span
									class="restriction">some </span> <span class="classStyle">antibiotic</span>
							</p>
							<button name="q1"
								onclick="document.getElementById('s1').style.visibility='visible';">Show
								solution</button>

							<h3>2. Find all organic sodium salts that are steroids and
								are conjugate acid of organosulfate oxoanion.</h3>
							<p class="solution" id="s2" style="visibility: hidden;">
								<span class="paranthesis">( </span> <span class="classStyle">organic_sodium_salt
								</span> <span class="booleanConstructor">and </span> <span
									class="relationStyle">has_parent_hydride </span> <span
									class="restriction">some </span> <span class="classStyle">steroid
								</span> <span class="paranthesis">) </span> <span
									class="booleanConstructor">and </span> <span
									class="relationStyle">has_part </span> <span
									class="restriction">some </span> <span class="classStyle">organosulfate_oxoanion</span>
							</p>
							<button name="q2"
								onclick="document.getElementById('s2').style.visibility='visible';">Show
								solution</button>


							<h3>3. Find all antibacterial and antifungal which can also
								be used as antibiotics.</h3>

							<p class="solution" id="s3" style="visibility: hidden;">
								<span class="paranthesis">( </span> <span class="classStyle">
									chemical_entity </span> <span class="booleanConstructor"> and </span>
								<span class="relationStyle">has_role </span> <span
									class="restriction">some </span> <span class="paranthesis">(
								</span> <span class="classStyle"> antibacterial_agent </span> <span
									class="booleanConstructor">or </span> <span class="classStyle">antifungal_agent
								</span> <span class="paranthesis">) </span> <span class="paranthesis">)
								</span> <span class="booleanConstructor">and </span> <span
									class="relationStyle">has_role </span> <span
									class="restriction">some </span> <span class="classStyle">antibiotic
								</span>
							</p>
							<button name="q3"
								onclick="document.getElementById('s3').style.visibility='visible';">Show
								solution</button>


							<br />
							<p>If you have any queries, comments or suggestions about the OntoQuery tool and tutorial, 
							please contact us at  chebi-help[at]ebi.ac.uk.</p>

						</div>
					</td>
				</tr>
			</tbody>
		</table>

        <%@ include file="footer.html" %>
	</div>
</body>
</html>