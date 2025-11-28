define([
    'widgets/brease/ChartWidget/ChartWidget',
    'widgets/brease/common/libs/DataAdapter',
    'widgets/brease/common/libs/Renderer',
    'brease/decorators/MeasurementSystemDependency'
], function (SuperClass, DataAdapter, Renderer, measurementSystemDependency) {

    'use strict';

    /**
     * @class widgets.brease.LineChart
     * #Description
     * Container widget to display graphically historic data
     * @extends widgets.brease.ChartWidget
     * @iatMeta studio:license
     * licensed
     * @iatMeta studio:isContainer
     * true
     * @iatMeta category:Category
     * Chart,Container
     * @requires widgets.brease.BusyIndicator
     *
     * @iatMeta description:short
     * Container widget to display graphically historic data
     * @iatMeta description:de
     * Container Widget zur grafischen Repräsentation von historischen Daten
     * @iatMeta description:en
     * Container widget to display graphically historic data
     */

    /**
     * @property {WidgetList} children=["widgets.brease.LineChartIndexAxis", "widgets.brease.LineChartTimeAxis", "widgets.brease.LineChartYAxis"]
     * @inheritdoc  
     */

    var defaultSettings = {
            zoomFactor: 1.2,
            scrollFactor: 0.1
        },

        WidgetClass = SuperClass.extend(function LineChart() {
            SuperClass.apply(this, arguments);
        }, defaultSettings),

        p = WidgetClass.prototype;

    p.init = function () {

        this.addInitialClass('breaseLineChart');

        SuperClass.prototype.init.call(this);

    };

    /**
     * @method setShowGrid
     * Sets the visibility of the grid
     * @param {Boolean} value
     */
    p.setShowGrid = function (value) {

        SuperClass.prototype.setShowGrid.call(this, value);
        this._redrawAll();
    };

    p.zoomIn = function () {

        this.renderer.zoomIn();
    };

    p.zoomOut = function () {

        this.renderer.zoomOut();
    };

    p.zoomReset = function () {

        this.renderer.zoomReset();
    };

    p.scrollLeft = function () {

        this.renderer.scrollLeft();
    };

    p.scrollRight = function () {

        this.renderer.scrollRight();
    };

    p.scrollUp = function () {

        this.renderer.scrollUp();
    };

    p.scrollDown = function () {

        this.renderer.scrollDown();
    };

    p.setMinZoomLevel = function (minZoomLevel) {

        SuperClass.prototype.setMinZoomLevel.call(this, minZoomLevel);
        this.dataAdapter.updateZoomLevelLimits();
        this.renderer.updateZoomLevelLimits();
    };

    p.setMaxZoomLevel = function (maxZoomLevel) {

        SuperClass.prototype.setMaxZoomLevel.call(this, maxZoomLevel);
        this.dataAdapter.updateZoomLevelLimits();
        this.renderer.updateZoomLevelLimits();
    };

    p.setZoomType = function (zoomType) {
        SuperClass.prototype.setZoomType.call(this, zoomType);
        this.renderer.updateZoomType(zoomType);
    };

    p._setDataAdapter = function (DataAdapterClass) {

        this.dataAdapter = new DataAdapterClass(this);
    };

    p._setRenderer = function (RendererClass) {

        this.renderer = new RendererClass(this);
    };

    p._chartItemsReadyHandler = function () {

        this._setDataAdapter(DataAdapter);
        this._setRenderer(Renderer);

        this.dataAdapter.updateScales();
        this.renderer.updateAxis();
    };

    p._axisDirtyHandler = function () {
        this.dataAdapter.updateScales();
        this.renderer.updateAxis();
    };

    p._cursorDirtyHandler = function () {

        this.dataAdapter.updateCursor();
        this.renderer.updateCursor();
    };

    p._valueListsDirtyHandler = function () {

        this.dataAdapter.updateGraphData();
        this.renderer.updateGraphs();
    };

    p._redrawAll = function () {

        this._axisIsDirty('x');
        this._axisIsDirty('y');
        this._valueListIsDirty();
        this._cursorIsDirty();
    };

    p.measurementSystemChangeHandler = function () {
        var widget = this,
            deferredObjects = [];
        if (this.chartItems && this.chartItems.yAxis) {
            for (var yAxis in this.chartItems.yAxis) {

                deferredObjects.push(this.chartItems.yAxis[yAxis].measurementSystemChanged());
            }
        }
        if (deferredObjects.length > 0) {
            $.when.apply($, deferredObjects)
                .then(function successHandler() {

                    widget._redrawAll();
                });
        }
    };

    p.dispose = function () {

        // ToDo: Disposed correctly?
        this.dataAdapter = null;
        if (this.renderer) {
            this.renderer.dispose();
        }
        this.renderer = null;

        SuperClass.prototype.dispose.apply(this, arguments);
    };

    // Private Functions

    return measurementSystemDependency.decorate(WidgetClass, true);
});
