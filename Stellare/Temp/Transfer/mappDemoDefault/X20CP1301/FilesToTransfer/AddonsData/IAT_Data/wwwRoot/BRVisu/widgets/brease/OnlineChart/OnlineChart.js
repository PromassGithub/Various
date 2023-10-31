define([
    'widgets/brease/ChartWidget/ChartWidget',
    'widgets/brease/common/libs/DataAdapter',
    'widgets/brease/common/libs/Renderer',
    'brease/decorators/MeasurementSystemDependency'
], function (SuperClass, DataAdapter, Renderer, measurementSystemDependency) {

    'use strict';

    /**
     * @class widgets.brease.OnlineChart
     * #Description
     * Container widget to display graphically online data
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
     * OnlineChart Container
     * @iatMeta description:de
     * Widget Container zur Representation von Zeitserien in Echtzeit
     * @iatMeta description:en
     * Widget container to represent time series in real-time
     */

    /**
     * @property {WidgetList} [children=["widgets.brease.OnlineChartTimeAxis","widgets.brease.OnlineChartYAxis"]]
     * @inheritdoc  
     */

    /**
     * @cfg {Boolean} autoscale=false
     * @iatStudioExposed
     * @iatCategory Behavior
     * Activates autoscaling functionality for y axes.
     */

    /**
     * @cfg {brease.enum.ChartZoomType} zoomType='xy'
     * @hide
     */

    /**
     * @cfg {Boolean} infiniteScroll=true
     * @hide
     */

    /**
     * @cfg {UInteger} minZoomLevel=20
     * @iatStudioExposed
     * @iatCategory Behavior
     * @deprecated 5.6 This property will be removed in mapp View 5.7
     * Defines in percentage the lower limit of the zoom in the graph area (100 means no zoom level applied)
     */

    /**
     * @cfg {UInteger} maxZoomLevel=500
     * @iatStudioExposed
     * @iatCategory Behavior
     * @deprecated 5.6 This property will be removed in mapp View 5.7
     * Defines in percentage the upper limit of the zoom in the graph area (100 means no zoom level applied)
     */

    var defaultSettings = {
            autoscale: false
        },

        WidgetClass = SuperClass.extend(function OnlineChart() {
            SuperClass.apply(this, arguments);
        }, defaultSettings),

        p = WidgetClass.prototype;

    p.init = function () {

        this.addInitialClass('breaseOnlineChart');

        SuperClass.prototype.init.call(this);
    };

    /**
     * @method zoomIn
     * @hide
     */

    /**
     * @method zoomOut
     * @hide
     */

    /**
     * @method zoomReset
     * @hide
     */

    /**
     * @method setZoomType
     * @hide
     */

    /**
     * @method scrollLeft
     * @hide
     */

    /**
     * @method scrollRight
     * @hide
     */

    /**
     * @method scrollUp
     * @hide
     */

    /**
     * @method scrollDown
     * @hide
     */

    /**
     * @method setMinZoomLevel
     * @hide
     */

    /**
     * @method setMaxZoomLevel
     * @hide
     */

    /**
     * @method setInfiniteScroll
     * @hide
     */

    /**
     * @method graphReset
     * @iatStudioExposed
     * Resets the data of the graph
     * @param {String} id
     */
    p.graphReset = function (id) {
        var graphId;
        if (id !== '') {
            id = brease.pageController.getContentId(this.elem) + '_' + id;
            for (graphId in this.chartItems.yValues) {
                if (graphId === id) {
                    this.chartItems.yValues[graphId].resetBuffer();
                    break;
                }
            }
        } else {
            for (graphId in this.chartItems.yValues) {
                this.chartItems.yValues[graphId].resetBuffer();
            }
        }
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

    /** Sets the value autoscale for autoscale property 
     * @method setAutoscale
     * @param {Boolean} value New value
     */
    p.setAutoscale = function (value) {
        this.settings.autoscale = value;
    };

    p.getAutoscale = function () {
        return this.settings.autoscale;
    };

    p._setDataAdapter = function (DataAdapterClass) {

        this.dataAdapter = new DataAdapterClass(this);
    };

    p._setRenderer = function (RendererClass, zoomFlag) {

        this.renderer = new RendererClass(this, {
            enableZoomingBehavior: zoomFlag
        });
    };

    p._chartItemsReadyHandler = function () {

        //console.log('trdev _chartItemsReadyHandler');
        var timeAxis = this.chartItems.xAxis[Object.keys(this.chartItems.xAxis)],
            sampleTime = timeAxis.getTimeSpan() * 1000 / 100,
            self = this;

        this.zoomed = false;

        for (var graph in this.chartItems.yValues) {
            this.chartItems.yValues[graph].resetBuffer();
        }

        this._timeInterval = window.setInterval(function () {
            self.updateAllBuffers();
        }, sampleTime);

        this._setDataAdapter(DataAdapter);
        this._setRenderer(Renderer, false);

        //// add listener for zoom
        //this.addEventListener('Zoomed', function (e) {
        //    self.zoomed = true;
        //});

    };

    p._axisDirtyHandler = function () {

        //console.log('trdev _axisDirtyHandler');

        this.dataAdapter.updateScales();
        this.renderer.updateAxis();
    };

    p._valueListsDirtyHandler = function () {

        //console.log('trdev _valueListsDirtyHandler');

        this.dataAdapter.updateGraphData();
        this.renderer.updateGraphs();
    };

    p.measurementSystemChangeHandler = function () {

        var widget = this,
            deferredObjects = [];

        if (this.chartItems && this.chartItems.yAxis) { 
            for (var yAxis in this.chartItems.yAxis) {
                if (typeof this.chartItems.yAxis[yAxis].measurementSystemChanged === 'function') {
                    deferredObjects.push(this.chartItems.yAxis[yAxis].measurementSystemChanged()); 
                }
            } 
        }

        if (deferredObjects.length > 0) {
            $.when.apply($, deferredObjects)
                .then(function successHandler() {

                    widget._redrawAll();
                }); 
        }
    };

    p.updateAllBuffers = function () {
        var timeStamp = new Date();
        if (!this.zoomed) {
            for (var graph in this.chartItems.yValues) {
                this.chartItems.yValues[graph].updateBuffer(timeStamp);
            }
        }
    };

    p._redrawAll = function () {

        this._axisIsDirty('x');
        this._axisIsDirty('y');
        this._valueListIsDirty();
    };

    p.wake = function () {

        var timeAxis = this.chartItems.xAxis[Object.keys(this.chartItems.xAxis)[0]],
            sampleTime = timeAxis.getTimeSpan() * 1000 / 100,
            self = this;

        this._timeInterval = window.setInterval(function () {
            self.updateAllBuffers();
        }, sampleTime);

        SuperClass.prototype.wake.apply(this, arguments);
    };

    p.suspend = function () {
        window.clearInterval(this._timeInterval);

        SuperClass.prototype.suspend.apply(this, arguments);
    };

    p.dispose = function () {

        this.dataAdapter = null;
        this.renderer = null;

        window.clearInterval(this._timeInterval);

        SuperClass.prototype.dispose.apply(this, arguments);
    };

    return measurementSystemDependency.decorate(WidgetClass, true);
});
