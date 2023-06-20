define(['brease/controller/libs/Utils'], function (Utils) {

    'use strict';

    /**
    * @class brease.controller.ZoomManager
    * @singleton
    */
    var ZoomManager = {

        setBrowserZoom: function (flag) {
            if (_visuConfigIsTrue('browserZoom')) {
                brease.bodyEl.css({ 'touch-action': 'pinch-zoom', '-ms-touch-action': 'pinch-zoom' });
            } else {
                brease.bodyEl.css({ 'touch-action': 'none', '-ms-touch-action': 'pinch-zoom' });
                if (brease.config.detection.ios === true) {
                    brease.bodyEl.css({ 'touch-action': 'manipulation' });
                    $(document.head).find('meta[name="viewport"]').attr('content', 'width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no');
                    if (brease.config.detection.browser === 'Safari') {
                        document.addEventListener('gesturestart', function (e) {
                            e.preventDefault();
                        });
                    }
                }
            }
        },

        iosBodyFix: function () {
            if (brease.config.detection.ios === true) {
                if (brease.appView.height() <= window.innerHeight) {
                    brease.bodyEl.css({ 'position': 'fixed' });
                } else {
                    brease.bodyEl.css({ 'position': 'static' });
                }
            }
        },

        // called if the root layout changes
        setRootLayoutSize: function (layoutDiv, layoutObj, $rootContainer) {
            if (_visuConfigIsTrue('zoom')) {
                // APP_RESIZE event will be dispatched by _appZoom
                document.body.style['overflow'] = 'hidden';
                _appZoom.init(layoutDiv, $rootContainer);
            } else {
                // set size of rootContainer and dispatch APP_RESIZE event
                document.body.style['overflow'] = 'auto';
                $rootContainer.css({
                    width: layoutObj.width + 'px',
                    height: layoutObj.height + 'px'
                });
                brease.dispatchResize();
            }
        },

        getAppZoom: function () {
            return _appZoom.scale;
        }

    };

    function _visuConfigIsTrue(name) {
        return brease.config.visu !== undefined && brease.config.visu[name] === true;
    }

    var _appZoom = {
        scale: 1,
        listening: false,
        init: function init(layoutDiv, $rootContainer) {
            this.$layoutDiv = $(layoutDiv);
            this.$rootContainer = $rootContainer;
            this.scale = 1;
            if (!this.listening) {
                // method zoom will dispatch APP_RESIZE event
                $(window).on('resize', _.debounce(_appZoom.onResize, 150));
                this.listening = true;
            }
            this.zoom();
        },
        zoom: function zoom() {

            // fix for older iOS Versions e.g. 11.1.1
            // this is needed that the body size is calculated in a proper way
            if (brease.config.detection.os === 'iOS') {
                brease.bodyEl.css('width', '100%');
            }
            
            var boundingBox = this.$layoutDiv[0].getBoundingClientRect(),
                bodySize = document.body.getBoundingClientRect(),
                scaleW = Math.floor(bodySize.width) / (boundingBox.width / this.scale),
                scaleH = Math.floor(bodySize.height) / (boundingBox.height / this.scale);

            this.scale = Math.min(scaleW, scaleH);
            
            if (this.scale === scaleW) {
                var w = Math.floor(this.$layoutDiv.outerWidth() * this.scale);
                this.scale = w / this.$layoutDiv.outerWidth();
            } else {
                var h = Math.floor(this.$layoutDiv.outerHeight() * this.scale);
                this.scale = h / this.$layoutDiv.outerHeight();
            }

            this.$layoutDiv.css({
                'transform': 'scale(' + this.scale + ',' + this.scale + ')',
                'transform-origin': '0 0'
            });
            boundingBox = this.$layoutDiv[0].getBoundingClientRect();

            this.$rootContainer.css({
                width: boundingBox.width,
                height: boundingBox.height
            });

            // A&P 651385: wrong zoom factor on T50 and Android tablet
            // forceRepaint forces the browser to show the correct applied css
            Utils.forceRepaint(this.$rootContainer[0]);

            brease.dispatchResize();
        },

        windowResizeHandler: function () {
            this.zoom();
        }
    };
    _appZoom.onResize = _appZoom.windowResizeHandler.bind(_appZoom);

    return ZoomManager;

});
