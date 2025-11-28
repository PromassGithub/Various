define(['brease/core/BaseWidget', 'brease/events/BreaseEvent', 'brease/enum/Enum', 'brease/core/Utils', 'brease/core/ContainerUtils'], function (SuperClass, BreaseEvent, Enum, Utils, ContainerUtils) {

    'use strict';

    /**
    * @class brease.core.ContainerWidget
    * @abstract
    * Base class for all container widgets.  
    * It should not usually be necessary to use this widget directly, because there are provided subclasses  
    * which implement specialized widget use cases which cover application needs.  
    * @extends brease.core.BaseWidget 
    *
    * @iatMeta studio:visible
    * false
    */

    /**
    * @property {WidgetList} children=["*"]
    * @inheritdoc  
    */
    var defaultSettings = {},

        WidgetClass = SuperClass.extend(function ContainerWidget() {
            SuperClass.apply(this, arguments);
        }, defaultSettings),

        p = WidgetClass.prototype;

    WidgetClass.widgetAddedHandler = 'widgetAddedHandler';
    WidgetClass.widgetRemovedHandler = 'widgetRemovedHandler';
    WidgetClass.widgetChangedHandler = 'widgetChangedHandler';

    p.init = function () {
        this.containerVisibility = true;
        this.el.wrapInner('<div class="container" />');
        this.getContainer();
        addListener.call(this);
        this.debouncedRefresh = _.debounce(this._refresh.bind(this), 100);
        
        SuperClass.prototype.init.apply(this, arguments);
    };

    p.disable = function () {
        SuperClass.prototype.disable.apply(this, arguments);
        if (this.initialized !== true) {
            ContainerUtils.inheritProperty(selectChildren(this.getContainer()), 'parentEnableState', false);
        }
    };

    p._enableHandler = function () {
        SuperClass.prototype._enableHandler.apply(this, arguments);
        var enabled = this.isEnabled();
        // A&P 630210: FlexBox: PermissionOperate is now applied to the child elements of nested FlexBoxes
        ContainerUtils.inheritProperty(selectChildren(this.getContainer()), 'parentEnableState', enabled);
    };

    p.updateChildrenVisibility = function () {
        var visibility = this.containerVisibility === true && this.isVisible();
        // A&P 679570: parentVisibleState from Container widget not applied if child is not initialized
        ContainerUtils.inheritProperty(selectChildren(this.getContainer()), 'parentVisibleState', visibility);
    };

    p.updateVisibility = function () {
        var hidden = this.isHidden;
        SuperClass.prototype.updateVisibility.apply(this, arguments);
        if (this.isHidden !== hidden || brease.config.editMode) {
            hidden = this.isHidden;
            this.updateChildrenVisibility();
        }
        this.elem.dispatchEvent(new CustomEvent(BreaseEvent.VISIBILITY_CHANGED, { bubbles: false, detail: { visible: this.isVisible() } }));
    };

    p.visibilityChangeHandler = function (e) {
        if (this.scroller && ($.contains(e.target, this.elem) || e.target === this.elem || $.contains(this.elem, e.target))) {
            this.debouncedRefresh();
        }
    };

    p._refresh = function () {
        if (this.scroller && this.isVisible()) {
            this.scroller.refresh();
        }
    };

    p.dispose = function () {
        removeListener.call(this);
        if (this.scroller) {
            if (typeof this.scroller.destroy === 'function') {
                this.scroller.destroy();
            }
            this.scroller.wrapper = null;
            this.scroller = null;
        }
        SuperClass.prototype.dispose.apply(this, arguments);
    };

    p.wake = function () {
        SuperClass.prototype.wake.apply(this, arguments);
        document.body.addEventListener(BreaseEvent.VISIBILITY_CHANGED, this._bind('visibilityChangeHandler'), true);
    };

    p.suspend = function () {
        document.body.removeEventListener(BreaseEvent.VISIBILITY_CHANGED, this._bind('visibilityChangeHandler'), true);
        SuperClass.prototype.suspend.apply(this, arguments);
    };

    p.getContainer = function () {
        if (this.container === undefined) {
            this.container = this.el.find('>.container');
        }
        return this.container;
    };

    p[WidgetClass.widgetAddedHandler] = function () { };
    p[WidgetClass.widgetRemovedHandler] = function () { };
    p[WidgetClass.widgetChangedHandler] = function () {
        this.debouncedRefresh();
    };

    function addListener() {
        if (brease.config.editMode === true) {
            this.elem.addEventListener(BreaseEvent.WIDGET_ADDED, this._bind(WidgetClass.widgetAddedHandler));
            this.elem.addEventListener(BreaseEvent.WIDGET_REMOVED, this._bind(WidgetClass.widgetRemovedHandler));
            this.elem.addEventListener(BreaseEvent.WIDGET_PROPERTIES_CHANGED, this._bind(WidgetClass.widgetChangedHandler));
        }
        document.body.addEventListener(BreaseEvent.VISIBILITY_CHANGED, this._bind('visibilityChangeHandler'), true);
    }

    function removeListener() {
        if (brease.config.editMode === true) {
            this.elem.removeEventListener(BreaseEvent.WIDGET_ADDED, this._bind(WidgetClass.widgetAddedHandler));
            this.elem.removeEventListener(BreaseEvent.WIDGET_REMOVED, this._bind(WidgetClass.widgetRemovedHandler));
            this.elem.removeEventListener(BreaseEvent.WIDGET_PROPERTIES_CHANGED, this._bind(WidgetClass.widgetChangedHandler));
        }
        document.body.removeEventListener(BreaseEvent.VISIBILITY_CHANGED, this._bind('visibilityChangeHandler'), true);
    }

    function selectChildren(container) {
        var children = container.find('[data-brease-widget]');
        if (children.length > 0) {
            children = children.first().parent().children('[data-brease-widget]');
        }
        return children;
    }
    return WidgetClass;

});
