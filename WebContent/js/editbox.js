
$(document).ready(function() {

	var _idleSecondsCounter = 0;
	$("div.dl_edit").keyup(function(e) {
		// Words / tokens must be separated by space!!
		if ((e.keyCode || e.which) == 32){ // space
			$(this).trigger('editEvent');
		}
		_idleSecondsCounter = 0;
	});
	
	$("div.dl_edit").bind('editEvent', function() {
		var text = $(this).text();
		$(this).html(colorText(text));
		setAutocompleteList(text);
		setEndOfContenteditable(this);
		checkSyntax(text); // this function will change the border-color accordint to the input text		
		// copy the text in the hidden Input element
		document.getElementById('hiddenQuery').value = $("div.dl_edit").text();
	});	
	
	$("#submitQuery").bind("click", function(){
		$("div.dl_edit").trigger('editEvent');
//		pushToHistory("a");
	});
		
	// reset idle counter on any mouse action
	$("div.dl_edit").bind('mousemove keydown DOMMouseScroll mousewheel mousedown touchstart touchmove', function(){
		_idleSecondsCounter = 0;
	});
	
	window.setInterval(CheckIdleTime, 1000); // every one sec
	function CheckIdleTime() {
	    _idleSecondsCounter++;
	    if ((IDLE_TIMEOUT-_idleSecondsCounter) == 0) { 
	    	// check the syntax after the first 5 sec of idle 
	    	checkSyntax($("div.dl_edit").text());
	    }
	}
	
	function colorText(text){
		var splitted = text.split(/[\s ]+/);
		var edited = "";
		while (splitted.length > 0){
			var current = splitted.pop();
			if (! (current === "") )
				edited = colorThis(current) + edited;
		}
		return edited;
	}
		
	function setAutocompleteList(text){
		splitted = text.split(/[\s ]+/);
		var lastToken =  splitted.pop();
		while (lastToken === "")
			lastToken = splitted.pop();
		if (contains(window.constructors, lastToken)){
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
	
	function colorThis(introducedString){ //decide how to color each term and return html formated string
		if (contains(window.constructors, introducedString)){
			return  "<span class=\"booleanConstructor\">"+introducedString+" </span>";
		}
		else if (contains(window.restrictions, introducedString)){
			return "<span class=\"restriction\">"+introducedString+" </span>";
		}
		else if (introducedString === "(" ){
			return "<span class=\"paranthesis\">"+introducedString+" </span>";
		}
		else if (introducedString === ")"){
			return "<span class=\"paranthesis\">"+introducedString+" </span>";
		}
		else if(contains(window.relations, introducedString))
			return "<span class=\"relationStyle\">"+introducedString+" </span>";
		else return "<span class=\"classStyle\">"+introducedString+" </span>";
	}
	
	function contains(a, obj) {
	    var i = a.length;
	    while (i--) {
	       if (a[i] === obj) {
	           return true;
	       }
	    }
	    return false;
	}
	
	function getText(){
		// returns the simple text from the div, so what the text that the user sees in the "edit box" in nice colors
		return $("div.dl_edit").text();
	}
	
});

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