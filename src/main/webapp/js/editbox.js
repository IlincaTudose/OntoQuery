
$(document).ready(function() {

	var _idleSecondsCounter = 0;
	$("div.dl_edit").keyup(function(e) {
		// Words / tokens must be separated by space!!
		if ((e.keyCode || e.which) == 32){ // space
			$(this).trigger('editEvent');
		}
		if ((e.keyCode || e.which) ==  $.ui.keyCode.DELETE || (e.keyCode || e.which) == $.ui.keyCode.BACKSPACE){ // space
			var splitted = $(this).text().split(/[\s�]+/);
			var lastToken =  splitted.pop();
			while (lastToken === "")
				lastToken = splitted.pop();
			if ($(this).text().lastIndexOf(" ") != ($(this).text().length - 1)){
				lastToken = splitted.pop();
			}
			setAutocompleteList(lastToken);
		}
		_idleSecondsCounter = 0;
	});
	
	$("div.dl_edit").bind('editEvent', function() {
		var text = $(this).text();
		$(this).html(colorText(text));
		var splitted = text.split(/[\s�]+/);
		var lastToken =  splitted.pop();
		while (lastToken === "")
			lastToken = splitted.pop();
		setAutocompleteList(lastToken);
		setEndOfContenteditable(this);
		checkSyntax(text); // this function will change the border-color according to the input text		
		// copy the text in the hidden Input element
		document.getElementById('hiddenQuery').value = $("div.dl_edit").text();
	});	
	
	$("#submitQuery").bind("click", function(){
		$("div.dl_edit").trigger('editEvent');
	});
		
	// reset idle counter on any mouse action
	$("div.dl_edit").bind('mousemove keydown DOMMouseScroll mousewheel mousedown touchstart touchmove', function(){
		_idleSecondsCounter = 0;
	});
	
	window.setInterval(CheckIdleTime, 100); // every one sec
	function CheckIdleTime() {
	    _idleSecondsCounter++;
	    if ((IDLE_TIMEOUT-_idleSecondsCounter) == 0) { 
	    	// check the syntax after the first 5 sec of idle 
	    	checkSyntax($("div.dl_edit").text());
	    }
	}	

	function setAutocompleteList(lastToken){
		if (lastToken == null){
			window.classExpected = true;
			window.availableTags = window.startStates.concat(window.relations);
		}
		else if (contains(window.constructors, lastToken)){
			window.classExpected = true;
			window.availableTags = window.startStates.concat(window.relations);
		}
		else if (contains(window.restrictions, lastToken)){
			window.classExpected = true;
			window.availableTags = window.startStates;
		}
		else if (contains(window.relations, lastToken)){
			window.classExpected = false;
			window.availableTags = window.restrictions;
		}
		else if (checkClass(lastToken)){
			window.classExpected = false;
			window.availableTags = window.constructors;
			if (window.openParantheses > 0){
				window.availableTags = window.availableTags.concat(window.closedParantheses);
			}
		}
		else if (lastToken === ")"){
			window.classExpected = false;
			window.availableTags = window.constructors;
			window.openParantheses--;
			
		}
		else if (lastToken === "("){
			window.classExpected = true;
			window.availableTags = window.startStates.concat(window.relations);
			window.openParantheses++;
		}
		else{
			window.classExpected = true;
			window.availableTags = window.startStates.concat(window.relations);
		}
	}
	
	function setEndOfContenteditable(contentEditableElement)
	{
	    var range,selection;
	    if(document.createRange)//Firefox, Chrome, Opera, Safari, IE 9+
	    {
	        range = document.createRange();//Create a range (a range is a like the selection but invisible)
	        range.selectNodeContents(contentEditableElement);//Select the entire contents of the element with the range
	        range.collapse(false);//collapse the range to the end point. false means collapse to end rather than the start
	        selection = window.getSelection();//get the selection object (allows you to change selection)
	        selection.removeAllRanges();//remove any selections already made
	        selection.addRange(range);//make the range you have just created the visible selection
	    }
	    else if(document.selection)//IE 8 and lower
	    { 
	        range = document.body.createTextRange();//Create a range (a range is a like the selection but invisible)
	        range.moveToElementText(contentEditableElement);//Select the entire contents of the element with the range
	        range.collapse(false);//collapse the range to the end point. false means collapse to end rather than the start
	        range.select();//Select the range (make it the visible selection
	    }
	}
	
	function getText(){
		// returns the simple text from the div, so what the text that the user sees in the "edit box" in nice colors
		return $("div.dl_edit").text();
	}

});


function contains(a, obj) {
    var i = a.length;
    while (i--) {
       if (a[i] === obj) {
           return true;
       }
    }
    return false;
}


function colorThis(introdString){ //decide how to color each term and return html formated string
	if (contains(window.constructors, introdString)){
		return  "<span class=\"booleanConstructor\">"+introdString+" </span>";
	}
	else if (contains(window.restrictions, introdString)){
		return "<span class=\"restriction\">"+introdString+" </span>";
	}
	else if (introdString === "(" ){
		return "<span class=\"paranthesis\">"+introdString+" </span>";
	}
	else if (introdString === ")"){
		return "<span class=\"paranthesis\">"+introdString+" </span>";
	}
	else if(contains(window.relations, introdString)){
		return "<span class=\"relationStyle\">"+introdString+" </span>";
	}
	else {
		return "<span class=\"classStyle\">"+introdString+" </span>";
	}
}


function colorText(text){
	var splitted = text.split(/[\s�]+/);
	var edited = "";
	while (splitted.length > 0){
		var current = splitted.pop();
		if (! (current === "") ){
			edited = colorThis(current) + edited;	
		}
	}
	return edited;
}
	
function setAvailableTags(term){
	if (window.classExpected){
		getMacthingClassNames(term);
		window.availableTagsWithClasses = window.availableTags.concat(window.classes);
	}
	else window.availableTagsWithClasses = window.availableTags;
}

function checkSyntax(inputText){
	// send a request to the server to validate machester syntax.
	$.get("syntaxCheck.jsp", { text: inputText } , function(data){
		window.isValid = data.split("###")[1];
		if (window.isValid === false || window.isValid === "false"){
			document.getElementById("editID").style.borderColor="red";
		}
		else document.getElementById("editID").style.borderColor="#93A3A3";
	});
}

function checkClass(inputText){
	// send a request to the server to validate machester syntax.
	$.ajax({
	     async: false,
	     type: 'GET',
	     url: 'isClass.jsp',
	     data: { text: inputText },
	     success: function(data) {
	 		window.isClass = data.split("###")[1];
	     }
	});
	return window.isClass;
}

function getMacthingClassNames(pattern){
	$.ajax({
	     async: false,
	     type: 'GET',
	     url: 'getMatchesFromServer.jsp',
	     data: { text: pattern },
	     success: function(data) {
	    	 window.classes = data.split("___")[1].split("###");
	     }
	});
}

function pushToHistory(currentQuery, err, resNo){
	var rNo = "&nbsp;&nbsp;&nbsp;(" + resNo + ")";
	if (err.length > 0){
		rNo = "&nbsp;&nbsp;&nbsp;<span class=\"errorStyle\">(" + resNo + ")</span>";
	}
	var cQuery = currentQuery + rNo;
	// add currentQuery to the history array
	$.ajax({
	     async: false,
	     type: 'GET',
	     url: 'histToSession.jsp',
	     data: { add: "true", query: cQuery },
	     success: function(data) {
	    	 window.queryHist = data.split("___")[1].split("###");
	     }
	});
}

function repushToHistory(currentQuery){
	// add currentQuery to the history array
	$.ajax({
	     async: false,
	     type: 'GET',
	     url: 'histToSession.jsp',
	     data: { add: "true", query: currentQuery },
	     success: function(data) {
	    	 window.queryHist = data.split("___")[1].split("###");
	     }
	});
}

function histEntryClick(elementID){
	// save selected query
	var selectedQuery = $(document.getElementById(elementID)).text().split(/\s\s\s/)[0] + " &nbsp;&nbsp;&nbsp;" +
	$(document.getElementById(elementID)).html().split("&nbsp;&nbsp;&nbsp;")[1];
	var realQuery = $(document.getElementById(elementID)).text().split(/\s\s\s/)[0];
	// push 
	repushToHistory(selectedQuery);
	// reload hist box
	loadRecentQueries();
	//put query in the edit box
	$(document.getElementById('editID')).html(realQuery);
	$("div.dl_edit").trigger('editEvent');
}


function loadRecentQueries(){
	getHistList();
	if (window.queryHist.length > 0){
		this._container = $(document.getElementById('recentOWLQueries'));
		this._container.html('');
		jQuery('<h3  class="recentQueries" title="The recent queries box will store the last 10 used queries. The number in brackets indicates the number of results for each query and the red color indicates queries which did not have a valid syntax.">Recent Queries</h3>').appendTo(this._container); 
		this._list = jQuery('<ul class="recentQueries"> </ul>').appendTo(this._container);
		for (var i=0;i<window.queryHist.length;i++){
			jQuery('<li> <a class="recentQueries" href="#" onclick="histEntryClick(\'hist'+(i+1)+'\');" id="hist'+(i+1)+'" >' +
					colorText(window.queryHist[i].split("&nbsp;&nbsp;&nbsp;")[0]) + "&nbsp;&nbsp;&nbsp;" + window.queryHist[i].split("&nbsp;&nbsp;&nbsp;")[1] +
		//			window.queryHist[i] +
					'</a></li>').appendTo(this._list);
		}
	}
}

function getHistList(){	
		$.ajax({
		     async: false,
		     type: 'GET',
		     url: 'histToSession.jsp',
		     data: { add: "false", query: "" },
		     success: function(data) {
		    	 if (data.indexOf("___###___") == -1){
		    	 	var h = data.split("___###")[1];
		    	 	h = h.split("###___")[0];
		    	 	window.queryHist = h.split("###");
		    	 }
		    	 else {
		    		 window.queryHist = [];
		    	 }
		     }
		});
}