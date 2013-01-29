package uk.ac.ebi.chebi.ontology.query;

import java.util.ArrayList;
import java.util.Set;
import org.semanticweb.owlapi.model.OWLClass;
import org.semanticweb.owlapi.model.OWLOntology;
import org.semanticweb.owlapi.reasoner.*;
import owltools.graph.OWLGraphWrapper;
//import org.semanticweb.HermiT.Reasoner;

import uk.ac.manchester.cs.jfact.JFactFactory;

public class DLReasoner {

	private static OWLGraphWrapper graph;
//	private static org.semanticweb.HermiT.Reasoner reasoner;
	private static OWLReasoner  reasoner;
	
	public DLReasoner(Ontology ont){
		try{
			graph = ont.getGraph();
			System.out.println("Creating a new reasoner.");
			OWLOntology o = graph.getSourceOntology();
//			Mooncat mooncat = new Mooncat(graph);
//			mooncat.mergeOntologies();
//			OWLOntology o = mooncat.getOntology();
			reasoner = (new JFactFactory()).createReasoner(ont.getGraph().getSourceOntology());
//			OWLOntologyManager m = OWLManager.createOWLOntologyManager();
//			File file = new File ("C:/Users/tudose/Documents/Docs/chebi-disjoints-all-merged.owl");
//			localOnt = m.loadOntologyFromOntologyDocument(file);
		        
//			reasoner = new org.semanticweb.HermiT.Reasoner(o);
			
			if (!reasoner.isPrecomputed(InferenceType.CLASS_HIERARCHY)){
				System.out.println("Precomputing inferences...");
				reasoner.precomputeInferences(InferenceType.CLASS_HIERARCHY);
				System.out.println("Done reloading the reasoner.");
			}
		}catch(Exception e){
			e.printStackTrace();
		}
	}	
	
	protected String[] getQueryResults(String dlQuery){
		ArrayList<String> res = new ArrayList<String>();
		try{
			Set<OWLClass> classes = DLQueryTool_modified.executeDLQuery(translateToIDs(dlQuery), graph, reasoner);
//			if (classes.isEmpty())
//				res.add("Your query returned 0 results.");
//			else 
				for (OWLClass c: classes){
		//		res.add(idToName(c.toStringID()));
				res.add(graph.getIdentifier(c));
				}
		}catch(Exception e){
			e.printStackTrace();
		}
		String a[] = {};
		return res.toArray(a);
	}
	
	protected String translateToIDs(String nlDLQuery) throws Exception{
		String[] splitted = nlDLQuery.split("[\\s ]+");
		String res = "";
		for (String tok: splitted){
			// try getting it by label, meybe it is a relation
			if (graph.getOWLObjectByIdentifier(tok) != null)
				res += tok + " ";
			else {
				tok = tok.replaceAll("_", " ");
				if (graph.getOWLObjectByLabel(tok) != null)
					res += graph.getOWLObjectByLabel(tok).toString().replaceAll("<http://purl.obolibrary.org/obo/|>|chebi#"+
				"|<http://purl.obolibrary.org/obo#|obo#|&obo2;", "") + " ";
				else if (tok.toLowerCase().matches("some|only|value|or|and|exactly|not|inverse|min|max|self|\\(|\\)"))
					res += tok + " ";
				else {
				//	res += tok + " ";
					Exception e = new Exception("Token <b>" + tok + "</b> could not be matched to an entry in our ontology. Please check the spelling.");
					throw e;
				}
			}
		}
		System.out.println("Query was translated to : " + res.trim());
		return res.trim();
	}
	
	protected static String idToName(String id){
		return graph.getLabel(graph.getOWLObjectByIdentifier(id.replaceAll("<http://purl.obolibrary.org/obo/|>", "")));
	}
	
	protected void release(){
		System.out.println("Reasoner was released!!");
		reasoner.dispose();
	}
	
	protected boolean checkSyntax(String query) throws Exception{
		String idQuery = "";
		String exceptionMessage = " ";
		try {
			if (query.equalsIgnoreCase(""))
				return true; //correct
			else {
				idQuery = translateToIDs(query);
				if( DLQueryTool_modified.parseQuery(idQuery, graph) != null )
					return true;				
			}
		}catch (Exception e){
			//exceptionMessage += "<span class=\\\"expectedTokensStyle\\\">";
			exceptionMessage += e.getMessage();
			exceptionMessage = exceptionMessage.replaceAll("\n", "<br/>");
			//exceptionMessage += "</span>";
			throw new Exception (exceptionMessage);
		}
		return false;		
	}
}
