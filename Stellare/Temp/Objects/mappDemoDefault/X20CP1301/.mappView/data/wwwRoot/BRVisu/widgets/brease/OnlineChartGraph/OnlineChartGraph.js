define([
    'widgets/brease/ChartYValueListWidget/ChartYValueListWidget',
    'brease/datatype/Node',
    'brease/core/Utils',
    'widgets/brease/ChartWidget/libs/constants'
], function (SuperClass, Node, Utils, Constants) {

    'use strict';

    /**
     * @class widgets.brease.OnlineChartGraph
     * #Description
     * Widget to display in a graph a time series
     * @extends widgets.brease.ChartYValueListWidget
     * @requires widgets.brease.OnlineChartYAxis
     * @iatMeta category:Category
     * Chart
     *
     * @iatMeta description:short
     * Widget for Data
     * @iatMeta description:de
     * Widget zur Anzeige eines Graphen der Zeitserie
     * @iatMeta description:en
     * Widget to display in a graph a time series
     */

    /**
     * @property {WidgetList} [parents=["widgets.brease.OnlineChartYAxis"]]
     * @inheritdoc
     */

    /**
     * @cfg {Number} value=0
     * @iatStudioExposed
     * @iatCategory Data
     * @bindable
     * @nodeRefId node
     * Current value to display on the graph as simple value
     */

    /**
     * @cfg {brease.datatype.Node} node=''
     * @iatStudioExposed
     * @iatCategory Data
     * @bindable
     * Current value to display on the graph as node
     */

    /**
     * @cfg {Number} minValue=0
     * @iatStudioExposed
     * @iatCategory Behavior
     * Minimum value for the graph
     */

    /**
     * @cfg {Number} maxValue=100
     * @iatStudioExposed
     * @iatCategory Behavior
     * Maximum value for the graph as simple value
     */

    /**
     * @cfg {WidgetReference} xAxisRefId (required)
     * @iatStudioExposed
     * @iatCategory Data
     * Name of the X-Axis the data refer to
     */

    /**
     * @cfg {brease.enum.ChartInterpolationType} interpolationType='step-after'
     * @iatStudioExposed
     * @iatCategory Behavior
     * Definition of interpolation type which should be applied to the graph.
     */

    /**
     * @cfg {Integer} numberOfSamples=-1
     * @hide
     */

    var defaultSettings = {
            xAxisRefId: '',
            minValue: 0,
            maxValue: 100,
            cursorValue: 0,
            node: {},
            value: 0,
            interpolationType: 'step-after'
        },

        WidgetClass = SuperClass.extend(function OnlineChartGraph() {
            SuperClass.apply(this, arguments);
        }, defaultSettings),

        p = WidgetClass.prototype;

    p.init = function () {

        this.addInitialClass('breaseOnlineChartGraph');

        this.data = {
            deferredValueChanged: undefined,
            node: new Node(this.settings.value, null, this.settings.minValue, this.settings.maxValue),
            currentValue: 0,
            values: [0],
            timeStamp: [new Date()]
        };

        SuperClass.prototype.init.call(this);
    };

    p._chartItemsReadyHandler = function () {
        this.xAxisWidget = brease.callWidget(this.settings.xAxisRefId, 'widget');

        if (this.xAxisWidget === null) {
            var error = {
                name: Constants.ERROR_INVALID_PROPERTY_VALUE,
                arg1: 'xAxisRefId',
                arg2: this.elem.id
            };

            this.chartWidget.errorHandler(error);

            return;
        }

        this.data.minTime = new Date();
        this.data.maxTime = new Date(this.data.minTime.getTime() + Number(this.xAxisWidget.getTimeSpan()) * 1000);

        this.xAxisWidget._isDirty();
    };

    /**
     * @method setNumberOfSamples
     * @hide
     */

    /**
     * @method getNumberOfSamples 
     * @hide
     */

    /**
     * @method setValue
     * Sets value with the current value to graph
     * @param {Number} value
     */
    p.setValue = function (value) {
        var self = this;

        $.when(this.allChartItemsInitializedDeferred).done(function () {
            if (Utils.isNumeric(value)) {
                self.data.currentValue = value;
            }
            self.chartWidget.updateAllBuffers();
        });
    };

    /**
     * @method getValue
     * Returns the value that is going to be update the buffer
     * @return {Number} value
     */
    p.getValue = function () {
        return this.data.currentValue;
    };

    /**
     * @method setMinValue
     * Sets minValue with the minimum value of the graph range
     * @param {Number} minValue
     */
    p.setMinValue = function (minValue) {
        if (this.settings.minValue !== minValue) {
            this.settings.minValue = minValue;
            this.axisWidget._isDirty();
        }
    };

    /**
     * @method getMinValue
     * Returns minValue of the graph
     * @return {Number} minValue
     */
    p.getMinValue = function () {
        return this.settings.minValue;
    };

    /**
     * @method setMaxValue
     * Sets maxValue with the maximum value of the graph range
     * @param {Number} maxValue
     */
    p.setMaxValue = function (maxValue) {
        if (this.settings.maxValue !== maxValue) {
            this.settings.maxValue = maxValue;
            this.axisWidget._isDirty();
        }

    };

    /**
     * @method getMaxValue
     * Returns maxValue of the graph
     * @return {Number} maxValue
     */
    p.getMaxValue = function () {
        return this.settings.maxValue;
    };

    /**
     * @method setNode
     * Sets node with the current value to graph
     * @param {brease.datatype.Node} node
     */
    p.setNode = function (node) {
        var self = this;

        $.when(this.allChartItemsInitializedDeferred).done(function () {
            self.data.node = Node.json2Node(node);
            if (!self.chartWidget.getAutoscale()) {
                self.setMinValue(self.data.node.minValue);
                self.setMaxValue(self.data.node.maxValue);
            }
            self.setValue(self.data.node.value);
        });
    };

    /**
     * @method getNode
     * Returns node with the last value graphed
     * @return {brease.datatype.Node} node
     */
    p.getNode = function () {
        if (this.axisWidget === undefined) {
            var axisWidgetId = this.el.parents('.breaseChartYAxisWidget').attr('id');
            this._registerAxisWidget(brease.callWidget(axisWidgetId, 'widget'));
        }
        this.data.node.setUnit(this.axisWidget.currentUnit());

        return this.data.node;
    };

    p.setCursorValue = function (cursorValue) {
        // to leave empty
    };

    p.getCursorValue = function () {
        return this.settings.cursorValue;
    };

    p.setCursorNode = function (cursorNode) {
        // to leave empty
    };

    p.getCursorNode = function () {
        return this.settings.cursorNode ? this.settings.cursorNode : new Node(this.getCursorValue());
    };

    /**
     * @method setXAxisRefId
     * Sets xAxisRefId as id of the OnlineChartXAxis widget of the current OnlineChart
     * @param {String} xAxisRefId
     */
    p.setXAxisRefId = function (xAxisRefId) {
        this.settings.xAxisRefId = xAxisRefId;
    };

    /**
     * @method getXAxisRefId
     * Returns xAxisRefId, the id of the OnlineChartXAxis widget of the current OnlineChart
     * @return {String} xAxisRefId
     */
    p.getXAxisRefId = function () {
        return this.settings.xAxisRefId;
    };

    p.updateUnit = function () {
        this.data.deferredValueChanged = $.Deferred();

        var subscriptions = brease.uiController.getSubscriptionsForElement(this.elem.id);
        if (subscriptions !== undefined && subscriptions.node !== undefined) {
            this.sendNodeChange({ attribute: 'node', nodeAttribute: 'unit', value: this.axisWidget.currentUnit() });
        } else {
            this.data.deferredValueChanged.resolve();
        }

        return this.data.deferredValueChanged.promise();
    };

    p.updateBuffer = function (timeStamp) {
        this.data.values.push(this.data.currentValue);
        this.data.timeStamp.push(timeStamp);

        // remove element outside the timeSpan window
        this.data.values = _dataInTimeSpan(this.data.values, this.data.timeStamp, this.xAxisWidget.getTimeSpan()).valuesInSpan;
        this.data.timeStamp = _dataInTimeSpan(this.data.values, this.data.timeStamp, this.xAxisWidget.getTimeSpan()).timeStampInSpan;

        // set min and max for time axis (timeSpan in seconds)
        if (this.data.timeStamp[this.data.timeStamp.length - 1] > this.data.maxTime) {
            this.data.maxTime = this.data.timeStamp[this.data.timeStamp.length - 1];
            this.data.minTime = this.data.maxTime - 1000 * this.xAxisWidget.getTimeSpan();
        }

        // set min and max for y axis
        if (this.chartWidget.getAutoscale()) {
            this._autoscaleYAxis();
        }

        if (this.data.deferredValueChanged !== undefined && this.data.deferredValueChanged.state() !== 'resolved') {
            if (this.data.node.unit === this.axisWidget.currentUnit()) {
                this.data.deferredValueChanged.resolve();
            }
        } else {
            this.xAxisWidget._isDirty();
            this._isDirty();
        }
    };

    p._autoscaleYAxis = function () {
        if (this.data.values.length === 0) {
            return;
        }
        
        var minValue = this.data.values[0];
        var maxValue = this.data.values[0];

        for (var i = 0; i < this.data.values.length; i = i + 1) {
            if (this.data.values[i] > maxValue) {
                maxValue = this.data.values[i];
            } else if (this.data.values[i] < minValue) {
                minValue = this.data.values[i];
            }
        }

        // Calculate padding
        var range = Math.abs(maxValue) > Math.abs(minValue) ? Math.abs(maxValue) : Math.abs(minValue);
        var padding = range * 0.1; // 10% of range

        minValue = minValue - padding;
        maxValue = maxValue + padding;

        this.setMinValue(minValue);
        this.setMaxValue(maxValue);
    };  

    p._coordinates = function () {
        var coordinates = [],
            numberOfSamples = this.data.values.length;
            
        if (this.getNumberOfSamples() >= 0 && this.getNumberOfSamples() <= numberOfSamples) {
            numberOfSamples = this.settings.numberOfSamples;
        }

        for (var i = 0; i < numberOfSamples; i += 1) {
            coordinates.push({
                x: this.data.timeStamp[i],
                y: this.data.values[i]
            });
        }

        return coordinates;
    };

    p._getMinTime = function () {
        return this.data.minTime;
    };

    p._getMaxTime = function () {
        return this.data.maxTime;
    };

    /**
     * @method resetBuffer
     * Resets the data of the graph
     */
    p.resetBuffer = function () {
        this.data.values = [];
        this.data.timeStamp = [];
    };

    p.dispose = function () {
        SuperClass.prototype.dispose.apply(this, arguments);
    };

    // Private Functions

    function _dataInTimeSpan(data, timeStamp, timeSpan) {

        var firstIdxInTimeSpan = -1,
            timeSpanMilliseconds = 1000 * timeSpan,
            timeSpanMargin = 1.05;

        firstIdxInTimeSpan = timeStamp.findIndex(function (elem, idx, array) {
            return (array[array.length - 1] - elem) <= (timeSpanMilliseconds * timeSpanMargin);
        });

        if (firstIdxInTimeSpan > 0) {
            return {
                valuesInSpan: data.slice(firstIdxInTimeSpan),
                timeStampInSpan: timeStamp.slice(firstIdxInTimeSpan)
            };
        } else {
            return {
                valuesInSpan: data,
                timeStampInSpan: timeStamp
            };
        }
    }

    return WidgetClass;

});
