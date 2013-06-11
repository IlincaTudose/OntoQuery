package uk.ac.ebi.chebi.ontology.query;

import java.io.*;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.util.ArrayList;
import java.util.Collections;
import java.util.ResourceBundle;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

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
			logger.info("Ontology is initialised completely");
		}catch(Exception e){
			e.printStackTrace();
			logger.error(e.getMessage());
		}
		
	}
	
	protected boolean isClass(String name){
		return classList.contains(name);
	}
	
	protected String getMatchingClassNames(String patt){
		// returns the 50 first best matching classNames
		// if there were no letters typed return a pre-defined list and spare some time.
		if (patt.equals(".") || patt.equals(""))
			return "coumarins###flavonoids###triterpenoids###sesquiterpenoids###alkaloids###anti-HIV_agent###antibacterial_agent###"+
						"antioxidant###antibiotic###anti-inflammatory_agent###organic_heteropolycyclic_compound###phosphoglycerolipid###"+
						"steroid###ganglioside###phosphosphingolipid###organophosphate_oxoxanion###carboxylic_acid###fatty_acid###"+
						"acyl-CoA###oligosaccharide_oligosaccharide###amino_oligosaccharide###secondary_metabolite###antineoplastic_agent###"+
						"enzyme_inhibitor###enzyme_activator###agonist###antagonist";
		else {
			Pattern p = Pattern.compile(patt.toLowerCase());
			Matcher m;
			String res = "";
			ArrayList<String> candidates = new ArrayList<String>();
			for (String s: classList){
				m = p.matcher(s.toLowerCase());
				if (m.find())
					candidates.add(s);
			}
			Collections.sort(candidates, new CustomComparator(patt));
			for (int i = 0; i < 50 && i < candidates.size(); i++){
				res += candidates.get(i) + "###";
			}		
			return res; 
		}
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
