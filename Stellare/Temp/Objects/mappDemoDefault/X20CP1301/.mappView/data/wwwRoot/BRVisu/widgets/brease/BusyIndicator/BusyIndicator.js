define([
    'brease/core/BaseWidget'
], function (SuperClass) {

    'use strict';

    var defaultSettings = {},

        /**
         * @class widgets.brease.BusyIndicator
         * #Description
         * rotating sign to signal activity
         *    
         * @breaseNote 
         * @extends brease.core.BaseWidget
         *
         * @iatMeta studio:visible
         * false
         * @iatMeta category:Category
         * System
         */
        /**
         * @method setEnable
         * @inheritdoc
         */
        /**
         * @method setVisible
         * @inheritdoc
         */
        /**
         * @method setStyle
         * @inheritdoc
         */
        /**
         * @event EnableChanged
         * @inheritdoc
         */
        /**
         * @event Click
         * @inheritdoc
         */
        /**
         * @event VisibleChanged
         * @inheritdoc
         */
        BusyIndicator = SuperClass.extend(function BusyIndicator() {
            SuperClass.apply(this, arguments);
        }, defaultSettings),

        p = BusyIndicator.prototype;

    p.init = function () {
        this.addInitialClass('breaseBusyIndicator');
        SuperClass.prototype.init.call(this, true);

        this.elem.onload = this._bind('draw');
        this.elem.onerror = this._bind('_imageLoadError');

        this.elem.src = 'widgets/brease/BusyIndicator/assets/busy-animated.gif';
    };

    p.draw = function () {

        this.elem.onload = null;
        this.elem.onerror = null;
        this._dispatchReady();
    };

    p.dispose = function () {

        this.elem.onload = null;
        this.elem.onerror = null;
        SuperClass.prototype.dispose.apply(this, arguments);
    };

    p._imageLoadError = function () {
        this.elem.onload = null;
        this.elem.onerror = null;

        console.iatWarn('could not load image @BusyIndicator[id="' + this.elem.id + '"]!');
    };

    return BusyIndicator;

});
