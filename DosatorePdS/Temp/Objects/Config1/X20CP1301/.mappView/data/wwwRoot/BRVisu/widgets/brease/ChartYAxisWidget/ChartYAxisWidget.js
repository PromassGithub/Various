define([
    'brease/core/ContainerWidget',
    'brease/enum/Enum',
    'brease/events/BreaseEvent'
], function (SuperClass, Enum, BreaseEvent) {

    'use strict';

    /**
     * @class widgets.brease.ChartYAxisWidget
     * @abstract
     * #Description
     * Abstract Widget as Base for all Chart Y-Axis Widgets
     * @extends brease.core.ContainerWidget
     * 
     * @iatMeta studio:isContainer
     * true
     * @iatMeta studio:visible
     * false
     * @iatMeta category:Category
     * Chart,Container
     *
     */

    /**
     * @cfg {String} axisLabel=''
     * @localizable
     * @iatStudioExposed
     * @iatCategory Appearance
     * Axis label
     */

    /**
     * @cfg {PixelVal} axisLabelDistance=45px
     * @iatStudioExposed
     * @iatCategory Appearance
     * Distance between the label and the axis.  
     */

    /**
     * @cfg {brease.enum.HorizontalAlign} axisPosition='left'
     * @iatStudioExposed
     * @iatCategory Appearance
     * Position of the y-Axis with respect to the graph area.
     */

    /**
     * @cfg {Rotation} tickLabelRotation=0deg
     * @iatStudioExposed
     * @iatCategory Appearance
     * Rotate the tick labels of the axis to the preferred angle
     */

    /**
     * @cfg {PixelVal} tickLabelDistance=9px
     * @iatStudioExposed
     * @iatCategory Appearance
     * Move the tick labels of the axis to the preferred distance to the axis
     */

    /**
     * @cfg {RoleCollection} permissionView
     * @hide
     */

    /**
     * @cfg {RoleCollection} permissionOperate
     * @hide
     */

    /**
     * @cfg {String} tooltip=''
     * @iatStudioExposed
     * @hide
     */

    /**
     * @method showTooltip
     * @hide
     */

    /**
     * @cfg {Integer} tabIndex=-1
     * @hide
     */

    /**
    * @method focus
    * @hide
    */
   
    /**
    * @event FocusIn
    * @hide
    */

    /**
    * @event FocusOut
    * @hide
    */

    var defaultSettings = {
            axisLabel: '',
            axisLabelDistance: 45,
            axisPosition: 'left',
            tickLabelRotation: '0deg',
            tickLabelDistance: '9px'
        },

        WidgetClass = SuperClass.extend(function ChartYAxisWidget() {
            SuperClass.apply(this, arguments);
        }, defaultSettings),

        p = WidgetClass.prototype;

    p.init = function () {

        this.addInitialClass('breaseChartYAxisWidget');

        this.axisItems = [];

        this.allChartItemsInitializedDeferred = $.Deferred();
        this.allChartItemsInitializedDeferred.promise();

        this.initializationPromise = $.Deferred();
        this.initializationPromise.promise();

        SuperClass.prototype.init.call(this);

        if (brease.config.editMode !== true) {
            this._childInitializationProgress();
        }
    };

    p._setWidth = function (w) {
        SuperClass.prototype._setWidth.call(this, w);

        if (brease.config.editMode) {
            this.el.css('flex-basis', '');
            this.el.css('width', this.settings.width);
            this.editorGrid.configuration.offsetX = (this.getAxisPosition() === 'left') ? this.settings.width - 2 : 0;
            this.editorGrid.parentWidget.editorGrid.updateAllChildren();
        }
    };

    p._clickHandler = function (e) {
        if (this.isDisabled) {
            /**
             * @event DisabledClick
             * Fired when disabled element is clicked on.
             * @iatStudioExposed
             * @param {String} horizontalPos horizontal position of click in pixel i.e '10px'
             * @param {String} verticalPos vertical position of click in pixel i.e '10px'
             * @param {String} origin id of widget that triggered this event
             * @param {Boolean} hasPermission defines if the state is caused due to missing roles of the current user 
             */
            var origin = this.elem.id,
                hasPermission = (this.settings.editable && this.settings.permissions.operate);
            var disabledClickEv = this.createMouseEvent('DisabledClick', { hasPermission: hasPermission, origin: origin }, e);
            disabledClickEv.dispatch(false);
            document.body.dispatchEvent(new CustomEvent(BreaseEvent.DISABLED_CLICK, {
                detail: {
                    contentId: this.settings.parentContentId,
                    hasPermission: hasPermission,
                    origin: origin,
                    widgetId: this.elem.id,
                    horizontalPos: disabledClickEv.data.eventArgs.horizontalPos,
                    verticalPos: disabledClickEv.data.eventArgs.verticalPos
                },
                bubbles: true
            }));
            this._handleEvent(e);
            return;
        }
        /**
         * @event Click
         * Fired when widget is clicked
         * @param {String} horizontalPos horizontal position of click in pixel i.e '10px'
         * @param {String} verticalPos vertical position of click in pixel i.e '10px'
         * @param {String} origin id of widget that triggered this event
         * @iatStudioExposed
         */
        var clickEv = this.createMouseEvent('Click', { origin: this.elem.id }, e);
        clickEv.dispatch(false);
    };

    /**
     * @method setAxisLabelDistance
     * Sets axisLabelDistance
     * @param {PixelVal} axisLabelDistance
     */
    p.setAxisLabelDistance = function (axisLabelDistance) {

        this.settings.axisLabelDistance = parseInt(axisLabelDistance, 10);

        if (brease.config.editMode) {
            this.editorGrid.configuration.axisLabelDistance = parseInt(this.getAxisLabelDistance(), 10);
            this.editorGrid.updateAxis();
        }

    };

    /**
     * @method getAxisLabelDistance 
     * Returns axisLabelDistance.
     * @return {PixelVal}
     */
    p.getAxisLabelDistance = function () {

        return ('' + this.settings.axisLabelDistance + 'px');

    };

    /**
     * @method setAxisPosition
     * Sets position of the axis with respect to the graph area
     * @param {brease.enum.HorizontalAlign} axisPosition
     */
    p.setAxisPosition = function (axisPosition) {

        this.settings.axisPosition = axisPosition;

        if (brease.config.editMode) {
            if (this.editorGrid.configuration.axisPosition !== this.settings.axisPosition) {
                this.el.detach().appendTo(this.editorGrid.parentWidget.el.find('.area' + axisPosition.charAt(0).toUpperCase() + axisPosition.slice(1)));
                this.editorGrid.configuration.axisPosition = this.settings.axisPosition;
                this.editorGrid.configuration.offsetX = (this.settings.axisPosition === 'right') ? 0 : (this.settings.width - 2);
                this.editorGrid.updateAxis();
                this.editorGrid.parentWidget.editorGrid.updateAllChildren();
            }
        }
    };

    /**
     * @method getAxisPosition 
     * Returns position of the axis with respect to the graph area
     * @return {brease.enum.HorizontalAlign}
     */
    p.getAxisPosition = function () {

        return this.settings.axisPosition;
    };

    /**
     * @method setTickLabelRotation
     * Sets rotation for the tick labels of the axis to the preferred angle
     * @param {Rotation} tickLabelRotation
     */
    p.setTickLabelRotation = function (tickLabelRotation) {

        this.settings.tickLabelRotation = tickLabelRotation;

        if (brease.config.editMode) {
            if (this.editorGrid.configuration.tickLabelRotation !== tickLabelRotation) {
                this.editorGrid.configuration.tickLabelRotation = tickLabelRotation;
                this.editorGrid.updateAxis();
            }
        }
    };

    /**
     * @method getTickLabelRotation 
     * Returns rotation of the tick labels
     * @return {Rotation}
     */
    p.getTickLabelRotation = function () {
        return this.settings.tickLabelRotation;
    };

    /**
     * @method setTickLabelDistance
     * Sets distance for the tick labels of the axis to the preferred distance to the axis
     * @param {PixelVal} tickLabelDistance
     */
    p.setTickLabelDistance = function (tickLabelDistance) {

        this.settings.tickLabelDistance = tickLabelDistance;

        if (brease.config.editMode) {
            if (this.editorGrid.configuration.tickLabelDistance !== tickLabelDistance) {
                this.editorGrid.configuration.tickLabelDistance = tickLabelDistance;
                this.editorGrid.updateAxis();
            }
        }
    };

    /**
     * @method getTickLabelDistance 
     * Returns distance of the tick labels
     * @return {PixelVal}
     */
    p.getTickLabelDistance = function () {
        return this.settings.tickLabelDistance;
    };

    /**
     * @method setAxisLabel
     * Sets Description text of axis
     * @param {String} axisLabel
     */
    p.setAxisLabel = function (axisLabel) {

        // to be overwritten
    };

    /**
     * @method getAxisLabel
     * Returns Description text of axis
     * @return {String}
     */
    p.getAxisLabel = function () {

        // to be overwritten
    };

    p._childInitializationProgress = function () {

        var self = this,
            axisItemsFlatList = [],
            deferredInitStates = [],
            deferredInitStatesFlatList = [];

        this.el.find('[data-brease-widget]').each(function () {

            axisItemsFlatList[this.id] = {};

            deferredInitStates[this.id] = $.Deferred();
            deferredInitStates[this.id].promise();
            deferredInitStatesFlatList.push(deferredInitStates[this.id]);
        });

        for (var axisItem in axisItemsFlatList) {

            if (brease.uiController.getWidgetState(axisItem) >= Enum.WidgetState.READY) {

                deferredInitStates[axisItem].resolve();

            } else {

                $('#' + axisItem).on(BreaseEvent.WIDGET_READY, function (e) {

                    if (e.target.id === e.currentTarget.id) {

                        deferredInitStates[e.target.id].resolve();
                        $('#' + e.target.id).off();
                    }
                });
            }
        }

        $.when.apply($, deferredInitStatesFlatList).then(function () {

            var firstChildrenInitializationPromises = [];

            for (var axisItem in axisItemsFlatList) {
                _registerAxisItem(self, axisItem);
            }

            //look for first level children inside container div
            Array.from(self.elem.querySelector('div.container').children)
                .filter(function (itemHtmlNode) {
                    return itemHtmlNode.hasAttribute('data-brease-widget');
                })
                .forEach(function (itemHtmlNode) {
                    var chartItemWidget = brease.callWidget(itemHtmlNode.id, 'widget');
                    firstChildrenInitializationPromises.push(chartItemWidget._getInitializationPromise());
                });

            $.when.apply($, firstChildrenInitializationPromises).done(function () {
                self._axisItemsReadyHandler();
            });
        });
    };

    p._getInitializationPromise = function () {

        return this.initializationPromise.promise();
    };

    p._isDirty = function () {

        var self = this;

        $.when(this.allChartItemsInitializedDeferred).done(function () {
            self.chartWidget._axisIsDirty('y');
        });
    };

    p._registerChartWidget = function (widget) {

        if (this.chartWidget === undefined) {
            this.chartWidget = widget;
        }
    };

    p._axisItemsReadyHandler = function () {

        this.initializationPromise.resolve();
    };

    p._chartItemsReadyHandler = function () {

        // To be overwritten
    };

    p.enable = function () {

        SuperClass.prototype.enable.call(this);
        $('#' + this.elem.id + '_breaseChartYAxis').removeClass('disabled');
    };

    p.disable = function () {

        SuperClass.prototype.disable.call(this);
        $('#' + this.elem.id + '_breaseChartYAxis').addClass('disabled');
    };

    p.updateVisibility = function (initial) {

        SuperClass.prototype.updateVisibility.call(this, initial);

        if (this.isHidden === true) {
            $('#' + this.elem.id + '_breaseChartYAxis').addClass('remove');
        } else {
            $('#' + this.elem.id + '_breaseChartYAxis').removeClass('remove');
        }
    };

    p.setStyle = function (style) {

        if ($('#' + this.elem.id + '_breaseChartYAxis')) {
            $('#' + this.elem.id + '_breaseChartYAxis').removeClass(this.settings.stylePrefix + '_style_' + this.settings.style);
        }
        SuperClass.prototype.setStyle.call(this, style);
        if ($('#' + this.elem.id + '_breaseChartYAxis')) {
            $('#' + this.elem.id + '_breaseChartYAxis').addClass(this.settings.stylePrefix + '_style_' + this.settings.style);
        }

    };

    p.dispose = function () {

        SuperClass.prototype.dispose.apply(this, arguments);
    };

    // Private Functions
    function _registerAxisItem(widget, axisItem) {

        var axisItemWidget = brease.callWidget(axisItem, 'widget');
        axisItemWidget._registerAxisWidget(widget);

        if (axisItemWidget.el.hasClass('breaseChartYValueListWidget')) {
            widget.axisItems[axisItem] = axisItemWidget;
        }
    }

    // override method called in BaseWidget.init
    p._initEditor = function () {
        var widget = this;
        
        require(['widgets/brease/ChartYAxisWidget/libs/EditorHandles',
            'widgets/brease/common/libs/EditorGrid'], 
        function (EditorHandles, EditorGrid) {
            var editorHandles = new EditorHandles(widget);

            widget.getHandles = function () {
                return editorHandles.getHandles();
            };
            widget.designer.getSelectionDecoratables = function () {
                return editorHandles.getSelectionDecoratables();
            };

            var editorGridConfiguration = {
                axisType: 'Vertical',
                axisPosition: widget.getAxisPosition(),
                tickLabelRotation: widget.getTickLabelRotation(),
                tickLabelDistance: widget.getTickLabelDistance(),
                scaleType: 'number',
                tickFormat: widget.currentFormat(),
                offsetX: (widget.getAxisPosition() === 'right') ? 0 : widget.settings.width - 2,
                offsetY: 0,
                axisLabel: widget.getAxisLabel(),
                axisLabelDistance: parseInt(widget.getAxisLabelDistance(), 10)
            };

            widget.editorGrid = new EditorGrid(widget, editorGridConfiguration);
            widget.editorGrid.createAxis();
            widget.allChartItemsInitializedDeferred.resolve();
        });
    };

    return WidgetClass;
});
