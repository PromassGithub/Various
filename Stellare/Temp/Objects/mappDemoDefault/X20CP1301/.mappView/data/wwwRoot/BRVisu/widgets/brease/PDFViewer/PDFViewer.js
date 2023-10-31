define([
    'brease/core/BaseWidget',
    'brease/events/BreaseEvent',
    'widgets/brease/PDFViewer/libs/external/pdfobject/pdfobject',
    'brease/config',
    'brease/controller/PopUpManager',
    'brease/decorators/LanguageDependency',
    'brease/controller/KeyboardManager',
    'brease/decorators/DragAndDropCapability'
], function (SuperClass, BreaseEvent, PDFObject, config, popupManager, languageDependency, keyboardManager, dragAndDropCapability) {

    'use strict';

    /**
     * @class widgets.brease.PDFViewer
     * #Description
     * widget allows to embed PDF documents.  
     * @extends brease.core.BaseWidget
     * @aside example pdfviewer
     *
     * @mixins widgets.brease.common.DragDropProperties.libs.DroppablePropertiesEvents
     *
     * @iatMeta studio:license
     * licensed
     * @iatMeta category:Category
     * Media
     * @iatMeta category:IO
     * Output
     * @iatMeta category:Appliance
     * Text
     * @iatMeta category:Performance
     * Medium,High
     * @iatMeta description:short
     * PDF Dokument anzeigen
     * @iatMeta description:de
     * Zeigt ein PDF Dokument und erlaubt dem Benutzer eine Bedienung des Dokuments
     * @iatMeta description:en
     * Displays a PDF document and allows an user interaction with the document
     */

    /**
     * @htmltag examples
     * ##Configuration examples:
     *
     * Example:
     *
     *     <div id="pdf1" data-brease-widget="widgets/brease/PDFViewer" data-brease-options="{'width':833, 'height':550, 'src':'files/test.pdf'}"></div>
     *
     *
     * @breaseNote 
     *
     */

    /**
     * @cfg {Boolean} usePlugin=true
     * @iatStudioExposed
     * @iatCategory Behavior
     * If TRUE (default), a javascript plug-in will be used to display the PDF.
     * If FALSE, the browser's embedded PDF viewer will be used to display the document. 
     * Note: the embedded viewer will typically offer faster performance, but not available on all client platforms.
     */

    /**
     * @cfg {PdfPath} src=''
     * @iatStudioExposed
     * @iatCategory Data
     * @bindable
     * @localizable
     * Path to the pdf file; a text key may be used.
     */

    /**
     * @cfg {UNumber} startPage='0'
     * Loads the document on the configured page number.
     * @groupRefId pdfOpenParameters
     * @groupOrder 1
     * @iatStudioExposed
     * @iatCategory Behavior
     */

    /** 
     * @cfg {String} documentZoom='auto' 
     * Zoom and scroll factors for the displayed document, in the following format: zoom-value, left-offset, top-offset. Note that scroll factors are optional. 
     * Viewer-specific options apply - please consult help for further details.
     * @groupRefId pdfOpenParameters
     * @groupOrder 2
     * @iatStudioExposed
     * @iatCategory Behavior
     */

    /**
     * @cfg {String} namedDest='' 
     * Loads the document at the specified named destination.
     * @groupRefId pdfOpenParameters
     * @groupOrder 3
     * @iatStudioExposed
     * @iatCategory Behavior
     */

    /**
     * @cfg {Boolean} showToolbar='false' 
     * Enable the display of the PDF viewer toolbar (limited compatibility).
     * @groupRefId pdfOpenParameters
     * @groupOrder 4
     * @iatStudioExposed
     * @iatCategory Behavior
     */

    var defaultSettings = {
            usePlugin: true,
            startPage: 0,
            documentZoom: 'auto',
            namedDest: '',
            showToolbar: false
        },

        WidgetClass = SuperClass.extend(function PDFViewer() {
            SuperClass.apply(this, arguments);
        }, defaultSettings),

        p = WidgetClass.prototype;

    p.init = function () {

        // Oct-31-16 (DG): Removing namedest/pagemode from Chrome embedded viewer since they're not supported anyhow
        this.pdfOpenParams = { 'page': '', 'nameddest': '', 'zoom': '', 'toolbar': '' };
        this.inlineOpenParams = undefined;
        this.pdfUrlOptions = undefined;
        this.url = undefined;
        this.deferred = new $.Deferred();
        this.numPad = keyboardManager.getNumPad();

        this.jsViewerPath = 'widgets/brease/PDFViewer/libs/external/pdfjs/web/viewer_br.html';

        if (this.settings.omitClass !== true) {
            this.addInitialClass('breasePDFViewer');
        }
        SuperClass.prototype.init.call(this);

        // Listen to numpad (for page navigation) + full screen request
        _initUserActions(this);

        if (brease.config.editMode) {
            _addEditorSVG(this);
        } else {
            this.el.on(BreaseEvent.WIDGET_READY, this._bind('_checkWidgetReady'));
            _srcTextInit(this);
            this.isFullscreen = false;
        }
    };

    /**
     * @method load
     * Loads a PDF from the source path to pdf document, e.g "Media/Documents/Datasheet.pdf"
     * @param {String} src 
     */
    p.load = function (src) {
        var widget = this;

        this.settings.src = src;

        if (brease.config.preLoadingState) {
            // trigger re-render on next load
            this.settings.reloadAfterPrecache = true;
        } else {
            if (widget.isVisible()) {
                _render(widget);
            }
            /*
                $.when(widget.deferred).done(function (widget) {
                    
                });
            */
        }
    };

    /**
     * @method getSrc
     * Get path of actually loaded pdf.
     * @return {String} Path of loaded PDF document.
     */
    p.getSrc = function () {
        return this.settings.src;
    };

    /**
    * @method setSrc
    * Sets source location of PDF document.
    * @iatStudioExposed
    * @param {String} value Path of the PDF document, e.g. "/Media/HelpPDF.pdf"
    * @paramMeta value:localizable=true
    */
    p.setSrc = function (value, keepKey) {
        if (keepKey !== true) {
            this.settings.srckey = null;
        }
        if (brease.language.isKey(value) === true) {
            this.setSrcKey(brease.language.parseKey(value));
        } else {
            this.load(value);
        }
    };

    /**
     * @method clearSrc
     * Clears source location of PDF document, and removes it from viewer.
     * @iatStudioExposed
     */
    p.clearSrc = function () {
        var sourcePath;

        this.settings.src = '';

        if (this.settings.usePlugin) {
            // PDF.JS
            if (this.pdfFrame) {
                sourcePath = this.pdfFrame.attr('src').replace(/(\?file=)(.*)/g, '?file=');
                document.getElementById(this.pdfFrame.attr('id')).src = sourcePath;
            }
        } else {
            // Chrome Embedded Viewer
            if (this.pdfObject) {
                this.pdfObject.data = '';
            }
        }
    };

    /**
     * @method setStartPage
     * Sets the page shown initially when document is loaded.
     * @param {UNumber} startPage
     */
    p.setStartPage = function (startPage) {
        this.settings.startPage = startPage;
    };

    /**
     * @method getStartPage
     * Returns the page that is configured to be shown initially.
     * @return {UNumber}
     */
    p.getStartPage = function () {
        return this.settings.startPage;
    };

    /**
     * @method setDocumentZoom
     * Sets the zoom value/style for the PDF document.
     * @param {String} documentZoom
     */
    p.setDocumentZoom = function (documentZoom) {
        this.settings.documentZoom = documentZoom;
    };

    /**
     * @method getDocumentZoom
     * Returns the configured value for the zoom value/style of the PDF document.
     * @return {String}
     */
    p.getDocumentZoom = function () {
        return this.settings.documentZoom;
    };

    /**
     * @method setNamedDest
     * Sets the named destination shown initially when document is loaded.
     * @param {String} namedDest
     */
    p.setNamedDest = function (namedDest) {
        this.settings.namedDest = namedDest;
    };

    /**
     * @method getNamedDest
     * Returns the name destination that is configured to be shown initially.
     * @return {String}
     */
    p.getNamedDest = function () {
        return this.settings.namedDest;
    };

    /**
     * @method setShowToolbar
     * Defines whether or not the viewer's toolbar is shown.
     * @param {Boolean} showToolbar
     */
    p.setShowToolbar = function (showToolbar) {
        this.settings.showToolbar = showToolbar;
    };

    /**
     * @method getShowToolbar
     * Returns the setting for the viewer toolbar visibility.
     * @return {Boolean}
     */
    p.getShowToolbar = function () {
        return this.settings.showToolbar;
    };

    /**
     * @method setUsePlugin
     * Sets usePlugin
     * @param {Boolean} usePlugin
     */
    p.setUsePlugin = function (usePlugin) {
        this.settings.usePlugin = usePlugin;
    };

    /**
     * @method getUsePlugin 
     * Returns usePlugin.
     * @return {Boolean}
     */
    p.getUsePlugin = function () {
        return this.settings.usePlugin;
    };

    /**
     * @method goToPage
     * Navigates to a certain page
     * @iatStudioExposed
     * @param {UInteger} value Navigate to this page.
     */
    p.goToPage = function (value) {
        var newPage = Number(value);
        if (Number.isInteger(newPage)) {
            this.settings.goToPage = newPage;
            // TEST
            if (this.isVisible()) {
                _render(this);
            } 
        }
    };

    p.setSrcKey = function (key) {
        if (key !== undefined) {
            this.settings.srckey = key;
            this.setLangDependency(true);
            this.langChangeHandler();
        }
    };

    p.langChangeHandler = function (e) {
        if (this.settings.srckey !== undefined) {
            this.load(brease.language.getTextByKey(this.settings.srckey));
        }
    };

    p._onNumPadSubmit = function (e) {
        this.numPad.removeEventListener(BreaseEvent.SUBMIT, this._bind('_onNumPadSubmit'));
        this.goToPage(e.detail.value);
    };

    p.onBeforeSuspend = function () {
        // _renderEmptyViewer(this);
        SuperClass.prototype.onBeforeSuspend.apply(this, arguments);
    };

    p.suspend = function () {
        _disposeUserActions(this);
        // Clear any page "memory" from widget
        this.settings.goToPage = undefined;
        SuperClass.prototype.suspend.apply(this, arguments);
    };

    p.wake = function () {
        if (this.settings.reloadAfterPrecache) {
            this.settings.reloadAfterPrecache = false;
            this.load(this.settings.src);
        }
        _initUserActions(this);
        SuperClass.prototype.wake.apply(this, arguments);
    };

    p._numPadHandler = function (e) {

        var widgetId = e.detail.widgetId,
            npValue,
            minValue,
            maxValue,
            numPadSettings = {};

        if (this.el && this.elem && this.elem.id === widgetId) {
            npValue = parseInt(e.detail.value);
            minValue = parseInt(e.detail.minValue);
            maxValue = parseInt(e.detail.maxValue);

            numPadSettings = {
                minValue: minValue,
                maxValue: maxValue,
                value: npValue,
                pointOfOrigin: 'element',
                format: { default: { decimalPlaces: 0, minimumIntegerDigits: 1 } }
            };

            this.numPad.addEventListener(BreaseEvent.SUBMIT, this._bind('_onNumPadSubmit'));
            this.numPad.show(numPadSettings, this.elem);
        }
    };

    p._checkWidgetReady = function () {
        this.deferred.resolve();
    };

    p._visibleHandler = function () {
        var widget = this;

        $.when(widget.deferred).done(function () {
            if (widget.isVisible()) {
                widget.load(widget.settings.src);
            }
        });
    };

    p._fullScreenHandler = function (e) {
        var widgetId = e.detail.widgetId;

        if (this.elem && this.elem.id === widgetId) {
            _toggleFullscreen(this);
        }
    };

    p.dispose = function () {
        window.clearTimeout(this.embedTimout);
        _unbindNumPad(this);
        _disposeUserActions(this);
        //Clear any page "memory" from widget
        this.settings.goToPage = undefined;
        SuperClass.prototype.dispose.apply(this, arguments);
    };

    /**
     * @event Click
     * @hide
     */

    /**
     * @event DisabledClick
     * @hide
     */

    p._clickHandler = function (e) {
        // Click event removed from the PDFViewer widget
    };

    /**
     * Private Methods
     */

    function _unbindNumPad(widget) {
        if (widget.numPad && widget.numPad.elem) {
            widget.numPad.removeEventListener(BreaseEvent.SUBMIT, widget._bind('_onNumPadSubmit'));
        }
    }

    function _initUserActions(widget) {
        // Listen to numpad request for page change + full screen request
        document.addEventListener('openNumPad.PDFViewer', widget._bind('_numPadHandler'));
        document.addEventListener('requestFullscreen.PDFViewer', widget._bind('_fullScreenHandler'));
    }

    function _disposeUserActions(widget) {
        // Remove listeners for numpad and full screen requests
        document.removeEventListener('openNumPad.PDFViewer', widget._bind('_numPadHandler'));
        document.removeEventListener('requestFullscreen.PDFViewer', widget._bind('_fullScreenHandler'));
    }

    function _srcTextInit(widget) {
        if (widget.settings.src !== undefined) {
            if (brease.language.isKey(widget.settings.src) === false) {
                widget.setSrc(widget.settings.src);
            } else {
                widget.setSrcKey(brease.language.parseKey(widget.settings.src));
            }
        }
    }

    // eslint-disable-next-line no-unused-vars
    function _embed(widget) {

        if (brease.config.editMode !== true) {
            _pdfOpenParamHandler(widget);

            if (widget.settings.src) {
                if (widget.settings.usePlugin === false) {

                    widget.pdfObject = _createPDFObject(widget);
                    if (widget.pdfObject === false) {
                        widget.el.html('<p style="width:80%; padding:2%;text-align:center;font-weight:bold;margin:auto;display:block;border:1px solid red;">no plugin available to display pdf documents</p>').css({ 'background-color': '#ffffff', width: widget.settings.width + 'px', height: widget.settings.height + 'px' });
                    }
                } else {
                    _includeAlternativeViewer(widget);
                }
            } else {
                if (config.warn === true) {
                    console.iatWarn('No PDF source given at widget PDFViewer[id="' + widget.elem.id + '"]');
                }
            }
        }
    }

    function _render(widget) {
        var url;

        if (brease.config.editMode !== true) {

            if (widget.settings.src !== undefined) {

                widget.inlineOpenParams = _extractInlineOpenParams(widget.settings.src);

                if (widget.settings.usePlugin === false) {
                    // BROWSER EMBEDDED VIEWER
                    if (widget.inlineOpenParams !== undefined) {
                        url = _parseUrl(widget.settings.src, true);
                    } else {
                        url = _parseUrl(widget.settings.src, false);
                    }

                    _pdfOpenParamHandler(widget);
                    if (widget.settings.goToPage !== undefined) {
                        widget.pdfOpenParams.page = widget.settings.goToPage;
                    }
                    widget.pdfObject = _createPDFObject(widget, url);

                    // check whether embedded viewer really exists
                    if (widget.pdfObject === false) {
                        widget.el.html('<p style="width:80%; padding:2%;text-align:center;font-weight:bold;margin:auto;display:block;border:1px solid red;">no plugin available to display pdf documents</p>').css({ 'background-color': '#ffffff', width: widget.settings.width + 'px', height: widget.settings.height + 'px' });
                    }
                } else {
                    // PDF.JS VIEWER
                    if (widget.pdfFrame === undefined) {
                        _includeAlternativeViewer(widget); // check on this!
                    }

                    url = _parseUrl(widget.settings.src, false);

                    if (widget.inlineOpenParams !== undefined) {

                        if (widget.settings.goToPage !== undefined) {
                            // modify path string, find 'page=', replace by 'page='+goToPage, if not found append after #
                            if (/page=/.test(url) === true) {
                                url = url.replace(/page=\w*/, 'page=' + widget.settings.goToPage);
                            } else {
                                url = url.replace(/#/, '#page=' + widget.settings.goToPage + '&');
                            }
                        }
                        widget.pdfFrame.attr('src', widget.jsViewerPath + '?file=' + url + '&widgetId=' + widget.elem.id);
                    } else {
                        _pdfOpenParamHandlerIFrame(widget);
                        if (widget.settings.goToPage !== undefined) {
                            widget.pdfUrlOptions = widget.pdfUrlOptions.replace(/page=\w*/, 'page=' + widget.settings.goToPage);
                        }
                        widget.pdfFrame.attr('src', widget.jsViewerPath + '?file=' + url + '&widgetId=' + widget.elem.id + widget.pdfUrlOptions);
                    }
                }
            } else {
                if (config.warn === true) {
                    console.iatWarn('No PDF source given at widget PDFViewer[id="' + widget.elem.id + '"]');
                }
            }
        }
    }

    // function _renderEmptyViewer(widget) {
    //     var url = '';

    //     if (brease.config.editMode !== true) {

    //         widget.settings.src = null;

    //         if (widget.settings.usePlugin === false) {
    //             widget.pdfObject = _createPDFObject(widget, url);

    //             // check whether embedded viewer really exists
    //             if (widget.pdfObject === false) {
    //                 widget.el.html('<p style="width:80%; padding:2%;text-align:center;font-weight:bold;margin:auto;display:block;border:1px solid red;">no plugin available to display pdf documents</p>').css({ 'background-color': '#ffffff', width: widget.settings.width + 'px', height: widget.settings.height + 'px' });
    //             }
    //         } else {
    //             widget.pdfFrame.attr('src', widget.jsViewerPath + '&widgetId=' + widget.elem.id);
    //         }
    //     }
    // }

    /**
     * @method _pdfOpenParamHandler
     * @private
     * Assembles start option object for PDFObject (embedded viewer, usePlugin=false).
     * sets the option string, to be concatenated with url
     * -------------------------
     * @param {Object}  widget
     */
    function _pdfOpenParamHandler(widget) {

        var s = widget.settings,
            p = widget.pdfOpenParams,
            i = widget.inlineOpenParams;

        // Assemble pdfOpenParams object that is passed to embedded viewer
        if (i !== undefined) {
            p.page = (i.page === undefined) ? '' : i.page;
            p.zoom = (i.zoom === undefined) ? '' : i.zoom;
            p.nameddest = (i.nameddest === undefined) ? '' : i.nameddest;
            p.toolbar = (i.showToolbar === true) ? 1 : 0;
        } else {
            p.page = (s.startPage === undefined || s.startPage === 0) ? '' : s.startPage;
            p.zoom = (s.documentZoom === undefined || s.documentZoom === 'auto') ? '' : s.documentZoom;
            p.nameddest = (s.namedDest === undefined) ? '' : s.namedDest;
            p.toolbar = (s.showToolbar === true) ? 1 : 0;
        }
    }

    /**
     * -------------------------
     * FUNCTION _pdfOpenParamHandlerIFrame
     * -------------------------
     * Assembles start option string for PDF.JS (usePlugin=true)
     * -------------------------
     * parameters:  widget
     * returns:     option string, to be concatenated with url
     */
    function _pdfOpenParamHandlerIFrame(widget) {
        var s = widget.settings,
            opt = '';

        // currently we are embedding PDF.JS manually with a <iframe>; options need to be added to the url path
        if (s.namedDest === '' || s.namedDest === undefined || s.goToPage !== undefined) {
            opt = (s.startPage === '' || s.startPage === undefined || s.startPage === 0) ? '#page=' : '#page=' + s.startPage;
        } else {
            opt = '#page=&nameddest=' + s.namedDest;
        }
        opt = (s.documentZoom === '' || s.documentZoom === undefined) ? (opt + '&zoom=') : (opt + '&zoom=' + s.documentZoom);
        opt = (s.showToolbar === true) ? (opt + '&toolbar=1') : (opt + '&toolbar=0');

        widget.pdfUrlOptions = opt;
    }

    function _createPDFObject(widget, url) {

        var width = widget.settings.width,
            height = widget.settings.height;

        return new PDFObject({
            url: url,
            width: width + 'px',
            height: height + 'px',
            pdfOpenParams: widget.pdfOpenParams
        }).embed(widget.elem.id);
    }

    function _includeAlternativeViewer(widget) {
        var jsViewerPath = widget.jsViewerPath;

        widget.pdfFrame = $('<iframe id="PDFViewerFrame_' + widget.elem.id + '" src="' + jsViewerPath + '?file=' + '&widgetId=' + widget.elem.id + widget.pdfUrlOptions + '" style="display: block;border:none; margin:0; padding:0;width:100%;height:100%"></iframe>');
        widget.el.html(widget.pdfFrame);
    }

    /**
     * -------------------------
     * FUNCTION _parseUrl
     * -------------------------
     * parameters:  url --> string path for PDF source
     *              chopParams --> TRUE: remove everything after #, FALSE: leave intact
     * return:      url path
     */
    function _parseUrl(url, chopParams) {
        // eslint-disable-next-line no-unused-vars
        var inlineOpenParams,
            // eslint-disable-next-line no-unused-vars
            returnObj = {};

        if (url.substring(0, 1) !== '/' && url.substring(0, 4) !== 'http') {
            var base = $('base').attr('href');
            url = base + url;
        }
        if (chopParams) {
            url = url.replace(/#(.*)/, '');
        }

        return url;

        /*
            inlineOpenParams = _extractInlineOpenParams(url);
            url = url.replace(/#(.*)/,'');
    
            // this should still be returned for compatibility
            returnObj = {'url':url, 'inlineOpenParams':inlineOpenParams};
            return returnObj;
        */
    }

    /**
     * ---------------------------------
     * FUNCTION _extractInlineOpenParams
     * ---------------------------------
     * parameter:   url --> string path for PDF source
     * return:      inline PDF Open Parameters as object
     */
    function _extractInlineOpenParams(url) {
        var parameterStringObj = [],
            urlOpenParams,
            i;

        if (/#/.test(url) === true) {
            urlOpenParams = '';
            parameterStringObj = url.match(/#(.*)/).pop().split(/&/);

            for (i = 0; i <= parameterStringObj.length - 1; i += 1) {
                urlOpenParams = urlOpenParams + parameterStringObj[i].replace(/(.*?)=(.*)/, '{"$1":"$2"}');
            }
            urlOpenParams = urlOpenParams.replace(/}{/g, ',');
            urlOpenParams = JSON.parse(urlOpenParams);
        }
        return urlOpenParams;
    }

    function _toggleFullscreen(widget) {
        if (widget.isFullscreen === false) {
            var maxZindex = popupManager.getHighestZindex();
            brease.bodyEl.addClass('fullscreenPDFViewer');
            widget.pdfFrame.css({ 'z-index': maxZindex + 1, position: 'absolute', top: '0px', left: '0px', width: '100%', height: '100%' }).appendTo(document.body);
            widget.isFullscreen = true;
        } else {
            brease.bodyEl.removeClass('fullscreenPDFViewer');
            widget.pdfFrame.css({ 'z-index': 0, position: 'relative', top: '0px', left: '0px', width: _parseSize(widget.settings.width), height: _parseSize(widget.settings.height) }).appendTo(widget.el);
            widget.isFullscreen = false;
        }
    }

    function _parseSize(size) {
        size = size + '';
        return (size.indexOf('%') !== -1) ? size : size + 'px';
    }

    function _addEditorSVG(widget) {
        widget.el.addClass('iatd-outline');
        widget.el.css('background-image', 'url("widgets/brease/PDFViewer/assets/PDF.svg")');
    }

    return dragAndDropCapability.decorate(languageDependency.decorate(WidgetClass, false), false);

});
