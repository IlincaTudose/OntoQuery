<%@page import="org.apache.tools.ant.taskdefs.Available"%>
<%@ page language="java"%>
<%@page import="uk.ac.ebi.chebi.ontology.query.DLQueryServer"%>

<%
    DLQueryServer dlServer = (DLQueryServer) getServletContext().getAttribute( "server");
%>

<link rel="stylesheet" type="text/css" href="css/historyBox.css">
<script src="js/historyBox.js"></script>


<form name="frm" method="get" action="response.jsp">
    <table class="grid_17 boxed-section">
        <tr>
            <td >
                Enter your query in the box, selecting from the suggestions list to construct valid queries.</td></tr>
        <tr>
            <td><div id="editID" class="dl_edit grid_19" contenteditable="true" title="Insert a query in Manchester OWL syntax here."></div>
                <img id="incompleteIcon" src="images/icon_alert.gif"
                     title="The list of suggested terms is too long to be loaded completely. Please type some more characters for more specific results.">
                <input type="submit" name="submit" value="Submit" class="submit"
                       id="submitQuery">
                <a href="OntoQueryHelp.jsp" target="_blank"
                   title="Click here to go to the OntoQuery tutorial page." class="no-underline" style="padding-left: 5px">
                    <img src="http://www.ebi.ac.uk/web_guidelines/images/icons/EBI-Generic/Generic%20icons/info.png" class="helpinfo">
                </a>

            </td>
        </tr>
        <tr>
            <td ><input type="checkbox" id="fuzzySearch"> Perform
                fuzzy search for suggestion list.<br/></td>
        </tr>
        <tr>
            <td>
                Examples: "

                <a href="response.jsp?submit=Submit&hiddenQuery=has_role+some+fungicide+&page=1" class="recentQueries">
                    <span class="relationStyle">has_role </span>
                    <span class="restriction">some </span>
                    <span class="classStyle">fungicide</span>
                </a>" ,


                "<a href="response.jsp?submit=Submit&hiddenQuery=%28+phenols+or+coumarins+%29+and+has_role+some+antiseptic_drug+&page=1" class="recentQueries">
                <span class="paranthesis">(</span>
                <span class="classStyle">phenols </span>
                <span class="restriction">or </span>
                <span class="classStyle">coumarins </span>
                <span class="paranthesis">) </span>
                <span class="booleanConstructor">and </span>
                <span class="relationStyle">has_role </span>
                <span class="restriction">some </span>
                <span class="classStyle">antiseptic_drug </span>
            </a>" .
            </td>
        </tr>
    </table>
    <div id="recentOWLQueries"  class="recentQueries grid_6">
        <!--ul class="recentQueries">
            <li> <a class="recentQueries" href="#" onclick="javascript:histEntryClick('hist1');" id="hist1" >chemical_entity and has_part some chloride or ( chemical_entity and has_part some chloride )</a></li>
            <li> <a class="recentQueries" href="#" onclick="javascript:histEntryClick('hist2');" id="hist2" >chemical_entity and has_part some chloride</a></li>
        </ul-->
    </div>


    <input type="hidden" name="hiddenQuery" id="hiddenQuery">
    <input type="hidden" name="page" value="1">

</form>


<script>

    function getQuery(){
        return $("#editID").text();
    }

    $(function() {
        // Fill autosuggest lists only once.
        if (window.relations == null) {
            var x = "<%=((DLQueryServer) getServletContext().getAttribute( "server")).getRelationNames()%>";
            window.relations = x.split("###");
            // now we need to update the startStates
            window.availableTags = window.startStates.concat(window.relations);
        }
        if (window.classes == null ){
            getMacthingClassNames("."); // initialize
            window.availableTags = window.availableTags.concat(window.classes);
        }

        loadRecentQueries();

        function split( val ) {
            return val.split(/[\s�]+/);
        }

        function extractLast( term ) {
            return split( term ).pop();
        }

        function hide(){
            document.getElementById("incompleteIcon").style.visibility="hidden";
        }

        function unhide(){
            document.getElementById("incompleteIcon").style.visibility="visible";
        }

        function getKeys (arrayOfObjects){
            var tmp = [];
            for (var i = arrayOfObjects.length - 1 ; i >= 0  ; i--){
                tmp.push(arrayOfObjects[i].key);
            }
            return tmp;
        }

        function sortByMatchPosition(myList, pattern){
            // sorts the given list after the position of the pattern
            var pat = pattern.toLowerCase();
            var map = [];
            var i;
            for ( i = 0; i < myList.length; i++){
                // distance = levenstein distance + position of the first match
                var dist = (myList[i].toLowerCase().indexOf(pat) * 10) + levenshteinen(myList[i].toLowerCase(), pat);
                map.push({key: myList[i], value: dist });
            }
            // sort by position numerically and ascending
            map.sort(function(a,b){return (a.value < b.value ? 1 : a.value > b.value ? -1 : 0);});
            // take the names out & return them
            return getKeys(map);
        }

        // calculate the Levenshtein distance between a and b, fob = form object, passed to the function
        function levenshteinen(string_a, string_b) {
            var cost;

            // get values
            var a = string_a;
            var m = a.length;

            var b = string_b;
            var n = b.length;

            // make sure a.length >= b.length to use O(min(n,m)) space, whatever that is
            if (m < n) {
                var c=a;a=b;b=c;
                var o=m;m=n;n=o;
            }

            var r = new Array();
            r[0] = new Array();
            for (var c = 0; c < n+1; c++) {
                r[0][c] = c;
            }

            for (var i = 1; i < m+1; i++) {
                r[i] = new Array();
                r[i][0] = i;
                for (var j = 1; j < n+1; j++) {
                    cost = (a.charAt(i-1) == b.charAt(j-1))? 0: 1;
                    r[i][j] = minimator(r[i-1][j]+1,r[i][j-1]+1,r[i-1][j-1]+cost);
                }
            }

            return r[m][n];
        }

        // return the smallest of the three values passed in
        minimator = function(x,y,z) {
            if (x < y && x < z) return x;
            if (y < x && y < z) return y;
            return z;
        };

        $.ui.autocomplete.prototype._renderItem = function( ul, item){
            var term = this.term.split(' ').pop();
            var re = new RegExp("(" + $.ui.autocomplete.escapeRegex(term, $('#fuzzySearch').is(':checked')) + ")", "gi") ;
            var t = item.label.replace(re,"<b>$1</b>");
            return $( "<li></li>" )
                    .data( "item.autocomplete", item )
                    .append( "<a>" + t + "</a>" )
                    .appendTo( ul );
        };
        $( "#editID" )
            // don't navigate away from the field on tab when selecting an item
                .bind( "keydown", function( event ) {
                    if ( event.keyCode === $.ui.keyCode.TAB &&
                            $( this ).data( "autocomplete" ).menu.active ) {
                        event.preventDefault();
                    }
                })
                .autocomplete({
                    minLength: 1,
                    source: function( request, response ) {
                        // set appropriate class names in available tags
                        setAvailableTags($.ui.autocomplete.escapeRegex(extractLast( request.term) , $('#fuzzySearch').is(':checked')));
                        // delegate back to autocomplete, but extract the last term
                        var results =  $.ui.autocomplete.filter(
                                window.availableTagsWithClasses, extractLast( request.term ), $('#fuzzySearch').is(':checked') ) ;
                        if (results.length > window.suggestListSize)
                            unhide();
                        else hide();
                        response((sortByMatchPosition(results, extractLast( request.term ))).slice(0, window.suggestListSize));
                    },
                    focus: function() {
                        // prevent value inserted on focus
                        return false;
                    },
                    select: function( event, ui ) {
                        var terms = split( $(this).text() );
                        // remove the current input
                        terms.pop();
                        // add the selected item
                        terms.push( ui.item.value );
                        // add placeholder to get the space at the end
                        terms.push( "" );
                        var add = terms.join( " " );
                        // add selected thind to the edit box
                        $(this).html(add);
                        $(this).trigger('editEvent');
                        // hide attention mark for incomplete suggestion list
                        hide();
                        return false;
                    }
                })
                .blur(function(){
                    // hide the exclamation mark if the box loses focus
                    hide();
                })
        ;
    });
</script>

