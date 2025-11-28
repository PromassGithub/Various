define(['brease/events/BreaseEvent', 'brease/core/Utils'], function (BreaseEvent, Utils) {

    'use strict';

    /**
     * @class brease.controller.libs.FocusElem
     * This class is used to get HTML elements that are not widgets into the FocusChain. (make it focusable)
     * It has all required properties and interfaces to simply insert it like a widget.
     * Call dispose to remove the element from the chain (i.e if the element is removed from dom)
     */
    var FoucsElem = function (elem, options) {
        this.elem = elem;

        this.settings = {
            tabIndex: options.tabIndex,
            focusable: true,
            parentContentId: options.parentContentId,
            enable: options.enable === undefined ? true : options.enable,
            visible: options.visible === undefined ? true : options.visible
        };
        if (!options.omitFocusStyle) {
            elem.classList.add('breaseFocusable');
            elem.style.removeProperty('outline');
        } else {
            elem.classList.remove('breaseFocusable');
            elem.style.outline = 'none';
        }
        _applyTabIndex.call(this);
        document.body.dispatchEvent(new CustomEvent(BreaseEvent.FOCUS_ELEM_READY, { detail: this }));
        this._bindedOnFocus = _onFocus.bind(this);
        this._bindedOnBlur = _onBlur.bind(this);
        this.elem.addEventListener('focus', this._bindedOnFocus);
        this.elem.addEventListener('blur', this._bindedOnBlur);
    };

    /**
     * @method dispose
     * Remove the element from the FocusChain
     */
    FoucsElem.prototype.dispose = function () {
        this.elem.removeEventListener('focus', this._bindedOnFocus);
        this.elem.removeEventListener('blur', this._bindedOnBlur);
        document.body.dispatchEvent(new CustomEvent(BreaseEvent.FOCUS_ELEM_DISPOSED, { detail: this }));
        this.elem.style.removeProperty('outline');
        this.elem.classList.remove('breaseFocusable');
        this.elem = null;
    };

    FoucsElem.prototype.getParentContentId = function () {
        return this.settings.parentContentId;
    };

    FoucsElem.prototype.getTabIndex = function () {
        return this.settings.tabIndex;
    };

    FoucsElem.prototype.isEnabled = function () {
        return this.settings.enable;
    };

    /**
     * @method disable
     * Removes the tabIndex from the html element and fires BreaseEvent.BEFORE_ENABLE_CHANGE
     */
    FoucsElem.prototype.disable = function () {
        if (this.settings.enable) {
            _dispatchBeforeStateChange.call(this, BreaseEvent.BEFORE_ENABLE_CHANGE, false);
            this.settings.enable = false;
            _applyTabIndex.call(this);
        }
    };

    /**
     * @method disable
     * Adds the tabIndex to the html element and fires BreaseEvent.BEFORE_ENABLE_CHANGE
     */
    FoucsElem.prototype.enable = function () {
        if (!this.settings.enable) {
            _dispatchBeforeStateChange.call(this, BreaseEvent.BEFORE_ENABLE_CHANGE, true);
            this.settings.enable = true;
            _applyTabIndex.call(this);
        }
    };

    /**
     * @method hide
     * Fires BreaseEvent.BEFORE_VISIBLE_CHANGE
     */
    FoucsElem.prototype.hide = function () {
        if (this.settings.visible) {
            _dispatchBeforeStateChange.call(this, BreaseEvent.BEFORE_VISIBLE_CHANGE, false);
            this.settings.visible = false;
        }
    };
    
    /**
    * @method show
    * Fires BreaseEvent.BEFORE_VISIBLE_CHANGE
    */
    FoucsElem.prototype.show = function () {
        if (!this.settings.visible) {
            _dispatchBeforeStateChange.call(this, BreaseEvent.BEFORE_VISIBLE_CHANGE, true);
            this.settings.visible = true;
        }
    };

    /**
     * @method isFocusable
     * Checks if the element has tabIndex>-1 & enabled & visible.
     */
    FoucsElem.prototype.isFocusable = function () {
        return this.settings.tabIndex > -1 && this.isEnabled() && Utils.isVisible(this.elem);
    };

    function _onFocus() {
        this.elem.dispatchEvent(new CustomEvent(BreaseEvent.FOCUS_IN, { bubbles: true }));
    }

    function _onBlur() {
        this.elem.dispatchEvent(new CustomEvent(BreaseEvent.FOCUS_OUT, { bubbles: true }));
    }

    function _applyTabIndex() {
        if (!brease.config.editMode && brease.config.visu.keyboardOperation && this.settings.tabIndex > -1 && this.settings.enable) {
            this.elem.tabIndex = this.settings.tabIndex;
        } else {
            this.elem.removeAttribute('tabIndex');
        }
    }

    /**
    * @event before_enable_change 
    * Fired before the operability of the widget changes.
    * @param {Boolean} value the new value of operability the widget will have after the change
    * @eventComment
    */
    /**
    * @event before_visible_change 
    * Fired before the visibility of the widget changes.
    * @param {Boolean} value the new value of visibility the widget will have after the change
    * @eventComment
    */
    function _dispatchBeforeStateChange(type, value) {
        this.elem.dispatchEvent(new CustomEvent(type, { detail: { value: value }, bubbles: true }));
    }

    return FoucsElem;
});
