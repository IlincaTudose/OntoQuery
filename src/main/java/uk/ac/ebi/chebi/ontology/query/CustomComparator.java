package uk.ac.ebi.chebi.ontology.query;

import java.util.Comparator;

public class CustomComparator implements Comparator<String>{

	String pattern;
	
	public CustomComparator(String pat){
		pattern = pat;
	}
	
	public int compare(String a, String b) {
        return  (dist(a) > dist(b) ? 1 : dist(a) < dist(b) ? -1 : 0);
    }
	
	private int dist(String a){
		return (a.toLowerCase().indexOf(pattern) * 10) + levenshteinen(a.toLowerCase(), pattern);
	}
	
	// calculate the Levenshtein distance between a and b, fob = form object, passed to the function
	int levenshteinen(String string_a, String string_b) {
		int cost;
		
		// get values
		String a = string_a;
		int m = a.length();
		
		String b = string_b;
		int n = b.length();
		
		// make sure a.length >= b.length to use O(min(n,m)) space, whatever that is
		if (m < n) {
			String c=a;a=b;b=c;
			int o=m;m=n;n=o;
		}
		
		int[][] r = new int[m+1][n+1];
		for (int c = 0; c < n+1; c++) {
			r[0][c] = c;
		}
		
		for (int i = 1; i < m+1; i++) {
			r[i][0] = i;
			for (int j = 1; j < n+1; j++) {
				cost = (a.charAt(i-1) == b.charAt(j-1))? 0: 1;
				r[i][j] = minimator(r[i-1][j]+1,r[i][j-1]+1,r[i-1][j-1]+cost);
			}
		}
//		System.out.println("levenstein: " + r[m][n] + " (" + string_a + ")");
		return r[m][n];
	}

	// return the smallest of the three values passed in
	int minimator (int x, int y, int z) {
		if (x < y && x < z) return x;
		if (y < x && y < z) return y;
		return z;
	};

}
