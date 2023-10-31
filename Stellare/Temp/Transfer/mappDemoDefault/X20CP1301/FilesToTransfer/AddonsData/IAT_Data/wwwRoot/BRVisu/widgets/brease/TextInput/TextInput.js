define([
    'brease/core/BaseWidget',
    'brease/decorators/LanguageDependency',
    'brease/controller/KeyboardManager',
    'brease/events/BreaseEvent',
    'brease/enum/Enum',
    'brease/core/Types',
    'widgets/brease/common/libs/wfUtils/UtilsEditableBinding',
    'brease/decorators/DragAndDropCapability',
    'widgets/brease/common/DragDropProperties/libs/DraggablePropertiesEvents',
    'widgets/brease/common/DragDropProperties/libs/DroppablePropertiesEvents'
], function (
    SuperClass, languageDependency, keyboardManager,
    BreaseEvent, Enum, Types, UtilsEditableBinding, dragAndDropCapability
) {

    'use strict';

    /**
    * @class widgets.brease.TextInput
    * #Description
    * widget for text input; opens a virtual keyboard for editing  
    *
    * @mixins widgets.brease.common.DragDropProperties.libs.DraggablePropertiesEvents
    * @mixins widgets.brease.common.DragDropProperties.libs.DroppablePropertiesEvents 
    *
    * @breaseNote 
    * @extends brease.core.BaseWidget
    *
    * @iatMeta category:Category
    * Text
    * @iatMeta description:short
    * Texteingabe
    * @iatMeta description:de
    * Ermöglicht dem Benutzer einen Text einzugeben
    * @iatMeta description:en
    * Enables the user to enter a text
    */

    /**
    * @htmltag examples
    * ##Configuration Example
    *
    *       <div id="inputText" data-brease-widget="widgets/brease/TextInput" data-brease-options="{'maxLength':32}"></div>
    */

    /**
    * @cfg {String} value=''
    * @iatStudioExposed
    * @iatCategory Data
    * @bindable
    * @editableBinding
    * Value displayed by the widget
    */

    /**
    * @cfg {Integer} maxLength=-1
    * @iatStudioExposed
    * @iatCategory Behavior
    * The maxLength attribute specifies the maximum number of characters allowed in the TextInput  
    * If maxLength < 0, there is no restriction.  
    */
    /**
    * @cfg {RegEx} inputRestriction=''
    * @iatCategory Behavior
    * @iatStudioExposed
    * @localizable
    * Indicates the set of characters that a user can enter into the TextInput  
    * If not defined (=default), there is no restriction.  
    */
    /**
    * @cfg {String} placeholder=''
    * @iatStudioExposed
    * @localizable
    * @iatCategory Behavior
    * Specifies a short hint that describes the expected value of the input field
    */
    /**
    * @cfg {Boolean} submitOnChange=true
    * @iatStudioExposed
    * @iatCategory Behavior
    * Determines if changes, triggered by user input, should be sent immediately to the server.  
    */
    /**
    * @cfg {Boolean} keyboard=true
    * @iatStudioExposed
    * @iatCategory Behavior
    * Determines if internal soft keyboard should open
    */

    /**
    * @cfg {Boolean} ellipsis=false
    * @iatStudioExposed
    * @iatCategory Behavior
    * If true, overflow of text is symbolized with an ellipsis.  
    */

    var defaultSettings = {
            submitOnChange: true,
            keyboard: true,
            tabIndex: 1,
            ellipsis: false,
            value: '',
            maxLength: -1,
            placeholder: '',
            placeholderTextKey: '',
            inputRestriction: '',
            inputRestrictionRegEx: null,
            inputRestrictionTextKey: ''
            // following default values are missing, maybe should be added when refactoring this widget
            // type
            // header
            // regexp
        },

        WidgetClass = SuperClass.extend(function TextInput() {
            SuperClass.apply(this, arguments);
        }, defaultSettings),

        p = WidgetClass.prototype;

    p.init = function (type) {
        if (this.settings.omitClass !== true) {
            this.addInitialClass('breaseTextInput');
        }
        if (this.settings.maxLength < 0) {
            this.settings.maxLength = undefined;
        }
        this.createKeyBoard();

        this.input = _createInputField.call(this, type);

        _ellipsisSettings(this);
        this.setPlaceholder(this.settings.placeholder);

        if (this.settings.value !== undefined) {
            this.setValue(this.settings.value);
        }

        if (this.settings.keyboard !== true) {
            this.input.addClass('keyboard');
        }

        this.setInputRestriction(this.settings.inputRestriction);

        if (this.keyBoard.state === Enum.WidgetState.READY) {
            SuperClass.prototype.init.call(this);
        } else {
            document.body.addEventListener(BreaseEvent.WIDGET_READY, this._bind('keyBoard_readyHandler'));
        }
        document.body.addEventListener(BreaseEvent.SYSTEM_KEYBOARD_CHANGED, this._bind('changeKeyBoard'));
    };

    p._preventClickHandler = function (e) {
        this._handleEvent(e);
    };

    // ausgelagert, damit abgeleitete widgets ueberschreiben koennen 
    p.createKeyBoard = function () {
        this.keyBoard = keyboardManager.getKeyboard();
    };

    p.keyBoard_readyHandler = function (e) {
        if (e.target.id === 'breaseKeyBoard') {
            document.body.removeEventListener(BreaseEvent.WIDGET_READY, this._bind('keyBoard_readyHandler'));
            SuperClass.prototype.init.call(this, true);
            this._dispatchReady();
        }
    };

    /**
        * @method setValue
        * @iatStudioExposed
        * sets the visible text
        * @param {String} value The new value
        */
    p.setValue = function (value) {
        //console.debug(this.constructor.name + '[' + this.elem.id + '].setValue:', value);
        this.settings.value = this.spsValue = value;
        this.showValue();
    };

    /**
        * Sets the visible text via an object
        * @method setData
        * @param {Object} data The data object with new value and maxLength
        * @param {String} [data.value] The new value for the widget
        * @param {Integer} [data.maxLength] The maximum length of the value
        */
    p.setData = function (data) {
        if (_.isObject(data)) {
            if (data.maxLength !== undefined) {
                this.settings.maxLength = data.maxLength;
            }
            if (data.value !== undefined) {
                this.settings.value = this.spsValue = data.value;
            }
        }
        this.showValue();
    };

    p.showValue = function () {
        this.input.val(this.settings.value);
    };

    /**
        * Gets the visible text
        * @method getValue
        * @iatStudioExposed
        * @return {String} The current value
        */
    p.getValue = function () {
        return this.settings.value;
    };

    /**
        * Reset value (text) to the value given by the server.<br/>This will only make sense, if submitOnChange=false
        * @method resetValue
        */
    p.resetValue = function () {
        //console.log('resetValue:', this.settings.value, this.spsValue);
        this.setValue(this.spsValue);
    };

    p.removeFocus = function () {
        //console.debug(this.constructor.name + '[' + this.elem.id + '].removeFocus');
        document.removeEventListener('keypress', this._bind('_onKeyPress'));
        this.el.removeClass('active');
    };

    /**
        * @method submitChange
        * @iatStudioExposed
        * Send value to the server, if binding for this widget exists.  
        * Usage of this method will only make sense, if submitOnChange=false, as otherwise changes are submitted automatically.
        */
    p.submitChange = function () {
        this.spsValue = this.input.val();
        this.sendValueChange({ value: this.spsValue });

        /**
            * @event ValueChanged
            * @param {String} value
            * @iatStudioExposed
            * Fired when index changes.
            */
        var ev = this.createEvent('ValueChanged', { value: this.getValue() });
        ev.dispatch();
    };

    /**
        * Sets maxLength
        * @method setMaxLength
        * @param {Integer} maxLength The maximum length of the value
        */
    p.setMaxLength = function (maxLength) {
        this.settings.maxLength = maxLength;

    };

    /**
        * Returns maxLength.
        * @method getMaxLength 
        * @return {Integer} The maximum length of the value
        */
    p.getMaxLength = function () {

        return this.settings.maxLength;

    };

    /**
        * Sets ellispsis
        * @method setEllipsis
        * @param {Boolean} ellipsis The ellipsis property value
        */
    p.setEllipsis = function (ellipsis) {
        this.settings.ellipsis = ellipsis;
        _ellipsisSettings(this);
    };

    /**
        * Returns ellipsis.
        * @method getEllipsis 
        * @return {Boolean} 'true' if ellipsis is enabled, otherwise 'false'
        */
    p.getEllipsis = function () {
        return this.settings.ellipsis;
    };

    /**
        * Sets a short hint that describes the expected value of the input field
        * @method setPlaceholder
        * @param {String} placeholder The placeholder property value
        */
    p.setPlaceholder = function (placeholder) {
        if (brease.language.isKey(placeholder) === false) {
            this.settings.placeholderTextKey = '';
            this.settings.placeholder = placeholder;
        } else {
            this.settings.placeholderTextKey = placeholder;
            this.settings.placeholder = brease.language.getTextByKey(brease.language.parseKey(placeholder));
        }
        _renderPlaceholder(this);
    };

    /**
        * Gets a short hint that describes the expected value of the input field
        * @method getPlaceholder 
        * @return {String} The placeholder property value
        */
    p.getPlaceholder = function () {
        return this.settings.placeholder;
    };

    /**
        * Sets submitOnChange
        * @method setSubmitOnChange
        * @param {Boolean} submitOnChange The submitOnChange property value
        */
    p.setSubmitOnChange = function (submitOnChange) {
        this.settings.submitOnChange = submitOnChange;
    };

    /**
        * Returns submitOnChange.
        * @method getSubmitOnChange 
        * @return {Boolean} The submitOnChange property value
        */
    p.getSubmitOnChange = function () {

        return this.settings.submitOnChange;

    };

    p.setInputRestriction = function (value) {
        if (brease.language.isKey(value) === false) {
            this.settings.inputRestrictionTextKey = '';
        } else {
            this.settings.inputRestrictionTextKey = value;
            value = brease.language.getTextByKey(brease.language.parseKey(value));
        }

        if (value !== undefined && value !== '') {
            this.settings.inputRestriction = value;
            this.settings.inputRestrictionRegEx = new RegExp(this.settings.inputRestriction);
        } else {
            this.settings.inputRestriction = '';
            this.settings.inputRestrictionRegEx = null;
        }
    };

    p.getInputRestriction = function () {
        return this.settings.inputRestriction;
    };

    /**
        * Sets keyboard
        * @method setKeyboard
        * @param {Boolean} keyboard The keyboard property value
        */
    p.setKeyboard = function (keyboard) {
        this.settings.keyboard = keyboard;

    };

    /**
        * Returns keyboard.
        * @method getKeyboard 
        * @return {Boolean} The keyboard property value
        */
    p.getKeyboard = function () {

        return this.settings.keyboard;
    };

    p.disable = function () {
        if (this.settings.keyboard !== true) {
            this.input.attr('tabindex', -1);
        }
        SuperClass.prototype.disable.apply(this, arguments);
    };

    p.enable = function () {
        if (this.settings.keyboard !== true) {
            this.input.attr('tabindex', this.settings.tabIndex);
        }
        SuperClass.prototype.enable.apply(this, arguments);
    };

    p.setEditable = function (editable, metaData) {
        UtilsEditableBinding.handleEditable(editable, metaData, this, ['value']);
    };

    p.suspend = function () {
        // remove document event listeners to support concent-caching
        document.body.removeEventListener(BreaseEvent.WIDGET_READY, this._bind('keyBoard_readyHandler'));
        document.body.removeEventListener(BreaseEvent.SYSTEM_KEYBOARD_CHANGED, this._bind('changeKeyBoard')); 
        SuperClass.prototype.suspend.apply(this, arguments);
    };

    p.wake = function () { 
        if (!keyboardManager.isCurrentKeyboard(this.keyBoard)) {
            this.changeKeyBoard();
        }
        document.body.addEventListener(BreaseEvent.SYSTEM_KEYBOARD_CHANGED, this._bind('changeKeyBoard')); 
        SuperClass.prototype.wake.apply(this, arguments);
    };

    p.dispose = function () {
        _unbindKeyboard.call(this);
        document.body.removeEventListener(BreaseEvent.SYSTEM_KEYBOARD_CHANGED, this._bind('changeKeyBoard')); 
        if (this.keyBoard) {
            this.keyBoard = null;
        }
        this.input.off();
        SuperClass.prototype.dispose.apply(this, arguments);
    };

    p._initEventHandler = function () {
        // überschreibt BaseWidget._initEventHandler
        if (this.settings.keyboard !== true) {
            this.input.on('focusout', this._bind('_onFocusOut')).on('focusin', this._bind('_onFocusIn'));
            this.el.on(BreaseEvent.MOUSE_DOWN, this._bind('_mouseDownHandler'));
            this.el.on(BreaseEvent.CLICK, this._bind('_clickHandler'));
        } else {
            this.el.on(BreaseEvent.CLICK, this._bind('_clickHandler')).on('click', this._bind('_preventClickHandler')).on('touchstart', this._bind('_preventClickHandler'));
        }
    };

    p._mouseDownHandler = function (e) {
        this.isMouseDown = true;
        $(window).on(BreaseEvent.MOUSE_UP, this._bind('_windowMouseUpHandler'));
    };

    p._windowMouseUpHandler = function (e) {
        if (this.el.has(e.target).length === 0 && e.target !== this.elem) {
            this._onFocusOut();
        }
        $(window).off(BreaseEvent.MOUSE_UP, this._bind('_windowMouseUpHandler'));
        this.isMouseDown = false;
    };

    p._clickHandler = function (e) {
        //console.debug(this.constructor.name + '[' + this.elem.id + ']._clickHandler');
        if (!this.isDisabled && brease.config.editMode !== true) {
            if (this.settings.keyboard === true) {
                _showKeyboard.call(this, this.settings.value);
                this.el.addClass('active');
            } else {
                this._onFocusIn();
            }

        }
        SuperClass.prototype._clickHandler.call(this, e);
    };

    function _showKeyboard(value) {
        _bindKeyboard.call(this);
        // keyboard expects undefined for restrict, if no restriction should be set
        // var restrict = this.settings.inputRestriction !== '' ? this.settings.inputRestriction : undefined;
        this.keyBoard.show({
            text: value,
            restrict: this.settings.inputRestriction,
            maxLength: this.settings.maxLength,
            type: this.settings.type,
            header: this.settings.header,

            // additional attributes to identify binding in KeyBoard
            contentId: this.settings.parentContentId,
            widgetId: this.elem.id,
            bindingAttributes: ['value']
        }, this.elem);
    }

    p.changeKeyBoard = function (e) {
        _unbindKeyboard.call(this);
        this.createKeyBoard();
        if (this.el.hasClass('active') && this.settings.keyboard === true) {
            _showKeyboard.call(this, e.detail.currentValue); 
        }
    };

    p._onFocusIn = function (e) {
        if (this.isDisabled === true) {
            this.input.blur();
        } else {
            this.input[0].focus();
            this.input[0].addEventListener('keypress', this._bind('_onKeyPress'));
            this.el.addClass('active');
        }
        //console.log('[' + this.elem.id + ']' + e.type + ':', e.originalEvent);
    };

    p._onFocusOut = function (e) {
        if (!this.isMouseDown) {
            _internalSetValue.call(this, this.input.val());
            if (this.settings.submitOnChange === true || this.forceSend === true) {
                this.submitChange();
            }
            this.forceSend = false;
            this.removeFocus();
        }
    };

    p._onKeyPress = function (e) {
        //console.log('TextInput[' + this.elem.id + ']._onKeyPress:', e.which);
        // Check "which" and "keyCode" for browser support
        var keyCode;
        if (e.which) {
            keyCode = e.which;
        } else {
            keyCode = e.keyCode;
        }

        if (keyCode === 13) {
            this.forceSend = true;
            this.input.blur();
            return;
        }
        var char0 = String.fromCharCode(keyCode);

        if (!_validateInput(this, char0)) {
            e.preventDefault();

        }
    };

    p._inputChangeHandler = function (e) {
        e.stopPropagation();
    };

    p._onKeyBoardClose = function () {
        _unbindKeyboard.call(this);
        this.el.removeClass('active');
    };

    p._onKeyBoardSubmit = function (e) {
        _internalSetValue.call(this, e.detail);
        if (this.settings.submitOnChange) {
            this.submitChange();
        }
    };

    p.langChangeHandler = function (e) {
        if (this.settings.placeholderTextKey !== undefined && this.settings.placeholderTextKey !== '') {
            this.setPlaceholder(this.settings.placeholderTextKey);
        }
        if (this.settings.inputRestrictionTextKey !== undefined && this.settings.inputRestrictionTextKey !== '') {
            this.setInputRestriction(this.settings.inputRestrictionTextKey);
        }
    };

    function _unbindKeyboard() {
        if (this.keyBoard) {
            this.keyBoard.removeEventListener(BreaseEvent.CLOSED, this._bind('_onKeyBoardClose'));
            this.keyBoard.removeEventListener(BreaseEvent.SUBMIT, this._bind('_onKeyBoardSubmit'));
        }
    }

    function _bindKeyboard() {
        if (this.keyBoard) {
            this.keyBoard.addEventListener(BreaseEvent.CLOSED, this._bind('_onKeyBoardClose'));
            this.keyBoard.addEventListener(BreaseEvent.SUBMIT, this._bind('_onKeyBoardSubmit'));
        }
    }

    function _validateInput(widget, value) {
        if (widget.settings.inputRestrictionRegEx !== undefined && widget.settings.inputRestrictionRegEx !== null &&
            widget.settings.inputRestrictionRegEx.test(value) === false) {
            return false;
        }
        return true;
    }

    function _internalSetValue(value) {
        //console.debug(this.constructor.name + '[' + this.elem.id + '].setValue:', value);
        this.settings.value = value;
        this.showValue();

        /**
            * @event change
            * Fired when value is changed by user    
            * @param {String} value
            * See at {@link brease.events.BreaseEvent#static-property-CHANGE BreaseEvent.CHANGE} for event type  
            * @eventComment
            */
        this.dispatchEvent(new CustomEvent(BreaseEvent.CHANGE, { detail: { value: this.settings.value } }));
    }

    function _createInputField(type) {
        this.settings.type = ((type !== undefined) ? type : Enum.InputType.text);
        var attr = { type: this.settings.type };
        if (_.isNumber(this.settings.maxLength)) {
            attr.maxlength = this.settings.maxLength;
        }
        attr.tabindex = (this.settings.keyboard !== true) ? this.settings.tabIndex : -1;
        if (this.settings.keyboard === true) {
            attr.readonly = 'readonly';
        }

        // Unclear when this event should be fired??
        return $('<input>').attr(attr).on('change', this._bind('_inputChangeHandler')).appendTo(this.el);
    }

    function _ellipsisSettings(widget) {
        if (widget.settings.ellipsis !== undefined) {
            widget.settings.ellipsis = Types.parseValue(widget.settings.ellipsis, 'Boolean');
        }
        if (widget.settings.ellipsis === true) {
            widget.el.addClass('ellipsis');
        } else {
            widget.el.removeClass('ellipsis');
        }
    }

    function _renderPlaceholder(widget) {
        var inputElem = widget.input.get(0);
        if (widget.settings.placeholder !== undefined && widget.settings.placeholder !== '') {
            inputElem.setAttribute('placeholder', widget.settings.placeholder);
        } else {
            inputElem.removeAttribute('placeholder');
        }
    }

    return dragAndDropCapability.decorate(languageDependency.decorate(WidgetClass, true), false);

});
