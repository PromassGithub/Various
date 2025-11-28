define(function () {
    
    'use strict';

    var ScreenManager = {

        captureScreenAndSaveOnClient: function (preFix) {
            preFix = preFix || 'screenshot';
            this.active = true;
            return new Promise(function (resolve, reject) {
                ScreenManager.takeScreenshot().then(function success(blob) {
                    ScreenManager.saveOnClient(blob, preFix).then(function () {
                        ScreenManager.active = false;
                        resolve();
                    });
                }, function fail(reason) {
                    ScreenManager.active = false;
                    reject(reason);
                }).catch(function (err) {
                    ScreenManager.active = false;
                    reject(err.message);
                    return err;
                });
            });
        },

        captureScreenAndSaveOnServer: function () {
           
        },
    
        takeScreenshot: function () {
            return new Promise(function (resolve, reject) {
                ScreenManager.createScreenshotCanvas().then(function (canvas) {
                    resolve(getBlobFromCanvas(canvas));
                }, reject).catch(function (err) {
                    reject(err);
                });
            });
        },
    
        createScreenshotCanvas: function () {
        
            return new Promise(function (resolve, reject) {
    
                return getDisplayMedia({
                    audio: false,
                    video: {
                        width: screen.width,
                        height: screen.height,
                        frameRate: 1
                    }
                }).then(function success(stream) {
    
                    const video = document.createElement('video');
    
                    video.onloadedmetadata = function () {
                        video.play();
                        video.pause();
    
                        ScreenManager.video = {
                            width: video.videoWidth,
                            height: video.videoHeight
                        };
    
                        const canvas = document.createElement('canvas');
                        canvas.width = ScreenManager.video.width;
                        canvas.height = ScreenManager.video.height;
    
                        const context = canvas.getContext('2d');
                        context.drawImage(video, 0, 0, ScreenManager.video.width, ScreenManager.video.height);
                        resolve(canvas);
    
                        stream.getTracks().forEach(function (track) {
                            track.stop();
                        });
                    };
                    video.srcObject = stream;
    
                }, function fail(message) {
                    reject(message);
                }).catch(function (err) {
                    reject(err.message);
                    return err;
                });
            });
        },
        
        saveOnClient: function saveOnClient(blob, name) {
    
            return new Promise(function (resolve) {
                var a = document.createElement('a');
                a.download = name;
                a.rel = 'noopener';
                a.href = URL.createObjectURL(blob);

                window.setTimeout(function () {
                    URL.revokeObjectURL(a.href);
                    resolve();
                }, 0);
                a.dispatchEvent(new MouseEvent('click'));
            });
        }
        
    };

    function getDisplayMedia(options) {
        if (navigator.mediaDevices && navigator.mediaDevices.getDisplayMedia) {
            return navigator.mediaDevices.getDisplayMedia(options);
        }
        if (navigator.getDisplayMedia) {
            return navigator.getDisplayMedia(options);
        }
        throw new Error('getDisplayMedia is not defined');
    }

    function getBlobFromCanvas(canvas) {
        return new Promise(function (resolve) {
            canvas.toBlob(function (blob) { 
                resolve(blob); 
            }, 'image/png');
        });
    }

    return ScreenManager;
});
