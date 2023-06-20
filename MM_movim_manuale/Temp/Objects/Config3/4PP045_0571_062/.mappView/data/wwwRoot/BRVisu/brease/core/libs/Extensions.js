define(function () {

    'use strict';

    var Extensions = {
        bak: {
            log: window.console.log,
            info: window.console.info,
            warn: window.console.warn,
            debug: window.console.debug
        },
        console: {
            initStorageLog: function (storageLog) {
                if (storageLog === true) {
                    console.log = function () {
                        try {
                            throw new Error('LogError');
                        } catch (e) {
                            var stack = e.stack.split('\n'),
                                file = stack[2].substring(stack[2].lastIndexOf('/') + 1),
                                track = file.split(':');
                            _logToStorage('log', Date.now(), arguments[0], track[0], track[1], arguments[1]);
                        }
                    };
                    console.debug = function () {

                        try {
                            throw new Error('LogError');
                        } catch (e) {
                            var stack = e.stack.split('\n'),
                                file = stack[2].substring(stack[2].lastIndexOf('/') + 1),
                                track = file.split(':');
                            _logToStorage('debug', Date.now(), arguments[0], track[0], track[1], '#0000ff');
                        }
                    };
                    console.warn = function () {

                        try {
                            throw new Error('LogError');
                        } catch (e) {
                            var stack = e.stack.split('\n'),
                                file = stack[2].substring(stack[2].lastIndexOf('/') + 1),
                                track = file.split(':');
                            _logToStorage('warn', Date.now(), arguments[0], track[0], track[1], '#000', '#fffbe6');
                        }
                    };
                } else {
                    Extensions.console.reset();
                }
            },
            reset: function () {
                console.warn = Extensions.bak.warn;
                console.info = Extensions.bak.info;
                console.log = Extensions.bak.log;
                console.debug = Extensions.bak.debug;
            },
            init: function (config) {
                
                console.always = function () {
                    console.log.apply(console, arguments);
                };
                console.alwaysWarn = function () {
                    console.warn.apply(console, arguments);
                };
                console.color = function (msg, color) {
                    console.log('%c' + msg, 'color:' + color + ';');
                };
                    
                if (config.warn === true) {
                    console.iatWarn = console.warn;
                    console.iatInfo = console.info;
                } else {
                    console.iatWarn = function () { };
                    console.iatInfo = function () { };
                }
                if (config.debug === true) {
                    console.iatDebug = console.debug;
                    console.iatDebugLog = console.log;
                } else {
                    console.iatDebug = function () { };
                    console.iatDebugLog = function () { };
                }
            }
        }
    };

    var _first = true;

    function _logToStorage() {
        var logData = localStorage.getItem('log');
        logData = (_first) ? _logEntry.apply(null, arguments) : logData + '|#|' + _logEntry.apply(null, arguments);
        _first = false;
        localStorage.setItem('log', logData);
    }

    function _logEntry(type, time, message, file, line, color, backColor) {
        message = message || '';
        var obj = {
            type: type,
            time: time,
            message: (message.indexOf('%c') === 0) ? message.substring(2) : message,
            file: file,
            line: line,
            color: (color) ? _color(color) : '#000',
            backColor: (backColor) || 'transparent'
        };
        return JSON.stringify(obj);
    }
    function _color(color) {
        if (color.indexOf && color.indexOf('color:') !== -1) { 
            color = color.substring(color.indexOf(':') + 1);
            if (color.indexOf(';') === color.length - 1) { 
                color = color.substring(0, color.length - 1);
            }
            return color;
        } else { 
            return color; 
        }
    }
    
    // Extensions for jquery

    $.fn.showByFlag = function (flag) {
        if (flag !== 0) {
            return this.show();
        } else {
            return this.hide();
        }
    };

    $.containsOrEquals = function (container, contained) {
        return container === contained || $.contains(container, contained);
    };

    return Extensions;
});
