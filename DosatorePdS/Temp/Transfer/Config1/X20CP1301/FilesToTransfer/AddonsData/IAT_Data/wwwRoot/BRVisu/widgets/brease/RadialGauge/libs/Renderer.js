define(['brease/core/Class',
    'libs/d3/d3',
    'brease/core/Types',
    'widgets/brease/common/libs/redux/utils/UtilsSize'
], function (SuperClass, d3, Types, UtilsSize) {

    'use strict';
    var SCALE_AREAS = 5;

    var Renderer = SuperClass.extend(function Renderer(widget) {
            SuperClass.call(this);
            this.widget = widget;
            this.settings = widget.settings;
            this.data = widget.data;
            this.initialize();
        }, null),

        p = Renderer.prototype;

    p.initialize = function () {
        _initParsing(this);

        this._setSize();
        this.backgroundShape = $('<div/>').addClass('backShape')
            .css('width', this._getSize() + 'px')
            .css('height', this._getSize() + 'px')
            .css('border-radius', '50%');
            
        this.widget.el.append(this.backgroundShape);

        this.svgContainer = d3.select('#' + this.widget.elem.id)
            .append('svg')
            .attr('width', this._getSize())
            .attr('height', this._getSize())
            .attr('class', 'gaugeContainer');

        this.textContainer = d3.select('#' + this.widget.elem.id)
            .append('svg')
            .attr('width', this._getSize())
            .attr('height', this._getSize())
            .attr('class', 'textContainer');
        this.updateScaleAreas();
        this.calcMajorTick();
        this.calcMinorTick();
        this.calcPointer();
        this.drawText();
    };

    p._setSize = function () {
        this.widgetWidth = UtilsSize.getWidth(this.widget.settings.width, this.widget.elem);
        this.widgetHeight = UtilsSize.getHeight(this.widget.settings.height, this.widget.elem);
        this.settings.size = Math.min(parseInt(this.widgetWidth, 10), parseInt(this.widgetHeight, 10));
    };
    
    p._getSize = function () {
        return this.settings.size;
    };
    
    p.updateScaleAreas = function () {
        var max = (this.settings.scaleAreaInPercent === true) ? 100 : Types.parseValue(this.data.node.getMaxValue(), 'Number', { default: this.settings.maxValue }),
            min = (this.settings.scaleAreaInPercent === true) ? 0 : Types.parseValue(this.data.node.getMinValue(), 'Number', { default: this.settings.minValue });
        this.scaleData = [];

        for (var i = 0; i < SCALE_AREAS; ++i) {
            this.scaleData.push({
                startAngle: Types.parseValue(this.widget.data.arrScaleAreaNode[i].value, 'Number', { min: min, max: max, default: i * 20 }),
                endAngle: Types.parseValue(this.widget.data.arrScaleAreaNode[i + 1].value, 'Number', { min: min, max: max, default: (i * 20) + 20 }),
                pieClass: 'area' + (i + 1)
            });
        }
        _drawScaleAreas(this);
    };

    p.calcMajorTick = function () {

        this.settings.majorTickAngle = [];
        this.settings.majorTickPosX = [];
        this.settings.majorTickPosY = [];
        this.settings.numberPosX = [];
        this.settings.numberPosY = [];

        var fullCircle = 360,
            tickCX = [],
            tickCY = [],
            numberCX = [],
            numberCY = [],
            numberGap = (this.settings.outerRadius - this.settings.innerRadius) / 1.25;

        this.settings.majorTickAngle[0] = this.settings.startAngle;

        if (this.settings.majorTicks > 0) {
            this.settings.majorTickAngle[1] = this.settings.startAngle + this.settings.range / this.settings.majorTicks;

            for (var i = 2; i < this.settings.majorTicks + 1; i += 1) {
                this.settings.majorTickAngle[i] = this.settings.majorTickAngle[i - 1] + this.settings.range / this.settings.majorTicks;
            }
        }

        for (var p = 0; p < this.settings.majorTicks + 1; p += 1) {

            if (this.settings.majorTickAngle[p] >= fullCircle) {
                this.settings.majorTickAngle[p] -= fullCircle;
            }

            if (this.settings.majorTickAngle[p] >= 0 && this.settings.majorTickAngle[p] < 90) {
                tickCX[p] = Math.sin(this.settings.majorTickAngle[p] * Math.PI / 180) * this.settings.innerRadius;
                tickCY[p] = Math.cos(this.settings.majorTickAngle[p] * Math.PI / 180) * this.settings.innerRadius;
                this.settings.majorTickPosX[p] = this.settings.radius + tickCX[p];
                this.settings.majorTickPosY[p] = this.settings.radius - tickCY[p];

                numberCX[p] = Math.sin(this.settings.majorTickAngle[p] * Math.PI / 180) * (this.settings.outerRadius + numberGap);
                numberCY[p] = Math.cos(this.settings.majorTickAngle[p] * Math.PI / 180) * (this.settings.outerRadius + numberGap);
                this.settings.numberPosX[p] = this.settings.radius + numberCX[p];
                this.settings.numberPosY[p] = this.settings.radius - numberCY[p];
            } else if (this.settings.majorTickAngle[p] >= 90 && this.settings.majorTickAngle[p] < 180) {
                tickCX[p] = Math.cos((this.settings.majorTickAngle[p] - 90) * Math.PI / 180) * this.settings.innerRadius;
                tickCY[p] = Math.sin((this.settings.majorTickAngle[p] - 90) * Math.PI / 180) * this.settings.innerRadius;
                this.settings.majorTickPosX[p] = this.settings.radius + tickCX[p];
                this.settings.majorTickPosY[p] = this.settings.radius + tickCY[p];

                numberCX[p] = Math.cos((this.settings.majorTickAngle[p] - 90) * Math.PI / 180) * (this.settings.outerRadius + numberGap);
                numberCY[p] = Math.sin((this.settings.majorTickAngle[p] - 90) * Math.PI / 180) * (this.settings.outerRadius + numberGap);
                this.settings.numberPosX[p] = this.settings.radius + numberCX[p];
                this.settings.numberPosY[p] = this.settings.radius + numberCY[p];
            } else if (this.settings.majorTickAngle[p] >= 180 && this.settings.majorTickAngle[p] < 270) {
                tickCX[p] = Math.sin((this.settings.majorTickAngle[p] - 180) * Math.PI / 180) * this.settings.innerRadius;
                tickCY[p] = Math.cos((this.settings.majorTickAngle[p] - 180) * Math.PI / 180) * this.settings.innerRadius;
                this.settings.majorTickPosX[p] = this.settings.radius - tickCX[p];
                this.settings.majorTickPosY[p] = this.settings.radius + tickCY[p];

                numberCX[p] = Math.sin((this.settings.majorTickAngle[p] - 180) * Math.PI / 180) * (this.settings.outerRadius + numberGap);
                numberCY[p] = Math.cos((this.settings.majorTickAngle[p] - 180) * Math.PI / 180) * (this.settings.outerRadius + numberGap);
                this.settings.numberPosX[p] = this.settings.radius - numberCX[p];
                this.settings.numberPosY[p] = this.settings.radius + numberCY[p];
            } else if (this.settings.majorTickAngle[p] >= 270 && this.settings.majorTickAngle[p] < 360) {
                tickCX[p] = Math.cos((this.settings.majorTickAngle[p] - 270) * Math.PI / 180) * this.settings.innerRadius;
                tickCY[p] = Math.sin((this.settings.majorTickAngle[p] - 270) * Math.PI / 180) * this.settings.innerRadius;
                this.settings.majorTickPosX[p] = this.settings.radius - tickCX[p];
                this.settings.majorTickPosY[p] = this.settings.radius - tickCY[p];

                numberCX[p] = Math.cos((this.settings.majorTickAngle[p] - 270) * Math.PI / 180) * (this.settings.outerRadius + numberGap);
                numberCY[p] = Math.sin((this.settings.majorTickAngle[p] - 270) * Math.PI / 180) * (this.settings.outerRadius + numberGap);
                this.settings.numberPosX[p] = this.settings.radius - numberCX[p];
                this.settings.numberPosY[p] = this.settings.radius - numberCY[p];
            }
        }

        _drawMajorTicks(this);
    };

    p.calcMinorTick = function () {

        if (this.settings.majorTicks > 0) {

            this.settings.totalMinorTicks = this.settings.minorTicks * this.settings.majorTicks + this.settings.majorTicks;
            this.settings.minorTickAngle = [];
            this.settings.minorPosX = [];
            this.settings.minorPosY = [];

            var fullCircle = 360,
                minorTickGap = this.settings.range / this.settings.totalMinorTicks,
                deltaCX = [],
                deltaCY = [];

            if (this.settings.minorTicks > 0) {

                this.settings.minorTickAngle[0] = this.settings.startAngle + minorTickGap;

                for (var i = 1; i < this.settings.totalMinorTicks; i += 1) {
                    this.settings.minorTickAngle[i] = this.settings.startAngle + minorTickGap * (i + 1);
                }

                for (var p = 0; p < this.settings.totalMinorTicks; p += 1) {

                    if (this.settings.minorTickAngle[p] >= fullCircle) {
                        this.settings.minorTickAngle[p] -= fullCircle;
                    }

                    if (this.settings.minorTickAngle[p] >= 0 && this.settings.minorTickAngle[p] < 90) {
                        deltaCX[p] = Math.sin(this.settings.minorTickAngle[p] * Math.PI / 180) * this.settings.innerRadius;
                        deltaCY[p] = Math.cos(this.settings.minorTickAngle[p] * Math.PI / 180) * this.settings.innerRadius;
                        this.settings.minorPosX[p] = this.settings.radius + deltaCX[p];
                        this.settings.minorPosY[p] = this.settings.radius - deltaCY[p];
                    } else if (this.settings.minorTickAngle[p] >= 90 && this.settings.minorTickAngle[p] < 180) {
                        deltaCX[p] = Math.cos((this.settings.minorTickAngle[p] - 90) * Math.PI / 180) * this.settings.innerRadius;
                        deltaCY[p] = Math.sin((this.settings.minorTickAngle[p] - 90) * Math.PI / 180) * this.settings.innerRadius;
                        this.settings.minorPosX[p] = this.settings.radius + deltaCX[p];
                        this.settings.minorPosY[p] = this.settings.radius + deltaCY[p];
                    } else if (this.settings.minorTickAngle[p] >= 180 && this.settings.minorTickAngle[p] < 270) {
                        deltaCX[p] = Math.sin((this.settings.minorTickAngle[p] - 180) * Math.PI / 180) * this.settings.innerRadius;
                        deltaCY[p] = Math.cos((this.settings.minorTickAngle[p] - 180) * Math.PI / 180) * this.settings.innerRadius;
                        this.settings.minorPosX[p] = this.settings.radius - deltaCX[p];
                        this.settings.minorPosY[p] = this.settings.radius + deltaCY[p];
                    } else if (this.settings.minorTickAngle[p] >= 270 && this.settings.minorTickAngle[p] < 360) {
                        deltaCX[p] = Math.cos((this.settings.minorTickAngle[p] - 270) * Math.PI / 180) * this.settings.innerRadius;
                        deltaCY[p] = Math.sin((this.settings.minorTickAngle[p] - 270) * Math.PI / 180) * this.settings.innerRadius;
                        this.settings.minorPosX[p] = this.settings.radius - deltaCX[p];
                        this.settings.minorPosY[p] = this.settings.radius - deltaCY[p];
                    }
                }

                _drawMinorTicks(this);
            }
        }
    };

    p.calcPointer = function () {

        var knobSize = 0.04,
            needleSize = 0.75;

        this.settings.knobRadius = this._getSize() * knobSize * 0.5;

        this.needleData = [
            {
                M1: 'M' + this.settings.radius + ',' + (this.settings.radius - this.settings.innerRadius) + ' ',
                L1: 'L' + (this.settings.radius - this.settings.knobRadius * needleSize) + ',' + this.settings.radius + ' ',
                L2: 'L' + (this.settings.radius + this.settings.knobRadius * needleSize) + ',' + this.settings.radius + ' ',
                M2: 'L' + this.settings.radius + ',' + (this.settings.radius - this.settings.innerRadius) + ' Z'
            }
        ];

        this.drawPointer();
    };

    p.drawPointer = function () {

        this.groupToRotate = this.svgContainer.append('g')
            .attr('class', 'groupToRotate');

        this.groupPointer = this.groupToRotate.append('g')
            .attr('class', 'groupPointer');

        this.pointerNeedle = this.groupPointer.selectAll('path')
            .data(this.needleData)
            .enter()
            .append('path')
            .attr('class', 'needle')
            .attr('d', function (d) { return (d.M1 + d.L1 + d.L2 + d.M2); });

        this.pointerKnob = this.groupPointer.append('circle')
            .attr('cx', this.settings.radius)
            .attr('cy', this.settings.radius)
            .attr('r', this.settings.knobRadius)
            .attr('class', 'knob');

        this.updateNeedle();
    };

    p.updateNeedle = function () {

        this.groupToRotate.attr('transform', 'rotate(' + this.settings.startAngle + ' ' + this.settings.radius + ',' + this.settings.radius + ')');

        this.settings.minMaxScale = d3.scale.linear().domain([this.data.node.minValue, this.data.node.maxValue])
            .range([0, this.settings.range]);

        if (this.data.node.value > this.data.node.maxValue) {
            this.settings.oldPosition = this.settings.actPosition;
            this.settings.actPosition = this.settings.range;
        } else if (this.data.node.value < this.data.node.minValue) {
            this.settings.oldPosition = this.settings.actPosition;
            this.settings.actPosition = 0;
        } else {
            this.settings.oldPosition = this.settings.actPosition;
            this.settings.actPosition = this.settings.minMaxScale(this.data.node.value);
        }

        this.groupPointer.transition()
            .duration(this.widget.settings.transitionTime)
            .attrTween('transform', _.bind(function () {
                if (this.settings.oldPosition !== undefined) {
                    return d3.interpolateString('rotate(' + this.settings.oldPosition + ' ' + this.settings.radius + ',' + this.settings.radius + ')', 'rotate(' + this.settings.actPosition + ' ' + this.settings.radius + ',' + this.settings.radius + ')');
                } else {
                    return d3.interpolateString('rotate(0 ' + this.settings.radius + ',' + this.settings.radius + ')', 'rotate(' + this.settings.actPosition + ' ' + this.settings.radius + ',' + this.settings.radius + ')');
                }
            }, this));

    };

    p.writeNumbers = function () {

        var rangeStep;

        if (this.settings.majorTicks > 0) {
            rangeStep = (this.data.node.maxValue - this.data.node.minValue) / this.settings.majorTicks;
        } else {
            rangeStep = 0;
        }

        for (var i = 0; i < this.settings.majorTicks + 1; i += 1) {
            if (this.settings.numberFormat !== undefined) {
                this.majorNumbers[i].text(brease.formatter.formatNumber((this.data.node.minValue + i * rangeStep), this.settings.numberFormat, this.settings.useDigitGrouping, this.settings.separators));
            }
        }
    };

    p.drawText = function () {

        var size = this._getSize(),
            groupRotation = (360 - this.settings.range) * 0.5,
            containerRotation = (this.settings.startAngle + this.settings.range) % 360 + groupRotation;

        this.groupText = this.textContainer.append('g')
            .attr('class', 'groupText');

        this.textElement = this.groupText.append('text')
            .attr('x', '50%')
            .attr('y', '20%');

        this.unitElement = this.groupText.append('text')
            .attr('x', '50%')
            .attr('y', '27%');

        this.textContainer.style('transform', _getCSSTranslationToCenter.call(this) + ' rotate(' + containerRotation + 'deg)');
        this.groupText.attr('transform', 'rotate(' + containerRotation * (-1) + ', ' + size * 0.5 + ', ' + size * 0.2 + ')');

    };

    p.redraw = function () {
        this.widget.el.find('.groupMajorTicks').remove();
        this.widget.el.find('.groupMinorTicks').remove();
        this.widget.el.find('.groupNumbers').remove();
        this.widget.el.find('.groupScaleAreas').remove();
        this.widget.el.find('.groupToRotate').remove();
        this.widget.el.find('.textContainer').children().remove();

        this._setSize();
        this._resizeContainers();

        this.backgroundShape.css({
            'border-radius': '50%',
            'transform': _getCSSTranslationToCenter.call(this)  
        });
        this.svgContainer.style('transform', _getCSSTranslationToCenter.call(this));
        this.updateScaleAreas();
        this.calcMajorTick();
        this.calcMinorTick();
        this.calcPointer();
        this.writeNumbers();
        this.drawText();
        this.widget.writeUnit(this.widget.settings.unitSymbol);
        this.textElement.text(this.widget.settings.text);
    };

    p._resizeContainers = function () {
        this.backgroundShape
            .css('width', this._getSize())
            .css('height', this._getSize());
        //this.widget.el.css('height', parseInt(this.widgetHeight, 10))
        //    .css('width', parseInt(this.widgetWidth, 10));
        this.svgContainer.attr('width', this._getSize())
            .attr('height', this._getSize());
        this.textContainer.attr('width', this._getSize())
            .attr('height', this._getSize());
    };

    /*PRIVATE
     **FUNCTIONS*/
    function _getCSSTranslationToCenter() {
        return 'translate(' + (this.widgetWidth - this._getSize()) * 0.5 + 'px, ' + (this.widgetHeight - this._getSize()) * 0.5 + 'px)';
    }
    function _drawScaleAreas(renderer) {

        var pieScale,
            outerSize = 0.70,
            innerSize = 0.55,
            scaleRange = renderer.settings.range * Math.PI / 180;

        renderer.settings.radius = parseInt((renderer._getSize() * 0.5), 10);
        renderer.settings.innerRadius = renderer.settings.radius * innerSize;
        renderer.settings.outerRadius = renderer.settings.radius * outerSize;

        if (renderer.arc !== undefined) {
            renderer.widget.el.find('.groupScaleAreas').remove();
        }

        if (renderer.settings.scaleAreaInPercent) {
            pieScale = d3.scale.linear().domain([0, 100]).range([0, scaleRange]);
        } else {
            pieScale = d3.scale.linear().domain([renderer.data.node.minValue, renderer.data.node.maxValue]).range([0, scaleRange]);
        }

        renderer.arc = d3.svg.arc()
            .innerRadius(renderer.settings.innerRadius)
            .outerRadius(renderer.settings.outerRadius)
            .startAngle(function (d) { return pieScale(d.startAngle); })
            .endAngle(function (d) { return pieScale(d.endAngle); });

        renderer.groupScaleAreas = renderer.svgContainer.insert('g', ':first-child')
            .attr('class', 'groupScaleAreas');

        renderer.groupScaleAreas.selectAll('path')
            .data(renderer.scaleData)
            .enter()
            .append('path')
            .attr('d', renderer.arc)
            .attr('class', function (d) { return d.pieClass; })
            .attr('transform', 'translate(' + renderer.settings.radius + ',' + renderer._getSize() * 0.5 + ') rotate(' + renderer.settings.startAngle + ')');

    }

    function _drawMajorTicks(renderer) {

        var svgMajorTick = [],
            majorLength = renderer.settings.outerRadius - renderer.settings.innerRadius;

        renderer.majorNumbers = [];

        renderer.groupMajorTicks = renderer.svgContainer.append('g')
            .attr('class', 'groupMajorTicks');

        renderer.groupMajorNumbers = renderer.svgContainer.append('g')
            .attr('class', 'groupNumbers');

        for (var i = 0; i < renderer.settings.majorTicks + 1; i += 1) {

            svgMajorTick[i] = renderer.groupMajorTicks.append('line')
                .attr('class', 'majorTick')
                .attr('id', 'major' + i)
                .attr('x1', renderer.settings.majorTickPosX[i])
                .attr('x2', renderer.settings.majorTickPosX[i] + majorLength)
                .attr('y1', renderer.settings.majorTickPosY[i])
                .attr('y2', renderer.settings.majorTickPosY[i]);

            renderer.widget.el.find('#major' + i).css({
                'transform': 'rotate(' + (renderer.settings.majorTickAngle[i] - 90) + 'deg)'
            });

            renderer.majorNumbers[i] = renderer.groupMajorNumbers.append('text')
                .attr('x', renderer.settings.numberPosX[i])
                .attr('y', renderer.settings.numberPosY[i]);
        }
    }

    function _drawMinorTicks(renderer) {

        var svgMinorTick = [],
            minorLength = (renderer.settings.outerRadius - renderer.settings.innerRadius) * 0.5;

        renderer.groupMinorTicks = renderer.svgContainer.append('g')
            .attr('class', 'groupMinorTicks');

        for (var i = 0; i < renderer.settings.totalMinorTicks; i += 1) {

            svgMinorTick[i] = renderer.groupMinorTicks.append('line')
                .attr('class', 'minorTick')
                .attr('id', 'minor' + i)
                .attr('x1', renderer.settings.minorPosX[i])
                .attr('x2', renderer.settings.minorPosX[i] + minorLength)
                .attr('y1', renderer.settings.minorPosY[i])
                .attr('y2', renderer.settings.minorPosY[i]);

            renderer.widget.el.find('#minor' + i).css({
                'transform': 'rotate(' + (renderer.settings.minorTickAngle[i] - 90) + 'deg)'
            });
        }
    }

    function _initParsing(widget) {
        widget.settings.majorTicks = parseInt(widget.settings.majorTicks, 10);
        widget.settings.minorTicks = parseInt(widget.settings.minorTicks, 10);

        widget.settings.startAngle = Number(widget.settings.startAngle);
        widget.settings.scaleArea0 = Number(widget.settings.scaleArea0);
        widget.settings.scaleArea1 = Number(widget.settings.scaleArea1);
        widget.settings.scaleArea2 = Number(widget.settings.scaleArea2);
        widget.settings.scaleArea3 = Number(widget.settings.scaleArea3);
        widget.settings.scaleArea4 = Number(widget.settings.scaleArea4);
        widget.settings.scaleArea5 = Number(widget.settings.scaleArea5);
    }

    return Renderer;

});
