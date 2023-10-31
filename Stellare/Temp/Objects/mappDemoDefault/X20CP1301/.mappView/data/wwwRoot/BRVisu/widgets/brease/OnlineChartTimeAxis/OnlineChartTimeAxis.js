define([
    'widgets/brease/ChartXAxisWidget/ChartXAxisWidget',
    'brease/decorators/LanguageDependency'
], function (SuperClass, languageDependency) {

    'use strict';

    /**
     * @class widgets.brease.OnlineChartTimeAxis
     * #Description
     * x-Axis for online chart container to display time information of online data
     * @extends widgets.brease.ChartXAxisWidget
     * @iatMeta studio:isContainer
     * true
     * @iatMeta category:Category
     * Chart,Container
     *
     * @iatMeta description:short
     * TimeAxis
     * @iatMeta description:de
     * Widget zur Representation der Zeitachse
     * @iatMeta description:en
     * Widget to represent the time axis
     */

    /**
     * @property {WidgetList} [children=[]]
     * @inheritdoc  
     */

    /**
     * @property {WidgetList} [parents=["widgets.brease.OnlineChart"]]
     * @inheritdoc  
     */

    /**
     * @cfg {String} format='mm:ss'
     * @iatStudioExposed
     * @iatCategory Appearance
     * @bindable
     * Specifies the format of the time shown on the axis ticks
     */

    /**
     * @cfg {UInteger} timeSpan='60'
     * @iatStudioExposed
     * @iatCategory Behavior
     * Period of time in seconds shown in the graph
     */

    var defaultSettings = {
            cursorValue: '1970-01-01T00:00:00.000Z',
            format: 'mm:ss',
            timeSpan: 60,
            formatTextKey: undefined,
            labelTextKey: undefined
        },

        WidgetClass = SuperClass.extend(function OnlineChartTimeAxis() {
            SuperClass.apply(this, arguments);
        }, defaultSettings),

        p = WidgetClass.prototype;

    p.init = function () {

        this.addInitialClass('breaseOnlineChartTimeAxis');

        this.data = {
            minValue: new Date()
        };
        this.data.maxValue = new Date(this.data.minValue.getTime() + Number(this.settings.timeSpan) * 1000);
        this.axisType = 'dateTime';

        SuperClass.prototype.init.call(this);

        if (brease.config.editMode !== true) {
            this.el.height(0);
        } else {
            this.allChartItemsInitializedDeferred.resolve();
        }

        this.setFormat(this.getFormat());
        this.setAxisLabel(this.getAxisLabel());
    };

    p.setCursorValue = function (cursorValue) {
        this.settings.cursorValue = cursorValue;
    };

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
                self.settings.labelTextKey = undefined;
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
     * @method setTimeSpan
     * Sets timeSpan in seconds
     * @param {UInteger} timeSpan
     */
    p.setTimeSpan = function (timeSpan) {
        this.settings.timeSpan = timeSpan;
    };

    /**
     * @method getTimeSpan 
     * Returns timeSpan in seconds
     * @return {UInteger}
     */
    p.getTimeSpan = function () {
        return this.settings.timeSpan;
    };

    p.currentFormat = function () {
        return this.settings.format;
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
            }
        }
    };

    p._getMaxValue = function () {
        var graphMaxTime,
            returnValue = null;

        for (var graph in this.chartWidget.chartItems.yValues) {

            graphMaxTime = this.chartWidget.chartItems.yValues[graph]._getMaxTime();

            if (returnValue === null) {
                returnValue = graphMaxTime;
            } else if (graphMaxTime > returnValue) {
                returnValue = graphMaxTime;
            }
        }

        return returnValue;
    };

    p._getMinValue = function () {
        return (new Date(this._getMaxValue().getTime() - this.getTimeSpan() * 1000));
    };

    p._getAxisType = function () {
        return this.axisType;
    };

    p.dispose = function () {
        SuperClass.prototype.dispose.apply(this, arguments);
    };

    // Private Functions

    return languageDependency.decorate(WidgetClass, true);
});
