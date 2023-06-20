define(['brease/events/BreaseEvent', 'brease/core/Utils', 'brease/events/EventDispatcher'], 
    function (BreaseEvent, Utils, EventDispatcher) {

        'use strict';

        var Slider = function (widget) {
            return this.init(widget);
        };
    
        Slider.prototype = new EventDispatcher();
    
        Slider.prototype.init = function (widget) {
            var sliderEl = widget.el.find('.breaseNumpadSlider');
            if (sliderEl.length > 0) {
                this.thumb = $('<div class="numpadSlider_thumb"><div class="numpadSlider_knob"></div><div class="numpadSlider_output"><span></span></div></div>').appendTo(sliderEl);
                this.track = $('<div class="numpadSlider_track"><div class="numpadSlider_track_inner">&nbsp;</div></div>').appendTo(sliderEl);
                this.outputVal = widget.el.find('.numpadSlider_output span');

                this.settings = {
                    width: this.track.outerWidth(),
                    thumbWidth: this.thumb.outerWidth(),
                    zoomFactor: getZoomFactor.call(this)
                };

                this.thumb.on(BreaseEvent.MOUSE_DOWN, onMouseDown.bind(this));
                this.track.on(BreaseEvent.CLICK, trackClickHandler.bind(this));
                this.bound_onMouseMove = onMouseMove.bind(this);
                this.bound_onMouseUp = onMouseUp.bind(this);
                return this; 
            } else {
                return {};
            }
        };

        Slider.prototype.getLimit = function (val, minValue, maxValue) {
            if (isNaN(val) || val === null) {
                return val;
            }
            if (val < minValue) {
                val = minValue;
            }

            if (val > maxValue) {
                val = maxValue;
            }
            return val - 0;
        };

        Slider.prototype.update = function () {
            this.settings.zoomFactor = getZoomFactor.call(this);
        };

        Slider.prototype.setConfig = function (minValue, maxValue, smallChange, largeChange) {
            this.settings.minValue = minValue;
            this.settings.maxValue = maxValue;
            this.settings.smallChange = smallChange;
            this.settings.largeChange = largeChange;
        };

        Slider.prototype.setValue = function (value, dispatch) {
            if (value !== undefined) {
                this.value = value;
                if (this.value !== null) {

                    var val = Math.round(value / this.settings.smallChange) * this.settings.smallChange,
                        pos;

                    val = this.getLimit(val, this.settings.minValue, this.settings.maxValue);

                    pos = valToPos.call(this, val);

                    if (val >= this.settings.minValue && val <= this.settings.maxValue) {
                        this.value = val;
                        setPosition.call(this, pos);
                        if (dispatch === true) {
                            this.dispatchEvent({ type: 'ValueChanged', detail: { value: this.value } });
                        }
                    }
                }
            }
        };

        Slider.prototype.setValueAsString = function (str) {
            this.outputVal.text(str);
        };
        
        Slider.prototype.setError = function (error) {
            this.outputVal.toggleClass('error', error);
        };

        function moveSlider(e) {
            var pageX = Utils.getOffsetOfEvent(e).x,
                pos = pageX - this.thumbOffset * this.settings.zoomFactor,
                val = posToVal.call(this, pos);

            this.setValue(val, true);
        }

        function calcThumbOffset(e) {

            this.thumbOffset = this.track.offset().left;
        }
    
        function onMouseDown(e) {
            this.mouseMove = true;
            calcThumbOffset.call(this, e);

            brease.bodyEl.on(BreaseEvent.MOUSE_MOVE, this.bound_onMouseMove);
            brease.bodyEl.on(BreaseEvent.MOUSE_UP, this.bound_onMouseUp);
        }
        
        function onMouseMove(e) {
            moveSlider.call(this, e);
        }
        
        function onMouseUp(e) {
            this.mouseMove = false;
            brease.bodyEl.off(BreaseEvent.MOUSE_MOVE);
            brease.bodyEl.off(BreaseEvent.MOUSE_UP);
            moveSlider.call(this, e);
        }
        
        function getZoomFactor() { // A&P 451830: Slider in Numpad not usable when zoomed
            var zoomFactor = brease.bodyEl.css('zoom');
            if (zoomFactor === undefined || zoomFactor === 'normal' || zoomFactor === 'auto') {
                return 1;
            } else {
                return parseFloat(zoomFactor);
            }
        }
        
        function trackClickHandler(e) {
            var value = this.value;
            if (!this.mouseMove) {
                var offset = calcOffset.call(this, e),
                    newValue = calcStep.call(this, offset, value);

                newValue = this.getLimit(newValue, this.settings.minValue, this.settings.maxValue);

                this.setValue(newValue, true);
            }

            this.mouseMove = false;

        }
        
        function calcOffset(e) {
            var thumbOffset = this.thumb.offset().left,
                offsetX = Utils.getOffsetOfEvent(e).x / this.settings.zoomFactor;

            return offsetX - thumbOffset - this.settings.thumbWidth / 2;
        }
        
        function calcStep(offset, value) {
            var val;

            if (offset > 0) {
                val = value + this.settings.largeChange;
            } else if (offset < 0) {
                val = value - this.settings.largeChange;
            }

            return val;
        }
        
        function posToVal(pos) {
            var nenner = (this.settings.width * this.settings.zoomFactor),
                val = (pos * (this.settings.maxValue / nenner - this.settings.minValue / nenner)) + this.settings.minValue;

            return this.getLimit(val, this.settings.minValue, this.settings.maxValue);
        }
        
        function valToPos(val) {
            var pos;
            val = this.getLimit(val, this.settings.minValue, this.settings.maxValue);

            if (this.settings.maxValue === -this.settings.minValue) {

                pos = (((this.settings.width / this.settings.maxValue) / 2) * val) - rangeToPixels.call(this, this.settings.minValue);
            } else {

                pos = ((this.settings.width * val) / (this.settings.maxValue - this.settings.minValue)) - rangeToPixels.call(this, this.settings.minValue);
            }
            return pos;
        }
        
        function rangeToPixels(range) {
            var px;
            if (this.settings.maxValue === -this.settings.minValue) {

                px = ((range / 2) / this.settings.maxValue) * this.settings.width;
            } else {

                px = (range * this.settings.width) / (this.settings.maxValue - this.settings.minValue);
            }
            return px;
        }
        
        function setPosition(pos) {
            this.thumb.css('left', pos - (this.settings.thumbWidth / 2));
        }

        return Slider;

    });
