define([
    'brease/core/ContainerWidget',
    'brease/enum/Enum',
    'brease/events/BreaseEvent',
    'widgets/brease/common/ErrorHandling/libs/CommissioningErrorHandler',
    'brease/decorators/DragAndDropCapability',
    'widgets/brease/common/DragDropProperties/libs/DroppablePropertiesEvents'],
function (SuperClass, Enum, BreaseEvent, ErrorHandler, dragAndDropCapability) {

    'use strict';

    /**
         * @class widgets.brease.ChartWidget
         * @abstract
         * #Description
         * Abstract Widget as Base for all Chart Widgets
         * @extends brease.core.ContainerWidget
         * @iatMeta studio:isContainer
         * true
         * 
         * @mixins widgets.brease.common.DragDropProperties.libs.DroppablePropertiesEvents
         * 
         * @iatMeta studio:visible
         * false
         * @iatMeta category:Category
         * Chart,Container
         *
         */

    /**
         * @cfg {Boolean} showGrid=true
         * @iatStudioExposed
         * @iatCategory Behavior
         * Controls visibility of Gridlines 
         */

    /**
         * @cfg {PixelValCollection} chartMargin='15px'
         * @iatStudioExposed
         * @iatCategory Appearance
         * Defines margins between the chart area and the external border of the widget
         */

    /**
         * @cfg {UInteger} minZoomLevel=20
         * @iatStudioExposed
         * @iatCategory Behavior
         * Defines in percentage the lower limit of the zoom in the graph area (100 means no zoom level applied)
         */

    /**
         * @cfg {UInteger} maxZoomLevel=500
         * @iatStudioExposed
         * @iatCategory Behavior
         * Defines in percentage the upper limit of the zoom in the graph area (100 means no zoom level applied)
         */

    /**
         * @cfg {brease.enum.ChartZoomType} zoomType='xy'
         * @iatStudioExposed
         * @bindable
         * @iatCategory Behavior
         * Defines on which Axis zooming is enabled
         */

    /**
         * @cfg {Boolean} infiniteScroll=true
         * @iatStudioExposed
         * @iatCategory Behavior
         * Defines if infinite scrolling in the charts is possible or not
         */

    var defaultSettings = {
            showGrid: true,
            chartMargin: '15px',
            minZoomLevel: 20,
            maxZoomLevel: 500,
            zoomType: 'xy',
            infiniteScroll: true
        },

        WidgetClass = SuperClass.extend(function ChartWidget() {
            SuperClass.apply(this, arguments);
        }, defaultSettings),

        p = WidgetClass.prototype;

    p.init = function () {

        this.addInitialClass('breaseChartWidget');

        this.chartItems = {
            xAxis: {},
            yAxis: {},
            xValues: {},
            yValues: {},
            xCursors: {},
            isDirty: {
                xaxis: false,
                yaxis: false,
                cursor: false,
                values: false,
                items: false
            }
        };

        this.timer = {
            axes: [],
            cursors: [],
            valueLists: [],
            chartItems: []
        };
        this.errorHandlerInstance = new ErrorHandler(this);
        this.error = false;

        this.initializationPromise = $.Deferred();
        // A&P 614000 with pre-caching, the widget_READY event needs to be
        // delayed, otherwise the elements in the DOM will be removed before
        // the required updates of the renderer occur
        this.timerCleared = {
            axes: $.Deferred(),
            cursors: $.Deferred(),
            valueLists: $.Deferred(),
            chartItems: $.Deferred()
        };

        SuperClass.prototype.init.call(this);

        if (brease.config.editMode !== true) {
            this._childInitializationProgress();
        }
    };

    // override method called in BaseWidget.init
    p._initEditor = function () {
        var widget = this;

        require(['widgets/brease/ChartWidget/libs/EditorHandles', 'widgets/brease/common/libs/EditorGrid'], function (EditorHandles, EditorGrid) {
            var editorHandles = new EditorHandles(widget);

            widget.getHandles = function () {
                return editorHandles.getHandles();
            };
            // workaround
            widget.designer.getSelectionDecoratables = function () {
                return editorHandles.getSelectionDecoratables();
            };

            var editorGridConfiguration = {
                layout: '5Areas',
                mainContainer: true
            };

            widget.el.css('padding', widget.getChartMargin());

            widget.editorGrid = new EditorGrid(widget, editorGridConfiguration);
            // create layout
            widget.editorGrid.createLayout();

            // extend methods of EditorGrid when child is added
            widget.editorGrid.childrenAdded = function (event) {
                var editorGrid = this;
                EditorGrid.prototype.childrenAdded.call(widget.editorGrid, event);

                var widgetAdded = brease.callWidget(event.detail.widgetId, 'widget');

                $.when(widgetAdded.allChartItemsInitializedDeferred).done(function () {

                    if (widgetAdded.getAxisPosition) {
                        widgetAdded.editorGrid.configuration.axisPosition = widgetAdded.getAxisPosition();
                    }

                    if (widgetAdded.el.hasClass('breaseChartXAxisWidget')) {
                        if (widgetAdded.editorGrid.configuration.axisPosition === 'bottom') {
                            widgetAdded.el.detach().appendTo(editorGrid.widget.el.find('.areaBottom'));
                            editorGrid.bottomAreaHeight += parseInt(widgetAdded.settings.height, 10);
                            editorGrid.widget.el.find('.areaGraph').css('height', editorGrid.widget.el.find('.areaGraph').height() - parseInt(widgetAdded.settings.height, 10));
                            editorGrid.widget.el.find('.areaBottom').css('flex-basis', editorGrid.bottomAreaHeight);
                        } else {
                            widgetAdded.el.detach().appendTo(editorGrid.widget.el.find('.areaTop'));
                            editorGrid.topAreaHeight += parseInt(widgetAdded.settings.height, 10);
                            editorGrid.widget.el.find('.areaGraph').css('height', editorGrid.widget.el.find('.areaGraph').height() - parseInt(widgetAdded.settings.height, 10));
                            editorGrid.widget.el.find('.areaTop').css('flex-basis', editorGrid.topAreaHeight);
                        }
                        widgetAdded.el.css('order', widgetAdded.el.css('z-Index'));
                    } else if (widgetAdded.el.hasClass('breaseChartYAxisWidget')) {

                        if (widgetAdded.editorGrid.configuration.axisPosition === 'left') {
                            widgetAdded.el.detach().appendTo(editorGrid.widget.el.find('.areaLeft'));
                            editorGrid.leftAreaSize = editorGrid.leftAreaSize + parseInt(widgetAdded.settings.width, 10);
                            editorGrid.widget.el.find('.areaGraph').css('width', editorGrid.widget.el.find('.areaGraph').width() - parseInt(widgetAdded.settings.width, 10));
                            editorGrid.widget.el.find('.areaLeft').css('flex-basis', editorGrid.leftAreaSize);
                        } else {
                            widgetAdded.el.detach().appendTo(editorGrid.widget.el.find('.areaRight'));
                            editorGrid.rightAreaSize = editorGrid.rightAreaSize + parseInt(widgetAdded.settings.width, 10);
                            editorGrid.widget.el.find('.areaGraph').css('width', editorGrid.widget.el.find('.areaGraph').width() - parseInt(widgetAdded.settings.width, 10));
                            editorGrid.widget.el.find('.areaRight').css('flex-basis', editorGrid.rightAreaSize);
                        }
                        widgetAdded.el.css('order', widgetAdded.el.css('z-Index'));
                    }

                    widget.editorGrid.updateAllChildren();
                });

            };

            widget.editorGrid.childrenRemoved = function (event) {
                EditorGrid.prototype.childrenRemoved.call(widget.editorGrid, event);
                this.updateAllChildren();
            };

            widget.editorGrid.updateAllChildren = function () {
                var self = this;

                this.leftAreaSize = 0;
                this.rightAreaSize = 0;
                this.topAreaHeight = 0;
                this.bottomAreaHeight = 0;

                Object.keys(this.children).forEach(function (key) {
                    if (self.children[key].el.hasClass('breaseChartYAxisWidget')) {

                        if (self.children[key].getAxisPosition() === 'left') {
                            self.leftAreaSize += parseInt(self.children[key].settings.width, 10);

                        } else {
                            self.rightAreaSize += parseInt(self.children[key].settings.width, 10);
                        }

                    } else if (self.children[key].el.hasClass('breaseChartXAxisWidget')) {
                        if (self.children[key].getAxisPosition() === 'bottom') {
                            self.bottomAreaHeight += parseInt(self.children[key].settings.height, 10);

                        } else {
                            self.topAreaHeight += parseInt(self.children[key].settings.height, 10);
                        }
                    }
                });

                // use css width and height instead of JQuery width() and height() methods, to avoid wrong values
                //  regarding "box-sizing" css property, see JQuery documentation

                this.widget.el.find('.areaLeft').css('flex-basis', this.leftAreaSize);
                this.widget.el.find('.areaRight').css('flex-basis', this.rightAreaSize);
                this.widget.el.find('.areaTop').css('flex-basis', this.topAreaHeight);
                this.widget.el.find('.areaBottom').css('flex-basis', this.bottomAreaHeight);
                this.widget._updateChart();
                //  this.widget.el.find(".breaseChartYAxisWidget.editMode").css('margin-top', this.topAreaHeight)
                //     .css('height', this.areas.graph.height());

                //console.log('graph height: ', this.areas.graph.height());
                //console.log('grpah width: ', this.bottomAreaHeight);
            };

            widget.el.find('.areaGraph').css({
                width: widget.el.width() - _pixelValStringToNumber(widget.el.css('padding-right')) - _pixelValStringToNumber(widget.el.css('padding-left')),
                height: widget.el.height() - _pixelValStringToNumber(widget.el.css('padding-top')) - _pixelValStringToNumber(widget.el.css('padding-bottom')),
                // background image graph area
                'background-image': 'url("widgets/brease/LineChart/assets/LCBackground.svg")',
                'background-size': 'contain'
            });

            widget.el.css('padding', 0);
            widget._updateChart();
            widget.dispatchEvent(new CustomEvent(BreaseEvent.WIDGET_EDITOR_IF_READY, { bubbles: true }));
        });
    };

    /**
         * @method setShowGrid
         * Sets the visibility of the grid
         * @param {Boolean} value
         */
    p.setShowGrid = function (value) {
        this.settings.showGrid = value;
    };

    /**
         * @method getShowGrid
         * Returns the visibility of the grid
         * @return {Boolean}
         */
    p.getShowGrid = function () {
        return this.settings.showGrid;
    };

    /**
         * @method setChartMargin
         * Sets chartMargin
         * @param {PixelValCollection} chartMargin
         */
    p.setChartMargin = function (chartMargin) {

        this.settings.chartMargin = (chartMargin.match(/[\d]*\.*[\d]+px/g)) ? chartMargin : '15px';

        if (brease.config.editMode) {
            this._updateChart();
            //this.el.css('padding', this.settings.chartMargin);
        }
    };

    /**
         * @method getChartMargin 
         * Returns chartMargin.
         * @return {PixelValCollection}
         */
    p.getChartMargin = function () {

        return this.settings.chartMargin;

    };

    /**
         * @method setMinZoomLevel
         * @iatStudioExposed
         * Sets minZoomLevel
         * @param {UInteger} minZoomLevel
         */
    p.setMinZoomLevel = function (minZoomLevel) {

        this.settings.minZoomLevel = minZoomLevel;

    };

    /**
         * @method getMinZoomLevel 
         * Returns minZoomLevel.
         * @return {UInteger}
         */
    p.getMinZoomLevel = function () {

        return this.settings.minZoomLevel;

    };

    /**
         * @method setMaxZoomLevel
         * @iatStudioExposed
         * Sets maxZoomLevel
         * @param {UInteger} maxZoomLevel
         */
    p.setMaxZoomLevel = function (maxZoomLevel) {

        this.settings.maxZoomLevel = maxZoomLevel;

    };

    /**
         * @method getMaxZoomLevel 
         * Returns maxZoomLevel
         * @return {UInteger}
         */
    p.getMaxZoomLevel = function () {

        return this.settings.maxZoomLevel;

    };

    /**
         * @method zoomIn
         * @iatStudioExposed
         * Zoom in
         */

    /**
         * @method zoomOut
         * @iatStudioExposed
         * Zoom out
         */

    /**
         * @method zoomReset
         * @iatStudioExposed
         * Zoom Reset
         */

    /**
         * @method setZoomType
         * @iatStudioExposed
         * Sets the zoomType, which affects the zomming behavior of the axes
         * @param {brease.enum.ChartZoomType} zoomType
         */
    p.setZoomType = function (zoomType) {
        this.settings.zoomType = zoomType;
    };

    /**
         * @method getZoomType
         * Gets the zoomType, which affects the zomming behavior of the axes
         */
    p.getZoomType = function () {
        return this.settings.zoomType;
    };

    /**
         * @method scrollLeft
         * @iatStudioExposed
         * Scroll to the Left
         */

    /**
         * @method scrollRight
         * @iatStudioExposed
         * Scroll to the right
         */

    /**
         * @method scrollUp
         * @iatStudioExposed
         * Scroll up
         */

    /**
         * @method scrollDown
         * @iatStudioExposed
         * Scroll down
         */

    /**
         * @method setInfiniteScroll
         * Sets the infiniteScroll property, which affects the scrolling behavior of the axes
         * @param {Boolean} infiniteScroll
         */
    p.setInfiniteScroll = function (infiniteScroll) {
        this.settings.infiniteScroll = infiniteScroll;
    };

    /**
         * @method getInfiniteScroll
         * Gets the infiniteScroll property, which affects the scrolling behavior of the axes
         */
    p.getInfiniteScroll = function () {
        return this.settings.infiniteScroll;
    };

    p.setStyle = function (style) {

        var $svgChart = $('#' + this.elem.id + ' svg g.chart');
        if ($svgChart.length) {
            $svgChart.removeClass(this.settings.stylePrefix + '_style_' + this.settings.style);
        }
        SuperClass.prototype.setStyle.call(this, style);
        if ($svgChart.length) {
            $svgChart.addClass(this.settings.stylePrefix + '_style_' + this.settings.style);
        }
    };

    /*
         * @method errorHandler
         * @param {Object} error: object containing following properties:
         *   - name of the error, as defined in ChartWidget/libs/constants.js
         *   - arg1: first argument used by the error handler, as defined in widgets/brease/common/libs/ErrorHandling/libs/CommissioningErrorHandler
         *   - arg2: second argument used by the error handler, as defined in widgets/brease/common/libs/ErrorHandling/libs/CommissioningErrorHandler
         */
    p.errorHandler = function (error) {

        this.error = true;
        this.errorHandlerInstance[error.name](error.arg1, error.arg2);
    };

    p._setWidth = function (w) {
        SuperClass.prototype._setWidth.call(this, w);

        if (brease.config.editMode) {
            this.editorGrid.updateAllChildren();
        }
    };

    p._setHeight = function (h) {
        SuperClass.prototype._setHeight.call(this, h);

        if (brease.config.editMode) {
            this.editorGrid.updateAllChildren();
        }
    };

    p._childInitializationProgress = function () {

        var self = this,
            chartItemsFlatList = [],
            deferredInitStates = [];

        this._deferredInitStatesFlatList = [];

        this.el.find('[data-brease-widget]').each(function () {

            chartItemsFlatList[this.id] = {};

            deferredInitStates[this.id] = $.Deferred();
            deferredInitStates[this.id].promise();
            self._deferredInitStatesFlatList.push(deferredInitStates[this.id]);
        });

        for (var chartItem in chartItemsFlatList) {

            if (brease.uiController.getWidgetState(chartItem) >= Enum.WidgetState.READY) {

                deferredInitStates[chartItem].resolve();

            } else {

                $('#' + chartItem).on(BreaseEvent.WIDGET_READY, function (e) {

                    if (e.target.id === e.currentTarget.id) {

                        deferredInitStates[e.target.id].resolve();
                        $('#' + e.target.id).off();
                    }
                });
            }
        }

        $.when.apply($, this._deferredInitStatesFlatList).then(function () {

            var that = self;

            that._firstChildrenInitializationPromises = [];

            for (var chartItemId in chartItemsFlatList) {
                self._registerChartItem(self, chartItemId);
            }

            //look for first level children inside container div (axes)
            Array.from(self.elem.querySelector('div.container').children)
                .filter(function (itemHtmlNode) {
                    return itemHtmlNode.hasAttribute('data-brease-widget');
                })
                .forEach(function (itemHtmlNode) {
                    var chartItemWidget = brease.callWidget(itemHtmlNode.id, 'widget');
                    that._firstChildrenInitializationPromises.push(chartItemWidget._getInitializationPromise());
                });

            $.when.apply($, that._firstChildrenInitializationPromises).done(function () {

                self.initializationPromise.resolve();
                self._chartItemsReady();
            });
        });
    };

    p._axisIsDirty = function (direction) {
        if (this.chartItems) {
            if (!this.chartItems.isDirty.xaxis && !this.chartItems.isDirty.yaxis) {

                var timerId = _.defer(function (widget) {
                    widget.timer.axes.shift();
                    widget._axisDirtyHandler();
                    // reset isDirty after axisDirtyHandler, as values are needed there
                    widget.chartItems.isDirty.xaxis = false;
                    widget.chartItems.isDirty.yaxis = false;
                    // A&P 614000 pre-caching. If all the request to update have been
                    // fulfilled, enable the widget_Ready event to be dispatched
                    if (!widget.timer.axes.length) {
                        widget.timerCleared.axes.resolve();
                    }
                }, this);

                this.timer.axes.push(timerId);
            }

            if (direction === 'x') {
                this.chartItems.isDirty.xaxis = true;
            } else {
                this.chartItems.isDirty.yaxis = true;
            }

            this._chartItemIsDirty();
        }
    };

    p._cursorIsDirty = function () {

        if (this.chartItems.isDirty.cursor === false) {

            var timerId = _.defer(function (widget) {

                widget.chartItems.isDirty.cursor = false;
                widget.timer.cursors.shift();
                widget._cursorDirtyHandler();
                // A&P 614000 pre-caching. If all the request to update have been
                // fulfilled, enable the widget_Ready event to be dispatched
                if (!widget.timer.cursors.length) {
                    widget.timerCleared.cursors.resolve();
                }
            }, this);

            this.timer.cursors.push(timerId);
        }

        this.chartItems.isDirty.cursor = true;

        this._chartItemIsDirty();
    };

    p._valueListIsDirty = function () {

        if (this.chartItems) {
            if (this.chartItems.isDirty.values === false) {

                var timerId = _.defer(function (widget) {
                    var graphBindedFlag = true;
                    widget.chartItems.isDirty.values = false;
                    widget.timer.valueLists.shift();
                    widget._valueListsDirtyHandler();
                    // With precaching we need to resolve the deferred object once
                    // we know the binded array of the graph has been applied
                    for (var graphId in widget.chartItems.yValues) {
                        if (widget.chartItems.yValues[graphId].data && widget.chartItems.yValues[graphId].data.arraySize === 0) {
                            graphBindedFlag = false;
                        }
                    }
                    // A&P 614000 pre-caching. If all the request to update have been
                    // fulfilled, enable the widget_Ready event to be dispatched
                    if (!widget.timer.valueLists.length && graphBindedFlag) {
                        widget.timerCleared.valueLists.resolve();
                    }
                }, this);

                this.timer.valueLists.push(timerId);
            }

            this.chartItems.isDirty.values = true;

            this._chartItemIsDirty();
        }
    };

    p._chartItemIsDirty = function () {

        if (this.chartItems.isDirty.items === false) {

            var timerId = _.defer(function (widget) {

                widget.chartItems.isDirty.items = false;
                widget.timer.chartItems.shift();
                widget._chartItemsDirtyHandler();
                // A&P 614000 pre-caching. If all the request to update have been
                // fulfilled, enable the widget_Ready event to be dispatched
                if (!widget.timer.chartItems.length) {
                    widget.timerCleared.chartItems.resolve();
                }
            }, this);

            this.timer.chartItems.push(timerId);
        }

        this.chartItems.isDirty.items = true;
    };

    p._getInitializationPromise = function () {

        return this.initializationPromise.promise();
    };

    function callAllItems(obj, level1, level2) {
        for (var itemId in obj) {
            if (level2 !== undefined) {
                obj[itemId][level1][level2](); 
            } else {
                obj[itemId][level1](); 
            }
        }
    }

    p._chartItemsReady = function () {
        var xAxisId, yAxisId, xValuesId, yValuesId, xCursorId;

        callAllItems(this.chartItems.xAxis, '_chartItemsReadyHandler');
        callAllItems(this.chartItems.yAxis, '_chartItemsReadyHandler');
        callAllItems(this.chartItems.xValues, '_chartItemsReadyHandler');
        callAllItems(this.chartItems.yValues, '_chartItemsReadyHandler');
        callAllItems(this.chartItems.xCursors, '_chartItemsReadyHandler');

        if (this.isThereAnyError()) {
            return;
        }

        this._chartItemsReadyHandler();

        for (xAxisId in this.chartItems.xAxis) {
            this.chartItems.xAxis[xAxisId].setStyle(this.chartItems.xAxis[xAxisId].settings.style);
            this.chartItems.xAxis[xAxisId]._setActiveCursor(undefined);
        }
        for (yAxisId in this.chartItems.yAxis) {
            this.chartItems.yAxis[yAxisId].setStyle(this.chartItems.yAxis[yAxisId].settings.style);
        }
        for (xValuesId in this.chartItems.xValues) {
            this.chartItems.xValues[xValuesId].setStyle(this.chartItems.xValues[xValuesId].settings.style);
        }
        for (yValuesId in this.chartItems.yValues) {
            this.chartItems.yValues[yValuesId].setStyle(this.chartItems.yValues[yValuesId].settings.style);
        }

        for (xCursorId in this.chartItems.xCursors) {
            this.chartItems.xCursors[xCursorId].setStyle(this.chartItems.xCursors[xCursorId].settings.style);
        }
        
        callAllItems(this.chartItems.xAxis, 'allChartItemsInitializedDeferred', 'resolve');
        callAllItems(this.chartItems.yAxis, 'allChartItemsInitializedDeferred', 'resolve');
        callAllItems(this.chartItems.xValues, 'allChartItemsInitializedDeferred', 'resolve');
        callAllItems(this.chartItems.yValues, 'allChartItemsInitializedDeferred', 'resolve');
        callAllItems(this.chartItems.xCursors, 'allChartItemsInitializedDeferred', 'resolve');
    };

    p.isThereAnyError = function () {
        return this.error;
    };

    p._chartItemsReadyHandler = function () {

        // To be overwritten
    };

    p._axisDirtyHandler = function () {

        // To be overwritten
    };

    p._valueListsDirtyHandler = function () {

        // To be overwritten
    };

    p._chartItemsDirtyHandler = function () {

        // To be overwritten
    };

    p._cursorDirtyHandler = function () {

        // To be overwritten
    };

    // A&P 614000 pre-caching. Added method suspend to remove
    // all pending changes and reset chartItems dirty flag
    p.suspend = function () {

        Object.getOwnPropertyNames(this.timer)
            .forEach(function (chartItemTimer) {
                while (this.timer[chartItemTimer].length) {
                    window.clearTimeout(this.timer[chartItemTimer].shift());
                }
            }, this);

        Object.getOwnPropertyNames(this.chartItems.isDirty)
            .forEach(function (chartItem) {
                this[chartItem] = false;
            }, this.chartItems.isDirty);

        SuperClass.prototype.suspend.apply(this, arguments);
    };

    p.dispose = function () {
        if (this.timer) {
            Object.getOwnPropertyNames(this.timer).forEach(function (chartItemTimer) {
                while (this.timer[chartItemTimer].length) {
                    window.clearTimeout(this.timer[chartItemTimer].shift());
                }
            }, this);
        }

        SuperClass.prototype.dispose.apply(this, arguments);
    };

    // A&P 614000 with pre-caching, the widget_READY event needs to be
    // delayed, otherwise the elements in the DOM will be removed before
    // the required updates of the renderer occur
    p._dispatchReady = function () {

        var self = this;

        if (brease.config.editMode) {
            SuperClass.prototype._dispatchReady.apply(self, arguments);
        } else {
            $.when(this.timerCleared.axes,
                this.timerCleared.cursors,
                this.timerCleared.valueLists,
                this.timerCleared.chartItems).done(function () {
                SuperClass.prototype._dispatchReady.apply(self, arguments);
            });
        }
    };

    // Private Functions
    p._registerChartItem = function (widget, chartItemId) {

        var chartItemWidget = brease.callWidget(chartItemId, 'widget');
        chartItemWidget._registerChartWidget(widget);

        if (chartItemWidget.el.hasClass('breaseChartXAxisWidget')) {
            widget.chartItems.xAxis[chartItemId] = chartItemWidget;
        } else if (chartItemWidget.el.hasClass('breaseChartYAxisWidget')) {
            widget.chartItems.yAxis[chartItemId] = chartItemWidget;
        } else if (chartItemWidget.el.hasClass('breaseChartXValueListWidget')) {
            widget.chartItems.xValues[chartItemId] = chartItemWidget;
        } else if (chartItemWidget.el.hasClass('breaseChartYValueListWidget')) {
            widget.chartItems.yValues[chartItemId] = chartItemWidget;
        } else if (chartItemWidget.el.hasClass('breaseChartXAxisCursorWidget')) {
            widget.chartItems.xCursors[chartItemId] = chartItemWidget;
        }
    };

    p._updateChart = function () {

        this.settings.areaLeft = parseInt(this.el.find('.areaLeft').css('flex-basis'), 10);
        this.settings.areaRight = parseInt(this.el.find('.areaRight').css('flex-basis'), 10);
        this.settings.areaTop = parseInt(this.el.find('.areaTop').css('flex-basis'), 10);
        this.settings.areaBottom = parseInt(this.el.find('.areaBottom').css('flex-basis'), 10);
        this.settings.borderTop = parseInt(this.el.css('border-top-width'), 10);
        this.settings.borderBottom = parseInt(this.el.css('border-bottom-width'), 10);
        this.settings.borderRight = parseInt(this.el.css('border-right-width'), 10);
        this.settings.borderLeft = parseInt(this.el.css('border-left-width'), 10);
        this._getPadding(this.settings.chartMargin);
        this._getAreas();
        for (var axisId in this.editorGrid.children) {
            if (this.editorGrid.children[axisId].editorGrid) {
                this.editorGrid.children[axisId].editorGrid.updateAxis();
            }
        }
    };

    p._getPadding = function (margin) {
        var p = $("<div id='padding'></div>").css('padding', margin);
        this.settings.paddingLeft = parseInt(p.css('padding-left'), 10);
        this.settings.paddingRight = parseInt(p.css('padding-right'), 10);
        this.settings.paddingTop = parseInt(p.css('padding-top'), 10);
        this.settings.paddingBottom = parseInt(p.css('padding-bottom'), 10);
        p.css('padding', 0);
    };

    p._getAreas = function () {
        this.editorGrid.areas.graph.css('width', this.settings.width - this.settings.areaLeft - this.settings.areaRight - parseInt(this.settings.paddingLeft, 10) - parseInt(this.settings.paddingRight, 10) - this.settings.borderLeft - this.settings.borderRight);
        this.editorGrid.areas.graph.css('height', this.settings.height - this.settings.areaTop - this.settings.areaBottom - parseInt(this.settings.paddingTop, 10) - parseInt(this.settings.paddingBottom, 10) - this.settings.borderTop - this.settings.borderBottom);

        this.el.find('.areaCenter').css('width', this.el.width() - this.settings.paddingLeft - this.settings.paddingRight - this.settings.areaLeft - this.settings.areaRight);
        this.el.find('.areaCenter').css('height', this.settings.height - this.settings.paddingTop - this.settings.paddingBottom);
        this.el.find('.areaCenter').css('position', 'absolute');
        this.el.find('.areaCenter').css('top', this.settings.paddingTop - this.settings.borderTop - this.settings.borderBottom);
        this.el.find('.areaCenter').css('left', this.settings.paddingLeft + this.settings.areaLeft);
        this.el.find('.areaCenter').css('right', this.settings.paddingRight + this.settings.areaRight);
        this.el.find('.areaCenter').css('bottom', this.settings.paddingBottom);

        this.el.find('.areaBottom').css('width', this.el.find('.areaGraph').width());
        this.el.find('.areaTop').css('width', this.el.find('.areaGraph').width());
        this.el.find('.areaLeft').css('height', this.el.find('.areaGraph').height());
        this.el.find('.areaRight').css('height', this.el.find('.areaGraph').height());

        this.el.find('.areaRight').css('position', 'absolute');
        this.el.find('.areaLeft').css('position', 'absolute');
        this.el.find('.areaRight').css('top', this.settings.paddingTop + this.settings.areaTop);
        this.el.find('.areaLeft').css('top', this.settings.paddingTop + this.settings.areaTop);
        this.el.find('.areaRight').css('right', this.settings.paddingRight);
        this.el.find('.areaLeft').css('left', this.settings.paddingLeft);
    };

    function _pixelValStringToNumber(pixelValString) {
        return pixelValString.match(/-?\d+(\.\d+)?/)[0];
    }

    return dragAndDropCapability.decorate(WidgetClass, false);
});
