define([
    'widgets/brease/ChartYValueListWidget/ChartYValueListWidget',
    'brease/datatype/Node',
    'brease/datatype/ArrayNode',
    'brease/core/Utils',
    'widgets/brease/ChartWidget/libs/constants'
], function (SuperClass, Node, ArrayNode, Utils, Constants) {

    'use strict';

    /**
     * @class widgets.brease.LineChartGraph
     * #Description
     * Widget to represent historic data
     * @extends widgets.brease.ChartYValueListWidget
     * @iatMeta category:Category
     * Chart
     *
     * @iatMeta description:short
     * Widget to represent historic data
     * @iatMeta description:de
     * Widget zur Repräsentation historischer Daten
     * @iatMeta description:en
     * Widget to represent historic data
     */

    /**
     * @property {WidgetList} parents=["widgets.brease.LineChartYAxis"]
     * @inheritdoc  
     */

    /**
     * @cfg {NumberArray1D} value
     * @nodeRefId node
     * @iatStudioExposed
     * @iatCategory Data
     * @bindable
     * @not_projectable
     * Binding for numeric values.  
     */

    /**
     * @cfg {brease.datatype.ArrayNode} node
     * @iatStudioExposed
     * @iatCategory Data
     * @bindable
     * @not_projectable
     * Binding for numeric nodes.  
     */

    /**
     * @cfg {Number} minValue=0
     * @iatStudioExposed
     * @iatCategory Behavior
     * Minimum value for graph.
     */

    /**
     * @cfg {Number} maxValue=100
     * @iatStudioExposed
     * @iatCategory Behavior
     * Maximum value for graph.
     */

    /**
     * @cfg {Number} cursorValue=0
     * @iatCategory Data
     * @iatStudioExposed
     * @not_projectable
     * @bindable
     * @readonly
     * @nodeRefId cursorNode
     * Current value of intersection with cursor
     */

    /**
     * @cfg {brease.datatype.Node} cursorNode=''
     * @iatCategory Data
     * @iatStudioExposed
     * @not_projectable
     * @bindable
     * @readonly
     * Current value with unit of intersection with cursor
     */

    /** 
     * @cfg {WidgetReference} xAxisRefId (required)
     * @iatStudioExposed
     * @iatCategory Data
     * Name of the X-Axis the data refer to
     */

    /**
     * @cfg {PixelVal} intersectionPointSize='10px'
     * @iatStudioExposed
     * @iatCategory Appearance
     * Diameter of the intersection point between the graph and the cursor
     */

    var defaultSettings = {
            xAxisRefId: '',
            minValue: 0,
            maxValue: 100,
            cursorValue: 0,
            interpolationType: 'linear',
            intersectionPointSize: '10px'
        },

        WidgetClass = SuperClass.extend(function LineChartGraph() {
            SuperClass.apply(this, arguments);
        }, defaultSettings),

        p = WidgetClass.prototype;

    p.init = function () {

        this.addInitialClass('breaseLineChartGraph');

        this.data = {
            deferredValueChanged: undefined,
            value: [],
            node: new ArrayNode([]),
            arraySize: 0
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

        for (var cursorsId in this.xAxisWidget.cursors) {
            this.xAxisWidget.cursors[cursorsId].graphWidgets[this.elem.id] = this;
        }

    };

    /**
     * @method setValue
     * Sets value
     * @param {NumberArray1D} value
     */
    p.setValue = function (value) {

        var self = this;

        $.when(self.allChartItemsInitializedDeferred).done(function () {
            // A&P 569250:  Line Chart Widget not reloaded when array changes size
            //if (value.length !== 0 && self.data.arraySize === 0) {
            if (value === null) {
                value = self.data.value;
            } else if (value.length !== self.data.arraySize) {
                self.data.arraySize = value.length;
                if (self.isHidden === false) { self.xAxisWidget._registerGraphArraySize(self.elem.id, self.data.arraySize); }
            }

            var cursorsDirtyFlag = false;

            for (var i = 0; i < value.length; i += 1) {
                if (self.data.value[i] !== value[i]) {
                    cursorsDirtyFlag = true;
                    break;
                }
            }

            self.data.value = value;

            if (cursorsDirtyFlag) {
                for (var cursorId in self.xAxisWidget.cursors) {
                    var cursorWidget = self.xAxisWidget.cursors[cursorId],
                        originalActiveState = cursorWidget._getActive();

                    if (cursorWidget._getActive()) {
                        cursorWidget.cursorsDirtyFlag = true;
                        cursorWidget.setValue(cursorWidget.getValue());
                        cursorWidget.cursorsDirtyFlag = false;
                        cursorWidget._setActive(originalActiveState);
                        cursorWidget._isDirty();
                        break;
                    }
                }
            }

            if (self.data.deferredValueChanged !== undefined && self.data.deferredValueChanged.state() !== 'resolved') {
                if (self.data.node.unit === self.axisWidget.currentUnit()) {
                    self.data.deferredValueChanged.resolve();
                }
            } else {
                self._isDirty();
            }
        });
    };

    /**
     * @method getValue 
     * Returns value.
     * @return {NumberArray1D}
     */
    p.getValue = function () {
        return this.data.value;
    };

    /**
     * @method setNode
     * Sets node
     * @param {brease.datatype.ArrayNode} node
     */
    p.setNode = function (node) {

        var self = this;

        $.when(this.allChartItemsInitializedDeferred).done(function () {

            self.data.node = ArrayNode.json2ArrayNode(node);

            self.setMinValue(self.data.node.minValue);
            self.setMaxValue(self.data.node.maxValue);
            self.setValue(self.data.node.value);

            if (self.settings.cursorNode === undefined) {
                self.settings.cursorNode = new Node(self.getCursorValue(), self.data.node.getUnit(), self.getMinValue(), self.getMaxValue());
            } else {
                _updateCursorNode.call(self);
            }
        });

    };

    /**
     * @method getNode 
     * Returns node.
     * @return {brease.datatype.ArrayNode}
     */
    p.getNode = function () {

        if (this.axisWidget === undefined) {

            var axisWidgetId = this.el.parents('.breaseChartYAxisWidget').attr('id');
            this._registerAxisWidget(brease.callWidget(axisWidgetId, 'widget'));
        }
        this.data.node.setUnit(this.axisWidget.currentUnit());

        return this.data.node;
    };

    /**
     * @method setMinValue
     * Sets minimum value
     * @param {Number} value
     */
    p.setMinValue = function (value) {

        if (this.settings.minValue !== value) {

            this.settings.minValue = value;

            if (this.settings.cursorNode !== undefined) {
                this.settings.cursorNode.setMinValue(value);
            }

            this.axisWidget._isDirty();
        }
    };

    /**
     * @method getMinValue 
     * Returns minimum value.
     * @return {Number}
     */
    p.getMinValue = function () {
        return this.settings.minValue;
    };

    /**
     * @method setMaxValue
     * Sets maximum value
     * @param {Number} value
     */
    p.setMaxValue = function (value) {

        if (this.settings.maxValue !== value) {

            this.settings.maxValue = value;

            if (this.settings.cursorNode !== undefined) {
                this.settings.cursorNode.setMaxValue(value);
            }

            this.axisWidget._isDirty();
        }
    };

    /**
     * @method getMaxValue 
     * Returns maximum value.
     * @return {Number}
     */
    p.getMaxValue = function () {
        return this.settings.maxValue;
    };

    /**
     * @method getCursorValue 
     * Returns value of intersection with cursor
     * @return {Number}
     */
    p.getCursorValue = function () {

        return this.settings.cursorValue;
    };

    /**
     * @method getCursorNode
     * Returns value with unit of intersection with cursor
     * @return {brease.datatype.Node}
     */
    p.getCursorNode = function () {

        return this.settings.cursorNode ? this.settings.cursorNode : new Node(this.getCursorValue());
    };

    /**
     * @method setXAxisRefId
     * Sets reference to xAxis Widget
     * @param {String} xAxisRefId
     */
    p.setXAxisRefId = function (xAxisRefId) {

        this.settings.xAxisRefId = xAxisRefId;
    };

    /**
     * @method getXAxisRefId 
     * Returns reference to xAxis Widget
     * @return {String}
     */
    p.getXAxisRefId = function () {

        return this.settings.xAxisRefId;
    };

    /**
     * @method setIntersectionPointSize
     * Sets diameter of the intersection point between graph and cursor
     * @param {PixelVal} intersectionPointSize
     */
    p.setIntersectionPointSize = function (intersectionPointSize) {

        this.settings.intersectionPointSize = intersectionPointSize;
    };

    /**
     * @method getIntersectionPointSize 
     * Returns diameter of the intersection point between graph and cursor
     * @return {PixelVal}
     */
    p.getIntersectionPointSize = function () {

        return this.settings.intersectionPointSize;
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

    p._visibleHandler = function (visibility) {
        var self = this;

        SuperClass.prototype._visibleHandler.apply(this, arguments);

        $.when(this.allChartItemsInitializedDeferred).done(function () {
            if (self.xAxisWidget) {
                Object.keys(self.xAxisWidget.cursors)
                    .forEach(function (cursorId) {
                        this[cursorId]._isDirty();
                    }, self.xAxisWidget.cursors);

                if (self.settings.visible === true) {
                    self.xAxisWidget._registerGraphArraySize(self.elem.id, self.data.arraySize);
                } else {
                    self.xAxisWidget._registerGraphArraySize(self.elem.id, 2);
                }
            }
        });
    };

    p._coordinates = function () {

        var xValues = this.xAxisWidget._xPositions(),
            coordinates = [];

        var numberOfSamples = this.data.value.length;
        if (this.getNumberOfSamples() >= 0 && this.getNumberOfSamples() <= numberOfSamples) {
            numberOfSamples = this.settings.numberOfSamples;
        }

        for (var i = 0; i < numberOfSamples; i += 1) {

            coordinates.push({

                x: xValues[i],
                y: this.data.value[i]
            });
        }

        return coordinates;
    };

    p._getIntersectionValue = function (xCoordinate, activeCursor, marker) {

        var idx = this.getIndexOfXCoordinate(xCoordinate),
            numberOfSamples = (this.getNumberOfSamples() < 0) ? this.getValue().length : this.getNumberOfSamples();

        // saturate the maximum available index to the numberOfSamples
        idx = (idx > numberOfSamples - 1) ? numberOfSamples - 1 : idx;

        if (idx >= 0 && marker === true) {
            if (activeCursor && (this.data.value[idx] !== undefined) && (this.data.value[idx] !== this.getCursorValue()) && this.isVisible()) {
                this._setCursorValue(this.data.value[idx]);

                if (this.settings.cursorNode !== undefined) {
                    _updateCursorNode.call(this);
                } else {
                    this.sendValueChange({ cursorValue: this.getCursorValue() });
                }
            }

            return this.data.value[idx];
        }

        return null;
    };

    p.getIndexOfXCoordinate = function (xCoordinate) {
        var idx = -1;
        if (Utils.isNumeric(xCoordinate.toString())) {
            idx = this.xAxisWidget._xPositions().indexOf(xCoordinate);
        } else {
            var valueArray = this.xAxisWidget._xPositions()
                .map(function (d) { return Number(d); });
            idx = valueArray.indexOf(this._binarySearchOfClosestValue(Number(xCoordinate), valueArray));

        }
        return idx;
    };

    p._getYValueFromXCoordinate = function (xCoordinate) {
        var idx = this.getIndexOfXCoordinate(xCoordinate),
            numberOfSamples = (this.getNumberOfSamples() < 0) ? this.getValue().length : this.getNumberOfSamples();

        // saturate the maximum available index to the numberOfSamples
        idx = (idx > numberOfSamples - 1) ? numberOfSamples - 1 : idx;

        if (idx >= 0) {
            if (this.data.value[idx] !== undefined) {

                return this.data.value[idx];
            }
        }

        return null;
    };

    p._binarySearchOfClosestValue = function (valueToMatch, values) {
        var start = 0,
            end = values.length - 1,
            middle = Math.round((start + end) / 2);

        if (values.length === 0) {
            return null;
        } else if (values.length === 1) {

            return values[start];

        } else if (values.length === 2) {

            return this._getClosestPointBetweenTwo(valueToMatch, values);

        } else if (values.length === 3) {
            if (valueToMatch < values[middle]) {
                return this._getClosestPointBetweenTwo(valueToMatch, values.slice(start, middle + 1));
            } else {
                return this._getClosestPointBetweenTwo(valueToMatch, values.slice(middle, end + 1));
            }
        } else if (valueToMatch < values[middle]) {

            return this._binarySearchOfClosestValue(valueToMatch, values.slice(start, middle + 1));

        } else if (valueToMatch > values[middle]) {

            return this._binarySearchOfClosestValue(valueToMatch, values.slice(middle, end + 1));

        } else {

            return values[middle];
        }
    };

    p._getClosestPointBetweenTwo = function (valueToMatch, twoValues) {

        if (twoValues.length === 2) {
            return ((valueToMatch - twoValues.reduce(function (a, b) { return a + b; }, 0) / 2) < 0) ? twoValues[0] : twoValues[1];
        } else {
            return null;
        }
    };

    p._setCursorValue = function (value) {

        if (value !== undefined) {
            this.settings.cursorValue = value;
        }
    };

    p.dispose = function () {
        this.settings.cursorNode = undefined;
        SuperClass.prototype.dispose.apply(this, arguments);
    };

    // Private Functions
    function _updateCursorNode() {
        var cursorNode = this.settings.cursorNode;
        var oldData = {
            Value: cursorNode.getValue(),
            Unit: cursorNode.getUnit()
        };
        cursorNode.setValue(this.getCursorValue());
        cursorNode.setUnit(this.data.node.getUnit());
        cursorNode.setMinValue(this.getMinValue());
        cursorNode.setMaxValue(this.getMaxValue());
        var hasChanged = Object.keys(oldData).some(function (key) {
            return oldData[key] !== cursorNode['get' + key]();
        });
        if (hasChanged) {
            this.sendValueChange({ cursorNode: this.getCursorNode() });
        }
    }
    return WidgetClass;
});
