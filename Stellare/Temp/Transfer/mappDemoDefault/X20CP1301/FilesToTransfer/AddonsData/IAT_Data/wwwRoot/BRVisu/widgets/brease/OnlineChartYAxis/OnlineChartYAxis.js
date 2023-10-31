define([
    'widgets/brease/ChartYAxisWidget/ChartYAxisWidget',
    'brease/config/NumberFormat',
    'brease/core/Utils',
    'brease/decorators/LanguageDependency'
], function (SuperClass, NumberFormat, Utils, languageDependency) {

    'use strict';

    /**
     * @class widgets.brease.OnlineChartYAxis
     * #Description
     * y-Axis for online chart container. It contains the online values to graphically represent.
     * @extends widgets.brease.ChartYAxisWidget
     * @iatMeta studio:isContainer
     * true
     * @iatMeta category:Category
     * Chart,Container
     *
     * @iatMeta description:short
     * Y-Axis
     * @iatMeta description:de
     * Widget zur Representation der Y-Achse
     * @iatMeta description:en
     * Widget to represent the y-axis
     */

    /**
     * @property {WidgetList} [children=["widgets.brease.OnlineChartGraph"]]
     * @inheritdoc  
     */

    /**
     * @property {WidgetList} [parents=["widgets.brease.OnlineChart"]]
     * @inheritdoc  
     */

    /**
     * @cfg {brease.config.MeasurementSystemFormat} format={'metric': { 'decimalPlaces': 1, 'minimumIntegerDigits': 1 }, 'imperial': { 'decimalPlaces': 1, 'minimumIntegerDigits': 1 }, 'imperial-us': { 'decimalPlaces': 1, 'minimumIntegerDigits': 1 }}
     * @iatStudioExposed
     * @bindable
     * @iatCategory Appearance
     * Numeric format for every measurement system
     */

    /**
     * @cfg {brease.config.MeasurementSystemUnit} unit=''
     * @iatStudioExposed
     * @bindable
     * @iatCategory Appearance
     * Unit code for every measurement system
     */

    var defaultSettings = {
            format: {
                'metric': { 'decimalPlaces': 1, 'minimumIntegerDigits': 1 },
                'imperial': { 'decimalPlaces': 2, 'minimumIntegerDigits': 1 },
                'imperial-us': { 'decimalPlaces': 1, 'minimumIntegerDigits': 2 }
            },
            unit: null
        },

        WidgetClass = SuperClass.extend(function OnlineChartYAxis() {
            SuperClass.apply(this, arguments);
        }, defaultSettings),

        p = WidgetClass.prototype;

    p.init = function () {

        this.addInitialClass('breaseOnlineChartYAxis');
        this.data = {
            currentUnit: _getCurrentUnit(this),
            currentUnitSymbol: ''
        };

        SuperClass.prototype.init.call(this);

        if (brease.config.editMode === true) {
            this.allChartItemsInitializedDeferred.resolve();
        }

        this.setAxisLabel(this.getAxisLabel());
        this.setUnit(this.getUnit());
        _getCurrentUnitSymbol(this);
        this.setFormat(this.getFormat());
    };

    p._chartItemsReadyHandler = function () {

    };

    /**
     * @method setFormat
     * Sets format
     * @param {brease.config.MeasurementSystemFormat} format
     */
    p.setFormat = function (format) {
        var self = this,
            validFormat;

        $.when(this.allChartItemsInitializedDeferred).done(function () {

            self.settings.format = format;
            validFormat = _updateFormat(self);

            if (brease.config.editMode) {
                self.editorGrid.configuration.tickFormat = self.currentFormat();
                self.editorGrid.updateAxis();

            } else if (validFormat) {
                self._isDirty();
                self.chartWidget._valueListIsDirty();
                self.chartWidget._cursorIsDirty();
            }
        });
    };

    /**
     * @method getFormat 
     * Returns format.
     * @return {brease.config.MeasurementSystemFormat}
     */
    p.getFormat = function () {
        return this.settings.format;
    };

    /**
     * @method setUnit
     * Sets unit
     * @param {brease.config.MeasurementSystemUnit} unit
     */
    p.setUnit = function (unit) {
        var widget = this;

        $.when(this.allChartItemsInitializedDeferred).done(function () {

            var deferredObject,
                self = widget;

            if (Utils.isObject(unit)) {
                self.settings.unit = unit;
            } else {
                self.settings.unit = (unit !== '' && unit !== null) ? JSON.parse(unit.replace(/'/g, '"')) : self.settings.unit;
            }

            deferredObject = self.measurementSystemChanged();

            if (!brease.config.editMode) {
                $.when(deferredObject).then(function () {

                    self._isDirty();
                    self.chartWidget._valueListIsDirty();
                    self.chartWidget._cursorIsDirty();
                });
            }
        });
    };

    /**
     * @method getUnit 
     * Returns unit.
     * @return {brease.config.MeasurementSystemUnit}
     */
    p.getUnit = function () {
        return this.settings.unit;
    };

    /**
     * @method setAxisLabel
     * Sets Description text of axis
     * @param {String} axisLabel
     */
    p.setAxisLabel = function (axisLabel) {
        var self = this;

        $.when(this.allChartItemsInitializedDeferred).done(function () {
            var validLabelTextKeyFlag = true;

            if (brease.language.isKey(axisLabel) === false) {
                self.settings.axisLabel = axisLabel;
                self.settings.axisLabelTextKey = undefined;
            } else {
                validLabelTextKeyFlag = self.setPropertyKey(brease.language.parseKey(axisLabel), 'axisLabel');
            }

            if (brease.config.editMode) {
                self.editorGrid.configuration.axisLabel = self.settings.axisLabel;
                self.editorGrid.updateAxis();
            } else if (validLabelTextKeyFlag) {
                self._isDirty();
                self.chartWidget._valueListIsDirty();
            }
        });
    };

    /**
     * @method getAxisLabel
     * Returns Description text of axis
     * @return {String}
     */
    p.getAxisLabel = function () {
        return this.settings.axisLabel;
    };

    p.setPropertyKey = function (key, property) {
        if (key !== undefined) {
            this.settings[property + 'TextKey'] = key;
            this.setLangDependency(true);
            var textFromTextKey = brease.language.getTextByKey(this.settings[property + 'TextKey']);
            if (textFromTextKey !== 'undefined key') {
                this.settings[property] = textFromTextKey;
                return true;
            } else {
                console.iatWarn(this.elem.id + ': ' + property + ' textKey not found: ' + key);
                return false;
            }
        } else {
            this.settings[property + 'TextKey'] = undefined;
            console.iatWarn(this.elem.id + ': The text key is not valid : ' + key);
            return false;
        }
    };

    p.minimum = function () {
        var returnValue = null,
            axisItemMinimum;

        for (var axisItem in this.axisItems) {

            axisItemMinimum = this.axisItems[axisItem].getMinValue();

            if (returnValue === null) {
                returnValue = axisItemMinimum;
            } else if (axisItemMinimum < returnValue) {
                returnValue = axisItemMinimum;
            }
        }

        return returnValue;
    };

    p.maximum = function () {
        var returnValue = null,
            axisItemMaximum;

        for (var axisItem in this.axisItems) {

            axisItemMaximum = this.axisItems[axisItem].getMaxValue();

            if (returnValue === null) {
                returnValue = axisItemMaximum;
            } else if (axisItemMaximum > returnValue) {
                returnValue = axisItemMaximum;
            }
        }

        return returnValue;
    };

    p.currentUnit = function () {
        return this.data.currentUnit;
    };

    p.currentUnitSymbol = function () {
        return this.data.currentUnitSymbol;
    };

    p.currentFormat = function () {
        return _getCurrentFormat(this);
    };

    p.langChangeHandler = function () {
        if (this.settings.axisLabelTextKey) {
            this.setPropertyKey(this.settings.axisLabelTextKey, 'axisLabel');
        }

        if (this.settings.axisLabelTextKey !== undefined) {
            this._isDirty();
            this.chartWidget._valueListIsDirty();
        }
    };

    p.measurementSystemChanged = function () {
        var widget = this,
            oldUnit = this.data.currentUnit,
            deferredInternal = [],
            deferredExternal = $.Deferred();

        this.data.currentUnit = _getCurrentUnit(this);

        if (this.data.currentUnit !== oldUnit) {

            deferredInternal.push(_getCurrentUnitSymbol(this));

            for (var axisItem in this.axisItems) {
                deferredInternal.push(this.axisItems[axisItem].updateUnit());
            }

            $.when.apply($, deferredInternal)
                .then(function successHandler() {
                    for (var axisItem in widget.axisItems) {
                        widget.axisItems[axisItem].resetBuffer();
                    }
                    _updateFormat(widget);
                    deferredExternal.resolve();
                });
        } else {
            _updateFormat(widget);
            deferredExternal.resolve();
        }

        return deferredExternal.promise();
    };

    p.dispose = function () {
        SuperClass.prototype.dispose.apply(this, arguments);
    };

    // Private Functions

    function _getCurrentUnit(widget) {
        return (widget.settings.unit !== null) ? widget.settings.unit[brease.measurementSystem.getCurrentMeasurementSystem()] : '';
    }

    function _getCurrentUnitSymbol(widget) {
        var deferredObject = $.Deferred();

        brease.language.pipeAsyncUnitSymbol(widget.data.currentUnit, function (unitSymbol) {

            widget.data.currentUnitSymbol = (unitSymbol === undefined) ? '' : unitSymbol;
            deferredObject.resolve();
        });

        return deferredObject.promise();
    }

    function _getCurrentFormat(widget) {
        return (Utils.isObject(widget.settings.format)) ? NumberFormat.getFormat(widget.settings.format, brease.measurementSystem.getCurrentMeasurementSystem())
            : widget.settings.numberFormat;
    }

    function _updateFormat(widget) {
        var currentMms = brease.measurementSystem.getCurrentMeasurementSystem(),
            formatObject,
            format = widget.getFormat(),
            textKey;

        if (format !== undefined) {
            if (Utils.isObject(format)) {
                widget.settings.numberFormat = NumberFormat.getFormat(format, currentMms);
                return true;
            } else if (typeof (format) === 'string') {
                if (brease.language.isKey(format)) {
                    try {
                        widget.setLangDependency(true);
                        textKey = brease.language.parseKey(format);
                        formatObject = JSON.parse(brease.language.getTextByKey(textKey).replace(/'/g, '"'));
                        widget.settings.numberFormat = NumberFormat.getFormat(formatObject, currentMms);
                        return true;
                    } catch (error) {
                        console.iatWarn(widget.elem.id + ': Format String "' + format + '" is invalid!');
                        widget.settings.numberFormat = NumberFormat.getFormat({}, currentMms);
                        return false;
                    }
                } else {
                    try {
                        formatObject = (format !== '') ? JSON.parse(format.replace(/'/g, '"')) : {};
                        widget.settings.numberFormat = NumberFormat.getFormat(formatObject, currentMms);
                        return true;
                    } catch (error) {
                        console.iatWarn(widget.elem.id + ': Format String "' + format + '" is invalid!');
                        widget.settings.numberFormat = NumberFormat.getFormat({}, currentMms);
                        return false;
                    }
                }
            }
        } else {
            widget.settings.numberFormat = NumberFormat.getFormat({}, currentMms);
            return false;
        }
    }

    return languageDependency.decorate(WidgetClass, true);
});
