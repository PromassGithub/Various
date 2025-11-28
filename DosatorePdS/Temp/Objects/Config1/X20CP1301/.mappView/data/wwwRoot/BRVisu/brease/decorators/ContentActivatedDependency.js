define(['brease/core/Decorator', 'brease/events/ClientSystemEvent', 'brease/enum/Enum'], function (Decorator, ClientSystemEvent, Enum) {

    'use strict';

    var ContentActivatedDependency = function () {
            this.initType = Decorator.TYPE_POST;
        },
        dependency = 'contentActivated',
        event = 'contentActivated',
        changeHandler = 'contentActivatedHandler';
        
    /**
    * @class brease.decorators.ContentActivatedDependency
    * @extends brease.core.Decorator
    * #Description
    * A decorator class to add functionality of contentActivated dependency to widgets which calls the method contentActivatedHandler 
    * as soon as the widget's content gets activated on the server in order to do some rendering initialization. e.g.: triggering a redraw
    * ##Example:  
    *
    *     define(['brease/core/BaseWidget', 'brease/decorators/ContentActivatedDependency'], function (SuperClass, contentActivatedDependency) {
    *     
    *       var defaultSettings = {},
    *       WidgetClass = SuperClass.extend(function Label() {
    *           SuperClass.apply(this, arguments);
    *       }, defaultSettings); 
    *
    *            [...]
    *     
    *        return contentActivatedDependency.decorate(WidgetClass);
    *     });
    *
    *
    * @iatMeta studio:visible
    * false
    */

    /**
    * @method decorate
    * decorate a widget class with functionality of contentActivated dependency
    * @param {brease.core.WidgetClass} widgetClass
    * @param {Boolean} initialDependency Initial dependency of widget instances
    * @return {brease.core.WidgetClass} returns decorated WidgetClass
    */

    ContentActivatedDependency.prototype = new Decorator();
    ContentActivatedDependency.prototype.constructor = ContentActivatedDependency;

    var instance = new ContentActivatedDependency();
    /**
    * @property {Object} methodsToAdd
    * @property {Function} methodsToAdd.setContentActivatedDependency
    * @property {Boolean} methodsToAdd.setContentActivatedDependency.flag  
    * Enable or disable contentActivated dependency; dependent widgets listen to contentActivated changes and execute method *contentActivatedHandler* on changes
    */
    instance.methodsToAdd = {

        init: function (initialDependency) {
            if (this[changeHandler] === undefined) {
                throw new Error('widget \u00BB' + this.elem.id + '\u00AB: decoration with "' + instance.constructor.name + '" requires method "' + changeHandler + '"');
            }

            this.dependencies[dependency] = {
                state: Enum.Dependency.INACTIVE,
                suspend: suspend.bind(this),
                wake: wake.bind(this),
                event: event
            };
            if (initialDependency === true) {
                this.setContentActivatedDependency(initialDependency);
            }
        },

        setContentActivatedDependency: function (flag) {
            if (flag === true) {
                setState.call(this, Enum.Dependency.ACTIVE);
            } else {
                setState.call(this, Enum.Dependency.INACTIVE);
            }
        },

        dispose: function () {
            this.dependencies[dependency] = null;
            removeListener.call(this);
        }

    };

    function suspend() {
        if (this.dependencies[dependency].state === Enum.Dependency.ACTIVE) {
            setState.call(this, Enum.Dependency.SUSPENDED);
        }
    }

    function wake() {
        if (this.dependencies[dependency].state === Enum.Dependency.SUSPENDED) {
            setState.call(this, Enum.Dependency.ACTIVE);
        }
    }

    function setState(state) {
        if (this.dependencies[dependency]) {
            this.dependencies[dependency].state = state;
            if (state === Enum.Dependency.ACTIVE) {
                removeListener.call(this);
                addListener.call(this);
            } else {
                removeListener.call(this);
            }
        }
    }

    function addListener() {
        brease.appElem.addEventListener(ClientSystemEvent.CONTENT_LOADED, this._bind(_contentActivatedHandler));
    }

    function removeListener() {
        brease.appElem.removeEventListener(ClientSystemEvent.CONTENT_LOADED, this._bind(_contentActivatedHandler));
    }
    function _contentActivatedHandler(e) {
        if (e.detail.contentId === this.getParentContentId()) {
            removeListener.call(this);
            this[changeHandler]();
        }
    }
    return instance;
});
