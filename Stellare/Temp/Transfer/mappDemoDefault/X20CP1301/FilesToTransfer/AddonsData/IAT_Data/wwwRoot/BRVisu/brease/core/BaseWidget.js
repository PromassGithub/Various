define(['brease/core/Class',
    'brease/events/BreaseEvent',
    'brease/config',
    'brease/core/Utils', 
    'brease/enum/Enum',
    'brease/core/Types', 
    'brease/events/EventHandler', 
    'brease/decorators/Permissions', 
    'brease/controller/FileManager', 
    'brease/core/libs/AsyncProcess', 
    'brease/decorators/TooltipDependency'],
function (SuperClass, BreaseEvent, config, Utils, Enum, Types, EventHandler, permissions, fileManager, AsyncProcess, tooltipDependency) {

    'use strict';

    /**
    * @class brease.core.BaseWidget
    * @abstract
    * Base class for all widgets.  
    * It should not usually be necessary to use this base widget directly, because there are provided subclasses  
    * which implement specialized widget use cases which cover application needs.  
    * @extends Class
    * @iatMeta studio:visible
    * false
    */
    /**
    * @property {WidgetList} [parents=["*"]]
    * Allowed parents for this Widget.  
    */
    /**
    * @property {WidgetList} [children=[]]
    * Allowed children for this Widget.  
    */
    /**
    * @cfg {Boolean} omitClass=false
    * Option to disable addition of widget CSS class  
    */
    /**
    * @cfg {Boolean} omitDisabledClick=false
    * Option to prevent the widget from dispatching 
    * DisabledClick events. Used if widget is created
    * inside another widget. e.g.: ToggleButton inside FlyOut widget
    */
    /**
    * @cfg {StyleReference} style='default'
    * @iatStudioExposed
    * @iatCategory Appearance 
    * @bindable
    * reference to a style for this widget type
    */

    /**
    * @cfg {Boolean} enable=true
    * @bindable
    * @iatStudioExposed
    * @iatCategory Behavior 
    * Initial option to enable widget.  
    */

    /**
    * @cfg {Boolean} visible=true
    * @bindable
    * @iatStudioExposed
    * @iatCategory Behavior 
    * change visibility
    */

    /**
    * @cfg {RoleCollection} permissionView
    * @iatStudioExposed
    * @iatCategory Accessibility 
    * restricts visibility to users, which have given roles
    */

    /**
    * @cfg {RoleCollection} permissionOperate
    * @iatStudioExposed
    * @iatCategory Accessibility 
    * restricts operability to users, which have given roles
    */

    /**
    * @cfg {String} tooltip=''
    * @localizable
    * @iatStudioExposed
    * @iatCategory Appearance 
    * reference to a tooltip for a widget
    */

    /**
    * @method showTooltip
    * @iatStudioExposed
    */
    var defaultSettings = {
            enable: true,
            editable: true,
            visible: true,
            omitClass: false,
            style: 'default',
            stylePrefix: '',
            permissions: {
                view: true,
                operate: true
            },
            parentVisibleState: true,
            parentEnableState: true,
            tooltip: '',
            omitDisabledClick: false
        },

        BaseWidget = SuperClass.extend(function BaseWidget(elem, options, deferredInit) {
            SuperClass.call(this);
            Utils.defineProperty(this, 'dependencies', {});
            this.tooltip = {};
            this.events = {};
            this.internalData = {};
            this.initialized = false;
            if (options !== undefined && options !== null) {
                this.settings = Utils.extendOptionsToNew(this.defaultSettings, options);
            } else {
                this.settings = Utils.deepCopy(this.defaultSettings);
            }
            this.settings.className = this.constructor.defaults.className;
            if (elem !== null && elem !== undefined) {
                this.elem = elem;
                this.el = $(elem);
            }
            if (this.constructor.static.multitouch === true) {
                this.el.attr('data-multitouch', 'true');
            }
            this.isDisabled = false;
            this.isHidden = false;
            this._cssClasses = (brease.config.editMode === true) ? ['editMode', 'breaseWidget'] : ['breaseWidget'];
            this._cssUpdates = {};
            if (deferredInit !== true) {
                this.omitReadyEvent = true;
                this.init();
            }
        },
        defaultSettings),
        _asyncProcess = new AsyncProcess(),

        p = BaseWidget.prototype;

    p.init = function (omitReadyEvent) {
        this.omitReadyEvent = omitReadyEvent;
        this._internalEnable();
        this.updateVisibility(true);

        if (Utils.isString(this.settings.position)) {
            this._cssUpdates.position = this.settings.position;
            this._invalidate();
        }

        _setStylePrefix(this);

        if (this.settings.styleClassAdded !== true) {
            this.addInitialClass(this.settings.stylePrefix + '_style_' + this.settings.style);
        }
        this.addClassNames(this._cssClasses);
        this._initEventHandler();
        if (brease.config.preLoadingState === true) {
            this.internalData.preLoaded = true;
        }
        this._waitForBinding();

        if (brease.config.editMode === true) {
            this._initEditor();
        }
    };

    p._initEditor = function () {
        //override in Widgets if needed
    };

    p.addClassNames = function (classNames) {
        if (this.elem !== undefined && classNames.length > 0) {
            var actNames = this.elem.className,
                arNames = actNames.split(' '),
                str = '';
            for (var i = 0; i < classNames.length; i += 1) {
                if (arNames.indexOf(classNames[i]) === -1) {
                    str += ((str !== '') ? ' ' : '') + classNames[i];
                }
            }
            this.elem.className = ((actNames !== '') ? actNames + ' ' : '') + str;
        }
        this.initialized = true;
    };
    /**
        * @method setStyle
        * @iatStudioExposed
        * @param {StyleReference} value
        */
    p.setStyle = function (value) {
        this.el.removeClass(this.settings.stylePrefix + '_style_' + this.settings.style);
        this.settings.style = value;
        this.el.addClass(this.settings.stylePrefix + '_style_' + this.settings.style);

    };

    p.getStyle = function () {
        return this.settings.style;
    };

    p.resetStyles = function () {
        if (this.el) {
            this.el.removeClass(this.settings.stylePrefix + '_style_' + this.settings.style);
            for (var i = 0; i < this.elem.classList.length; i += 1) {
                if (this.elem.classList[i].indexOf(this.settings.stylePrefix) === 0) {
                    this.el.removeClass(this.elem.classList[i]);
                }
            }
            this.settings.style = 'default';
            this.el.addClass(this.settings.stylePrefix + '_style_' + this.settings.style);
        }
    };

    p._invalidate = function () {
        //this._defer('_cssRender');
        this._cssRender();
    };

    p._defer = function (methodName) {

        if (this.queue === undefined) {
            this.queue = [];
        }
        if (this.queue.indexOf(methodName) === -1) {
            this.queue.push(methodName);
        }
        if (this._updatePending !== true) {
            this._updatePending = true;
            _asyncProcess.add(this._bind('_processDefered'));
        }
    };

    p._processDefered = function () {

        this._updatePending = false;
        for (var i = 0, l = this.queue.length; i < l; i += 1) {
            this[this.queue[i]]();
        }
        this.queue.length = 0;
    };

    p._cssRender = function () {
        if (Object.keys(this._cssUpdates).length > 0) {
            this.el.css(this._cssUpdates);
            this._cssUpdates = {};
        }
    };

    p._setCSSUpdate = function (cssProperty, unitSuffix, optionsKey, dataType, config) {
        this.settings[optionsKey] = Types.parseValue(this.settings[optionsKey], dataType, config);
        this._cssUpdates[cssProperty] = this.settings[optionsKey] + unitSuffix;
    };

    p._setWidth = function (w) {
        this.settings.width = w;
        //this._cssUpdates.width = this.settings.width + ((this.settings.width.indexOf('%') !== -1) ? '' : 'px');
        //this._invalidate();
    };

    p._setHeight = function (h) {
        this.settings.height = h;
        //this._cssUpdates.height = this.settings.height + ((this.settings.height.indexOf('%') !== -1) ? '' : 'px');
        //this._invalidate();
    };

    p.deferredInit = function (container, html, omitReadyEvent) {
        this.el = $(html).prependTo(container);
        this.elem = this.el[0];
        this.init(omitReadyEvent);
    };

    p.addInitialClass = function (className) {
        if (this._cssClasses.indexOf(className) === -1) {
            this._cssClasses.push(className);
        }
    };

    p.removeInitialClass = function (className) {
        var index = this._cssClasses.indexOf(className);
        if (index !== -1) {
            this._cssClasses.splice(index, 1);
        }
    };

    /**
        * @method createEvent
        * method creates an event object for a widget
        * @param {String} event name of the event
        * @param {Object} eventArgs Object of event arguments
        */
    p.createEvent = function (event, eventArgs) {
        if (this.settings.className && this.elem !== null) {
            if (this.events[event] !== undefined) {
                this.events[event].setEventArgs(eventArgs);
                return this.events[event];
            } else {
                var type = fileManager.getPathByClass(this.settings.className, 'type');
                this.events[event] = new EventHandler(type + '.Event', this.elem.id, event, eventArgs, this.elem);
                return this.events[event];
            }
        } else {
            console.iatWarn('could not create Event');
            return undefined;
        }
    };

    /**
    * @method createMouseEvent
    * method creates an mouse event object for a widget with position arguments
    * @param {String} event name of the event
    * @param {Object} eventArgs Object of event arguments
    * @param {Object} e event object
    */
    p.createMouseEvent = function (event, eventArgs, e) {
        eventArgs = eventArgs || {};

        var rootZoom = brease.pageController.getRootZoom();
        if (!_.isNumber(rootZoom) || rootZoom === 0) { rootZoom = 1; }

        eventArgs.horizontalPos = e.clientX ? Math.round(e.clientX / rootZoom) + 'px' : '0px';
        eventArgs.verticalPos = e.clientY ? Math.round(e.clientY / rootZoom) + 'px' : '0px';

        return this.createEvent(event, eventArgs);
    };

    p.dispatchServerEvent = function (eventName, eventArgs) {
        var ev = this.createEvent(eventName, eventArgs);
        if (ev) {
            ev.dispatch(false);
        }
    };

    /**
        * @method disable
        * Disable widget  
        * This method sets the state 'isDisabled' of the widget (to true) only and adds CSS class 'disabled'.  
        * Inherited widgets have to specify what 'disabled' means for them.  
        * In a Button in default style for example, it means that click and mousedown events are not propagated and the button appears in grayscale.  
        */
    p.disable = function () {
        //console.log('BaseWidget[' + ((this.elem) ? this.elem.id : 'undefined') + '].disable');

        if (this.isDisabled === false) {
            this.isDisabled = true;
            if (this.initialized !== true) {
                this.addInitialClass('disabled');
            } else {
                this.el.addClass('disabled');
                this._enableHandler(false);
            }
        }
    };

    /**
        * @method enable
        * Enable widget  
        * This method only sets the state 'isDisabled' of the widget (to false) and removes CSS class 'disabled'  
        * Inherited widgets have to specify what 'disabled' means for them.  
        */
    p.enable = function () {
        //console.log('BaseWidget[' + ((this.elem) ? this.elem.id : 'undefined') + '].enable');
        if (this.isDisabled === true) {
            this.isDisabled = false;
            if (this.initialized !== true) {
                this.removeInitialClass('disabled');
            } else {
                this.el.removeClass('disabled');
                this._enableHandler(true);
            }
        }
    };

    /**
        * @method setEnable
        * @iatStudioExposed
        * Sets the state of property «enable»
        * @param {Boolean} value
        */
    p.setEnable = function (value) {
        var metaData = arguments[1];
        this.settings.enable = Types.parseValue(value, 'Boolean');
        this._internalEnable();
        var origin = (metaData) ? metaData.origin : undefined;
        if (origin !== 'server') {
            this.sendValueChange({ enable: this.getEnable() });
        }
    };

    /**
        * @method
        * Is called after the operability of the widget is changed.   
        * This method is not mentioned to be called from outside, but acts as a hook for widgets.  
        * It can be overridden in widgets to react on operability changes.    
        * @param {Boolean} operability
        */
    p._enableHandler = function (operability) {
        //override in Widgets if needed
    };

    /**
        * @method
        * Is called after the visibility of the widget is changed.   
        * This method is not mentioned to be called from outside, but acts as a hook for widgets.  
        * It can be overridden in widgets to react on visibility changes.    
        * @param {Boolean} visibility
        */
    p._visibleHandler = function (visibility) {
        //override in Widgets if needed
    };

    /**
        * @method setEditable
        * Sets the state of property «editable»  
        * Used for «editable» binding; method is called exclusevely by the framework
        * @param {Boolean} editable
        * @param {Object} metaData
        * @param {String} metaData.attribute name of property = 'editable'
        * @param {String} metaData.refAttribute name of original bound property
        * @param {Boolean} metaData.value 
        */
    p.setEditable = function (editable, metaData) {
        // support for editable binding
        // metaData contains information about the original bound property: metaData.refAttribute
        // override in supported widgets:

        //if (metaData !== undefined && metaData.refAttribute !== undefined) {
        //    var refAttribute = metaData.refAttribute;
        //    if (refAttribute === 'supportedAttribute, e.g node or value') {
        //        this.settings.editable = editable;
        //        this._internalEnable();
        //    }
        //}
    };

    /**
        * @method getEditable
        * Returns the state of property «editable»
        * @param {String} refAttribute name of original bound property
        * @return {Boolean}
        */
    p.getEditable = function () {
        return this.settings.editable;
    };

    /**
        * @method getEnable
        * Returns the state of property «enable»
        * @return {Boolean}
        */
    p.getEnable = function () {
        return this.settings.enable;

    };

    /**
        * @method setVisible
        * @iatStudioExposed
        * Sets the state of property «visible»
        * @param {Boolean} value
        */
    p.setVisible = function (value) {
        var metaData = arguments[1];
        this.settings.visible = Types.parseValue(value, 'Boolean');
        this.updateVisibility();
        var origin = (metaData) ? metaData.origin : undefined;
        if (origin !== 'server') {
            this.sendValueChange({ visible: this.getVisible() });
        }
    };

    /**
        * @method getVisible
        * Returns the state of property «visible»
        * @return {Boolean}
        */
    p.getVisible = function () {
        return this.settings.visible;
    };

    /**
        * @method getSettings
        * Returns the actual settings of the widget.
        * @return {Object} settings Actual settings parsed from config options and defaultSettings
        */
    p.getSettings = function () {

        return this.settings;
    };
    /**
       * @method getDefaultSettings
       * Returns the default settings of the widget.
       * @return {Object} defaultSettings
       */
    p.getDefaultSettings = function () {
        return this.defaultSettings;
    };

    /**
        * @method isEnabled
        * Returns true if widget is enabled and false if widget is disabled
        * @return {Boolean}
        */
    p.isEnabled = function () {
        return !this.isDisabled;
    };

    /**
        * @method isVisible
        * Returns true if widget is visible and false if widget is hidden
        * @return {Boolean}
        */
    p.isVisible = function () {
        return !this.isHidden;
    };

    /**
        * @method addEventListener
        * adds eventlistener to the widget html element
        * @param {String} type event type
        * @param {Function} listener
        */
    p.addEventListener = function (type, listener) {
        if (this.elem) {
            this.elem.addEventListener(type, listener);
        }
    };

    /**
        * @method removeEventListener
        * removes eventlistener from the widget html element
        * @param {String} type event type
        * @param {Function} listener
        */
    p.removeEventListener = function (type, listener) {
        if (this.elem) {
            this.elem.removeEventListener(type, listener);
        }
    };

    p.dispatchEvent = function (event) {
        try {
            this.elem.dispatchEvent(event);
        } catch (e) {
            console.iatWarn(e.message);
            console.iatWarn(this.settings.className + '[' + ((this.elem) ? this.elem.id : 'undefined elem') + '].dispatchEvent(' + event.type + '):' + e.message);
        }
    };

    p.onBeforeSuspend = function () {
        //console.log('%c            ' + this.elem.id + '.onBeforeSuspend', 'color:#cc0000;');
        // override in widgets if needed
    };

    /**
        * @method
        * Do not call 'suspend' directly, use uiController.suspendInContent instead
        */
    p.suspend = function () {
        //console.log('%c            ' + this.elem.id + '.suspend', 'color:#cc0000;');

        for (var key in this.dependencies) {
            this.dependencies[key].suspend();
        }
    };

    /**
        * @method
        * Do not call *wake* directly, use uiController.wakeInContent instead, otherwise arguments are missing  
        */
    p.wake = function (events, preserveOldValues, bindings) {
        //console.log('%c            ' + this.elem.id + '.wake', 'color:#00cc00;');

        for (var key in this.dependencies) {
            this.dependencies[key].wake(events[this.dependencies[key].event]);
        }
    };

    p.onBeforeDispose = function () {
        //console.log('%c            ' + this.elem.id + '.onBeforeDispose', 'color:#00aaaa;');
        // override in widgets if needed
    };

    p.dispose = function (keepBindingInformation) {
        //console.warn('%c            ' + this.elem.id + '.dispose', 'color:#999999;');
        if (this.queue) {
            this.queue.length = 0;
        }
        for (var ev in this.events) {
            this.events[ev].dispose();
        }
        this.events = null;
        this.el.off();
        this.el.empty();
        document.body.removeEventListener(BreaseEvent.BINDING_LOADED, this._bind(_bindingLoadedHandler));
        SuperClass.prototype.dispose.call(this);
        brease.uiController.setWidgetState(this.elem.id, Enum.WidgetState.NON_EXISTENT);
        document.body.dispatchEvent(new CustomEvent(BreaseEvent.WIDGET_DISPOSE, { detail: { id: this.elem.id, keepBindingInformation: keepBindingInformation }, bubbles: true }));
        this.el.remove();
        this.el = null;
        this.elem = null;
    };

    /**
        * @method
        * Dispatch changes of a attribute value for data binding. 
        * @param {Object} data  
        * data is a key/value object, where *key* is the name of the property and *value* is the value of the property.  
        * Example: {"selectedIndex":2}
        */
    p.sendValueChange = function (detail) {
        //console.debug('BaseWidget[id=' + this.elem.id + '].sendValueChange:', detail);
        this.dispatchEvent(new CustomEvent(BreaseEvent.ATTRIBUTE_CHANGE, { detail: detail, bubbles: true }));
        brease.uiController.bindingController.attributeChangeForwarder({ target: { id: this.elem.id }, detail: detail });
    };

    /**
        * @method
        * Dispatch changes of a Node for data binding.
        * @param {brease.objects.NodeData} data  
        * Example NumericInput: this.sendNodeChange({ attribute: "node", nodeAttribute: "unit", value: this.data.unitCode });
        */
    p.sendNodeChange = function (detail) {
        //console.debug('BaseWidget[id=' + this.elem.id + '].sendNodeChange:', detail);
        this.dispatchEvent(new CustomEvent(BreaseEvent.NODE_ATTRIBUTE_CHANGE, { detail: detail, bubbles: true }));
        brease.uiController.bindingController.nodeAttributeChangeForwarder({ target: { id: this.elem.id }, detail: detail });
    };

    /**
        * @event property_changed
        * Fired if a bound attribute is changed by a server call  
        * @param {String} attribute Name of bound attribute
        * @param {ANY} value Value sent by server
        * See at {@link brease.events.BreaseEvent#static-property-PROPERTY_CHANGED BreaseEvent.PROPERTY_CHANGED} for event type  
        * @eventComment
        */

    p._handleEvent = function (e, forceStop) {
        //console.debug('_handleEvent:',this,e,forceStop);
        if (e.originalEvent) {
            // on devices with mouse and touch support (Mouse-Touch-Device) the call of preventDefault on a touch event will prevent mouse-emulation
            // virtual event vclick starts on touchstart, therefore preventDefault will prevent mouse-emulation
            // on a Mouse-Touch-Device the css selector :active normally reacts on mouse events mousedown and mouseup; 
            // if we stop mouse-emulation there will be no following mouse events and thus css reacts on touch events
            // for widgets this is the correct behaviour, as the virtual events vmousedown and vmouseup inherit from the touch events, if they are present
            e.originalEvent.preventDefault();
        }
        if (this.isDisabled === true || forceStop === true) {
            e.stopImmediatePropagation();
        }
    };

    p._dispatchReady = function () {
        //console.log('%c' + this.elem.id +'._dispatchReady','color:red')
        if (this.elem) {
            brease.uiController.setWidgetState(this.elem.id, Enum.WidgetState.READY);
        }
        this.dispatchEvent(new CustomEvent(BreaseEvent.WIDGET_READY, { detail: { widgetType: this.settings.className }, bubbles: true }));
    };

    p._initEventHandler = function () {
        if (this.el) {
            this.el.on(BreaseEvent.CLICK, this._bind('_clickHandler'));
        }

    };

    /**
        * @event Click
        * Fired when element is clicked on.
        * @iatStudioExposed
        * @param {String} origin id of widget that triggered this event
        * @param {String} horizontalPos horizontal position of click in pixel i.e '10px'
        * @param {String} verticalPos vertical position of click in pixel i.e '10px'
        * @eventComment
        */
    p._clickHandler = function (e, additionalArguments) {
        if (this.isDisabled) {
            this._disabledClickHandler(e, additionalArguments);
        } else {

            var eventArgs = _extendArgs({}, additionalArguments, e.target);
            this.createMouseEvent('Click', eventArgs, e).dispatch(false);
        }
    };

    function _extendArgs(original, additional, eventTarget) {
        var newObj = _.assign(original, additional);

        if (!Utils.isString(newObj.origin)) {
            // this way we don't have to call parentWidgetId if there is already one in additionalArguments
            newObj.origin = brease.uiController.parentWidgetId(eventTarget);
        }

        return newObj;
    }

    /**
        * @event DisabledClick
        * Fired when disabled element is clicked on.
        * @iatStudioExposed
        * @param {String} origin id of widget that triggered this event
        * @param {Boolean} hasPermission defines if the state is caused due to missing
        * @param {String} horizontalPos horizontal position of click in pixel i.e '10px'
        * @param {String} verticalPos vertical position of click in pixel i.e '10px'
        * roles of the current user 
        * @eventComment
        */
    p._disabledClickHandler = function (e, additionalArguments) {
        // A&P 635010 a click on the ToggleButton of a disabled FlyOut widget does
        // not trigger a DisabledClick event on the FlyOut
        if (!this.settings.omitDisabledClick) {
            var eventArgs = _extendArgs({
                hasPermission: (this.settings.editable && this.settings.permissions.operate)
            }, additionalArguments, e.target);

            var event = this.createMouseEvent('DisabledClick', eventArgs, e);
            event.dispatch(false);

            document.body.dispatchEvent(new CustomEvent(BreaseEvent.DISABLED_CLICK, {
                detail: {
                    contentId: this.getParentContentId(),
                    hasPermission: eventArgs.hasPermission,
                    origin: eventArgs.origin,
                    widgetId: this.elem.id,
                    horizontalPos: event.data.eventArgs.horizontalPos,
                    verticalPos: event.data.eventArgs.verticalPos
                },
                bubbles: true
            }));
            this._handleEvent(e);
        }
    };

    p._internalEnable = function () {
        //console.log(this.elem.id + '._internalEnable');
        _setOperability.call(this);
    };

    p.updateVisibility = function (initial) {
        //console.log(this.elem.id + '.updateVisibility');
        _setVisibility.call(this, this.settings.visible, this.settings.permissions.view, this.settings.parentVisibleState, brease.config.editMode, initial);
        this._visibleHandler();
    };

    p.setParentVisibleState = function (state) {
        this.settings.parentVisibleState = state;
        this.updateVisibility();
    };

    p.setParentEnableState = function (state) {
        this.settings.parentEnableState = state;
        this._internalEnable();
    };

    p._waitForBinding = function () {
        if (this.getParentContentId() === undefined || this.getParentContentId() === brease.settings.globalContent) {
            // widget is not related to a content -> no binding
            this._initialValueHandling();

        } else if (brease.uiController.bindingController.isBindingLoaded(this.getParentContentId())) {
            // binding of related content is already loaded
            this._initialValueHandling(brease.uiController.bindingController.getSubscriptionsForElement(this.elem.id));
        } else {
            // binding of related content is NOT laoded -> wait for it
            document.body.addEventListener(BreaseEvent.BINDING_LOADED, this._bind(_bindingLoadedHandler));
        }
    };

    p._initialValueHandling = function (bindings) {
        this.bindings = bindings;
        //if (bindings) {
        // widget has bindings -> wait for binded values
        //} else {
        // widget has no bindings -> show initial (or default) values
        //}
    };

    p.getParentContentId = function () {
        return this.settings.parentContentId;
    };

    //***************//
    //*** PRIVATE ***//
    //***************//

    function _bindingLoadedHandler(e) {
        if (e.detail.contentId === this.getParentContentId()) {
            document.body.removeEventListener(BreaseEvent.BINDING_LOADED, this._bind(_bindingLoadedHandler));
            this._initialValueHandling(brease.uiController.bindingController.getSubscriptionsForElement(this.elem.id));
        }
    }

    function _setOperability() {
        var oldValue = this.isDisabled;
        if (this.settings.enable !== true || this.settings.editable !== true || this.settings.permissions.operate !== true || this.settings.parentEnableState !== true) {
            this.disable();
        } else {
            this.enable();
        }
            
        /**
            * @event EnableChanged
            * Fired when operability of the widget changes.
            * @param {Boolean} value operability
            * @iatStudioExposed 
            * @eventComment
            */
        if (this.isDisabled !== oldValue) {
            //console.log('%c' + this.elem.id + '.setOperability:oldValue=' + !oldValue + '/newValue=' + !this.isDisabled, 'color:#00cccc');
            var ev = this.createEvent(BreaseEvent.ENABLE_CHANGED, { value: !this.isDisabled });
            if (ev) {
                ev.dispatch();
            }
        }
    }

    function _setVisibility(visibilitySetting, viewPermission, parentVisibleState, editMode, initial) {
        if (editMode !== true) {
            var oldValue = this.isHidden;
            //console.log(this.elem.id+':',{visibilitySetting:visibilitySetting, viewPermission:viewPermission, parentVisibleState:parentVisibleState});
            if (visibilitySetting !== true || viewPermission !== true || parentVisibleState !== true) {
                if (initial) {
                    this.addInitialClass('remove');
                } else { 
                    if (this.isHidden === false) {
                        this.el.addClass('remove'); 
                    }
                }
                this.isHidden = true;
            } else {
                if (!initial) {
                    if (this.isHidden === true) {
                        this.el.removeClass('remove'); 
                    }
                    this.isHidden = false;
                }
            }

            /**
                * @event VisibleChanged 
                * Fired when the visibility of the widget changes.
                * @param {Boolean} value visibility
                * @iatStudioExposed 
                * @eventComment
                */
            if (this.isHidden !== oldValue) {
                //console.log('%c' + this.elem.id + '.setVisibility:oldValue=' + !this.isHidden, 'color:#cc00cc');
                var ev = this.createEvent(BreaseEvent.VISIBLE_CHANGED, { value: !this.isHidden });
                if (ev) {
                    ev.dispatch();
                }
            }
        }
    }

    function _setStylePrefix(widget) {
        if (!widget.settings.stylePrefix) {
            if (widget.constructor.defaults.stylePrefix === undefined) {
                widget.constructor.defaults.stylePrefix = fileManager.getPathByClass(widget.settings.className, 'style');
            }
            widget.settings.stylePrefix = widget.constructor.defaults.stylePrefix;
        }
    }

    permissions.decorate(BaseWidget, brease.config.editMode !== true, {
        permissions: {
            view: {
                property: 'permissionView', updateMethod: 'updateVisibility'
            },
            operate: {
                property: 'permissionOperate', updateMethod: '_internalEnable'
            }
        }
    });

    tooltipDependency.decorate(BaseWidget, true);

    return BaseWidget;

});
