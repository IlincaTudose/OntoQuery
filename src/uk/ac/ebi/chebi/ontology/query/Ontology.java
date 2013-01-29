package uk.ac.ebi.chebi.ontology.query;

import java.util.ArrayList;
import java.util.Collections;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.eclipse.jdt.internal.compiler.ast.ClassLiteralAccess;
import org.semanticweb.owlapi.model.*;
import owltools.graph.OWLGraphWrapper;
import owltools.io.ParserWrapper;
import uk.ac.manchester.cs.owl.owlapi.OWLClassImpl;
import uk.ac.manchester.cs.owl.owlapi.OWLObjectPropertyImpl;

public class Ontology {

	/**
	 * Loads chebi ontology as a graph representation.
	 */
	private String ONTOLOGY_IRI = "chebi-merged.24.01.13.owl";
//	private String ONTOLOGY_IRI = "C:/Users/tudose/Documents/Docs/chebi.obo";
//	private String ONTOLOGY_IRI = "chebi-disjoints.owl";	
	private static OWLGraphWrapper graph;
	private String classString = "";
	private String relationString = "";
	private ArrayList<String> classList;
	
	public Ontology(){
		try{
			ParserWrapper pw = new ParserWrapper();	
			String newIri = IRI.create(Ontology.class.getClassLoader().getResource(ONTOLOGY_IRI)).toString();
			graph = pw.parseToOWLGraph(newIri, true);
			classList = new ArrayList<String>();		
			// fill the ID - label map
			for (OWLObject obj: graph.getAllOWLObjects()){
				// only add labels in the hash
				String label;
				try{
					label = graph.getLabel(obj).trim();
				} catch (NullPointerException e) {label = graph.getIdentifier(obj);}
				if (OWLClassImpl.class.toString().equals(obj.getClass().toString())){
					classString += label.replaceAll(" ", "_") + "###";
					classList.add(label.replaceAll(" ", "_"));
				}
				else if (OWLObjectPropertyImpl.class.toString().equals(obj.getClass().toString()))
					relationString += label.replaceAll(" ", "_") + "###";
			}
		}catch(Exception e){
			e.printStackTrace();
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
			Pattern p = Pattern.compile(patt);
			Matcher m;
			String res = "";
			ArrayList<String> candidates = new ArrayList<String>();
			for (String s: classList){
				m = p.matcher(s.toLowerCase());
				if (m.find())
					candidates.add(s);
//				if(patt.length() == 1 && candidates.size() > 500){
//					break;
//				}
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
}
