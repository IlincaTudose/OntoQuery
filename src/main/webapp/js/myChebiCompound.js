/**
 *
 *
 * @class
 * @extends Biojs
 *
 * @author <a href="mailto:johncar@gmail.com">John Gomez-Carvajal</a>
 * @version 1.0.0
 * @category 2
 *
 * @requires <a href=''>Server side proxy</a>
 *
 * @requires <a href='../biojs/css/ChEBICompound.css'>ChEBICompound.css</a>
 * @dependency <link href="../biojs/css/biojs.ChEBICompound.css" rel="stylesheet" type="text/css" />
 *
 * @requires <a href='http://blog.jquery.com/2011/09/12/jquery-1-6-4-released/'>jQuery Core 1.6.4</a>
 * @dependency <script language="JavaScript" type="text/javascript" src="../biojs/dependencies/jquery/jquery-1.6.4.js"></script>
 *
 * @param {Object} options An object with the options for the component.
 *
 * @option {string} [imageUrl="http://www.ebi.ac.uk/chebi/displayImage.do"]
 *    Url of the web service in order to require the compound image.
 *    To get a compound image, 'imageUrl + id' will be used as URI.
 *
 * @option {string} id
 *    ChEBI identifier of the compound to be displayed (i.e. '4991').
 *
 * @option {int} [height=undefined]
 *    The height in pixels of how big this component should be displayed. If it's not specified, the CSS value will be used instead.
 *
 * @option {int} [width=undefined]
 *    The width in pixels of how big this image should be displayed. If it's not specified, the CSS value will be used instead.
 *
 * @example
 * var instance = new Biojs.ChEBICompound({
 *    target: 'YourOwnDivId',
 *    id: 'CHEBI:2922',
 *    width: 700,
 *    height: 400
 * });
 *
 */
Biojs.ChEBICompound = Biojs.extend(
    /** @lends Biojs.ChEBICompound# */
    {
        constructor: function(options){
            var self = this;
            var width = this.opt.width;
            var height = this.opt.height;
            var imageWidth, imageHeight;
            if ( "string" == (typeof this.opt.target) ) {
                this._container = jQuery( "#" + this.opt.target );

            } else {

                this.opt.target = "biojs_ChEBICompound_" + this.getId();
                this._container = jQuery('<div id="'+ self.opt.target +'"></div>');
            }

//		this._container.html('').addClass("ChEBICompound");

            if ( width == undefined ) {
                width = this._container.css('width');

            } else {
                this._container.width( width );
            }

            if ( height == undefined ) {
                height = this._container.css('height');

            } else {
                this._container.height( height );
            }

            this._container.html('');
            this._table = jQuery('<div class="gridLayoutCellWrap"></div>').appendTo(this._container);
            this._nameContainer=jQuery('<div class="gridLayoutCellTitle"></div>').appendTo(this._table);
            this._imageContainer = jQuery('<div class="gridLayoutCellItems">  </div>').appendTo(this._table);

//		this._imageContainer = jQuery('<ul id="bodynav2" class = "bodynav"> </ul>').appendTo(this._imageContainer);
//		this._imageContainer = jQuery('<li class="bodynavLi"> </li>').appendTo(this._imageContainer);

            // Build the summary left panel
            this._summaryContainer = this._table;

            // Size of the image for the URL request
            imageWidth = this._imageContainer.width();
            imageHeight = this._imageContainer.height();
            this.opt.imageDimension = (imageWidth < imageHeight)? imageWidth: imageHeight;

            if (this.opt.id !== undefined) {
                this.setId(this.opt.id);
            }
        },

        opt: {
            target: 'YourOwnDivId',
            id: undefined,
            imageUrl: 'http://www.ebi.ac.uk/chebi/displayImage.do',
            chebiDetailsUrl: 'http://www.ebi.ac.uk/webservices/chebi/2.0/test/getCompleteEntity?chebiId=',
            proxyUrl: '../biojs/dependencies/proxy/proxy.php',

            height: undefined,
            width: undefined,
            scale: false,
            imageIndex: 0
        },

        eventTypes : [
        /**
         * @name Biojs.ChEBICompound#onRequestError
         * @event
         * @param {function} actionPerformed An function which receives an {@link Biojs.Event} object as argument.
         * @eventData {Object} source The component which did triggered the event.
         * @eventData {string} file The name of the loaded file.
         * @eventData {string} result A string with either value 'success' or 'failure'.
         * @eventData {string} message Error message in case of result be 'failure'.
         *
         * @example
         * instance.onRequestError(
         *    function( e ) {
  		 *       alert( e.message );
  		 *    }
         * );
         *
         * */
            "onRequestError",
        /**
         * @name Biojs.ChEBICompound#onImageLoaded
         * @event
         * @param {function} actionPerformed An function which receives an {@link Biojs.Event} object as argument.
         * @eventData {Object} source The component which did triggered the event.
         * @eventData {string} id The identifier of the loaded file.
         *
         * @example
         * instance.onImageLoaded(
         *    function( e ) {
  		 *       alert( e.id + " loaded." );
  		 *    }
         * );
         *
         * */
            "onImageLoaded"
        ],

        /**
         * Set the identifier of the chemical component.
         * Shows both information and image for the new identifier.
         *
         * @param {string} chebiId Chemical EBI's identifier for the compound to be displayed.
         *
         * @example
         * instance.setId('CHEBI:4991');
         *
         * @example
         * // No image available
         * instance.setId('CHEBI:60004');
         *
         */
        setId: function( chebiId ) {
            var self = this;
            var url;
            var image;

            this._imageContainer.html('');
            this.opt.id = chebiId.replace('CHEBI:','');
            this._requestDetails( this.opt );

            url = this.opt.imageUrl + '?defaultImage=true&imageIndex=0&chebiId=' + chebiId;
//		jQuery('<ul> <li class="bodynavLi" style="background:none; padding:0px; border:0px;"> <a href="'+
//				'http://www.ebi.ac.uk/chebi/searchId.do?chebiId=' + chebiId + '">'+
//				'<img src="' + this.opt.imageUrl + '?defaultImage=true&imageIndex=0&chebiId=' + chebiId
//				+ '" width="200" height="200"  id='+ this.opt.id+'  onerror="hide(id)"  style="border:1px solid black"/>'
//				+' </a></li></ul>').appendTo(this._imageContainer);

            jQuery('<a href="http://www.ebi.ac.uk/chebi/searchId.do?chebiId=' + chebiId + '" id='+ this.opt.id+' >'+
                '<img src="' + this.opt.imageUrl + '?defaultImage=true&imageIndex=0&chebiId=' + chebiId
                + '" width="200" height="200" name='+ this.opt.id+'  onerror="hide(name)" ' +
                'style=" display:block;margin-left: auto;margin-right: auto" />'+'</a>').appendTo(this._imageContainer);

//		image = jQuery('<img id="image_' + chebiId + '"/>');
//		image.attr('src', url)
//        	.load(function() {
///*	           if (!this.complete || typeof this.naturalWidth == "undefined" || this.naturalWidth == 0) {
//	        	   alert("noimage");
//	        	   self._imageContainer.addClass("noImage");
//	        	   self.raiseEvent( Biojs.ChEBICompound.EVT_ON_REQUEST_ERROR, {
//	        		   id: chebiId,
//	        		   url: url,
//	        		   message: "No image available"
//	   			   });
//
//	           } else {
//*/	        	   image.css({
//	        		   	'width': "100",
//	           			'height': "100",
//	           			'margin': "auto"
//	        	   });
//	        	   self._imageContainer.removeClass("noImage");
//	        	   self._imageContainer.append(image);
//	        	   self.raiseEvent( Biojs.ChEBICompound.EVT_ON_IMAGE_LOADED, {
//	        		   id: chebiId,
//	        		   url: url
//	   			   });
////	           }
//        	});


        },

        _requestDetails: function( opt ){
            var self = this;

            var urlSummary = opt.chebiDetailsUrl + opt.id;

            Biojs.console.log( "Requesting summary from: " + urlSummary );

            var httpRequest = {
                url: urlSummary,
                method: "GET",
                /**
                 * @ignore
                 */
                success: function(xml){
                    self._dataReceived(xml);
                },
                /**
                 * @ignore
                 */
                error: function(qXHR, textStatus, errorThrown) {
                    Biojs.console.log("ERROR requesting summary. Response: " + textStatus);
                    self.raiseEvent( Biojs.ChEBICompound.EVT_ON_REQUEST_ERROR, {
                        message: textStatus
                    });
                }
            };

            // Using proxy?
            // Redirect using the proxy and encode all params as url data
            if ( opt.proxyUrl != undefined ) {

                // Redirect to proxy url
                httpRequest.url = opt.proxyUrl;

                // Encode both url and parameters under the param url
                httpRequest.data = [{ name: "url", value: urlSummary }];

                // Data type
                httpRequest.dataType = "text";
            }

            jQuery.ajax(httpRequest);

        },


        // parses the xml file from the request and stores the information in an easy to access way
        _dataReceived: function(xml){
            var data = {};
            var i = 0;
            jQuery.parseXML("<?xml version='1.0' encoding='UTF-8'?><S:Envelope xmlns:S='http://schemas.xmlsoap.org/soap/envelope/'><S:Body><getCompleteEntityResponse xmlns='http://www.ebi.ac.uk/webservices/chebi'><return><chebiId>CHEBI:59740</chebiId><chebiAsciiName>nucleophilic reagent</chebiAsciiName><definition>A reagent that forms a bond to its reaction partner (the electrophile) by donating both bonding electrons.</definition><status>CHECKED</status><entityStar>3</entityStar><Synonyms><data>nucleophile</data><type>SYNONYM</type><source>ChEBI</source></Synonyms><Synonyms><data>nucleophiles</data><type>SYNONYM</type><source>ChEBI</source></Synonyms><Synonyms><data>nucleophilic reagents</data><type>SYNONYM</type><source>ChEBI</source></Synonyms><OntologyParents><chebiName>reagent</chebiName><chebiId>CHEBI:33893</chebiId><type>is a</type><status>CHECKED</status><cyclicRelationship>false</cyclicRelationship></OntologyParents><OntologyParents><chebiName>Lewis base</chebiName><chebiId>CHEBI:39144</chebiId><type>is a</type><status>CHECKED</status><cyclicRelationship>false</cyclicRelationship></OntologyParents><OntologyChildren><chebiName>ammonia</chebiName><chebiId>CHEBI:16134</chebiId><type>has role</type><status>CHECKED</status><cyclicRelationship>false</cyclicRelationship></OntologyChildren><OntologyChildren><chebiName>hydroxylamine</chebiName><chebiId>CHEBI:15429</chebiId><type>has role</type><status>CHECKED</status><cyclicRelationship>false</cyclicRelationship></OntologyChildren><OntologyChildren><chebiName>sodium ethoxide</chebiName><chebiId>CHEBI:52096</chebiId><type>has role</type><status>CHECKED</status><cyclicRelationship>false</cyclicRelationship></OntologyChildren></return></getCompleteEntityResponse></S:Body></S:Envelope>");
            var self = this;
            var stringXML = xml.replace(/^\s+|\s+$/g, '');

            Biojs.console.log("Data received");
            if ( stringXML.length > 0 ) {
                xmlDoc = jQuery.parseXML( stringXML );
                xmlResult = jQuery(xmlDoc).find('return');
                data.chebiAsciiName = { name: "Name", value: xmlResult.find(' > chebiAsciiName').text() };
                data.chebiId = { name: "Identifier", value: xmlResult.find('> chebiId').text() };
                data.definition = { name: "Definition", value: xmlResult.find('> definition').text() };
                data.SecondaryChEBIIds = { name: "Other Identifiers", value: xmlResult.find(' > SecondaryChEBIIds').text() };
                data.entityStar = { name: "Stars", value: xmlResult.find(' > entityStar').text() };

            }
            this._setSummary( data );

            return data;
        },


        _setSummary : function ( data ) {
            Biojs.console.log("_setSummary()");

            var container = this._summaryContainer;

            // Remove all elements in container
            //	container.children().remove();

            if ( Biojs.Utils.isEmpty(data) ) {
                container.append('Not information available');

            } else {
                // Add the summary data
                var title = '<a href="http://www.ebi.ac.uk/chebi/searchId.do?chebiId=' + data["chebiId"].value + '">' +
                    data["chebiAsciiName"].value +'</a>';
                jQuery(title).appendTo(this._nameContainer);

                title = '<div>'+data["chebiId"].value +'</div>';
                jQuery(title).appendTo(this._nameContainer);

//          var id = '<td style="width: 100px;">'+ data["chebiId"].value;
//			jQuery('<td><a href="http://www.ebi.ac.uk/chebi/searchId.do?chebiId=' + data["chebiId"].value + '">' +
//					data["chebiId"].value + '</a>&nbsp;' + data["chebiAsciiName"].value ).appendTo( this._generalContainer );
//			var starsString = "";
//			var stars = data["entityStar"].value;
//			while (stars-- > 0){
//				starsString += '<img src="images/goldenstar.gif">\n';
//			}
//            var title = stars == 3 ?  "This entity has been manually annotated by the ChEBI Team." : "This entity is unchecked by the ChEBI Team.";
//			jQuery(id +' <div title="'+title +'"> Stars: '+ starsString +'</div> </td> ').appendTo( this._generalContainer );

                this.raiseEvent( Biojs.ChEBICompound.EVT_ON_SUMMARY_LOADED,{
                    id: data.Identifier
                });
            }

            Biojs.console.log("_setSummary done");
        },

        _buildTabPanel: function( container, onVisibilityChangeCb ) {

            container.html('');

            var content = jQuery('<div class="content"></div>').appendTo(container);
            var expand = jQuery('<div style="display: none;" class="toggle expand"></div>').appendTo(container);
            var collapse = jQuery('<div class="toggle collapse"/>').appendTo(container);

            var buttonsWidth = parseInt( jQuery('.toggle').css('width'), 10 );
            var contentWidth = container.width() - buttonsWidth;

            container.css( 'left', 0 )
                .find('.toggle')
                .click( function(){
                    // Animate show/hide this tab
                    container.animate({
                            left: ( parseInt( container.css('left'), 10 ) == 0 ? buttonsWidth - container.outerWidth() : 0 ) + "px"
                        },
                        // to call once the animation is complete
                        function() {

                            var visibleWidth = parseInt( container.css('left'), 10 ) == 0 ? container.width() : buttonsWidth;

                            container.find('.toggle').toggle();

                            if ( "function" == typeof onVisibilityChangeCb ) {
                                onVisibilityChangeCb.call( this, collapse.is(':visible'), visibleWidth );
                            }
                        }
                    );
                })
                .css({
                    'float':'right',
                    'position':'relative'
                });

            Biojs.console.log('content width '+ contentWidth);

            content.css({
                'width': contentWidth + "px",
                'height': container.height() + "px",
                'word-wrap': 'break-word'
            });

            return content;
        },

        getHTML: function () {
            return this._container;
        }

    },{
        //Events
        EVT_ON_IMAGE_LOADED: "onImageLoaded",
        EVT_ON_SUMMARY_LOADED: "onSummaryLoaded",
        EVT_ON_REQUEST_ERROR: "onRequestError"

    });

function hide(id){
//    document.getElementById(id).hidden = true;

    var elem = document.getElementById(id) != null ? document.getElementById(id).parentNode : null;
    if (elem != null || elem != undefined) {
        elem.innerHTML = "No structure to display";
        elem.style.paddingLeft = "10px";
    }

}