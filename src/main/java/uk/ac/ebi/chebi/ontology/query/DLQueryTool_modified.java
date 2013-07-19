package uk.ac.ebi.chebi.ontology.query;

import java.util.HashSet;
import java.util.Set;

import org.apache.log4j.Logger;
import org.obolibrary.macro.ManchesterSyntaxTool;
import org.semanticweb.owlapi.apibinding.OWLManager;
import org.semanticweb.owlapi.expression.ParserException;
import org.semanticweb.owlapi.model.IRI;
import org.semanticweb.owlapi.model.OWLClass;
import org.semanticweb.owlapi.model.OWLClassExpression;
import org.semanticweb.owlapi.model.OWLDataFactory;
import org.semanticweb.owlapi.model.OWLEquivalentClassesAxiom;
import org.semanticweb.owlapi.model.OWLOntology;
import org.semanticweb.owlapi.model.OWLOntologyManager;
import org.semanticweb.owlapi.reasoner.InferenceType;
import org.semanticweb.owlapi.reasoner.NodeSet;
import org.semanticweb.owlapi.reasoner.OWLReasoner;

import owltools.graph.OWLGraphWrapper;


public class DLQueryTool_modified {


	/**
	 * Modified version of the DLQueryTool from the OWLTools library.
	 * source: http://owltools.googlecode.com/svn/trunk/OWLTools-Core/src/main/java/owltools/mooncat/DLQueryTool.java
	 */
	transient static final Logger logger = Logger.getLogger(DLQueryTool_modified.class);

	/**
	 * Execute the DL query on the given ontology graph. Uses the factory to create
	 * the {@link OWLReasoner} for an internal query ontology.
	 */

	public static OWLClassExpression parseQuery(String query, OWLGraphWrapper graph) throws Exception {
		ManchesterSyntaxTool parser = null;
		OWLClassExpression ce = null;
		OWLOntology ont = graph.getSourceOntology();
		try {
			parser = new ManchesterSyntaxTool(ont);
			ce = parser.parseManchesterExpression(query);
		} catch (ParserException e) {
			String errMessage = "There was a problem parsing token ";
			String tok = "";
			if (graph.getOWLObjectByIdentifier(e.getCurrentToken().replaceAll("CHEBI_", "CHEBI:")) != null)
				tok = graph.getLabel(graph.getOWLObjectByIdentifier(e.getCurrentToken().replaceAll("CHEBI_", "CHEBI:")));
			else
				tok = e.getCurrentToken();
			errMessage += "<b>" + tok + "</b> or the query is not compete. <br/>";
			errMessage += "The parser expected one of : " + (e.getMessage().split("Expected one of:")[1]) + ".";
			throw new Exception(errMessage);
		} finally {
			// always dispose parser to avoid a memory leak
			if (parser != null) {
				parser.dispose();
			}
		}
		return ce;
	}

	public static Set<OWLClass> executeDLQuery(String dlQuery, OWLGraphWrapper graph, OWLReasoner reasoner) throws Exception {
		// create parser and parse DL query string
		OWLClassExpression ce = parseQuery(dlQuery, graph);
		long start = System.currentTimeMillis();
		// create query ontology
		OWLOntologyManager m = OWLManager.createOWLOntologyManager();
		OWLOntology queryOntology = m.createOntology(IRI.generateDocumentIRI(), graph.getAllOntologies());
		logger.info("Loading the ontology took " + (System.currentTimeMillis() - start) + "ms.");
		start = System.currentTimeMillis();
		OWLDataFactory f = m.getOWLDataFactory();
		OWLClass qc = f.getOWLClass(IRI.create("http://owltools.org/Q"));
		OWLEquivalentClassesAxiom ax = f.getOWLEquivalentClassesAxiom(ce, qc);
		m.addAxiom(queryOntology, ax);

		Set<OWLClass> subset = executeQuery(ce, graph.getSourceOntology(), reasoner);
		if (subset.isEmpty()) {
			logger.warn("No classes found for query subclass of:" + dlQuery);
		}
		logger.info("Results found in " + (System.currentTimeMillis() - start) + "ms.");
		return subset;
	}

	/**
	 * Execute the DL query on the given ontology graph. Uses the factory to create
	 * the {@link OWLReasoner} for an internal query ontology.
	 */

	static Set<OWLClass> executeQuery(OWLClassExpression queryObject, OWLOntology ontology, OWLReasoner reasoner) {
		Set<OWLClass> subset = new HashSet<OWLClass>();
		long start = System.currentTimeMillis();
		try {
			logger.info("is precomputed (before): " + reasoner.isPrecomputed(InferenceType.CLASS_HIERARCHY));
			logger.info("is precomputed: " + reasoner.isPrecomputed(InferenceType.CLASS_HIERARCHY));
			logger.info("Precomputing inferences took " + (System.currentTimeMillis() - start) + "ms.");
			start = System.currentTimeMillis();
			logger.info("Start evaluation for DL query subclass of: " + queryObject);
			NodeSet<OWLClass> node = reasoner.getSubClasses(queryObject, false);
			if (node != null) {
				Set<OWLClass> classes = node.getFlattened();
				for (OWLClass owlClass : classes) {
					if (!owlClass.isBottomEntity() && !owlClass.isTopEntity()) {
						if (reasoner.isSatisfiable(owlClass))
							subset.add(owlClass);
					}
				}
				logger.info("Number of found classes for dl query subclass of: " + classes.size());
			}
			logger.info("Evaluating the class expression took " + (System.currentTimeMillis() - start) + "ms.");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return subset;
	}

}
