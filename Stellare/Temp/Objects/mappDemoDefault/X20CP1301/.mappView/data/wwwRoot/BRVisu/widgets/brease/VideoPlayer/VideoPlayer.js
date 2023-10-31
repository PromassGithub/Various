define([
    'brease/core/BaseWidget',
    'brease/core/Types',
    'brease/decorators/LanguageDependency',
    'brease/decorators/DragAndDropCapability'
], function (
    SuperClass, Types, languageDependency, dragAndDropCapability
) {

    'use strict';

    /**
     * @class widgets.brease.VideoPlayer
     * #Description
     * Widget for displaying a video.    
     * @breaseNote
     * @extends brease.core.BaseWidget
     *
     * @mixins widgets.brease.common.DragDropProperties.libs.DroppablePropertiesEvents
     *
     * @iatMeta studio:license
     * licensed
     * @iatMeta category:Category
     * Media
     * @iatMeta category:IO
     * Output
     * @iatMeta category:Appliance
     * Graphic
     * @iatMeta category:Performance
     * Medium,High
     * @iatMeta description:short
     * Video/audio player widget
     * @iatMeta description:de
     * Zeigt einen Film und erlaubt dem Benutzer eine Interaktion mit dem Player
     * @iatMeta description:en
     * Plays video files, allowing user interaction with the player
     */

    /**
     * @cfg {VideoPath} src=''
     * @iatStudioExposed
     * @iatCategory Data
     * @bindable
     * @localizable
     * Path to a video file (e.g. Media/Video.mp4).
     * There are generally 3 supported video formats: MP4, WebM and Ogg.
     * Notice: iOS devices can only play MP4 files with H.264 video encoding.
     * A text key can be used.
     */

    /**
     * @cfg {Boolean} controls=true
     * @iatStudioExposed
     * @iatCategory Behavior
     * If this attribute is true, VideoPlayer will offer controls to allow the user to control video playback, including volume, seeking, and pause/resume playback. 
     */

    /**
     * @cfg {Boolean} autoplay=false
     * @iatStudioExposed
     * @iatCategory Behavior
     * Enables the autoplay functionality, that the video starts as soon as the widget is ready. 
     */

    /**
     * @cfg {Boolean} loop=false
     * @iatStudioExposed
     * @iatCategory Behavior
     * If this attribute is true, the videoplayer will, upon reaching the end of the video, automatically seek back to the start. 
     */

    /**
     * @cfg {ImagePath} poster=''
     * @iatStudioExposed
     * @iatCategory Appearance
     * Specifies an image to be shown while the video is downloading, or until the user hits the play button
     */

    /**
     * @cfg {Boolean} muted=false
     * @iatStudioExposed
     * @iatCategory Behavior
     * Mute the audio of the video.  
     */

    /**
     * @cfg {brease.enum.VideoPlayerPreload} preload=none 
     * @iatStudioExposed
     * @iatCategory Behavior
     * Defines if and how the video contents should start loading as the page loads.
     * Possible values: 'none', 'auto', 'metadata'
     */

    var defaultSettings = {
            controls: true,
            autoplay: false,
            loop: false,
            poster: '',
            muted: false,
            preload: 'none'
        },

        WidgetClass = SuperClass.extend(function VideoPlayer() {
            SuperClass.apply(this, arguments);
        }, defaultSettings),

        p = WidgetClass.prototype;

    p.init = function () {
        var userAgent = navigator.userAgent,
            omitReadyEvent = true;

        this.data = {};

        // A&P 632165: Check Chrome version
        this.data.clickToPlayVersion = 72;
        this.data.isChrome = (userAgent.match(/Chrome\/(.*?)\./) !== null);
        this.data.isMobile = (userAgent.match(/Mobile/) !== null);

        (this.data.isChrome) ? this.data.chromeVersionMajor = userAgent.match(/Chrome\/(.*?)\./)[1] : this.data.chromeVersionMajor = this.data.clickToPlayVersion;
        
        if (this.settings.omitClass !== true) {
            this.addInitialClass('breaseVideoPlayer');
        }
        SuperClass.prototype.init.call(this, omitReadyEvent);

        if (brease.config.editMode) {
            _editorImageHandling(this);
            this._dispatchReady(); 
        } else {
            _srcTextInit(this);
            _addListeners(this);
            _initSettings(this);
            
            this.data.playState = false;

            if (brease.config.preLoadingState) {
                this.elem.load();
            } else {
                this._dispatchReady(); 

                if (this.settings.autoplay) {
                    this.startVideo();
                }
            }
        }
    };

    /**
    * @method setSrc
    * Sets source location of the video file, e.g. "/Media/help_video.mp4"
    * @iatStudioExposed
    * @param {String} value Path of the video file, e.g. "/Media/help_video.mp4"
    * @paramMeta value:localizable=true
    */
    p.setSrc = function (value, keepKey) {

        if (keepKey !== true) {
            this.settings.srckey = null;
        }
        if (brease.language.isKey(value) === true) {
            this.setSrcKey(brease.language.parseKey(value));
        } else {
            this.settings.src = value;
        }

        if (!brease.config.editMode && this.elem) {
            this.el.attr('src', this.settings.src);
        }
    };

    /**
     * @method getSrc 
     * Returns src.
     * @return {String}
     */
    p.getSrc = function () {
        return this.settings.src;
    };

    /**
     * @method setControls
     * Sets controls
     * @param {Boolean} controls
     */
    p.setControls = function (controls) {
        this.settings.controls = controls;
        this.settings.controls = Types.parseValue(this.settings.controls, 'Boolean', { default: this.defaultSettings.controls });

        this.el.attr('controls', this.settings.controls);
    };

    /**
     * @method getControls 
     * Returns controls.
     * @return {Boolean}
     */
    p.getControls = function () {
        return this.settings.controls;
    };

    /**
     * @method setAutoplay
     * Sets autoplay
     * @param {Boolean} autoplay
     */
    p.setAutoplay = function (autoplay) {
        this.settings.autoplay = autoplay;
        this.settings.autoplay = Types.parseValue(this.settings.autoplay, 'Boolean', { default: this.defaultSettings.autoplay });

        this.el.attr('autoplay', this.settings.autoplay);
    };

    /**
     * @method getAutoplay 
     * Returns autoplay.
     * @return {Boolean}
     */
    p.getAutoplay = function () {
        return this.settings.autoplay;
    };

    /**
     * @method setLoop
     * Sets loop
     * @param {Boolean} loop
     */
    p.setLoop = function (loop) {
        this.settings.loop = loop;
        this.settings.loop = Types.parseValue(this.settings.loop, 'Boolean', { default: this.defaultSettings.loop });

        this.el.attr('loop', this.settings.loop);
    };

    /**
     * @method getLoop 
     * Returns loop.
     * @return {Boolean}
     */
    p.getLoop = function () {
        return this.settings.loop;
    };

    /**
     * @method setPoster
     * Sets poster
     * @param {String} poster
     */
    p.setPoster = function (poster) {

        this.settings.poster = poster;

        if (brease.config.editMode) {
            _editorImageHandling(this);
            return;
        }

        var attr = {};
        if (this.settings.poster !== undefined) {
            attr.poster = this.settings.poster;
        }

        this.el.attr(attr);
    };

    /**
     * @method getPoster 
     * Returns poster.
     * @return {String}
     */
    p.getPoster = function () {

        return this.settings.poster;

    };

    /**
     * @method setMuted
     * Sets muted
     * @param {Boolean} muted
     */
    p.setMuted = function (muted) {
        this.settings.muted = Types.parseValue(muted, 'Boolean', { default: this.defaultSettings.muted });
        
        this.elem.muted = this.settings.muted;
    };

    /**
     * @method getMuted 
     * Returns muted.
     * @return {Boolean}
     */
    p.getMuted = function () {
        return this.settings.muted;
    };

    /**
     * @method setPreload
     * Sets preload
     * @param {brease.enum.VideoPlayerPreload} preload
     */
    p.setPreload = function (preload) {
        this.settings.preload = preload;
    };

    /**
     * @method getPreload 
     * Returns preload.
     * @return {brease.enum.VideoPlayerPreload}
     */
    p.getPreload = function () {
        return this.settings.preload;
    };

    /**
     * @method startVideo
     * @iatStudioExposed
     * Starts the video.
     */
    p.startVideo = function () {
        var widget = this;

        // playPromise = this.elem.play().then(function(){console.log('Promise Resolved!');}).catch(function(error){_rejectedVideoPromise(widget, error)});
        this.data.playPromise = this.elem.play();

        if (this.data.playPromise !== undefined) {
            this.data.playPromise.then(function () {
                widget.data.playState = true;
                // console.log('Promise Resolved: ' + widget.elem.id);
            }).catch(function (error) { _rejectedVideoPromise(widget, error); });
        }
    };

    /**
     * @method stopVideo
     * @iatStudioExposed
     * Stops the video.
     */
    p.stopVideo = function () {
        var widget = this;
        if (this.data.playPromise !== undefined) {   
            this.data.playPromise.then(function () {
                //console.log('Promise Resolved: Video pausing...');
                widget.elem.pause(); 
                widget.data.playState = !widget.elem.paused;  
            }).catch(function (error) { 
                if (widget.elem) {
                    _rejectedVideoPromise(widget, error); 
                } 
            });
        }
    };

    p.setSrcKey = function (key) {
        if (key !== undefined) {
            this.settings.srckey = key;
            this.setLangDependency(true);
            this.langChangeHandler();
        }
    };

    p.getSrcKey = function () {
        return this.settings.srckey;
    };

    p.langChangeHandler = function (e) {
        if (this.settings.srckey !== undefined) {
            this.setSrc(brease.language.getTextByKey(this.settings.srckey), true);
        }
    };

    p.disable = function () {
        SuperClass.prototype.disable.call(this);
        this.el.attr('controls', false);
    };

    p.enable = function () {
        SuperClass.prototype.enable.call(this);

        if (this.settings.controls) {
            this.el.attr('controls', true);
        } else {
            this.el.attr('controls', false);
        }

    };

    p._canPlayHandler = function () {
        var attr = {};

        if (brease.config.preLoadingState) {
            this._dispatchReady();
        } else {
            if (this.settings.poster !== undefined) {
                attr.poster = this.settings.poster;
            }
            this.el.attr(attr);
        }
    };

    p._errorHandler = function (e) {
        console.log('[' + WidgetClass.name + ']' + this.elem.id + ':', this.elem.error);
        this.el.attr('poster', 'widgets/brease/VideoPlayer/assets/error.png');
        if (brease.config.preLoadingState) {
            this._dispatchReady();
        }
    };

    p._videoPlayingHandler = function () {
        this.data.playState = true;

        /**
         * @event VideoStarted
         * @iatStudioExposed
         * Fired when the video has been started.
         */
        var videoEv = this.createEvent('VideoStarted');
        videoEv.dispatch();
    };

    p._videoPausingHandler = function () {
        this.data.playState = false;

        /**
         * @event VideoPaused
         * @iatStudioExposed
         * Fired when the video has been paused.
         */
        var videoEv = this.createEvent('VideoPaused');
        videoEv.dispatch();
    };

    p._videoEndedHandler = function () {
        this.data.playState = false;

        /**
         * @event VideoEnded
         * @iatStudioExposed
         * Fired when the video has ended.
         */
        var videoEv = this.createEvent('VideoEnded');
        videoEv.dispatch();
    };

    p._clickHandler = function (event) {
        var mouseEvent;

        if (!this.isDisabled && event !== undefined) {
            if (event.originalEvent.originalEvent.type !== undefined) {
                mouseEvent = (event.originalEvent.originalEvent.type === 'mouseup');
            } else {
                mouseEvent = false;
            }

            if (this.data.isChrome && !this.data.isMobile) {
                if (this.data.chromeVersionMajor < this.data.clickToPlayVersion || (this.data.chromeVersionMajor >= this.data.clickToPlayVersion && mouseEvent === false)) {
                    if (this.data.playState) {
                        this.stopVideo();
                    } else {
                        this.startVideo();
                    }
                }    
            } else if (this.data.isMobile) {
                if (this.data.playState) {
                    this.stopVideo();
                } else {
                    this.startVideo();
                }
            }
        }

        SuperClass.prototype._clickHandler.apply(this, arguments);
    };

    p.dispose = function () {
        if (this.data.playState) {
            this.stopVideo();
        }
        
        _removeListeners(this);
        SuperClass.prototype.dispose.apply(this, arguments);
    };

    p.suspend = function () {
        
        if (this.data.playState) {
            this.stopVideo();
        }
        _removeListeners(this);

        SuperClass.prototype.suspend.apply(this, arguments);
    };

    p.wake = function () {
        
        _addListeners(this);

        if (!this.data.playState && this.settings.autoplay) {
            this.startVideo();
        }
        
        SuperClass.prototype.wake.apply(this, arguments);
    };

    //Privat functions

    function _srcTextInit(widget) {
        if (widget.settings.src !== undefined) {
            if (brease.language.isKey(widget.settings.src) === false) {
                widget.setSrc(widget.settings.src);
            } else {
                widget.setSrcKey(brease.language.parseKey(widget.settings.src), false);
            }
        }
    }

    function _addListeners(widget) {
        widget.el.on('error', widget._bind('_errorHandler'));
        widget.el.on('canplay', widget._bind('_canPlayHandler'));
        widget.el.on('play', widget._bind('_videoPlayingHandler'));
        widget.el.on('pause', widget._bind('_videoPausingHandler'));
        widget.el.on('ended', widget._bind('_videoEndedHandler'));
    }

    function _removeListeners(widget) {
        widget.el.off('error', widget._bind('_errorHandler'));
        widget.el.off('canplay', widget._bind('_canPlayHandler'));
        widget.el.off('play', widget._bind('_videoPlayingHandler'));
        widget.el.off('pause', widget._bind('_videoPausingHandler'));
        widget.el.off('ended', widget._bind('_videoEndedHandler'));
    }

    function _initSettings(widget) {
        var controls, attr = {};

        if (widget.isDisabled) {
            controls = false;
        } else {
            controls = Types.parseValue(widget.settings.controls, 'Boolean', { default: widget.defaultSettings.controls });
        }

        widget.settings.autoplay = Types.parseValue(widget.settings.autoplay, 'Boolean', { default: widget.defaultSettings.autoplay });
        widget.settings.loop = Types.parseValue(widget.settings.loop, 'Boolean', { default: widget.defaultSettings.loop });
        widget.settings.muted = Types.parseValue(widget.settings.muted, 'Boolean', { default: widget.defaultSettings.muted });
        widget.settings.preload = Types.parseValue(widget.settings.preload, 'brease.enum.VideoPlayerPreload', { default: widget.defaultSettings.preload });
        widget.settings.poster = Types.parseValue(widget.settings.poster, 'String', { default: widget.defaultSettings.poster });

        // boolean attributes for <video> tag
        if (controls) { attr.controls = 'controls'; }
        // A&P *****: handle autoplay in js, not as <video> attribute
        // if (widget.settings.autoplay) { attr.autoplay = 'autoplay'; }
        if (widget.settings.loop) { attr.loop = 'loop'; }
        if (widget.settings.muted) { attr.muted = 'muted'; }

        // configuration properties for <video> tag
        attr.preload = widget.settings.preload;
        attr.poster = widget.settings.poster;
        attr.src = widget.settings.src;

        // remove download option for video element
        attr.controlsList = 'nodownload'; // additional options: nofullscreen, noremoteplayback

        widget.el.attr(attr);
        widget.elem.muted = widget.settings.muted;
    }

    function _editorImageHandling(widget) {
        if (widget.settings.poster !== undefined && widget.settings.poster !== '') {
            widget.el.css('background-image', 'url(' + widget.settings.poster + ')')
                .css('background-repeat', 'no-repeat')
                .css('background-position', '50% 50%');
        } else {
            widget.el.css('background-image', 'url("widgets/brease/VideoPlayer/assets/Video.svg")')
                .css('background-repeat', 'no-repeat')
                .css('background-position', '50% 50%');
        }
    }

    function _rejectedVideoPromise(widget, error) {
        var tempSrc;

        // attempt to reload with different source
        if (widget.data.originalSrc === undefined) {
            widget.data.originalSrc = widget.getSrc();
        }

        tempSrc = widget.data.originalSrc + '?t=' + Date.now();
        widget.setSrc(tempSrc);

        console.log((widget.elem) ? widget.elem.id : 'disposed VideoPlayer' + ':', tempSrc, error);
    }

    return dragAndDropCapability.decorate(languageDependency.decorate(WidgetClass, false), false);

});
