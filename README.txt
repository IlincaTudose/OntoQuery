##########
How to set up OntoQuery for another ontology?
##########

1. Copy the OWL/OBO file in Webcontents/resources .
2. Set the path to it in Ontology.java .
3. Set ID post-processing. If you are using an OBO file, you might need to precess the returned IDs, if they contain special characters not allowed in URLs. A common example is ":", which the OWL API converts to underscore. If you use OWL and no changes are made, just remove [.replaceAll("CHEBI_", "CHEBI:")] from DLQueryTool_modified.java or adjust it according to your ontology.
4. Set custom variables in the first part of globalVariables.js as described in the file.
5. Set Java memory to 2GB
6. Call adminInput.jsp to  load the ontology.
