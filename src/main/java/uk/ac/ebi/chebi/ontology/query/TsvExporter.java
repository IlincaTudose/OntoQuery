package uk.ac.ebi.chebi.ontology.query;

import org.apache.log4j.Logger;

import java.io.BufferedWriter;
import java.io.IOException;
import java.io.OutputStream;
import java.io.OutputStreamWriter;

/**
 * Created with IntelliJ IDEA.
 * User: venkat
 * Date: 23/07/2013
 * Time: 12:09
 */
public class TsvExporter {

	private static final Logger logger = Logger.getLogger(TsvExporter.class);

	private OutputStream outputStream;

	public TsvExporter(OutputStream pathToTable) {
		this.outputStream = pathToTable;
	}


	public void write(String exportContent) {
		try {
			BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(outputStream));
			writer.write("Identifier\tlabel\turl\n");
			writer.write(exportContent);
			writer.flush();
			writer.close();
		} catch (IOException e) {
			logger.error("Could not write table to file : ", e);
		}
	}



}
