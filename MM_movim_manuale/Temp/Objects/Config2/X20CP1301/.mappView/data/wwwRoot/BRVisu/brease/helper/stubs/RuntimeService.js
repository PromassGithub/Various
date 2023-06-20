define(['brease/events/EventDispatcher',
    'brease/events/SocketEvent',
    'brease/controller/objects/VisuStatus', 
    'brease/services/libs/ServerCode',
    'brease/core/Utils'], 
function (EventDispatcher, SocketEvent, VisuStatus, ServerCode, Utils) {

    'use strict';

    var data = { 
            activateVisuSuccessResponseCode: 0,
            activateVisuFailResponseCode: ServerCode.NO_LICENSE,
            visusWithoutLicense: ['visuwithoutlicense'],
            timeout: {
                activateContentResponse: 50,
                activateContentEvent: 100 
            }
        },
        RuntimeServiceStub = function RuntimeServiceStub(testData, subscriptions, eventSubscriptions) {
            this.testData = {};
            for (var key in testData) {
                this.testData[key.toLowerCase()] = testData[key];
            }
            this.subscriptions = (subscriptions) || {};
            this.eventSubscriptions = (eventSubscriptions) || {};
            this.data = Utils.deepCopy(data);
            this.isStub = true;
        };

    RuntimeServiceStub.prototype = new EventDispatcher();
    RuntimeServiceStub.prototype.constructor = RuntimeServiceStub;
    
    var p = RuntimeServiceStub.prototype;

    p.setData = function (key, value, type) {
        if (type === 'timeout') {
            data.timeout[key] = value;
        } else {
            data[key] = value;
        }
    };

    p.resetData = function (key, value, type) {
        this.data = Utils.deepCopy(data);
    };

    p.loadVisuData = function (visuId, callback, callbackInfo) {
        visuId = visuId.toLowerCase();
        if (typeof callback === 'function') {
            if (this.testData && this.testData[visuId]) {
                callback({ success: true, visuData: this.testData[visuId] }, callbackInfo);
            } else {
                if (visuId === 'malformedvisu') {
                    callback({ success: false, status: 'parsererror' }, callbackInfo);
                } else {
                    callback({ success: false, status: VisuStatus.NOT_FOUND }, callbackInfo);
                }
            }
        }
    };

    p.activateVisu = function (visuId, callback, callbackInfo) {
        console.warn('activateVisu:' + visuId);
        if (data.visusWithoutLicense.indexOf(visuId.toLowerCase()) !== -1) {
            window.setTimeout(activateFailResponse.bind(this, callback, callbackInfo), 50);
        } else {
            window.setTimeout(activateResponse.bind(this, callback, callbackInfo), 50);
            window.setTimeout(activateEvent.bind(this, {
                visuId: visuId.toLowerCase()
            }, SocketEvent.VISU_ACTIVATED), 150);
        }
    };

    p.activateContent = function (contentId, visuId, callback, callbackInfo) {
        console.log('activateContent:' + contentId + ',visuId=' + visuId);

        window.setTimeout(activateResponse.bind(this, callback, callbackInfo), data.timeout.activateContentResponse);
        window.setTimeout(activateEvent.bind(this, {
            visuId: visuId.toLowerCase(),
            contentId: contentId
        }, SocketEvent.CONTENT_ACTIVATED), data.timeout.activateContentEvent);
    };

    p.deactivateContent = function (contentId, visuId, callback, callbackInfo) {
        console.log('deactivateContent:' + contentId + ',visuId=' + visuId);
        window.setTimeout(activateResponse.bind(this, callback, callbackInfo), 50);
        window.setTimeout(activateEvent.bind(this, {
            visuId: visuId.toLowerCase(),
            contentId: contentId
        }, SocketEvent.CONTENT_DEACTIVATED), 100);
    };

    p.deactivateVisu = function (visuId) {
        console.log('deactivateVisu:' + visuId);
    };

    p.getSessionEventSubscription = function () {
        return { success: true, eventSubscriptions: [] };
    };

    p.getEventSubscription = function (contentId, visuId, callback, callbackInfo) {
        callback({ 'status': { 'code': 0, 'message': '' }, 'success': true, 'eventSubscriptions': this.eventSubscriptions[contentId] }, callbackInfo);
    };

    p.getSubscription = function (contentId, visuId, callback, callbackInfo) {
        callback({ 'status': { 'code': 0, 'message': '' }, 'success': true, 'subscriptions': this.subscriptions[contentId] }, callbackInfo);
    };

    p.setClientInformation = function (data) {
        console.log('%csetClientInformation:' + data, 'color:#cc00cc;');
    };

    p.sendUpdate = function (data) {
        console.info('%csendUpdate:' + JSON.stringify(data), 'color:darkgreen');
    };

    p.sendEvent = function (data) {
        console.log('sendEvent:', JSON.stringify(data));
    };

    p.opcuaReadNodeHistory = function () {
        console.log('opcuaReadNodeHistory:', JSON.stringify(arguments));
    };

    p.opcuaReadHistoryCount = function () {
        console.log('opcuaReadHistoryCount:', JSON.stringify(arguments));
    };

    p.opcuaReadHistoryStart = function () {
        console.log('opcuaReadHistoryStart:', JSON.stringify(arguments));
    };

    p.opcuaReadHistoryEnd = function () {
        console.log('opcuaReadHistoryEnd:', JSON.stringify(arguments));
    };

    p.opcuaBrowse = function () {
        console.log('opcuaBrowse:', JSON.stringify(arguments));
    };

    p.opcuaCallMethod = function () {
        console.log('opcuaCallMethod:', JSON.stringify(arguments));
    };

    p.opcuaRead = function () {
        console.log('opcuaRead:', JSON.stringify(arguments));
    };

    p.triggerServerAction = function (action, target, aId, args) {
        var type = 'action';
        this.dispatchEvent({
            'event': type,
            'detail': {
                'action': action,
                'target': target,
                'actionArgs': args || {},
                'actionId': aId
            }
        }, type);
    };

    p.actionResponse = function () {};

    p.initLangModule = function (langModule) {
        var self = this;
        this.langModule = langModule;

        this.loadLanguages = function (callback) {
            callback({
                'current_language': self.langModule.current_language,
                'languages': self.langModule.languages,
                success: self.langModule.loadSuccess
            });
        };
        this.loadTexts = function (langKey, callback, callbackInfo) {
            callback(self.langModule.text[langKey], callbackInfo);
        };
        this.loadSystemTexts = function (langKey, callback, callbackInfo) {
            callback(self.langModule.text[langKey], callbackInfo);
        };
        this.getUnitSymbols = function (langKey, arKeys, callback, callbackInfo) {
            var result = {};
            for (var i = 0; i < arKeys.length; i += 1) {
                if (self.langModule.unitSymbols[langKey][arKeys[i]] !== undefined) {
                    result[arKeys[i]] = self.langModule.unitSymbols[langKey][arKeys[i]];
                }
            }
            window.setTimeout(function () {
                callback({ unitSymbols: result }, callbackInfo);
            }, 10);
        };
        this.switchLanguage = function (langKey, callback, callbackInfo) {
            if (self.langModule.switchSuccess) {
                self.langModule.current_language = langKey;
            }
            callback({ success: self.langModule.switchSuccess }, callbackInfo);
        };
    };

    function activateResponse(callback, callbackInfo) {
        callback({ status: { code: 0 }, success: true }, callbackInfo);
    }

    function activateFailResponse(callback, callbackInfo) {
        callback({ status: { code: data.activateVisuFailResponseCode }, success: true }, callbackInfo);
    }

    function activateEvent(detail, type) {
        this.dispatchEvent({
            event: type,
            detail: detail
        }, type);
    }

    return RuntimeServiceStub;

});
