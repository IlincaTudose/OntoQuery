function pushToHistory(currentQuery){
	// add currentQuery to the history array
	alert("called");
	if ( session.getAttribute("qHist") != null)
		session.setAttribute("qHist", currentQuery + ";;;" + session.getAttribute("qHist"));
	// don't want more than 10 last queries
	else 
		session.setAttribute("qHist", currentQuery);
	alert("done");
}

function getCallingObject(e) {
    e = e || window.event;
    var targ = e.target || e.srcElement;
    if (targ.nodeType == 3) targ = targ.parentNode; // defeat Safari bug
    return targ;
}

function histEntryClick(e){
	alert("clicked!!!");
//	document.cookie = "a=3";
//	alert(document.cookie);
}

function reloadRecentQueries(){
	// parse cookie
	// dynamically build the hist box
}