package uk.ac.ebi.chebi.ontology.query;

import java.io.*;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import org.apache.log4j.Logger;
import org.semanticweb.owlapi.model.*;
import owltools.graph.OWLGraphWrapper;
import owltools.io.ParserWrapper;
import uk.ac.manchester.cs.owl.owlapi.OWLClassImpl;
import uk.ac.manchester.cs.owl.owlapi.OWLObjectPropertyImpl;

/**
 * Loads chebi ontology as a graph representation.
 */
public class Ontology {

	transient Logger logger = Logger.getLogger(Ontology.class);

	private String ONTOLOGY_IRI = "ftp://ftp.ebi.ac.uk/pub/databases/chebi/ontology/chebi-disjoints.owl";
//	private String ONTOLOGY_IRI = "http://svn.code.sf.net/p/fbbtdv/code/fbbt/releases/fbbt-simple.owl";
//	private String ONTOLOGY_IRI = "http://www.geneontology.org/ontology/go-simple.owl";
//	private String ONTOLOGY_IRI = "http://www.imbi.uni-freiburg.de/ontology/biotop/1.0/";
    private static OWLOntology chebiOntology;
	private static OWLGraphWrapper graph;
	private String classString = "";
	private String relationString = "";
	private ArrayList<String> classList;
	
	public Ontology(){
		try{
			ParserWrapper pw = new ParserWrapper();
			File temp = File.createTempFile("tempfile", ONTOLOGY_IRI.substring(ONTOLOGY_IRI.lastIndexOf(".")));
			BufferedWriter bw = new BufferedWriter(new FileWriter(temp));
			bw.write(getFTPAsString());
			bw.close();

			logger.debug("Ontology written to temp file");
			chebiOntology = pw.parse(temp.toString());

			graph = new OWLGraphWrapper(chebiOntology);
			logger.debug("OWL file parsed and graph is created");

			classList = new ArrayList<String>();
			// fill the ID - label map
			for (OWLObject obj: graph.getAllOWLObjects()){
				// only add labels in the hash
				String label;
				try{
					label = graph.getLabel(obj).trim();
				} catch (NullPointerException e) {
					label = graph.getIdentifier(obj);
				}
				if (OWLClassImpl.class.toString().equals(obj.getClass().toString())){
					classString += label.replaceAll(" ", "_") + "###";
					classList.add(label.replaceAll(" ", "_"));
				}
				else if (OWLObjectPropertyImpl.class.toString().equals(obj.getClass().toString())) {
					relationString += label.replaceAll(" ", "_") + "###";
				}
			}
			logger.info("relations: "+ relationString);
			logger.info("Ontology is initialised completely");
		}catch(Exception e){
			e.printStackTrace();
			logger.error(e.getMessage());
		}
		
	}
	
	protected boolean isClass(String name){
		return classList.contains(name);
	}

	protected String getMatchingClassNames(String pattern) {
		long t1 = System.currentTimeMillis();
		String result = "";
		List<String> list = new ArrayList<String>();
		if (pattern.equals(".") && pattern.equals("")) {
			list = classList.subList(0, 50);
			// if there were no letters typed return a pre-defined list and spare some time.
			// returns the 50 first best matching classNames
		} else {
			for (String owlClass : classList) {
				if (owlClass.contains(pattern)) {
					list.add(owlClass);
					if (pattern.length() < 3 && list.size() == 50) break;
				}
			}
		logger.info("list size : " + list.size());
			Collections.sort(list, new CustomComparator(pattern));
		}
		for (int i = 0; i < 50 && i < list.size(); i++) {
			result += list.get(i) + "###";
		}
		long t2 = System.currentTimeMillis();
		logger.info("total time :" + (t2 - t1) + "ms");
		return result;
	}

	protected OWLGraphWrapper getGraph(){
		return graph;
	}

	
	protected String getClasses(){
		return classString;
	}
	
	protected String getRelations(){
		return relationString;
	}
		
	protected String idToName(String id){
		return graph.getLabel(graph.getOWLObjectByIdentifier(id));
	}
	
	protected IRI getIRI(){
		return IRI.create(ONTOLOGY_IRI);
	}

	protected  String getStringFromInputStream(InputStream is) {
		BufferedReader br = null;
		StringBuilder sb = new StringBuilder();
		try {
			String line;
			br = new BufferedReader(new InputStreamReader(is));
			while ((line = br.readLine()) != null) {
				sb.append(line);
			}
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			if (br != null) {
				try {
					br.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
		return sb.toString();
	}

	public String getFTPAsString() {
		String content = "";
		try {
			URL url = new URL(ONTOLOGY_IRI);
			URLConnection con = url.openConnection();
			InputStream is = con.getInputStream();
			content = getStringFromInputStream(is);
		} catch (MalformedURLException e) {
			e.printStackTrace();
			logger.error(e.getMessage());
		} catch (IOException e) {
			e.printStackTrace();
			logger.error(e.getMessage());
		}
		return content;
	}

}
