define(['brease/core/BaseWidget',
    'brease/events/BreaseEvent',
    'brease/decorators/LanguageDependency',
    'brease/decorators/MeasurementSystemDependency',
    'brease/datatype/Node',
    'brease/config/NumberFormat',
    'brease/core/Utils',
    'brease/core/Types',
    'widgets/brease/RadialGauge/libs/Config',
    'widgets/brease/RadialGauge/libs/Renderer',
    'widgets/brease/common/libs/wfUtils/UtilsObject',
    'brease/decorators/DragAndDropCapability',
    'widgets/brease/common/libs/BreaseResizeObserver',
    'brease/decorators/ContentActivatedDependency',
    'widgets/brease/common/DragDropProperties/libs/DroppablePropertiesEvents'], 
function (
    SuperClass, BreaseEvent, languageDependency, measurementSystemDependency, 
    Node, NumberFormat, Utils, Types, Config, Renderer, UtilsObject, 
    dragAndDropCapability, BreaseResizeObserver, contentActivatedDependency) {

    'use strict';

    /**
    * @class widgets.brease.RadialGauge
    * @extends brease.core.BaseWidget
    *
    * @mixins widgets.brease.common.DragDropProperties.libs.DroppablePropertiesEvents
    *
    * @iatMeta studio:license
    * licensed
    * @iatMeta category:Category
    * Chart,Numeric
    * @iatMeta description:short
    * Zeigerinstrument rund
    * @iatMeta description:de
    * Zeigt einen numerischen Wert in einem Zeigerinstrument mit optionaler Skala an
    * @iatMeta description:en
    * Displays a numeric value in a radial gauge with an optional scale
    */

    var defaultSettings = Config,

        WidgetClass = SuperClass.extend(function RadialGauge() {
            SuperClass.apply(this, arguments);
        }, defaultSettings),

        p = WidgetClass.prototype;

    p.init = function () {
        if (this.settings.omitClass !== true) {
            this.addInitialClass('breaseRadialGauge');
        }

        this.data = {
            node: new Node(this.settings.value, null, this.settings.minValue, this.settings.maxValue),
            arrScaleAreaNode: [new Node(this.settings.scaleArea0), new Node(this.settings.scaleArea1), new Node(this.settings.scaleArea2), new Node(this.settings.scaleArea3), new Node(this.settings.scaleArea4), new Node(this.settings.scaleArea5)]
        };

        // Add deferred objects
        // this.measurementSystemChangePromise = null;
        this.unitChangePromise = null;
        this.nodeChangeResolve = null;

        // two promises are used here: one for the overall scale area update
        this.scaleNodeChangeResolve = null;
        // and another for each of the scale areas
        this.scaleAreasNodeChangeResolve = [];

        _readWidgetProperties(this);
        this.settings.startAngle = this.settings.startAngle % 360;
        this.settings.range = this.settings.range % 360;
        this.renderer = new Renderer(this);

        _initSettings(this);
        this.observer = new BreaseResizeObserver(this.elem, this._bind('redrawView'));
        SuperClass.prototype.init.call(this);
        this.addListeners();
    };

    // override method called in BaseWidget.init
    // additional behaviour in DataHandler _initEditor
    p._initEditor = function () {
        var widget = this;
        // this.elem.classList.add('iatd-outline');

        require(['widgets/brease/common/libs/EditorHandlesSquare'], function (EditorHandles) {
            var editorHandles = new EditorHandles(widget);
            widget.getHandles = function () {
                return editorHandles.getHandles();
            };
            widget.designer.getSelectionDecoratables = function () {
                return editorHandles.getSelectionDecoratables();
            };
            widget.designer.isSquare = function () {
                return true;
            };
            /*
            if (widget.renderer !== undefined) {
                widget.renderer.setTransitionTime(0);
            }
            */
            widget.dispatchEvent(new CustomEvent(BreaseEvent.WIDGET_EDITOR_IF_READY, { bubbles: true }));
            widget.observer.init();
        });

        this.elem.addEventListener(BreaseEvent.WIDGET_STYLE_PROPERTIES_CHANGED, this._bind(this._editorStyleChanged));
    };

    p.contentActivatedHandler = function () {
        if (this.observer.initialized) {
            this.observer.wake();
        } else {
            this.observer.init();
        }
    };

    /**
    * @method setFormat
    * Sets format
    * @param {brease.config.MeasurementSystemFormat} format
    */
    p.setFormat = function (format) {
        this.settings.format = format;
        _updateFormat(this);
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
    * @method setMinValue
    * Sets minValue
    * @param {Number} minValue
    */
    p.setMinValue = function (minValue) {
        if (Utils.isNumeric(minValue)) {
            this.data.node.setMinValue(minValue);
            this.renderer.writeNumbers();
            this.renderer.updateNeedle();
            this.renderer.updateScaleAreas();
        }
    };

    /**
    * @method getMinValue 
    * Returns minValue.
    * @return {Number}
    */
    p.getMinValue = function () {
        return this.data.node.minValue;
    };

    /**
    * @method setMaxValue
    * Sets maxValue
    * @param {Number} maxValue
    */
    p.setMaxValue = function (maxValue) {
        if (Utils.isNumeric(maxValue)) {
            this.data.node.setMaxValue(maxValue);
            this.renderer.writeNumbers();
            this.renderer.updateNeedle();
            this.renderer.updateScaleAreas();
        }
    };

    /**
    * @method getMaxValue 
    * Returns maxValue.
    * @return {Number}
    */
    p.getMaxValue = function () {
        return this.data.node.maxValue;
    };

    /**
    * @method setMajorTicks
    * Sets majorTicks
    * @param {UInteger} majorTicks
    */
    p.setMajorTicks = function (majorTicks) {
        this.settings.majorTicks = parseInt(majorTicks, 10);
        this.el.find('.groupMajorTicks').remove();
        this.el.find('.groupMinorTicks').remove();
        this.el.find('.groupNumbers').remove();
        this.renderer.calcMajorTick();
        this.renderer.calcMinorTick();
        this.renderer.writeNumbers();
    };

    /**
    * @method getMajorTicks 
    * Returns majorTicks.
    * @return {UInteger}
    */
    p.getMajorTicks = function () {
        return this.settings.majorTicks;
    };

    /**
    * @method setMinorTicks
    * Sets minorTicks
    * @param {UInteger} minorTicks
    */
    p.setMinorTicks = function (minorTicks) {
        this.settings.minorTicks = parseInt(minorTicks, 10);
        this.el.find('.groupMinorTicks').remove();
        this.renderer.calcMinorTick();
    };

    /**
    * @method getMinorTicks 
    * Returns minorTicks.
    * @return {UInteger}
    */
    p.getMinorTicks = function () {
        return this.settings.minorTicks;
    };

    /**
    * @method setStartAngle
    * Sets startAngle
    * @param {Number} startAngle
    */
    p.setStartAngle = function (startAngle) {
        this.settings.startAngle = Types.parseValue(startAngle, 'Number', { min: 0 }) % 360.0;
        this.el.find('.groupMajorTicks').remove();
        this.el.find('.groupMinorTicks').remove();
        this.el.find('.groupNumbers').remove();
        this.el.find('.groupText').remove();
        this.renderer.updateScaleAreas();
        this.renderer.calcMajorTick();
        this.renderer.calcMinorTick();
        this.renderer.updateNeedle();
        this.renderer.drawText();
        this.renderer.writeNumbers();
        this.setText(this.settings.text);
    };

    /**
    * @method getStartAngle 
    * Returns startAngle.
    * @return {Number}
    */
    p.getStartAngle = function () {
        return this.settings.startAngle;
    };

    /**
    * @method setNode
    * Sets node
    * @param {brease.datatype.Node} node
    */
    p.setNode = function (node) {
        if (node.minValue !== undefined && this.data.node.minValue !== node.minValue) {
            this.data.node.setMinValue(node.minValue);
        }
        if (node.maxValue !== undefined && this.data.node.maxValue !== node.maxValue) {
            this.data.node.setMaxValue(node.maxValue);
        }
        if (node.value !== undefined) {
            this.data.node.setValue(node.value);
        }

        if (this.nodeChangeResolve) {
            this.nodeChangeResolve();
        } else {
            this.renderer.writeNumbers();
            this.renderer.updateNeedle();
            this.renderer.updateScaleAreas();
        }
    };

    /**
    * @method getNode 
    * Returns node.
    * @return {brease.datatype.Node}
    */
    p.getNode = function () {
        return this.data.node;
    };

    /**
    * @method setValue
    * @iatStudioExposed
    * Sets value
    * @param {Number} value
    */
    p.setValue = function (value) {
        if (value !== undefined) {
            this.data.node.setValue(value);
        }

        if (this.nodeChangeResolve) {
            this.nodeChangeResolve();
        } else {
            this.renderer.updateNeedle();
        }
    };

    /**
    * @method getValue 
    * Returns value.
    * @return {Number}
    */
    p.getValue = function () {
        return this.data.node.value;
    };

    /**
    * @method _setScaleArea
    * @param {Number} scaleAreaIndex
    */
    p._setScaleArea = function (scaleAreaIndex, scaleAreaValue) {
        this.data.arrScaleAreaNode[scaleAreaIndex].setValue(Types.parseValue(scaleAreaValue, 'Number'));

        if (this.scaleNodeChangeResolve && this.scaleAreasNodeChangeResolve[scaleAreaIndex]) {
            this.scaleAreasNodeChangeResolve[scaleAreaIndex]();
        } else {
            this.renderer.updateScaleAreas();
        }
    };

    /**
    * @method _setScaleAreaUnit
    * @param {Number} scaleAreaIndex
    */
    p._setScaleAreaUnit = function (scaleAreaIndex) {
        this.data.arrScaleAreaNode[scaleAreaIndex].unit = this.settings.unit[brease.measurementSystem.getCurrentMeasurementSystem()];
    };

    /**
    * @method setScaleArea0
    * Sets scaleArea0
    * @param {Number} scaleArea0
    */
    p.setScaleArea0 = function (scaleArea0) {
        var value = Types.parseValue(scaleArea0, 'Number');
        if (scaleArea0 !== undefined) {
            this._setScaleArea(0, value);
        }
    };

    /**
    * @method getScaleArea0
    * Returns scaleArea0.
    * @return {Number}
    */
    p.getScaleArea0 = function () {
        return this.data.arrScaleAreaNode[0].getValue();
    };

    /**
     * @method setScaleArea0Node
     * Sets scaleArea0Node
     * @param {brease.datatype.Node} scaleArea0Node
     */
    p.setScaleArea0Node = function (scaleArea0Node) {
        this.setScaleArea0(scaleArea0Node.value);
        this._setScaleAreaUnit(0);
    };

    /**
     * @method getScaleArea0Node
     * Returns the node object for scaleArea0 
     * @return {brease.datatype.Node}
     */
    p.getScaleArea0Node = function () {
        return this.data.arrScaleAreaNode[0];
    };

    /**
    * @method setScaleArea1
    * Sets scaleArea1
    * @param {Number} scaleArea1
    */
    p.setScaleArea1 = function (scaleArea1) {
        var value = Types.parseValue(scaleArea1, 'Number');
        if (scaleArea1 !== undefined) {
            this._setScaleArea(1, value);
        }
    };

    /**
    * @method getScaleArea1 
    * Returns scaleArea1.
    * @return {Number}
    */
    p.getScaleArea1 = function () {
        return this.data.arrScaleAreaNode[1].getValue();
    };

    /**
     * @method setScaleArea1Node
     * Sets scaleArea1Node
     * @param {brease.datatype.Node} scaleArea1Node
     */
    p.setScaleArea1Node = function (scaleArea1Node) {
        this.setScaleArea1(scaleArea1Node.value);
        this._setScaleAreaUnit(1);
    };

    /**
     * @method getScaleArea1Node
     * Returns the node object for scaleArea1
     * @return {brease.datatype.Node}
     */
    p.getScaleArea1Node = function () {
        return this.data.arrScaleAreaNode[1];
    };

    /**
    * @method setScaleArea2
    * Sets scaleArea2
    * @param {Number} scaleArea2
    */
    p.setScaleArea2 = function (scaleArea2) {
        var value = Types.parseValue(scaleArea2, 'Number');
        if (scaleArea2 !== undefined) {
            this._setScaleArea(2, value);
        }
    };

    /**
    * @method getScaleArea2
    * Returns scaleArea2.
    * @return {Number}
    */
    p.getScaleArea2 = function () {
        return this.data.arrScaleAreaNode[2].getValue();
    };

    /**
     * @method setScaleArea2Node
     * Sets scaleArea2Node
     * @param {brease.datatype.Node} scaleArea2Node
     */
    p.setScaleArea2Node = function (scaleArea2Node) {
        this.setScaleArea2(scaleArea2Node.value);
        this._setScaleAreaUnit(2);
    };

    /**
     * @method getScaleArea2Node
     * Returns the node object for scaleArea2
     * @return {brease.datatype.Node}
     */
    p.getScaleArea2Node = function () {
        return this.data.arrScaleAreaNode[2];
    };

    /**
    * @method setScaleArea3
    * Sets scaleArea3
    * @param {Number} scaleArea3
    */
    p.setScaleArea3 = function (scaleArea3) {
        var value = Types.parseValue(scaleArea3, 'Number');
        if (scaleArea3 !== undefined) {
            this._setScaleArea(3, value);
        }
    };

    /**
    * @method getScaleArea3
    * Returns scaleArea3.
    * @return {Number}
    */
    p.getScaleArea3 = function () {
        return this.data.arrScaleAreaNode[3].getValue();
    };

    /**
     * @method setScaleArea3Node
     * Sets scaleArea3Node
     * @param {brease.datatype.Node} scaleArea3Node
     */
    p.setScaleArea3Node = function (scaleArea3Node) {
        this.setScaleArea3(scaleArea3Node.value);
        this._setScaleAreaUnit(3);
    };

    /**
     * @method getScaleArea3Node
     * Returns the node object for scaleArea3
     * @return {brease.datatype.Node}
     */
    p.getScaleArea3Node = function () {
        return this.data.arrScaleAreaNode[3];
    };

    /**
    * @method setScaleArea4
    * Sets scaleArea4
    * @param {Number} scaleArea4
    */
    p.setScaleArea4 = function (scaleArea4) {
        var value = Types.parseValue(scaleArea4, 'Number');
        if (scaleArea4 !== undefined) {
            this._setScaleArea(4, value);
        }
    };

    /**
    * @method getScaleArea4
    * Returns scaleArea4.
    * @return {Number}
    */
    p.getScaleArea4 = function () {
        return this.data.arrScaleAreaNode[4].getValue();
    };

    /**
     * @method setScaleArea4Node
     * Sets scaleArea4Node
     * @param {brease.datatype.Node} scaleArea4Node
     */
    p.setScaleArea4Node = function (scaleArea4Node) {
        this.setScaleArea4(scaleArea4Node.value);
        this._setScaleAreaUnit(4);
    };

    /**
     * @method getScaleArea4Node
     * Returns the node object for scaleArea4
     * @return {brease.datatype.Node}
     */
    p.getScaleArea4Node = function () {
        return this.data.arrScaleAreaNode[4];
    };

    /**
    * @method setScaleArea5
    * Sets scaleArea5
    * @param {Number} scaleArea5
    */
    p.setScaleArea5 = function (scaleArea5) {
        var value = Types.parseValue(scaleArea5, 'Number');
        if (scaleArea5 !== undefined) {
            this._setScaleArea(5, value);
        }
    };

    /**
    * @method getScaleArea5
    * Returns scaleArea5.
    * @return {Number}
    */
    p.getScaleArea5 = function () {
        return this.data.arrScaleAreaNode[5].getValue();
    };

    /**
     * @method setScaleArea5Node
     * Sets scaleArea5Node
     * @param {brease.datatype.Node} scaleArea5Node
     */
    p.setScaleArea5Node = function (scaleArea5Node) {
        this.setScaleArea5(scaleArea5Node.value);
        this._setScaleAreaUnit(5);
    };

    /**
     * @method getScaleArea5Node
     * Returns the node object for scaleArea5
     * @return {brease.datatype.Node}
     */
    p.getScaleArea5Node = function () {
        return this.data.arrScaleAreaNode[5];
    };

    /**
    * @method setText
    * Sets text
    * @param {String} text
    */
    p.setText = function (text) {
        this.settings.text = text;
        this.renderer.textElement.text(text);
    };

    /**
    * @method getText 
    * Returns text.
    * @return {String}
    */
    p.getText = function () {
        return this.settings.text;
    };

    /**
    * @method setTextKey
    * set the textkey
    * @param {String} key The new textkey
    */
    p.setTextKey = function (key) {
        if (key !== undefined) {
            this.settings.textkey = key;
            this.setLangDependency(true);
        }
    };

    /**
    * @method getTextKey
    * get the textkey
    */
    p.getTextKey = function () {
        return this.settings.textkey;
    };

    /**
    * @method setShowUnit
    * Sets showUnit
    * @param {Boolean} showUnit
    */
    p.setShowUnit = function (showUnit) {
        this.settings.showUnit = showUnit;
        this.showUnit();
    };

    /**
    * @method getShowUnit 
    * Returns showUnit.
    * @return {Boolean}
    */
    p.getShowUnit = function () {
        return this.settings.showUnit;
    };

    /**
    * @method setUnit
    * Sets unit
    * @param {brease.config.MeasurementSystemUnit} unit
    */
    p.setUnit = function (unit) {
        if (brease.language.isKey(unit)) {
            this.setLangDependency(true);
            this.settings.unitTextKey = brease.language.parseKey(unit);
        } else {
            this.settings.unitTextKey = undefined;
        }

        if (Utils.isObject(unit)) {
            this.settings.unit = unit;
        } else {
            if (brease.language.isKey(unit)) {
                this.settings.unit = Utils.parsePseudoJSON(brease.language.getTextByKey(this.settings.unitTextKey), _failMessage.call(this, unit, 'unit'));
                
            } else {
                this.settings.unit = Utils.parsePseudoJSON(unit, _failMessage.call(this, unit, 'unit'));
            }
        }    
        if (unit === undefined) {
            this.settings.unit = undefined;
        }

        this.processMeasurementSystemUpdate();
    };

    /**
    * @method getUnit 
    * Returns unit
    * @return {brease.config.MeasurementSystemUnit}
    */
    p.getUnit = function () {
        return this.settings.unit;
    };

    /**
    * @method setScaleAreaInPercent
    * Sets scaleAreaInPercent
    * @param {Boolean} scaleAreaInPercent
    */
    p.setScaleAreaInPercent = function (scaleAreaInPercent) {
        this.settings.scaleAreaInPercent = scaleAreaInPercent;
        this.renderer.updateScaleAreas();
    };

    /**
    * @method getScaleAreaInPercent 
    * Returns scaleAreaInPercent.
    * @return {Boolean}
    */
    p.getScaleAreaInPercent = function () {
        return this.settings.scaleAreaInPercent;
    };

    /**
    * @method setRange
    * Sets range
    * @param {UNumber} range
    */
    p.setRange = function (range) {
        // this.settings.range = range;
        this.settings.range = Types.parseValue(range, 'Number', { min: 0, max: 360 }) % 360.0;
        this.el.find('.groupMajorTicks').remove();
        this.el.find('.groupMinorTicks').remove();
        this.el.find('.groupNumbers').remove();
        this.el.find('.groupText').remove();
        this.renderer.updateScaleAreas();
        this.renderer.calcMajorTick();
        this.renderer.calcMinorTick();
        this.renderer.updateNeedle();
        this.renderer.drawText();
        this.renderer.writeNumbers();
        this.setText(this.settings.text);
    };

    /**
    * @method getRange 
    * Returns range.
    * @return {UNumber}
    */
    p.getRange = function () {
        return this.settings.range;
    };

    /**
    * @method setTransitionTime
    * Sets transitionTime
    * @param {UInteger} transitionTime
    */
    p.setTransitionTime = function (transitionTime) {
        this.settings.transitionTime = transitionTime;
    };

    /**
    * @method getTransitionTime 
    * Returns transitionTime.
    * @return {UInteger}
    */
    p.getTransitionTime = function () {
        return this.settings.transitionTime;
    };

    p.showUnit = function () {
        brease.language.pipeAsyncUnitSymbol(this.data.node.unit, this._bind('writeUnit'));
    };

    p.writeUnit = function (symbol) {
        if (brease.config.editMode === true) {
            this.settings.unitSymbol = 'unit';
        } else {
            this.settings.unitSymbol = symbol;
        }
        if (this.settings.showUnit === true || this.settings.showUnit === 'true') {
            this.renderer.unitElement.text(this.settings.unitSymbol);
        } else {
            this.renderer.unitElement.text('');
        }    
    };

    p.wake = function () {
        this.addListeners();
        SuperClass.prototype.wake.apply(this, arguments);
    };

    p.suspend = function () {
        this.observer.suspend();
        this.removeListeners();
        SuperClass.prototype.suspend.apply(this, arguments);
    };

    p.dispose = function () {
        this.observer.dispose();
        this.observer = undefined;
        this.removeListeners();
        this.renderer.dispose();
        SuperClass.prototype.dispose.apply(this, arguments);
    };

    p.redrawView = function () {
        if (this.renderer && this.isVisible()) {
            this.renderer.redraw();
        }
    };

    function reDrawListener(e) {
        if (e.detail.contentId === this.getParentContentId()) {
            this.redrawView();
        }
    }

    p.addListeners = function () {
        if (isNaN(this.settings.height) || isNaN(this.settings.width)) {
            brease.bodyEl.on(BreaseEvent.FRAGMENT_SHOW, this._bind(reDrawListener));
        }
        document.body.addEventListener(BreaseEvent.THEME_CHANGED, this._bind('redrawView'));
    };

    p.removeListeners = function () {
        brease.bodyEl.off(BreaseEvent.FRAGMENT_SHOW, this._bind(reDrawListener));
        document.body.removeEventListener(BreaseEvent.THEME_CHANGED, this._bind('redrawView'));
    };

    p.langChangeHandler = function () {
        if (this.data.node.unit !== null && this.settings.showUnit === true) {
            this.showUnit();
        }
        if (this.settings.textkey) {
            this.setText(brease.language.getTextByKey(this.settings.textkey));
        }
    };

    p.processMeasurementSystemUpdate = function () {
        var widget = this,
            subscriptions = brease.uiController.getSubscriptionsForElement(this.elem.id),
            getUnitSymbolPromise = _getUnitSymbolAsync(widget),
            nodeChangePromise = _sendNodeChangeAsync(widget, subscriptions),
            scaleAreaNodeChangePromise = _sendScaleNodeChangeAsync(widget, subscriptions);

        _unitSettings(widget);
        _updateFormat(this);

        var promiseArray = [
            getUnitSymbolPromise,
            nodeChangePromise,
            scaleAreaNodeChangePromise
        ];

        Promise.all(promiseArray)
            .then(function () {
                widget.unitChangePromise = null;
                widget.nodeChangeResolve = null;
                widget.scaleChangeResolve = null;
                widget.scaleAreasNodeChangeResolve = []; 
                getUnitSymbolPromise = null;

                _updateNodeDisplay(widget);
                widget.renderer.writeNumbers();
                widget.renderer.updateNeedle();
                widget.renderer.updateScaleAreas();
            });
    };

    function _getUnitSymbolAsync(widget) {
        return new Promise(function (resolve) {
            var unitCommonCode = _getUnitCommonCode(widget);
            widget.unitChangePromise = resolve;

            if (unitCommonCode) {
                brease.language.pipeAsyncUnitSymbol(unitCommonCode, function (symbol) {
                    widget.settings.unitSymbol = symbol;
                    resolve(symbol);
                });
            } else {
                widget.settings.unitSymbol = '';
                resolve('');
            }
        });
    }

    function _sendNodeChangeAsync(widget, subscriptions) {
        return new Promise(function (resolve) {
            widget.nodeChangeResolve = resolve;
            // Update node value for new unit
            var nodeObj = widget.data.node,
                unitCommonCode = _getUnitCommonCode(widget);

            if (subscriptions !== undefined && subscriptions.node !== undefined) {
                if (unitCommonCode && nodeObj.getUnit() !== unitCommonCode) {
                    // setting node.unit is neccassary, because changing measurement system when widget is suspended and "wake"
                    //  is called  again, the binding controller is calling "getNode" method to determine current unit of
                    //  new measurement system
                    widget.data.node.setUnit(unitCommonCode);
                    widget.sendNodeChange({
                        attribute: 'node',
                        nodeAttribute: 'unit',
                        value: unitCommonCode
                    });
                } else {
                    resolve();
                }
            } else {
                resolve();
            }
        });
    }

    function _sendScaleNodeChangeAsync(widget, subscriptions) {
        return new Promise(function (resolve) {
            widget.scaleNodeChangeResolve = resolve;
            // Update node value for new unit
            var nodeObj = widget.data.arrScaleAreaNode,
                unitCommonCode = _getUnitCommonCode(widget),
                promiseArray = [];
            
            promiseArray = nodeObj.map(function (nodeItem, index) {
                var attributeName = 'scaleArea' + index;

                return new Promise(function (resolve) {
                    widget.scaleAreasNodeChangeResolve[index] = resolve;
                    
                    if (subscriptions !== undefined && subscriptions[attributeName + 'Node'] !== undefined) {
                        if (unitCommonCode && nodeItem.getUnit() !== unitCommonCode) {
                            nodeItem.setUnit(unitCommonCode);
                            
                            widget.sendNodeChange({
                                attribute: attributeName + 'Node',
                                nodeAttribute: 'unit',
                                value: unitCommonCode
                            });
                        } else {
                            resolve();
                        }
                    } else {
                        resolve();
                    }
                }); 
            });

            Promise.all(promiseArray)
                .then(function () {
                    resolve();
                });
        });
    }

    p.measurementSystemChangeHandler = function () {
        this.processMeasurementSystemUpdate();
    };

    p._editorStyleChanged = function () {
        if (this.renderer) {
            this.renderer.redraw();
        }
    };

    p._redrawInEditor = function (height, width) {
        if (height !== undefined) { this._setHeight(height); }
        if (width !== undefined) { this._setWidth(width); }
        if (this.renderer) {
            this.renderer.redraw();
        }
    };

    p._visibleHandler = function () {
        SuperClass.prototype._visibleHandler.apply(this, arguments);
        this.redrawView();
    };

    /*PRIVATE
    **FUNCTIONS*/
    function _initSettings(widget) {
        widget.settings.separators = brease.user.getSeparators();
        widget.settings.mms = brease.measurementSystem.getCurrentMeasurementSystem();

        _updateFormat(widget);
        _unitSettings(widget);
        _initText(widget);
    }

    function _updateFormat(widget) {
        if (brease.language.isKey(widget.settings.format)) {
            widget.setLangDependency(true);
        }
        var formatObject = UtilsObject.createFormatObject(widget.defaultSettings.format, widget.settings.format, _failMessage.call(widget, widget.settings.format, 'format'));
        widget.settings.numberFormat = NumberFormat.getFormat(formatObject, widget.settings.mms);
          
        widget.settings.separators = brease.user.getSeparators();
        widget.renderer.writeNumbers();
    }

    function _updateNodeDisplay(widget) {
        widget.writeUnit(widget.settings.unitSymbol);
    }

    function _unitSettings(widget) {
        widget.settings.mms = brease.measurementSystem.getCurrentMeasurementSystem();
        if (Utils.isObject(widget.settings.unit)) {
            widget.data.node.unit = widget.settings.unit[brease.measurementSystem.getCurrentMeasurementSystem()];
            widget.showUnit();
            widget.setLangDependency(true);

            for (var i = 0; i < widget.data.arrScaleAreaNode.length; i++) {
                widget._setScaleAreaUnit(i);
            }
        }
    }

    function _getUnitCommonCode(widget) {
        var unitObj = widget.settings.unit;
        if (unitObj) {
            return unitObj[brease.measurementSystem.getCurrentMeasurementSystem()];
        }
        return null;
    }

    function _initText(widget) {
        if (widget.settings.text !== undefined) {
            if (brease.language.isKey(widget.settings.text) === false) {
                widget.setText(widget.settings.text);
            } else {
                widget.setTextKey(brease.language.parseKey(widget.settings.text));
                widget.setText(brease.language.getTextByKey(widget.settings.textkey));
            }
        }
    }

    function _readWidgetProperties(widget) {
        if (widget.settings.height === undefined || widget.settings.width === undefined) {
            widget.settings.height = parseInt(widget.el.css('height'), 10);
            widget.settings.width = parseInt(widget.el.css('height'), 10);
            widget.settings.left = parseInt(widget.el.css('height'), 10);
            widget.settings.top = parseInt(widget.el.css('height'), 10);
        }
    }

    function _failMessage(str, type) {
        return this.elem.id + ': ' + type + ' string "' + str + '" is invalid!';
    }

    return contentActivatedDependency.decorate(dragAndDropCapability.decorate(measurementSystemDependency.decorate(languageDependency.decorate(WidgetClass, false), true), false), true);

});
