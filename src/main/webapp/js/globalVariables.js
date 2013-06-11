//ATENTION these lists are global variables. DO not use the same names within the same application!

/*************************************
 * Customizable variables are below. Feel free to change after your own need.
 */

//all Manchester syntax restriction types
var restrictions = [
					"some"/*,
					"only",
					"value",
					"min",
					"exactly",
					"max"*/];

// all Manchester syntax boolean constructors
var constructors = [
					"and",
					"or",
					"not"
					];

//number of sugestions in the grop-down auto-cumplete. In one view 12 entries are shown.
var suggestListSize = 49;

//seconds to wait until automatic syntax check. 
//A check is also performed after each space (so suposedly new word) or each new name inserted from the suggestions.
var IDLE_TIMEOUT = 5; 


/*************************************
 * Please do not change the variables below.
 */

var classes = null; // to add dynamically

var relations = null; //to add dynamically

// all things allowed in "start states", so at the beginning of a class definition
var startStates = ["(", 
                  // "inverse",
                   "not"
                   ];

var closedParantheses = [")"];

var availableTags = startStates;

// not to be changed
var openParantheses = 0;

var isValid = true; // if the query is in valid Manchester syntax

var isClass = false; // for the syntax aware auto suggest

var classExpected = true;

var queryHist = ["chemical_entity and has_part some chloride", "base"];
