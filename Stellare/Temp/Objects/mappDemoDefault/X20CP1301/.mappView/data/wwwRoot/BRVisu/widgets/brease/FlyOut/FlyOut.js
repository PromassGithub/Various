define([
    'brease/core/ContainerWidget',
    'brease/events/BreaseEvent',
    'brease/enum/Enum',
    'brease/core/Utils',
    'brease/controller/PopUpManager'
], function (SuperClass, BreaseEvent, Enum, Utils, popupManager) {
    'use strict';
    /**
     * @class widgets.brease.FlyOut
     * @extends brease.core.ContainerWidget
     * @requires widgets.brease.ToggleButton
     *
     * @iatMeta studio:visible
     * true
     * @iatMeta studio:license
     * licensed
     * @iatMeta studio:isContainer
     * true
     *
     * @iatMeta category:Category
     * Container
     * @iatMeta description:short
     * Ausblendbares Containerfeld
     * @iatMeta description:de
     * Ausblendbarer Container
     * @iatMeta description:en
     * Hideable container
     */

    /**
     * @property {WidgetList} [parents=["system.brease.Content"]]
     * @inheritdoc  
     */

    /**
     * @cfg {brease.enum.ImageAlign} docking='left'
     * @iatStudioExposed
     * @iatCategory Appearance
     * position of the flyout widget
     */

    /**
     * @cfg {ImagePath} image=''
     * @iatStudioExposed
     * @bindable
     * @iatCategory Appearance
     * Path to an optional image.
     * <br>When svg - graphics are used, be sure that in your *.svg-file height and width attributes are specified on the &lt;svg&gt; element.
     * For more detailed information see https://www.w3.org/TR/SVG/struct.html (chapter 5.1.2)
     */

    /**
     * @cfg {Boolean} autoClose=false
     * @iatStudioExposed
     * @iatCategory Behavior
     * close Flyout on click outside the content
     * if true and the FlyOut is open and the user clicks somewhere outside the FlyOut, it closes automatically
     */

    /**
     * @cfg {brease.enum.ImageAlign} imageAlign='left'
     * @iatStudioExposed
     * @iatCategory Appearance
     * Position of image relative to text.
     */

    /**
     * @cfg {String} text=''
     * @localizable
     * @iatStudioExposed
     * @bindable
     * @iatCategory Appearance
     * Text displayed in the FlyOut button
     */

    /**
     * @cfg {Integer} buttonOffset=0
     * @iatStudioExposed
     * @iatCategory Appearance
     * Offset of the button
     */

    /**
     * @cfg {brease.enum.DialogMode} mode='modeless'
     * @iatStudioExposed
     * @iatCategory Behavior
     * Similar to a pop-up dialog window, this option determines if the user can ('modeless') or cannot ('modal') interact with the remainder of the UI.
     */

    /**
     * @cfg {Boolean} showOnTop=false
     * @iatStudioExposed
     * @iatCategory Behavior
     * When TRUE, forces the FlyOut above all other elements in the visualization.
     */

    /**
     * @cfg {Boolean} showButton=true
     * @iatStudioExposed
     * @iatCategory Behavior
     * When FALSE, this property makes the FlyOut button invisible. The FlyOut must then be opened and closed via the widget's actions (Open, Close, Toggle).
     */

    /**
     * @cfg {StyleReference} buttonStyle='default'
     * @iatStudioExposed
     * @iatCategory Appearance
     * @typeRefId widgets.brease.ToggleButton
     * Style of the Button
     * Use the styles of the widget widgets.brease.ToggleButton
     */

    /**
     * @cfg {Boolean} ellipsis=false
     * @iatStudioExposed
     * @iatCategory Behavior
     * If true, overflow of text is symbolized with an ellipsis. This option has no effect, if wordWrap = true.
     */

    /**
     * @cfg {Boolean} wordWrap=false
     * @iatStudioExposed
     * @iatCategory Behavior
     * If true, text will wrap when necessary.
     * This property has no effect, if multiLine=false
     */

    /**
     * @cfg {Boolean} multiLine=false
     * @iatStudioExposed
     * @iatCategory Behavior
     * If true, more than one line is possible.
     * Text will wrap when necessary (if property wordWrap is set to true) or at explicit line breaks (\n).
     * If false, text will never wrap to the next line. The text continues on the same line.
     */
    
    /**
     * @method showTooltip
     * @hide
     */

    var defaultSettings = {
            docking: Enum.ImageAlign.left,
            buttonHeight: 50,
            buttonWidth: 50,
            buttonImageAlign: Enum.ImageAlign.left,
            ellipsis: false,
            wordWrap: false,
            multiLine: false,
            mode: Enum.DialogMode.MODELESS,
            showOnTop: false,
            showButton: true,
            dimmerOn: false,
            buttonStyle: 'default',
            autoClose: false,
            // styling information used as calcluation base.. set default values here
            width: 100,
            height: 200
        },

        WidgetClass = SuperClass.extend(function FlyOut(elem, options, deferredInit, inherited) {
            SuperClass.call(this, elem, options, false, true);
        }, defaultSettings),

        p = WidgetClass.prototype;

    p.init = function () {

        var widget = this;

        if (this.settings.omitClass !== true) {
            this.addInitialClass('breaseFlyOut');
        }
        if (brease.config.editMode) {
            this.settings.enable = true;
        }
        SuperClass.prototype.init.call(this, true);

        this.contentWrapper = this.container;

        this.el.wrapInner('<div class="breaseFlyOutWrapper" />');
        this.flyOutWrapper = this.el.find('.breaseFlyOutWrapper');

        //add button
        this.buttonId = Utils.uniqueID(this.elem.id + '_child');
        this.flyOutWrapper.one(BreaseEvent.CONTENT_PARSED, this._bind('_wrapperParsedHandler'));

        this.bodyWrapper = $("<div class='breaseFlyOut' />")
            .attr('id', this.elem.id + '_breaseFlyOutWrapper');
        if (!brease.config.editMode) {
            this.bodyWrapper.css({ top: 0, left: 0 });
        }
        
        this._initEventHandler();

        // Add dimmer to DOM structure
        if (this.dimmer === undefined && this.settings.mode === Enum.DialogMode.MODAL && !brease.config.editMode) {
            this.dimmer = $('<div/>').attr('id', 'Dimmer_' + this.elem.id).addClass('breaseModalDimmer init-only');
            this.dimmer.css('display', 'none');
        }

        this.settings.buttonTooltip = this.settings.tooltip;
        this.settings.tooltip = '';

        brease.uiController.createWidgets(this.flyOutWrapper[0], [{
            className: 'ToggleButton',
            id: this.buttonId,
            options: $.extend(true, this.settings.buttonSettings,
                {
                    text: this.settings.text,
                    image: this.settings.image,
                    imageAlign: this.settings.imageAlign,
                    ellipsis: this.settings.ellipsis,
                    wordWrap: this.settings.wordWrap,
                    multiLine: this.settings.multiLine,
                    style: this.settings.buttonStyle,
                    tooltip: this.settings.buttonTooltip,
                    droppable: false,
                    omitDisabledClick: true
                })
        }], true, this.settings.parentContentId);

        this.setStyle(this.settings.style);

        this.flyOutReady = new $.Deferred();
        this.flyOutReady.promise();

        this.toggleButtonReady = new $.Deferred();
        this.toggleButtonReady.promise();
        
        this.el.on(BreaseEvent.WIDGET_READY, widget._bind('_widgetReadyHandler'));
        this.flyOutWrapper.on(BreaseEvent.WIDGET_READY, widget._bind('_buttonReadyHandler'));

        if (brease.config.editMode) {

            require(['widgets/brease/FlyOut/libs/EditorHandles'], function (EditorHandles) {
                var editorHandles = new EditorHandles(widget);

                widget.getHandles = function () {
                    return editorHandles.getHandles();
                };
            
                widget.isRotatable = function () {
                    return editorHandles.isRotatable();
                };

                widget.designer.getSelectionDecoratables = function () {
                    return editorHandles.getSelectionDecoratables();
                };
            });

            // Provide access to function for designer
            this._updateEditDimensions = function () {
                _updateEditDimensions.call(this);
            };

            this.el.css('overflow', 'visible');
            
        } else {
            _setInitialZIndex(this);
            if (this.isHidden) {
                _setVisibility.call(this, this.isHidden);
            }
        }
    };

    p.setStyle = function (style) {
        if (this.bodyWrapper) {
            this.bodyWrapper.removeClass(this.settings.stylePrefix + '_style_' + this.settings.style);
        }
        SuperClass.prototype.setStyle.call(this, style);
        if (this.bodyWrapper) {
            this.bodyWrapper.addClass(this.settings.stylePrefix + '_style_' + this.settings.style);
        }
    };

    /**
     * @method setDocking
     * Sets docking
     * @param {brease.enum.ImageAlign} docking
     */
    p.setDocking = function (docking) {
        this.settings.docking = docking;

        if (brease.config.editMode) {

            this.flyOutWrapper.css({ top: 'auto', left: 'auto', right: 'auto', bottom: 'auto' });
            this.elem.style.removeProperty('left');
            this.elem.style.removeProperty('top');
            this.elem.style.removeProperty('right');
            this.elem.style.removeProperty('bottom');
            this.bodyWrapper.css({ top: 'auto', left: 'auto', right: 'auto', bottom: 'auto' });
            this.button.css('position', 'relative');
            this.container.css('position', 'relative');
            this.container.css('bottom', 'auto');
            switch (this.settings.docking) {

                case Enum.ImageAlign.top:
                case Enum.ImageAlign.bottom:
                {
                    this.distance = parseInt(this.settings.height, 10);
                    this.bodyWrapper.css({
                        width: this.contentWrapper.outerWidth(),
                        height: this.contentWrapper.outerHeight() + this.button.outerHeight()
                    });
                    break;
                }
                case Enum.ImageAlign.left:
                case Enum.ImageAlign.right:
                {
                    this.distance = parseInt(this.settings.width, 10);
                    this.bodyWrapper.css({
                        width: this.contentWrapper.outerWidth() + this.button.outerWidth(),
                        height: this.contentWrapper.outerHeight()
                    });
                    break;
                }

            }

            if (this.el.hasClass('show')) {
                _updateDocking.call(this);
                _updateEditDimensions.call(this);
            } else {
                this.show();
                _updateDocking.call(this);
                _updateEditDimensions.call(this);
                this.hide();
            }
        }
    };

    /**
     * @method getDocking 
     * Returns docking.
     * @return {brease.enum.ImageAlign}
     */
    p.getDocking = function () {
        return this.settings.docking;
    };

    /**
     * @method setImage
     * @iatStudioExposed
     * Sets image
     * @param {ImagePath} image
     */
    p.setImage = function (image) {
        var self = this;

        $.when(this.flyOutReady).done(function () {
            self.settings.image = image;
            brease.callWidget(self.buttonId, 'setImage', self.settings.image);
        });
    };

    /**
     * @method getImage 
     * Returns image.
     * @return {ImagePath}
     */
    p.getImage = function () {
        return this.settings.image;
    };

    /**
     * @method setAutoClose
     * Sets autoClose
     * @param {Boolean} autoClose
     */
    p.setAutoClose = function (autoClose) {
        this.settings.autoClose = autoClose;
    };

    /**
     * @method getAutoClose 
     * Returns autoClose.
     * @return {Boolean}
     */
    p.getAutoClose = function () {
        return this.settings.autoClose;
    };

    /**
     * @method setImageAlign
     * Sets imageAlign
     * @param {brease.enum.ImageAlign} imageAlign
     */
    p.setImageAlign = function (imageAlign) {
        var self = this;

        $.when(this.flyOutReady).done(function () {
            self.settings.imageAlign = imageAlign;
            brease.callWidget(self.buttonId, 'setImageAlign', self.settings.imageAlign);
        });
    };

    /**
     * @method getImageAlign 
     * Returns imageAlign.
     * @return {brease.enum.ImageAlign}
     */
    p.getImageAlign = function () {
        return this.settings.imageAlign;
    };

    /**
    * @method setText
    * @iatStudioExposed
    * Sets text
    * @param {String} text
    * @paramMeta text:localizable=true
    */
    p.setText = function (text) {
        var self = this;

        $.when(this.flyOutReady).done(function () {
            self.settings.text = text;
            brease.callWidget(self.buttonId, 'setText', self.settings.text);
        });
    };

    /**
     * @method getText 
     * Returns text.
     * @return {String}
     */
    p.getText = function () {
        return this.settings.text;
    };

    /**
     * @method setButtonOffset
     * Sets buttonOffset
     * @param {Integer} buttonOffset
     */
    p.setButtonOffset = function (buttonOffset) {
        this.settings.buttonOffset = buttonOffset;

        if (brease.config.editMode) {
            this._setButtonOffset();
            _updateEditDimensions.call(this);
        }
    };

    /**
     * @method getButtonOffset 
     * Returns buttonOffset.
     * @return {Integer}
     */
    p.getButtonOffset = function () {
        return this.settings.buttonOffset;
    };

    /**
     * @method setButtonStyle
     * Sets buttonStyle
     * @param {StyleReference} buttonStyle
     */
    p.setButtonStyle = function (buttonStyle) {
        var self = this;

        $.when(this.flyOutReady).done(function () {
            self.settings.buttonStyle = buttonStyle;
            brease.callWidget(self.buttonId, 'setStyle', self.settings.buttonStyle);
        });
    };

    /**
     * @method getButtonStyle 
     * Returns buttonStyle.
     * @return {String}
     */
    p.getButtonStyle = function () {
        return this.settings.buttonStyle;
    };

    /**
     * @method setMode
     * Sets the dialog mode for the FlyOut
     * @param {brease.enum.DialogMode} mode
     */
    p.setMode = function (mode) {
        this.settings.mode = mode;
    };

    /**
     * @method getMode 
     * Returns status for dialog mode property.
     * @return {brease.enum.DialogMode}
     */
    p.getMode = function () {
        return this.settings.mode;
    };

    /**
     * @method setShowOnTop
     * Sets the stacking mode for the FlyOut
     * @param {Boolean} showOnTop
     */
    p.setShowOnTop = function (showOnTop) {
        this.settings.showOnTop = showOnTop;
    };

    /**
     * @method getShowOnTop
     * Returns the stacking mode for the FlyOut
     * @return {Boolean}
     */
    p.getShowOnTop = function () {
        return this.settings.showOnTop;
    };

    /**
      * @method setShowButton
      * Configures whether or not to use the FlyOut button
      * @param {Boolean} showButton
      */
    p.setShowButton = function (showButton) {
        this.settings.showButton = showButton;

        if (brease.config.editMode) {
            this._setButtonVisibility();
        }
    };

    /**
     * @method getShowButton
     * Returns the status of the showButton property
     * @return {Boolean}
     */
    p.getShowButton = function () {
        return this.settings.showButton;
    };

    /**
     * @method setEllipsis
     * Sets ellipsis
     * @param {Boolean} ellipsis
     */
    p.setEllipsis = function (ellipsis) {
        var self = this;

        $.when(this.flyOutReady).done(function () {
            self.settings.ellipsis = ellipsis;
            brease.callWidget(self.buttonId, 'setEllipsis', self.settings.ellipsis);
        });
    };

    /**
     * @method getEllipsis 
     * Returns ellipsis.
     * @return {Boolean}
     */
    p.getEllipsis = function () {
        return this.settings.ellipsis;
    };

    /**
     * @method setWordWrap
     * Sets wordWrap
     * @param {Boolean} wordWrap
     */
    p.setWordWrap = function (wordWrap) {
        var self = this;

        $.when(this.flyOutReady).done(function () {
            self.settings.wordWrap = wordWrap;
            brease.callWidget(self.buttonId, 'setWordWrap', self.settings.wordWrap);
        });
    };

    /**
     * @method getWordWrap 
     * Returns wordWrap.
     * @return {Boolean}
     */
    p.getWordWrap = function () {
        return this.settings.wordWrap;
    };

    /**
     * @method setMultiLine
     * Sets multiLine
     * @param {Boolean} multiLine
     */
    p.setMultiLine = function (multiLine) {
        var self = this;

        $.when(this.flyOutReady).done(function () {
            self.settings.multiLine = multiLine;
            brease.callWidget(self.buttonId, 'setMultiLine', self.settings.multiLine);
        });
    };

    /**
     * @method getMultiLine 
     * Returns multiLine.
     * @return {Boolean}
     */
    p.getMultiLine = function () {
        return this.settings.multiLine;
    };

    /**
     * @method open
     * @iatStudioExposed
     * Open the FlyOut widget.
     */
    p.open = function () {

        if (this.isDisabled) { return; }
        
        _setZIndex(this);
        this.show();
        _updateButtonToggleState(this, true);
    };

    /**
     * @method close
     * @iatStudioExposed
     * Close the FlyOut widget.
     */
    p.close = function () {
        if (this.isDisabled) { return; }
        
        _resetZIndex(this);
        this.hide();
        _updateButtonToggleState(this, false);
    };

    /**
     * @method toggle
     * @iatStudioExposed
     * Open the FlyOut widget.
     */
    p.toggle = function () {

        if (this.isDisabled) { return; }

        if (this.el.hasClass('show')) {
            _resetZIndex(this);
            this.hide();
            _updateButtonToggleState(this, false);
        } else {
            _setZIndex(this);
            this.show();
            _updateButtonToggleState(this, true);
        }
    };

    p._wrapperParsedHandler = function () {
        this.button = $('#' + this.buttonId);
        this.button.addClass('flyoutButton');
        this._setButtonOffset();
        this._setButtonVisibility();
        _updateEditDimensions.call(this);

        if (brease.config.preLoadingState === true) {
            this._dispatchReady();
        } else {
            _addListeners(this);
        }
    };

    p._setButtonOffset = function () {

        if (this.settings.buttonOffset === undefined) {
            return;
        }
        var offset = this.settings.buttonOffset;

        switch (this.settings.docking) {
            case Enum.ImageAlign.top:
                this.button.css('left', offset);
                break;
            case Enum.ImageAlign.right:
                this.button.css('top', offset);
                break;
            case Enum.ImageAlign.bottom:
                this.button.css('left', offset);
                break;

            case Enum.ImageAlign.left:
                this.button.css('top', offset);
                break;
        }
    };

    p._setButtonVisibility = function () {

        if (this.settings.showButton === true) {
            if (!brease.config.editMode) {
                this.button.css('visibility', 'visible');
            } else {
                // cannot set visibility to false --> still need button to operate the FlyOut
                this.button.css('opacity', 1);
                this.button.removeClass('iatd-outline');
            } 
        } else {
            if (!brease.config.editMode) {
                this.button.css('visibility', 'hidden');
            } else {
                // cannot set visibility to false --> still need button to operate the FlyOut
                this.button.css('opacity', 0.1);
                this.button.addClass('iatd-outline');
            }   
        }

    };

    p._setInitialPosition = function () {
        var container;

        window.clearTimeout(this.initPosTmOut);
        this.bodyWrapper.append(this.flyOutWrapper);

        if (brease.config.editMode) {
            this.el.append(this.bodyWrapper);
            container = brease.bodyEl.find('.iatd-content-wrapper');
            if (container.length === 1) { //append only if wrappper is there
                container.append(this.el);
            }
        } else {
            container = this.el.closest('.contentBox');

            if ($.contains(brease.appElem, this.elem) || container.length === 0) {
                brease.bodyEl.append(this.bodyWrapper);
            } else {
                container.append(this.bodyWrapper);
            }
            this.bodyWrapper.before(this.dimmer);
        }
        _updateDocking.call(this);
        this._initEditDimensions();
    };

    p.show = function () {
        var cssInfo = {
            top: {
                top: 0,
                left: 0
            },
            right: {
                right: 0,
                top: 0
            },
            bottom: {
                top: 0,
                left: 0
            },
            left: {
                left: 0,
                top: 0
            }
        };

        this.el.addClass('show');
        this.bodyWrapper.addClass('show');

        this.flyOutWrapper.css(cssInfo[this.settings.docking]);
        _updateEditDimensions.call(this);

        if (this.settings.mode === Enum.DialogMode.MODAL) {
            this._toggleDimmer(true);
        }

        if (this.settings.autoClose === true) {
            _addOptionalAutoCloseListener(this);
        }
    };

    p.hide = function () {

        var cssObj = {
            left: 0,
            top: 0
        };
        this.el.removeClass('show');
        this.bodyWrapper.removeClass('show');

        switch (this.settings.docking) {

            case Enum.ImageAlign.top:

                cssObj = {
                    top: this.distance * -1,
                    left: 0
                };
                break;

            case Enum.ImageAlign.right:

                cssObj = {
                    right: this.distance * -1,
                    top: 0
                };
                break;

            case Enum.ImageAlign.bottom:

                cssObj = {
                    top: this.distance,
                    left: 0
                };
                if (brease.config.editMode) {
                    cssObj = {
                        bottom: this.settings.height * -1,
                        left: 0
                    };
                }
                break;

            case Enum.ImageAlign.left:

                cssObj = {
                    left: this.distance * -1,
                    top: 0
                };
                break;
        }

        this.flyOutWrapper.css(cssObj);

        if (this.settings.mode === Enum.DialogMode.MODAL) {
            this._toggleDimmer(false);
        }

        if (this.settings.autoClose === true) {
            _removeOptionalAutoCloseListener(this);
        }
    };

    p.getButtonId = function () {
        return this.buttonId;
    };

    // Overload 'updateVisibility' from ContainerWidget, BaseWidget
    p.updateVisibility = function (initial) {
        var hidden,
            widget = this;

        $.when(this.flyOutReady).done(function () {
            SuperClass.prototype.updateVisibility.call(widget, initial);
            hidden = widget.isHidden;

            if (widget.button !== undefined) {
                _setVisibility.call(widget, hidden);
            }
        });
    }; 

    p._initEventHandler = function () {
        if (this.bodyWrapper) {
            this.bodyWrapper.on(BreaseEvent.CLICK, this._bind('_clickHandler'));
        }
    };
    
    /**
     * @event Click
     * Fired when element is clicked on.
     * @iatStudioExposed
     */
    p._clickHandler = function (e, additionalArguments) {
        SuperClass.prototype._clickHandler.call(this, e, { origin: this.elem.id });
    };

    p._toggleChangeHandler = function (e) {
        if (this.isDisabled || brease.config.editMode) { return; }

        if (e.detail.checked === true) {
            this.show();
            this._toggleStateChangedHandler(true);
        } else {
            this.hide();
            this._toggleStateChangedHandler(false);
        }
    };

    p._resizeEventHandler = function () {
        // A&P 570355: added check of scale factor (nonzero) 
        if (Utils.getScaleFactor(this.elem.parentElement) !== 0) {
            _updateDocking.call(this);
        }
    };

    p._mouseDownHandler = function (e) {
        var widget = this;

        if (this.isDisabled || brease.config.editMode) { return; }
        this._handleEvent(e);

        if ((this.el.hasClass('move') === false) && (this.el.hasClass('show') === false)) {
            _.defer(function () {
                _setZIndex(widget);
            });
        }

        this.flyOutWrapper.removeClass('transition');
        this.el.addClass('move');
        this.bodyWrapper.addClass('move');

        this.startX = e.originalEvent.touches ? e.originalEvent.touches[0].pageX : e.pageX;
        this.startY = e.originalEvent.touches ? e.originalEvent.touches[0].pageY : e.pageY;

        this.offsetTop = this.el.offset().top;
        this.offsetLeft = this.el.offset().left;
        this.mouseOffsetY = this.startY - this.offsetTop;
        this.mouseOffsetX = this.startX - this.offsetLeft;

        var cssTop = this.flyOutWrapper.css('top');
        var cssRight = this.flyOutWrapper.css('right');
        var cssLeft = this.flyOutWrapper.css('left');
        this.startDistance = {
            top: ((cssTop !== 'auto') ? parseInt(cssTop, 10) : 0) * -1,
            right: ((cssRight !== 'auto') ? parseInt(cssRight, 10) : 0) * -1,

            bottom: ((cssTop !== 'auto') ? parseInt(cssTop, 10) : 0),
            left: ((cssLeft !== 'auto') ? parseInt(cssLeft, 10) : 0) * -1
        };

        brease.bodyEl.on(BreaseEvent.MOUSE_MOVE, this._bind('_mouseMoveHandler'));
        brease.bodyEl.on(BreaseEvent.MOUSE_UP, this._bind('_mouseUpHandler'));
    };

    p._mouseMoveHandler = function (e) {
        if (this.isDisabled || brease.config.editMode) { return; }
        
        var scaleFactor = Utils.getScaleFactor(this.elem.parentElement),
            cssObj = {},
            offset;

        this.pageX = e.originalEvent.touches ? e.originalEvent.touches[0].pageX : e.pageX;
        this.pageY = e.originalEvent.touches ? e.originalEvent.touches[0].pageY : e.pageY;

        switch (this.settings.docking) {

            case Enum.ImageAlign.top:
                var top = (this.startDistance.top - (this.pageY - this.offsetTop - this.mouseOffsetY) / scaleFactor) * -1;

                if (top <= 0 && Math.abs(top) <= this.distance) {
                    cssObj = { top: top };
                } else {
                    return;
                }
                break;
            case Enum.ImageAlign.bottom:
                offset = (this.startY - this.pageY) / scaleFactor;

                var bottom = this.startDistance.bottom - offset;
                if (bottom >= 0 && bottom <= this.distance) {
                    cssObj = { top: bottom };
                } else {
                    return;
                }
                break;
            case Enum.ImageAlign.left:
                var left = (this.startDistance.left - (this.pageX - this.offsetLeft - this.mouseOffsetX) / scaleFactor) * -1;

                if (left <= 0 && Math.abs(left) <= this.distance) {
                    cssObj = { left: left };
                } else {
                    return;
                }
                break;
            case Enum.ImageAlign.right:
                offset = (this.offsetLeft - this.startX) / scaleFactor + this.el.width();

                if (this.startDistance.right <= 0) {
                    offset -= this.distance;
                }
                var right = (this.offsetLeft - this.pageX) / scaleFactor - offset + this.el.width() - this.distance;

                if (right <= 0 && Math.abs(right) <= this.distance) {
                    cssObj = { right: right };
                } else {
                    return;
                }
                break;
        }
        this.flyOutWrapper.css(cssObj);
    };

    p._mouseUpHandler = function (e) {
        var toggleButton = brease.callWidget(this.buttonId, 'widget'),
            internalTarget = false;

        if (e.target.id !== null && e.target.id !== '') {
            internalTarget = this.container.find('#' + e.target.id).length > 0;
        }

        if (this.isDisabled || brease.config.editMode || internalTarget) { return; }
        this._handleEvent(e, true);

        brease.bodyEl.off(BreaseEvent.MOUSE_UP, this._bind('_mouseUpHandler'));
        brease.bodyEl.off(BreaseEvent.MOUSE_MOVE, this._bind('_mouseMoveHandler'));

        this.flyOutWrapper.addClass('transition');

        var distY = this.pageY - this.startY,
            distX = this.pageX - this.startX,
            dist;

        switch (this.settings.docking) {

            case Enum.ImageAlign.top:
                dist = distY;
                break;

            case Enum.ImageAlign.right:
                dist = distX * -1;
                break;

            case Enum.ImageAlign.bottom:
                dist = distY * -1;
                break;

            case Enum.ImageAlign.left:
                dist = distX;
                break;
        }

        if (dist > 10) {
            this.show();
        } else if (dist < -10) {
            this.hide();
        }

        this.moveTimout = window.setTimeout(function (widget) {
            widget.el.removeClass('move');
            widget.bodyWrapper.removeClass('move');
            if (widget.el.hasClass('show') === false) {
                _resetZIndex(widget);
            }
        }, 500, this);        

        this.moveTimout = window.setTimeout(function (widget) {
            if (widget.el.hasClass('show') === false) {
                _resetZIndex(widget);

                if (widget.button.hasClass('checked')) {
                    _updateButtonToggleState(widget, false);
                }
            } else {
                if (widget.button.hasClass('checked') === false) {
                    _updateButtonToggleState(widget, true);
                }
            }
        }, 10, this);

        toggleButton._upHandler(e);
    };

    p._autoCloseHandler = function (e) {
        var actualElementOnClickCoordinates,
            clientRect = this.bodyWrapper.find('.container')[0].getBoundingClientRect(),
            insideCoordinates = false;

        if (Utils.isNumeric(e.clientX) && Utils.isNumeric(e.clientY)) {
            insideCoordinates = e.clientX > clientRect.left && e.clientX < clientRect.right &&
                e.clientY > clientRect.top && e.clientY < clientRect.bottom;
            actualElementOnClickCoordinates = document.elementFromPoint(e.clientX, e.clientY);
        }

        if (e.target !== this.button[0] &&
            !$.contains(this.flyOutWrapper[0], actualElementOnClickCoordinates) &&
            !$.contains(this.flyOutWrapper[0], e.target) &&
            !insideCoordinates) {
            _autoClose(this);
            this.close();
        }
    };

    p._placedInTabItemRepositionHandler = function (e) {
        if (e.detail.visible) {
            this.el.closest('.breaseTabItemContainer').off(BreaseEvent.VISIBILITY_CHANGED, this._bind('_placedInTabItemRepositionHandler'));
            _updateDocking.call(this);
        }
    };

    p.setEnable = function (value) {
        if (brease.config.editMode !== true) {
            SuperClass.prototype.setEnable.apply(this, arguments);
            _setEnable.call(this, value);
        }
    };

    p._setDimmer = function () {
        if (this.dimmer !== undefined) {
            this.dimmer.css('display', 'block').removeClass('init-only');
            _disableScroll.call(this);
        }
    };

    p._removeDimmer = function () {
        if (this.dimmer !== undefined) {
            this.dimmer.removeClass('active');
            _updateModalOverlays();
            this.dimmer.css({ display: 'none' });
        }
    };

    /**
     * @event ToggleStateChanged
     * @param {Boolean} newValue
     * @iatStudioExposed
     * Event returns a boolean value of 'TRUE' once the FlyOut widget is expanded (opened), and 'FALSE' when the FlyOut is collapsed (closed).
     */
    p._toggleStateChangedHandler = function (val) {
        var ev = this.createEvent('ToggleStateChanged', { newValue: val });
        if (ev) {
            ev.dispatch();
        }
    };

    p._toggleDimmer = function (val) {

        if (!brease.config.editMode) {
            if (val && !this.settings.dimmerOn) {
                this.settings.dimmerOn = true;
                var currZIndex = popupManager.getHighestZindex();
                this._setDimmer(currZIndex);
                _updateModalOverlays();
            } else if (!val && this.settings.dimmerOn) {
                this.settings.dimmerOn = false;
                this._removeDimmer();
                _enableScroll.call(this);
            }
        }
    };

    p._widgetReadyHandler = function (e) {
        var self = this;

        if (e.target.id === self.elem.id) {
            $.when(self.toggleButtonReady).done(function () {
                self.flyOutReady.resolve();
            });
        }
    };

    p._buttonReadyHandler = function (e) {
        var self = this;

        if (e.target.id === self.buttonId) {
            self.toggleButtonReady.resolve();
        }
    };

    p.onBeforeDispose = function () {
        var widget = this;
        if (this.settings.mode === Enum.DialogMode.MODAL) {
            this._toggleDimmer(false);
        }

        _removeListeners(this);

        brease.uiController.dispose(this.bodyWrapper, false, function () {
            widget.bodyWrapper.remove();
            if (widget.settings.mode === Enum.DialogMode.MODAL) {
                widget.dimmer.remove();
            }
        });

        SuperClass.prototype.onBeforeDispose.apply(this, arguments);
    };

    p.wake = function () {
        this._setInitialPosition();
        if (this.bodyWrapperCache) {
            this.bodyWrapper = $('#' + this.bodyWrapperCache[0].id);
            
            if (this.settings.mode === Enum.DialogMode.MODAL) {
                this.bodyWrapper.before(this.dimmerCache);
                this.dimmer = $('#' + this.dimmerCache[0].id);    
            }
        }

        _addListeners(this);

        SuperClass.prototype.wake.apply(this, arguments);
    };

    p.onBeforeSuspend = function () {
        if (this.settings.mode === Enum.DialogMode.MODAL) {
            this._toggleDimmer(false);
            
            this.dimmerCache = this.dimmer.detach();
        }
        
        // A&P 547330 (content caching behavior of the FlyOut): ensure widget is closed on page changes when autoClose is set to TRUE
        if (this.settings.autoClose === true) {
            this.close();
        }
        
        _removeListeners(this);
        this.bodyWrapperCache = this.bodyWrapper.detach(); // Flyout in DialogWindow affects calculation of size when it's contents are in DOM
        SuperClass.prototype.onBeforeSuspend.apply(this, arguments);
    };

    p._initEditDimensions = function () {
        if (brease.config.editMode) {
            var position = _calcPosition(this);
            switch (this.settings.docking) {
                case Enum.ImageAlign.bottom:
                {
                    this.bodyWrapper.css({
                        left: 0,
                        top: 'auto',
                        bottom: 0,
                        minWidth: 0,
                        width: position.container.width,
                        minHeight: position.container.height * 2, // highly unlikely that tha button is larger than the content in a very big content... 
                        height: '100vh' //100% viewport height  (auto adapted when viewport changes)
                    });
                    break;
                }
                case Enum.ImageAlign.top:
                {
                    this.bodyWrapper.css({
                        left: 0,
                        top: 0,
                        bottom: 'auto',
                        minWidth: 0,
                        width: position.container.width,
                        minHeight: position.container.height * 2, // highly unlikely that tha button is larger than the content in a very big content... 
                        height: '100vh' //100% viewport height  (auto adapted when viewport changes)
                    });

                    break;
                }
                case Enum.ImageAlign.right:
                {
                    this.bodyWrapper.css({
                        left: 'auto',
                        right: 0,
                        top: 0,
                        minHeight: 0,
                        height: position.container.height,
                        minWidth: position.container.width * 2, // highly unlikely that tha button is larger than the content in a very big content... 
                        width: '100vw' //100% viewport with  (auto adapted when viewport changes)
                    });
                    break;
                }
                case Enum.ImageAlign.left:
                {
                    this.bodyWrapper.css({
                        left: 0,
                        right: 'auto',
                        top: 0,
                        minHeight: 0,
                        height: position.container.height,
                        minWidth: position.container.width * 2, // highly unlikely that tha button is larger than the content in a very big content... 
                        width: '100vw' //100% viewport with  (auto adapted when viewport changes)
                    });
                }
            }
        }
    };

    function _autoClose(widget) {
        var parentLayout = widget.el.closest('[data-brease-layoutId]'),
            parentWidget = parentLayout.closest('.breaseWidget');
        if (parentWidget.length > 0) { //Flyout in e.g. a DialogWindow (embedded content)
            parentLayout.off(BreaseEvent.CLICK, widget._bind('_autoCloseHandler'));
        } else {
            $(document).off(BreaseEvent.CLICK, widget._bind('_autoCloseHandler'));
        }
    }

    function _addOptionalAutoCloseListener(widget) {
        var parentLayout = widget.el.closest('[data-brease-layoutId]'),
            parentWidget = parentLayout.closest('.breaseWidget');
        
        if (parentWidget.length > 0) { //Flyout in e.g. a DialogWindow (embedded content)
            parentLayout.on(BreaseEvent.CLICK, widget._bind('_autoCloseHandler')); // only click on DialogWindow's content closes FlyOut, click on header (moving Dialog) won't trigger a close
            parentLayout.on(BreaseEvent.DISABLED_CLICK, widget._bind('_autoCloseHandler'));
        } else {
            $(document).on(BreaseEvent.CLICK, widget._bind('_autoCloseHandler'));
            $(document).on(BreaseEvent.DISABLED_CLICK, widget._bind('_autoCloseHandler'));
        }
    }

    function _removeOptionalAutoCloseListener(widget) {
        var parentLayout = widget.el.closest('[data-brease-layoutId]'),
            parentWidget = parentLayout.closest('.breaseWidget');
        
        if (parentWidget.length > 0) { //Flyout in e.g. a DialogWindow (embedded content)
            parentLayout.off(BreaseEvent.CLICK, widget._bind('_autoCloseHandler')); // only click on DialogWindow's content closes FlyOut, click on header (moving Dialog) won't trigger a close
            parentLayout.off(BreaseEvent.DISABLED_CLICK, widget._bind('_autoCloseHandler'));
        } else {
            $(document).off(BreaseEvent.CLICK, widget._bind('_autoCloseHandler'));
            $(document).off(BreaseEvent.DISABLED_CLICK, widget._bind('_autoCloseHandler'));
        }
    }

    function _addListeners(widget) {
        widget.button.on(BreaseEvent.MOUSE_DOWN, widget._bind('_mouseDownHandler'));
        widget.button.on(BreaseEvent.CHANGE, widget._bind('_toggleChangeHandler')); 

        widget.initPosTmOut = window.setTimeout(widget._bind('_setInitialPosition'), 10);
        
        // A&P 536750: changed from FRAGMENT_SHOW to PAGE_LOADED event (triggered on appContainer, not SystemLoader)
        $('#appContainer').on(BreaseEvent.PAGE_LOADED, widget._bind('_setInitialPosition'));

        // A&P 691770: if FlyOut is placed in a tabItem it needs to reposition on initial visibility_change where visibility is true
        widget.el.closest('.breaseTabItemContainer').on(BreaseEvent.VISIBILITY_CHANGED, widget._bind('_placedInTabItemRepositionHandler'));

        // A&P 510755
        brease.bodyEl.on(BreaseEvent.APP_RESIZE, widget._bind('_resizeEventHandler'));
    }

    function _removeListeners(widget) {
        widget.button.off(BreaseEvent.MOUSE_DOWN, widget._bind('_mouseDownHandler'));
        widget.button.off(BreaseEvent.CHANGE, widget._bind('_toggleChangeHandler'));

        // A&P 536750: changed from FRAGMENT_SHOW to PAGE_LOADED event (triggered on appContainer, not SystemLoader)
        $('#appContainer').off(BreaseEvent.PAGE_LOADED, widget._bind('_setInitialPosition'));
        
        // A&P 691770:
        widget.el.closest('.breaseTabItemContainer').off(BreaseEvent.VISIBILITY_CHANGED, widget._bind('_placedInTabItemRepositionHandler'));
        
        // A&P 510755
        brease.bodyEl.off(BreaseEvent.APP_RESIZE, widget._bind('_resizeEventHandler'));

        window.clearTimeout(widget.moveTimout);
        window.clearTimeout(widget.initPosTmOut);

        if (widget.el.hasClass('show')) {
            brease.bodyEl.off(BreaseEvent.MOUSE_MOVE, widget._bind('_mouseMoveHandler'));
            brease.bodyEl.off(BreaseEvent.MOUSE_UP, widget._bind('_mouseUpHandler'));
        }

        _autoClose(widget);
    }

    function _setVisibility(value) {
        // value === true, widget is 'hidden'
        // value === false, widget is shown, not hidden
 
        if (brease.config.editMode !== true) {
            if (value === undefined) {
                
            } else if (value === true) {
                this.bodyWrapper.addClass('remove');
                if (this.settings.autoClose === true) {
                    _invisibleHide(this);
                }
            } else {
                this.bodyWrapper.removeClass('remove');
                _updateDocking.call(this);
            }
        }
    }

    function _setEnable(value) {
        if (brease.config.editMode !== true) {
            if (value === undefined) {
                
            } else {
                var toggleButton = brease.callWidget(this.buttonId, 'widget');

                if (value) {
                    toggleButton.enable();
                } else {
                    toggleButton.disable();
                    _invisibleHide(this);
                }
            }
        }
    }

    function _invisibleHide(widget) {
        if (widget.el.hasClass('show')) {
            widget.hide();
            _updateButtonToggleState(widget, false);
        }
    }

    function _updateButtonToggleState(widget, buttonState) {
        var toggleButton = brease.callWidget(widget.buttonId, 'widget');
        if (!brease.config.editMode) {
            if (buttonState !== toggleButton.settings.value) {
                toggleButton.toggle(buttonState, true);
            }
        }
    }

    function _resetZIndex(widget) {
        var widgetZIndex = 100 + widget.settings.zIndex;

        if (widget.settings.showOnTop === false || brease.config.editMode) { return; }

        widget.bodyWrapper.css('z-index', widgetZIndex);
        if (widget.dimmer !== undefined) {
            widget.dimmer.css('z-index', widgetZIndex);
        }
    }

    function _setInitialZIndex(widget) {
        var widgetZIndex = 100 + widget.settings.zIndex; // this should be the z-index assigned by the editor, controlled by user

        widget.bodyWrapper.css('z-index', widgetZIndex);
        if (widget.dimmer !== undefined) {
            widget.dimmer.css('z-index', widgetZIndex);
        }

        widget.settings.prevActiveZIndex = widgetZIndex;
    }

    function _setZIndex(widget) {

        if (widget.settings.showOnTop === false || brease.config.editMode) { return; }

        if (widget.settings.prevActiveZIndex === undefined) {
            widget.settings.prevActiveZIndex = widget.bodyWrapper.css('z-index');
        }

        var highestZIndex = popupManager.getHighestZindex();
        if (widget.settings.prevActiveZIndex < highestZIndex) {
            widget.settings.prevActiveZIndex = highestZIndex;
        }

        widget.bodyWrapper.css('z-index', widget.settings.prevActiveZIndex);
        if (widget.dimmer !== undefined) {
            widget.dimmer.css('z-index', widget.settings.prevActiveZIndex);
        }
    }

    function _updateDocking() {
        var bodyWrapperCss = {},
            dialogLayout = this.el.closest('[data-brease-dialogid]'),
            scaleFactor = Utils.getScaleFactor(this.elem.parentElement);

        this.el.removeClass('right top left bottom');
        this.bodyWrapper.removeClass('right top left bottom');
        this.button.appendTo(this.flyOutWrapper);

        switch (this.settings.docking) {
            case Enum.ImageAlign.top:
                this.distance = parseInt(this.settings.height, 10);
                this.bodyWrapper.addClass('top');
                this.el.addClass('top');

                bodyWrapperCss = {
                    width: this.contentWrapper.outerWidth(),
                    height: this.contentWrapper.outerHeight() + this.button.outerHeight() + parseInt(this.button.css('marginTop'), 10) + parseInt(this.button.css('marginBottom'), 10),
                    transform: 'matrix(' + scaleFactor + ',0,0,' + scaleFactor + ',0,0)',
                    transformOrigin: 'top left'
                };
                break;

            case Enum.ImageAlign.right:
                this.distance = parseInt(this.settings.width, 10);

                this.bodyWrapper.addClass('right');
                this.el.addClass('right')
                    .css('left', 'auto');

                bodyWrapperCss = {
                    width: this.contentWrapper.outerWidth() + this.button.outerWidth() + parseInt(this.button.css('marginLeft'), 10) + parseInt(this.button.css('marginRight'), 10),
                    height: this.contentWrapper.outerHeight(),
                    transform: 'matrix(' + scaleFactor + ',0,0,' + scaleFactor + ',' + this.button.outerWidth() * scaleFactor + ',0)',
                    transformOrigin: 'top right'
                };
                break;

            case Enum.ImageAlign.bottom:
                this.button.prependTo(this.flyOutWrapper);
                this.distance = parseInt(this.settings.height, 10);
                this.bodyWrapper.addClass('bottom');
                this.el.addClass('bottom')
                    .css('top', 'auto')
                    .css('display', 'inline');
                
                bodyWrapperCss = {
                    width: this.contentWrapper.outerWidth(),
                    height: this.contentWrapper.outerHeight() + this.button.outerHeight() + parseInt(this.button.css('marginTop'), 10) + parseInt(this.button.css('marginBottom'), 10),
                    transform: 'matrix(' + scaleFactor + ',0,0,' + scaleFactor + ',0,' + this.button.outerHeight() * scaleFactor + ')',
                    transformOrigin: 'bottom left'
                };
                break;

            case Enum.ImageAlign.left:
                this.distance = parseInt(this.settings.width, 10);
                this.bodyWrapper.addClass('left');
                this.el.addClass('left');
                bodyWrapperCss = {
                    width: this.contentWrapper.outerWidth() + this.button.outerWidth() + parseInt(this.button.css('marginLeft'), 10) + parseInt(this.button.css('marginRight'), 10),
                    height: this.contentWrapper.outerHeight(),
                    transform: 'matrix(' + scaleFactor + ',0,0,' + scaleFactor + ',0,0)',
                    transformOrigin: 'top left'
                };
                break;
        }

        //as flyout is attached differently in the designer (and dialogs), the transformation should not be applied
        if (brease.config.editMode || dialogLayout.length > 0) { 
            bodyWrapperCss.transform = 'none';
            bodyWrapperCss.transformOrigin = '50% 50% 0';
        }
        this.bodyWrapper.css(bodyWrapperCss);

        this._setButtonOffset();
        _updateEditDimensions.call(this);

        if (!this.el.hasClass('initialized')) {
            this.hide();
            _updateEditDimensions.call(this);
            var that = this;
            _.defer(function () {
                if (!brease.config.editMode) {
                    that.flyOutWrapper.addClass('transition');
                }
            });
            if (brease.config.editMode !== true && this.settings.enable === false) {
                _setEnable.call(this, this.settings.enable);
            }
            
            this.el.addClass('initialized');
            this.bodyWrapper.addClass('initialized');

            this._dispatchReady();
        }

        _fixOffsetAfterUpdateDocking.call(this);
    }

    function _fixOffsetAfterUpdateDocking() {
        var scaleFactor = Utils.getScaleFactor(this.elem.parentElement),
            parentOffset = this.el.parent().offset(),
            dialogLayout = this.el.closest('[data-brease-dialogid]'),
            offset = {
                top: parseInt(this.settings.top * scaleFactor),
                left: parseInt(this.settings.left * scaleFactor)
            };

        if (brease.config.editMode) {
            if (this.settings.docking === Enum.ImageAlign.top) {
                offset.top = this.contentWrapper.offset().top;
                offset.top = 0;
            } else if (this.settings.docking === Enum.ImageAlign.left) {
                offset.left = this.contentWrapper.offset().left;
                offset.left = 0;
            }
            return;
        }

        if (dialogLayout.length === 0) { // NOT a dialog content
            
            offset.left += parentOffset.left;
            offset.top += parentOffset.top;

            switch (this.settings.docking) {
                case Enum.ImageAlign.right:
                    offset.left += (this.el.parent().width() - this.bodyWrapper.width()) * scaleFactor;
                    break;
                
                case Enum.ImageAlign.bottom:
                    offset.top += (this.el.parent().height() - this.bodyWrapper.height()) * scaleFactor;

                    break;
            }
            this.bodyWrapper.offset(offset);
        
        } else { // dialog: no scaling should be applied (due to location in DOM)
            
            switch (this.settings.docking) {
                case Enum.ImageAlign.right:
                    this.bodyWrapper.css('left', 'auto');
                    this.bodyWrapper.css('top', this.settings.top);
                    break;

                case Enum.ImageAlign.left:
                    this.bodyWrapper.css('top', this.settings.top);
                    break;
              
                case Enum.ImageAlign.bottom:
                    this.bodyWrapper.css('top', 'auto');
                    this.bodyWrapper.css('left', this.settings.left); 
                    break;

                case Enum.ImageAlign.top:
                    this.bodyWrapper.css('left', this.settings.left); 
                    break;
            }
        }
    }
    // used in designer context
    function _calcPosition(widget) {
        var position = { container: {}, button: {} };

        position.container = {
            width: parseInt(widget.settings.width, 10),
            height: parseInt(widget.settings.height, 10)
        };

        position.button = {
            top: parseInt(widget.settings.top, 10),
            left: parseInt(widget.settings.left, 10)
        };

        switch (widget.settings.docking) {
            case Enum.ImageAlign.top:
            case Enum.ImageAlign.bottom:
            {
                position.button.left += widget.settings.buttonOffset;
                break;
            }
            case Enum.ImageAlign.left:
            case Enum.ImageAlign.right:
            {
                position.button.top += widget.settings.buttonOffset;
                break;
            }
        }

        return position;
    }

    p._setWidth = function (w) {
        if (brease.config.editMode) {
            this.settings.width = w;
            _updateDocking.call(this);

            this._setButtonOffset();
            _updateEditDimensions.call(this);
        }
    };

    p._setHeight = function (h) {
        if (brease.config.editMode) {
            this.settings.height = h;
            _updateDocking.call(this);

            this._setButtonOffset();

            _updateEditDimensions.call(this);
        }
    };

    function _updateEditDimensions() {
        if (brease.config.editMode) {
            var position = _calcPosition(this);

            this.container.css('pointer-events', 'auto');
            this.button.css('pointer-events', 'auto');

            this.container.css({
                width: position.container.width,
                height: position.container.height // only partial visible..
            });

            if (this.el.hasClass('show')) {
                switch (this.settings.docking) {
                    case Enum.ImageAlign.bottom:
                    {
                        this.button.css({
                            position: 'absolute',
                            left: position.button.left,
                            top: 'auto',
                            bottom: position.container.height
                        });

                        this.bodyWrapper.css({
                            left: 0,
                            top: 'auto',
                            bottom: 0,
                            minWidth: 0,
                            width: position.container.width,
                            minHeight: position.container.height * 2, // highly unlikely that tha button is larger than the content in a very big content... 
                            height: '100vh' //100% viewport height  (auto adapted when viewport changes)
                        });

                        this.container.css({
                            position: 'absolute',
                            top: 'auto',
                            bottom: 0
                        });
                        this.flyOutWrapper.css({ top: 'auto', bottom: 0 });
                        break;
                    }
                    case Enum.ImageAlign.top:
                    {
                        this.button.css({
                            left: position.button.left,
                            top: 0
                        });

                        this.bodyWrapper.css({
                            left: 0,
                            top: 0,
                            bottom: 'auto',
                            minWidth: 0,
                            width: position.container.width,
                            minHeight: position.container.height * 2, // highly unlikely that tha button is larger than the content in a very big content... 
                            height: '100vh' //100% viewport height  (auto adapted when viewport changes)
                        });

                        break;
                    }
                    case Enum.ImageAlign.right:
                    {
                        this.button.css({
                            left: 0,
                            top: position.button.top
                        });

                        this.bodyWrapper.css({
                            left: 'auto',
                            right: 0,
                            top: 0,
                            minHeight: 0,
                            height: position.container.height,
                            minWidth: position.container.width * 2, // highly unlikely that tha button is larger than the content in a very big content... 
                            width: '100vw' //100% viewport with  (auto adapted when viewport changes)
                        });

                        this.flyOutWrapper.css({ right: 0 });
                        break;
                    }
                    case Enum.ImageAlign.left:
                    {
                        this.button.css({
                            left: 0,
                            top: position.button.top
                        });

                        this.bodyWrapper.css({
                            left: 0,
                            right: 'auto',
                            top: 0,
                            minHeight: 0,
                            height: position.container.height,
                            minWidth: position.container.width * 2, // highly unlikely that tha button is larger than the content in a very big content... 
                            width: '100vw' //100% viewport with  (auto adapted when viewport changes)
                        });
                    }
                }
            } else {

                this.hide(); //  css
                /* Special case bottom - closed */
                if (this.settings.docking === Enum.ImageAlign.bottom) {
                    this.button.css({
                        position: 'absolute',
                        top: 'auto',
                        bottom: 0
                    });
                    this.container.css({
                        position: 'absolute',
                        top: 'auto',
                        bottom: -position.container.height
                    });
                    this.flyOutWrapper.css({ top: 'auto', bottom: 0 });
                }
            }
            this._setButtonOffset();
            this._setButtonVisibility();

            var event = this.createEvent('HandlesChanged');
            event.dispatch();
            
        }
    }

    function _updateModalOverlays() {
        $('.breaseModalDimmer:visible').addClass('active');
    }

    var _safe;
    function _disableScroll() {
        this.dimmer.on('mousewheel DOMMouseScroll touchstart', _preventDefault);
        if (!_safe) {
            _safe = {
                x: brease.bodyEl.css('overflow-x'),
                y: brease.bodyEl.css('overflow-y')
            };
        }
        document.body.style.overflow = 'hidden';
    }

    function _enableScroll() {
        if ($('.breaseModalDimmer:visible').length === 0 && !this.dimmer.hasClass('init-only')) {
            this.dimmer.off('mousewheel DOMMouseScroll touchstart', _preventDefault);
            brease.bodyEl.css('overflow-x', _safe.x);
            brease.bodyEl.css('overflow-y', _safe.y);
        }
    }

    function _preventDefault(e) {
        e.preventDefault();
    }

    return WidgetClass;

});
