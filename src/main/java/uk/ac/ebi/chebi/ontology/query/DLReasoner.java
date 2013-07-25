package uk.ac.ebi.chebi.ontology.query;

import java.util.ArrayList;
import java.util.Set;

import org.apache.log4j.Logger;
import org.semanticweb.owlapi.model.OWLClass;
import org.semanticweb.owlapi.reasoner.*;
import owltools.graph.OWLGraphWrapper;

import uk.ac.manchester.cs.jfact.JFactFactory;

public class DLReasoner {

	transient Logger logger = Logger.getLogger(DLReasoner.class);

	private static OWLGraphWrapper graph;
	private static OWLReasoner reasoner;
	private static StringBuilder exportContent ;
	public DLReasoner(Ontology ont) {
		try {
			graph = ont.getGraph();
			logger.info("Creating a new reasoner.");
//			OWLOntology o = graph.getSourceOntology();
			reasoner = (new JFactFactory()).createReasoner(ont.getGraph().getSourceOntology());
			if (!reasoner.isPrecomputed(InferenceType.CLASS_HIERARCHY)) {
				logger.info("Precomputing inferences...");
				reasoner.precomputeInferences(InferenceType.CLASS_HIERARCHY);
				logger.info("Done reloading the reasoner.");
			}
		} catch (Exception e) {
			e.printStackTrace();
			logger.error(e.getMessage());
		}
	}

	protected String[] getQueryResults(String dlQuery) {
		exportContent =  new StringBuilder();
		ArrayList<String> res = new ArrayList<String>();
		try {
			Set<OWLClass> classes = DLQueryTool_modified.executeDLQuery(translateToIDs(dlQuery), graph, reasoner);
			for (OWLClass c : classes) {
			    res.add(getFormattedResult(c));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		String a[] = {};
		return res.toArray(a);
	}

	protected String translateToIDs(String nlDLQuery) throws Exception {
		String[] splitted = nlDLQuery.split("[\\s�]+");
		String res = "";
		for (String tok : splitted) {
			// try getting it by label, may be it is a relation
			if (graph.getOWLObjectByIdentifier(tok) != null){
				res += tok + " ";
			}	else {
				// some ontologies use underscore to separate words
				// while others use space so try both...
				if (graph.getOWLObjectByLabel(tok) != null) {
					res += graph.getOWLObjectByLabel(tok) + " ";
				} else if (graph.getOWLObjectByLabel(tok.replaceAll("_", " ")) != null) {
					res += graph.getOWLObjectByLabel(tok.replaceAll("_", " ")) + " ";
				} else if (tok.toLowerCase().matches("some|only|value|or|and|exactly|not|inverse|min|max|self|\\(|\\)")) {
					res += tok + " ";
				} else {
					Exception e = new Exception("Token <b>" + tok + "</b> could not be matched to an entry in our ontology. Please check the spelling.");
					logger.error(e.getMessage());
				}
			 }
		}
		logger.debug("Query was translated to : "+res.trim());
		return res.trim();
	}

	protected static String idToName(String id) {
		return graph.getLabel(graph.getOWLObjectByIdentifier(id.replaceAll("<http://purl.obolibrary.org/obo/|>", "")));
	}

	protected void release() {
		logger.info("Reasoner was released!!");
		reasoner.dispose();
	}

	protected boolean checkSyntax(String query) throws Exception {
		String idQuery ;
		String exceptionMessage = " ";
		try {
			if (query.equalsIgnoreCase(""))
				return true; //correct
			else {
				idQuery = translateToIDs(query);
				if (DLQueryTool_modified.parseQuery(idQuery, graph) != null)
					return true;
			}
		} catch (Exception e) {
			exceptionMessage += e.getMessage();
			exceptionMessage = exceptionMessage.replaceAll("\n", "<br/>");
			logger.error(exceptionMessage);
			throw new Exception(exceptionMessage);
		}
		return false;
	}

	protected String getFormattedResult(OWLClass owlClass) {
		//ChEBI id uses  webservices in the front end to get more data like structures , entry status and so on.
		//Others are linked to obo library.
		setExporterData(owlClass);
		if (!owlClass.toString().contains("CHEBI")) {
			String content = graph.getLabel(owlClass) + "(" + graph.getIdentifier(owlClass) + ")";
			return "<a href ='" + owlClass.toString().replace("<", "").replace(">", "") + "' target='blank' >" + content + "</a>";
		}
		return graph.getIdentifier(owlClass);
	}

	protected void setExporterData(OWLClass owlClass){
		exportContent.append(graph.getIdentifier(owlClass)).append("\t").
				append(graph.getLabel(owlClass)).append("\t").
				append(owlClass.toString().replace("<", "").replace(">", "")).append("\n");
	}

	protected String getExportContent(){
		return exportContent.toString();
	}


}
