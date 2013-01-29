package uk.ac.ebi.chebi.ontology.query;

import java.util.ArrayList;

// Singleton class
public class DLQueryServer {

	private static Ontology ont;
	private static DLReasoner dlReasoner;
	private static DLQueryServer serverInstance = null;
	private static final Object classLock = DLQueryServer.class;
	private String[] results;
	
	private DLQueryServer(){
		// ontology is loaded into a graph
		ont = new Ontology();
		// initialize DL query tool
		dlReasoner = new DLReasoner(ont);
	}
	
	public static DLQueryServer getServerInstance(){
		System.out.println("Get server instance.");
		synchronized(classLock){
			if (serverInstance == null)
				serverInstance = new DLQueryServer();
			System.out.println("done");
			return serverInstance;
		}
	}
	
	public String getClassNames(){
		return ont.getClasses();
//		return "role###chemical_entity###base";
	}
	
	public String getMatchingClassNames(String pattern){
		return ont.getMatchingClassNames(pattern);
	}
	
	public boolean isClass(String name){
		return ont.isClass(name);
	}
	
	public String getRelationNames(){
		return ont.getRelations();
//		return "has_part###has_role";
	}
	
	public void computeDLQueryResults(String query){
		results = dlReasoner.getQueryResults(query);
	}
	
	// returns all results
	public String[] getResults(){
		return results;
	}

	public String[] getResults(int from, int to){
		String[] res = new String[to-from];
		for (int i = from; i < to; i++){
			res[i-from] = results[i];
		}
		return res;
	}
	
	public int getResultsNumber(){
		return results.length;
	}
	
	// TODO this shouldn't be visible! I need it now to output the translated query.
	public String getTranslationToID(String query) throws Exception{
		return dlReasoner.translateToIDs(query);
	}
	
	public void reloadOntology(){
		ont = new Ontology();
	}
	
	public void reloadReasoner(){
		dlReasoner.release();
		dlReasoner = new DLReasoner(ont);
	}
	
	public String getMockUpAutoComplete(){
		return "has_role###nas_s###aabhas###x_has###1Has";
	}
	
	public boolean hasValidSyntax(String query) throws Exception{
		return dlReasoner.checkSyntax(query);
	}
	
}
