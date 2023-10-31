define([
    'brease/core/Class',
    'brease/events/BreaseEvent',
    'widgets/brease/GenericDialog/GenericDialog',
    'widgets/brease/GenericDialog/libs/config',
    'widgets/brease/Table/libs/FilterSettings',
    //'widgets/brease/Table/libs/ConfigSettings',
    'widgets/brease/Table/libs/DialogueTexts',
    'widgets/brease/Label/Label',
    'widgets/brease/CheckBox/CheckBox',
    'widgets/brease/DateTimeInput/DateTimeInput',
    'widgets/brease/Image/Image',
    'widgets/brease/Rectangle/Rectangle',
    'widgets/brease/DropDownBox/DropDownBox',
    'widgets/brease/NumericInput/NumericInput'
], function (
    SuperClass, BreaseEvent, Dialog, DialogConfig, 
    Filter, Texts, Label, CheckBox, DateTimeIn, Image, 
    Rectangle, DropDownBox, NumIn
) {
    
    'use strict';

    var DialogueClass = SuperClass.extend(function Dialogue(widget) {
            this.dialog = new Dialog(widget.elem);// widget.configDiag;
            SuperClass.apply(this);
            this.widget = widget;
        }, null),

        p = DialogueClass.prototype;
    
    p.initializeFilter = function (lang) {
        this.filter = new Filter(this.dialog, this.widget, lang);
        this._initializeEmptyDialogConfig(Texts[this.lang].title);
        return this.config;
    };

    // p.initializeConfig = function (lang) {
    //     this.tableConfig = new TableConfig(this.dialog, this.widget, lang);
    //     this._initializeEmptyDialogConfig(Texts[this.lang].title);
    //     return this.config;
    // };

    p.openFilter = function () {
        this.lang = _getLanguage();
        this.dialog.show(this.initializeFilter(this.lang), this.widget.elem);
        this.passedFirst = false;
        var self = this;
        this.dialog.isReady().then(function (arg) {
            $('#' + self.dialog.elem.id).on(BreaseEvent.WIDGET_READY, self._bind('_widgetAddedToFilter'));
            $('#' + self.dialog.elem.id).on('window_closing', self._bind('_collectFilterBeforeClosing'));
        });
    };

    // p.openConfig = function() {
    //     this.lang = _getLanguage();
    //     this.dialog.show(this.initializeConfig(this.lang), this.widget.elem);
    //     this.passedFirst = false;
    //     var self = this;
    //     this.dialog.isReady().then(function (arg){
    //         $('#'+self.dialog.elem.id).on(BreaseEvent.WIDGET_READY, self._bind('_widgetAddedToConfig'));
    //         $('#'+self.dialog.elem.id).on('window_closing', self._bind('_collectConfigBeforeClosing'));
    //     });
    // };

    p._initializeEmptyDialogConfig = function (headerText) {
        this.config = new DialogConfig();

        // dialog
        this.config.forceInteraction = true;
        this.config.contentWidth = 600;
        this.config.contentHeight = 480;

        // header
        this.config.header.text = headerText;

        //footer
        this.config.buttons.ok = true;
        this.config.buttons.cancel = true;
    };

    p._widgetAddedToFilter = function (e) {
        $('#' + this.dialog.elem.id).off(BreaseEvent.WIDGET_READY, this._bind('_widgetAddedToFilter'));
        this.filter.initialize();
        this.filter._reColourFirstLineSeparator();
    };

    p._widgetAddedToConfig = function (e) {
        $('#' + this.dialog.elem.id).off(BreaseEvent.WIDGET_READY, this._bind('_widgetAddedToConfig'));
        this.tableConfig.initialize();
        this.tableConfig._reColourFirstLineSeparator();
    };

    p._collectFilterBeforeClosing = function (e) {
        if (e.target.id === this.dialog.elem.id && this.dialog.getDialogResult() === 'ok') {
            this.widget.settings.filter = this.filter._widgetCollectStateBeforeClosing();
            this.widget.renderer.updateTableSize();
            this.widget.submitFilterConfiguration();
        }
    };

    // p._collectConfigBeforeClosing = function (e){
    //     if (e.target.id === this.dialog.elem.id && this.dialog.getDialogResult() === 'ok'){
    //         this.widget.settings.tableConfiguration = this.tableConfig._widgetCollectStateBeforeClosing();
    //         this.widget.renderer.updateTableSize();
    //         this.widget.submitTableConfiguration();
    //     }
    // };

    p._addRowHandler = function (e) {
        this.filter._addRowHandler(e);
    };
    
    function _getLanguage() {
        var lang = brease.language.getCurrentLanguage();
        if (lang !== 'de') {
            lang = 'en';
        }
        return lang;
    }

    // eslint-disable-next-line no-unused-vars
    function _reColourAllObjects(self) {
        self.filter._reColourFirstLineSeparator();
    }

    p.dispose = function () {
        this.dialog.dispose();
        SuperClass.prototype.dispose.call(this);
    };

    return DialogueClass;
});
