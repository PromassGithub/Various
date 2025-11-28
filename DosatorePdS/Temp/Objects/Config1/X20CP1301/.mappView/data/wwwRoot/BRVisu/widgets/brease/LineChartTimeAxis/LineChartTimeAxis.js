define([
    'widgets/brease/ChartXAxisWidget/ChartXAxisWidget',
    'brease/decorators/LanguageDependency'
], function (SuperClass, languageDependency) {
    'use strict';

    /**
     * @class widgets.brease.LineChartTimeAxis
     * #Description
     * x-Axis for line chart container to display time information of historic data
     * @extends widgets.brease.ChartXAxisWidget
     * @iatMeta studio:isContainer
     * true
     * @iatMeta category:Category
     * Chart,Container
     *
     * @iatMeta description:short
     * X-Axis for LineChart container to display time information of historic data
     * @iatMeta description:de
     * X-Achse des LineChart Containers zur Anzeige der historischen Daten über die Zeit.
     * Die Daten müssen in einheitlichen Zeitabständen gesampelt werden.
     * @iatMeta description:en
     * X-Axis for LineChart container to display time information of historic data.
     * The data are suppose to be equally time-spaced with uniform sample rate.
     */

    /**
     * @property {WidgetList} children=["widgets.brease.LineChartXAxisTimeCursor","widgets.brease.LineChartXAxisMsTimeCursor"]
     * @inheritdoc  
     */

    /**
     * @property {WidgetList} parents=["widgets.brease.LineChart"]
     * @inheritdoc  
     */

    /**
     * @cfg {String} format='mm:ss'
     * @iatStudioExposed
     * @bindable
     * @iatCategory Appearance
     * Specifies the format of the time shown on the axis ticks.
     */

    /**
     * @cfg {DateTime} minValue='1970-01-01T00:00:00.000Z'
     * @iatStudioExposed
     * @bindable
     * @iatCategory Behavior
     * Minimum value for Axis
     */

    /**
     * @cfg {DateTime} maxValue='1970-01-01T00:01:00.000Z'
     * @iatStudioExposed
     * @bindable
     * @iatCategory Behavior
     * Maximum value for Axis
     */

    var defaultSettings = {
            minValue: '1970-01-01T00:00:00.000Z',
            maxValue: '1970-01-01T00:01:00.000Z',
            cursorValue: '1970-01-01T00:00:00.000Z',
            format: 'mm:ss',
            formatTextKey: undefined,
            labelTextkey: undefined
        },

        WidgetClass = SuperClass.extend(function LineChartTimeAxis() {
            SuperClass.apply(this, arguments);
        }, defaultSettings),

        p = WidgetClass.prototype;

    p.init = function () {

        this.addInitialClass('breaseLineChartTimeAxis');
        SuperClass.prototype.init.call(this);

        this.data.minValue = {
            value: new Date(),
            timeZoneCorrectedValue: new Date(),
            timeZoneOffset: 0
        };
        this.data.maxValue = {
            value: new Date(),
            timeZoneCorrectedValue: new Date(),
            timeZoneOffset: 0
        };
        this.data.xPositionsMillisecondResolution = [];
        this.data.xPositionsSecondResolution = [];
            
        this.axisType = 'dateTime';

        _updateTimeStructure(this.data.minValue, this.settings.minValue);
        _updateTimeStructure(this.data.maxValue, this.settings.maxValue);

        if (brease.config.editMode !== true) {
            this.el.height(0);
        }

        this.setFormat(this.getFormat());
        this.setAxisLabel(this.getAxisLabel());
    };

    p._chartItemsReadyHandler = function () {

    };

    /**
     * @method setFormat
     * Sets format
     * @param {String} format
     */
    p.setFormat = function (format) {

        var self = this;

        $.when(this.allChartItemsInitializedDeferred).done(function () {
            var validFormatTextKeyFlag = true;

            if (brease.language.isKey(format) === false) {
                self.settings.format = format;
                self.settings.formatTextKey = undefined;
            } else {
                validFormatTextKeyFlag = self.setPropertyKey(brease.language.parseKey(format), 'format');
            }

            if (brease.config.editMode) {
                self.editorGrid.configuration.tickFormat = self.settings.format;
                self.editorGrid.updateAxis();

            } else if (validFormatTextKeyFlag) {
                self._isDirty();
                self.chartWidget._valueListIsDirty();
                self.chartWidget._cursorIsDirty();
            }
        });
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

    /**
     * @method getFormat 
     * Returns format.
     * @return {String}
     */
    p.getFormat = function () {

        return this.settings.format;
    };

    /**
     * @method setMinValue
     * @iatStudioExposed
     * Sets minimum value
     * @param {DateTime} value
     */
    p.setMinValue = function (value) {

        var self = this;

        $.when(this.allChartItemsInitializedDeferred).done(function () {
            self.settings.minValue = value;
            _updateTimeStructure(self.data.minValue, value);
            self._generateXPositions();
            self._isDirty();
            if (self.chartWidget) {
                self.chartWidget._valueListIsDirty();
            }

            for (var cursorId in self.cursors) {
                var cursorWidget = self.cursors[cursorId];

                cursorWidget.setValue(cursorWidget.getValue());
            }
            if (self.chartWidget) {
                self.chartWidget._cursorIsDirty();
            }
        });
    };

    /**
     * @method getMinValue 
     * Returns minimum value.
     * @return {DateTime}
     */
    p.getMinValue = function () {

        return this.data.minValue.value.toISOString();
    };

    /**
     * @method setMaxValue
     * @iatStudioExposed
     * Sets maximum value
     * @param {DateTime} value
     */
    p.setMaxValue = function (value) {

        var self = this;

        $.when(this.allChartItemsInitializedDeferred).done(function () {
            self.settings.maxValue = value;
            _updateTimeStructure(self.data.maxValue, value);
            self._generateXPositions();
            self._isDirty();
            if (self.chartWidget) {
                self.chartWidget._valueListIsDirty();
            }

            for (var cursorId in self.cursors) {
                var cursorWidget = self.cursors[cursorId];

                cursorWidget.setValue(cursorWidget.getValue());
            }
            if (self.chartWidget) {
                self.chartWidget._cursorIsDirty();
            }
        });
    };

    /**
     * @method getMaxValue 
     * Returns maximum value.
     * @return {DateTime}
     */
    p.getMaxValue = function () {

        return this.data.maxValue.value.toISOString();
    };

    /**
     * @method getCursorValue 
     * Returns cursor-position value.
     * @return {DateTime}
     */
    p.getCursorValue = function () {

        return this.settings.cursorValue;
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

    p.currentFormat = function () {

        return this.getFormat();
    };

    p._registerGraphArraySize = function () {
        var oldMaxArraySize = this.data.maxArraySize;

        SuperClass.prototype._registerGraphArraySize.apply(this, arguments);

        if (oldMaxArraySize !== this.data.maxArraySize) {
            this._generateXPositions();
        }

        this._isDirty();
    };

    p._getMinValue = function () {

        return this.data.minValue.timeZoneCorrectedValue;
    };

    p._getMaxValue = function () {

        return this.data.maxValue.timeZoneCorrectedValue;
    };

    p._xPositions = function (cursorType) {

        if (cursorType === 'secondsTime') {
            return this.data.xPositionsSecondResolution;
        }
        return this.data.xPositionsMillisecondResolution;
    };

    p._getAxisType = function () {

        return this.axisType;
    };

    p._generateXPositions = function () {

        var timeRange = this.data.maxValue.timeZoneCorrectedValue - this.data.minValue.timeZoneCorrectedValue,
            offset,
            newPoint = new Date(this._getMinValue()),
            newPointRoundedToSecond = roundDateToSecond(newPoint),
            distance = Math.abs(newPointRoundedToSecond.getTime() - newPoint.getTime()),
            referencePoint = {
                value: newPoint,
                neighbourhoodRadius: distance
            };

        this.data.xPositionsMillisecondResolution = [new Date(this._getMinValue())];
        this.data.xPositionsSecondResolution = [referencePoint.value];

        for (var i = 1; i < this.data.maxArraySize; i += 1) {

            offset = Math.round((i * timeRange) / (this.data.maxArraySize - 1));
            newPoint = new Date(this._getMinValue().getTime() + offset);

            this.data.xPositionsMillisecondResolution.push(newPoint);

            newPointRoundedToSecond = roundDateToSecond(newPoint);

            if ((newPointRoundedToSecond.getTime() - referencePoint.value.getTime()) === 0) {

                distance = Math.abs(newPoint.getTime() - referencePoint.value.getTime());
                if (distance < referencePoint.neighbourhoodRadius) {
                    referencePoint.neighbourhoodRadius = distance;
                    this.data.xPositionsSecondResolution.pop();
                    this.data.xPositionsSecondResolution.push(newPoint);
                }
            } else {
                distance = Math.abs(newPointRoundedToSecond.getTime() - newPoint.getTime());
                referencePoint.value = newPointRoundedToSecond;
                referencePoint.neighbourhoodRadius = distance;
                this.data.xPositionsSecondResolution.push(newPoint);
            }
        }
    };

    p.langChangeHandler = function (e) {

        if (e === undefined || e.detail === undefined ||
            e.detail.textkey === undefined ||
            e.detail.textkey === this.settings.formatTextKey ||
            e.detail.textkey === this.settings.axisLabelTextKey) {

            if (this.settings.formatTextKey !== undefined) {
                this.setPropertyKey(this.settings.formatTextKey, 'format');
            }

            if (this.settings.axisLabelTextKey !== undefined) {
                this.setPropertyKey(this.settings.axisLabelTextKey, 'axisLabel');
            }

            if ((this.settings.formatTextKey !== undefined) || (this.settings.axisLabelTextKey !== undefined)) {
                this._isDirty();
                this.chartWidget._valueListIsDirty();
                this.chartWidget._cursorIsDirty();
            }
        }
    };

    p.dispose = function () {

        SuperClass.prototype.dispose.apply(this, arguments);
    };

    // Private Functions
    function _updateTimeStructure(dtStructure, stringValue) {

        dtStructure.value = new Date(stringValue);
        dtStructure.timeZoneCorrectedValue = new Date(stringValue);
        dtStructure.timeZoneOffset = dtStructure.value.getTimezoneOffset();

        dtStructure.timeZoneCorrectedValue.setMinutes(dtStructure.timeZoneCorrectedValue.getMinutes() + dtStructure.timeZoneOffset);
    }

    function roundDateToSecond(date) {

        return new Date(Math.round(+date / 1000) * 1000);
    }

    return languageDependency.decorate(WidgetClass, true);
});
