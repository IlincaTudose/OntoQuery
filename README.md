##########
How to set up OntoQuery for another ontology?
##########

1. Copy the OWL/OBO file to resources directory.
2. Else you can point it directly to a FTP site. Set the name of the file/ Url pointing to FTP in Ontology.java .
3. Set ID post-processing. If you are using an OBO file, you might need to precess the returned IDs,
if they contain special characters not allowed in URLs. A common example is ":", which the OWL API converts to underscore.
If you use OWL and no changes are made, just remove [.replaceAll("CHEBI_", "CHEBI:")] from DLQueryTool_modified.java or adjust it according to your ontology.
4. Set custom variables in the first part of globalVariables.js as described in the file.
5. Set up memory to at least 2GB and density limit as described "-Xms1024m -Xmx2048m -XX:MaxPermSize=128m -DentityExpansionLimit=1000000".
6. While deploying, the ontology will loaded automatically (it takes a while depending upon the ontology)

Note: without DensityExpansionLimit, the RDFXML  parser will fail to parse the owl/obo file.
