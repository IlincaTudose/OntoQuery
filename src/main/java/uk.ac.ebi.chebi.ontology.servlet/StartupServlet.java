package uk.ac.ebi.chebi.ontology.servlet;

import org.apache.log4j.Logger;
import uk.ac.ebi.chebi.ontology.query.DLQueryServer;

import javax.servlet.http.HttpServlet;

/**
 * Created with IntelliJ IDEA.
 * User: venkat
 * Date: 10/07/2013
 * Time: 11:00
 * Description: This initialises the DLQuery server while deploying,
 *                             so we don't need to load the ontology manually.
 */
public class StartupServlet extends HttpServlet {

	transient static Logger logger = Logger.getLogger(StartupServlet.class);

	public void init() {
		try {
			DLQueryServer serv = DLQueryServer.getServerInstance();
			getServletContext().setAttribute("server", serv);
			if (serv.isLoaded()) {
				logger.info("Successfully loaded the ontology");
			} else {
				logger.error("Loading ontology failed, please check log.");
			}
		} catch (Exception e) {
			logger.error(e.getCause());
		}
	}
}
