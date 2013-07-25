package uk.ac.ebi.chebi.ontology.query;

import org.apache.log4j.Logger;

// Singleton class
public class DLQueryServer {

	transient static Logger logger = Logger.getLogger(DLQueryServer.class);
	private static Ontology ont;
	private static DLReasoner dlReasoner;
	private static DLQueryServer serverInstance = null;
	private static final Object classLock = DLQueryServer.class;
	private String[] results;
	private String exportContent;
	private DLQueryServer(){
		// ontology is loaded into a graph
		ont = new Ontology();
		// initialize DL query tool
		dlReasoner = new DLReasoner(ont);
	}
	
	public static DLQueryServer getServerInstance(){
		logger.info("Get a new server instance.");
		synchronized(classLock){
			if (serverInstance == null)
				serverInstance = new DLQueryServer();
			logger.info("Server instance created.");
			return serverInstance;
		}
	}

	public String getExportContent() {
		return exportContent;
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
		exportContent = (dlReasoner.getExportContent());
	}
	
	// returns all results
	public String[] getResults(){
		return results;
	}

	public boolean hasValidSyntax(String query) throws Exception{
		return dlReasoner.checkSyntax(query);
	}

	public boolean isLoaded(){
		return ont != null && dlReasoner != null;
	}
	
}
