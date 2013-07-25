package uk.ac.ebi.chebi.ontology.servlet;

import uk.ac.ebi.chebi.ontology.query.TsvExporter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Created with IntelliJ IDEA.
 * User: venkat
 * Date: 23/07/2013
 * Time: 11:03
 */
public class TsvExporterServlet extends HttpServlet{

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("application/octet-stream");
		response.setHeader("Content-Disposition",
				"attachment;filename=DLQueryResult.tsv");

		TsvExporter writer = new TsvExporter(response.getOutputStream());

		writer.write((String) request.getSession().getAttribute("exportContent"));
	}
}
