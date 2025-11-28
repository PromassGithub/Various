define(['brease/core/BaseWidget',
    'brease/events/BreaseEvent'], 
function (SuperClass, BreaseEvent) {

    'use strict';

    /**
     * @class widgets.brease.ChartYValueListWidget
     * #Description
     * DESCRIPTION
     * @extends brease.core.BaseWidget
     * @iatMeta studio:visible
     * false
     * @iatMeta category:Category
     * Chart
     *
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
     * @cfg {brease.enum.ChartInterpolationType} interpolationType='linear'
     * @iatStudioExposed
     * @iatCategory Behavior
     * Definition of interpolation type which should be applied to the graph.
     */

    /**
     * @cfg {Integer} numberOfSamples=-1
     * @iatStudioExposed
     * @bindable
     * @iatCategory Data
     * Defines the number of samples of the datasource, which should be drawn in the chart
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
            interpolationType: 'linear',
            numberOfSamples: -1
        },
        WidgetClass = SuperClass.extend(function ChartYValueListWidget() {
            SuperClass.apply(this, arguments);
        }, defaultSettings),

        p = WidgetClass.prototype;

    p.init = function () {

        this.addInitialClass('breaseChartYValueListWidget');

        this.allChartItemsInitializedDeferred = $.Deferred();
        this.allChartItemsInitializedDeferred.promise();

        this.initializationPromise = $.Deferred();
        this.initializationPromise.promise();

        SuperClass.prototype.init.call(this);

        this._yValueReadyHandler();
    };

    p._isDirty = function () {

        var self = this;

        $.when(this.allChartItemsInitializedDeferred).done(function () {
            self.chartWidget._valueListIsDirty();
        });
    };

    p._registerChartWidget = function (widget) {

        if (this.chartWidget === undefined) {
            this.chartWidget = widget;
        }

    };

    p._registerAxisWidget = function (widget) {

        if (this.axisWidget === undefined) {
            this.axisWidget = widget;
        }
    };

    p._getInitializationPromise = function () {

        return this.initializationPromise.promise();
    };

    p._yValueReadyHandler = function () {

        this.initializationPromise.resolve();
    };

    p._chartItemsReadyHandler = function () {

        // To be overwritten
    };

    p._coordinates = function () {
        // To be overwritten
    };

    p._clickHandler = function (e) {
        if (this.isDisabled) {
            /**
             * @event DisabledClick
             * Fired when disabled element is clicked on.
             * @iatStudioExposed
             * @param {String} origin id of widget that triggered this event
             * @param {Boolean} hasPermission defines if the state is caused due to missing roles of the current user 
             * @param {String} horizontalPos horizontal position of click in pixel i.e '10px'
             * @param {String} verticalPos vertical position of click in pixel i.e '10px'
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
            
        } else {
            /**
             * @event Click
             * Fired when widget is clicked
             * @param {String} origin id of widget that triggered this event
             * @param {String} horizontalPos horizontal position of click in pixel i.e '10px'
             * @param {String} verticalPos vertical position of click in pixel i.e '10px'
             * @iatStudioExposed
             */
            var clickEv = this.createMouseEvent('Click', { origin: this.elem.id }, e);
            clickEv.dispatch(false);
        }
    };

    /**
     * @method setInterpolationType
     * Sets node
     * @param {brease.enum.ChartInterpolationType} interpolationType
     */
    p.setInterpolationType = function (interpolationType) {
        this.settings.interpolationType = interpolationType;
    };

    /**
     * @method getInterpolationType 
     * Returns node.
     * @return {brease.enum.ChartInterpolationType}
     */
    p.getInterpolationType = function () {
        return this.settings.interpolationType;
    };

    /**
     * @method setNumberOfSamples
     * Sets numberOfSamples property
     * @param {Integer} numberOfSamples
     */
    p.setNumberOfSamples = function (numberOfSamples) {
        var self = this,
            activeCursor;
        this.settings.numberOfSamples = numberOfSamples;
        $.when(this.allChartItemsInitializedDeferred).done(function () {
            self._isDirty();
            var cursorsId;
            // AP 637465 Gets actual active cursor
            for (cursorsId in self.xAxisWidget.cursors) {
                if (Object.prototype.hasOwnProperty.call(self.xAxisWidget.cursors, cursorsId) && self.xAxisWidget.cursors[cursorsId]._getActive()) {
                    activeCursor = cursorsId;
                }
            }
        
            for (cursorsId in self.xAxisWidget.cursors) {
                if (Object.prototype.hasOwnProperty.call(self.xAxisWidget.cursors, cursorsId) && !self.xAxisWidget.cursors[cursorsId]._getActive()) {
                    self.xAxisWidget.cursors[cursorsId].setValue(self.xAxisWidget.cursors[cursorsId].getValue());
                }
            }
            // Sets value for the active cursor
            if (activeCursor) {
                self.xAxisWidget.cursors[activeCursor].setValue(self.xAxisWidget.cursors[activeCursor].getValue());
            }
            self.chartWidget.renderer.updateCursor();

        });
    };

    /**
     * @method getNumberOfSamples 
     * Returns numberOfSamples property
     * @return {Integer}
     */
    p.getNumberOfSamples = function () {
        return this.settings.numberOfSamples;
    };

    p._enableHandler = function (operability) {
        if (operability === true) {
            $('#' + this.elem.id + '_breaseChartYValueList').removeClass('disabled');
            $('#' + this.elem.id + '_breaseChartYValueList_line').removeClass('disabled');
            $('#' + this.elem.id + '_breaseChartYValueList_area').removeClass('disabled');
            $('#' + this.elem.id + '_intersectionPoints').removeClass('disabled');
        } else {
            $('#' + this.elem.id + '_breaseChartYValueList').addClass('disabled');
            $('#' + this.elem.id + '_breaseChartYValueList_line').addClass('disabled');
            $('#' + this.elem.id + '_breaseChartYValueList_area').addClass('disabled');
            $('#' + this.elem.id + '_intersectionPoints').addClass('disabled');    
        }

        SuperClass.prototype._enableHandler.apply(this, arguments);
    };

    p._visibleHandler = function (visibility) {

        SuperClass.prototype._visibleHandler.apply(this, arguments);

        if (this.settings.visible === true) {
            $('#' + this.elem.id + '_breaseChartYValueList').removeClass('remove');
            $('#' + this.elem.id + '_breaseChartYValueList_line').removeClass('remove');
            $('#' + this.elem.id + '_breaseChartYValueList_area').removeClass('remove');
            $('#' + this.elem.id + '_intersectionPoints').removeClass('remove');
        } else {
            $('#' + this.elem.id + '_breaseChartYValueList').addClass('remove');
            $('#' + this.elem.id + '_breaseChartYValueList_line').addClass('remove');
            $('#' + this.elem.id + '_breaseChartYValueList_area').addClass('remove');
            $('#' + this.elem.id + '_intersectionPoints').addClass('remove');
        }
    };

    p.setStyle = function (style) {

        if ($('#' + this.elem.id + '_breaseChartYValueList').length > 0) {
            $('#' + this.elem.id + '_breaseChartYValueList').removeClass(this.settings.stylePrefix + '_style_' + this.settings.style);
            $('#' + this.elem.id + '_breaseChartYValueList_line').removeClass(this.settings.stylePrefix + '_style_' + this.settings.style);
            $('#' + this.elem.id + '_breaseChartYValueList_area').removeClass(this.settings.stylePrefix + '_style_' + this.settings.style);
            $('#' + this.elem.id + '_intersectionPoints').removeClass(this.settings.stylePrefix + '_style_' + this.settings.style);
        }
        SuperClass.prototype.setStyle.call(this, style);
        if ($('#' + this.elem.id + '_breaseChartYValueList').length > 0) {
            $('#' + this.elem.id + '_breaseChartYValueList').addClass(this.settings.stylePrefix + '_style_' + this.settings.style);
            $('#' + this.elem.id + '_breaseChartYValueList_line').addClass(this.settings.stylePrefix + '_style_' + this.settings.style);
            $('#' + this.elem.id + '_breaseChartYValueList_area').addClass(this.settings.stylePrefix + '_style_' + this.settings.style);
            $('#' + this.elem.id + '_intersectionPoints').addClass(this.settings.stylePrefix + '_style_' + this.settings.style);
        }
    };

    p.dispose = function () {

        SuperClass.prototype.dispose.apply(this, arguments);
    };

    // override method called in BaseWidget.init
    p._initEditor = function () {
        var widget = this,
            editorGridConfiguration = {};

        require(['widgets/brease/ChartYValueListWidget/libs/EditorHandles',
            'widgets/brease/common/libs/EditorGrid'], 
        function (EditorHandles, EditorGrid) {
            widget.editorGrid = new EditorGrid(widget, editorGridConfiguration);

            var editorHandles = new EditorHandles(widget);

            widget.getHandles = function () {
                return editorHandles.getHandles();
            };
            // workaround
            widget.designer.getSelectionDecoratables = function () {
                return editorHandles.getSelectionDecoratables();
            };
            widget.allChartItemsInitializedDeferred.resolve();
        });
    };

    return WidgetClass;
});
