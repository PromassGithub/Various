define(['brease/core/Class', 'brease/events/BreaseEvent', 'brease/enum/Enum', 'widgets/brease/MessageBox/libs/Buttons'], function (SuperClass, BreaseEvent, Enum, buttons) {
    
    'use strict';

    var ButtonManager = SuperClass.extend(function (widget, btnCallback) {
            SuperClass.call(this);
            this.init(widget, btnCallback);
        }, null),

        p = ButtonManager.prototype;

    p.init = function (widget, btnCallback) {
        this.widget = widget;
        this.footer = widget.el.find('.messageBoxFooter');
        this.btnCallback = btnCallback;

        this.arElem = {};
        for (var key in buttons) {
            this.arElem[key] = {
                el: $('#' + widget.elem.id + '_messageBox_' + key)
            };
            this.arElem[key].textEl = this.arElem[key].el.find('span');
        }
        this.setTexts();
    };
    
    p.addEventListeners = function () {
        this.footer.on(BreaseEvent.CLICK, '.messageBoxButton', this._bind('btnClickHandler'));
        this.footer.on(BreaseEvent.MOUSE_DOWN, '.messageBoxButton', this._bind('btnDownHandler'));
    };

    p.removeEventListeners = function () {
        this.footer.off(BreaseEvent.CLICK, '.messageBoxButton', this._bind('btnClickHandler'));
        this.footer.off(BreaseEvent.MOUSE_DOWN, '.messageBoxButton', this._bind('btnDownHandler'));
    };

    p.setTexts = function () {
        for (var key in buttons) {
            this.arElem[key].textEl.text(brease.language.getTextByKey(buttons[key].textkey));
        }
    };

    p.setButtons = function (messageBoxType) {
        var buttonFlags;

        switch (messageBoxType) {
            case Enum.MessageBoxType.AbortRetryIgnore:
                buttonFlags = Enum.MessageBoxState.ABORT | Enum.MessageBoxState.RETRY | Enum.MessageBoxState.IGNORE;
                break;
            case Enum.MessageBoxType.OK:
                buttonFlags = Enum.MessageBoxState.OK;
                break;
            case Enum.MessageBoxType.OKCancel:
                buttonFlags = Enum.MessageBoxState.OK | Enum.MessageBoxState.CANCEL;
                break;
            case Enum.MessageBoxType.RetryCancel:
                buttonFlags = Enum.MessageBoxState.RETRY | Enum.MessageBoxState.CANCEL;
                break;
            case Enum.MessageBoxType.YesNo:
                buttonFlags = Enum.MessageBoxState.YES | Enum.MessageBoxState.NO;
                break;
            case Enum.MessageBoxType.YesNoCancel:
                buttonFlags = Enum.MessageBoxState.YES | Enum.MessageBoxState.NO | Enum.MessageBoxState.CANCEL;
                break;
        }

        for (var key in buttons) {
            this.arElem[key].el.showByFlag(buttonFlags & Enum.MessageBoxState[buttons[key].state]);
        }

    };

    p.btnDownHandler = function (e) {
        var key = e.currentTarget.getAttribute('data-key');
        if (key) {
            this.arElem[key].el.addClass('active');
            this.activeButton = key;
        }
        brease.docEl.on(BreaseEvent.MOUSE_UP, this._bind('btnUpHandler'));
    };

    p.btnUpHandler = function (e) {
        _stopEvent(e);
        brease.docEl.off(BreaseEvent.MOUSE_UP, this._bind('btnUpHandler'));
        this.arElem[this.activeButton].el.removeClass('active');
        this.activeButton = '';
    };

    p.btnClickHandler = function (e) {

        var key = e.currentTarget.getAttribute('data-key');

        if (key) {
            this.btnCallback.call(this.widget, Enum.MessageBoxState[buttons[key].state]);
        }

    };

    function _stopEvent(e) {
        e.originalEvent.preventDefault();
        e.stopImmediatePropagation();
    }

    return ButtonManager;

});
