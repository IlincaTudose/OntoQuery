package uk.ac.ebi.chebi.ontology.query;

import java.util.ArrayList;
import java.util.Collections;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.tools.ant.types.mappers.CutDirsMapper;

public class main {

	public static void main(String[] args) {
//		DLQueryServer.getServerInstance();
/*		DLInquirer s = new DLInquirer();
//		for (String x: s.getQueryResults("CHEBI_24431 and has_role some CHEBI_50906")){
//			System.out.println(x);
//		}
		String translate = s.translateToIDs("'chemical entity' and 'has role' some base");
		System.out.println("Translated!! \n" + translate);
		for (String x: s.getQueryResults(translate)){
			System.out.println(x);
		}
		*/
		CustomComparator c =  new CustomComparator("bac");
		System.out.println(c.compare("bachh", "bacasad"));
		String patt = "ah";
		ArrayList<String> classList = new ArrayList<String>();
		classList.add("blah1");
		classList.add("blasahasb2");
		classList.add("blahb2");
			// returns the 50 first best matching classNames
			Pattern p = Pattern.compile(patt);
			Matcher m;
			String res = "";
			ArrayList<String> candidates = new ArrayList<String>();
			for (String s: classList){
				m = p.matcher(s);
				if (m.find())
					candidates.add(s);
			}
			Collections.sort(candidates, new CustomComparator(patt));
			for (int i = 0; i < 50 && i < candidates.size(); i++){
				System.out.println(candidates.get(i));
				res += candidates.get(i) + "###";
			}	
			System.out.println(res);
		}
}
