define(['brease/helper/XHRPool'], function (XHRPool) {

    'use strict';

    var _baseUrl = window.location.protocol + '//' + window.location.hostname + ':' + window.location.port + '/services/',
        _clientService = _baseUrl + 'client/',
        _baseService = _baseUrl + 'server/';

    function _requestData(data, parameter) {
        var obj = { Data: data };
        if (parameter) {
            obj.Parameter = parameter;
        }
        return JSON.stringify(obj);
    }

    return {

        /************************
        *** BINDING related ****
        ************************/
        activateVisu: function (visuId, callback, callbackInfo) {
            if (visuId !== undefined) {
                var request = XHRPool.getXHR(callbackInfo);
                request.open('GET', _clientService + 'activateVisu?visuId=' + visuId);
                request.send(null, callback);
            } else {
                console.iatWarn('undefined visuId in method activateVisu');
            }
        },

        deactivateVisu: function (visuId, callback, callbackInfo) {
            if (visuId !== undefined) {
                var request = XHRPool.getXHR(callbackInfo);
                request.open('GET', _clientService + 'deactivateVisu?visuId=' + visuId);
                request.send(null, callback);
            } else {
                console.iatWarn('undefined visuId in method deactivateVisu');
            }
        },

        getSubscription: function (contentId, visuId, callback, callbackInfo) {
            if (contentId !== undefined) {
                var request = XHRPool.getXHR(callbackInfo);
                request.open('GET', _clientService + 'getSubscription?contentId=' + contentId + '&visuId=' + visuId);
                request.send(null, callback);
            } else {
                console.iatWarn('undefined contentId in method getSubscription');
            }
        },

        loadConfiguration: function (callback, callbackInfo) {
            var request = XHRPool.getXHR(callbackInfo);
            request.open('GET', _baseService + 'getConfiguration');
            request.send(null, callback);
        },

        loadVisuData: function (visuId, callback, callbackInfo) {
            $.getJSON('/' + visuId + '.json', function (data) {
                callback({
                    success: true,
                    visuData: data
                }, callbackInfo);
            }).fail(function (jqxhr, textStatus, error) {
                console.log('error:' + JSON.stringify({ status: textStatus, errorMessage: error.toString() }));
                callback({ success: false, status: textStatus }, callbackInfo);
            });
        },

        createBindings: function (contentId, visuId, bindings, callback, callbackInfo) {
            var request = XHRPool.getXHR(callbackInfo);
            request.open('POST', _clientService + 'createBindings');
            request.send(JSON.stringify({
                'Parameter': {
                    'visuId': visuId,
                    'contentId': contentId
                },
                'Data': bindings
            }), callback);
        },

        deleteBindings: function (contentId, visuId, targets, callback, callbackInfo) {
            var request = XHRPool.getXHR(callbackInfo);
            request.open('POST', _clientService + 'deleteBindings');
            request.send(JSON.stringify({
                'Parameter': {
                    'visuId': visuId,
                    'contentId': contentId
                },
                'Data': targets
            }), callback);
        },

        getBindingSourceProperties: function (contentId, visuId, widgetId, widgetAttribute, nodeAttribute, callback, callbackInfo) {
            var request = XHRPool.getXHR(callbackInfo);
            request.open('POST', _clientService + 'getProperties');
            request.send(JSON.stringify({
                'Parameter': {
                    'visuId': visuId,
                    'contentId': contentId
                },
                'Data': [{
                    'type': 'brease',
                    'refId': widgetId,
                    'attribute': widgetAttribute,
                    'property': nodeAttribute
                }] }), callback);
        },

        /*#######################
        ### Action Event related ###
        #######################*/

        getEventSubscription: function (contentId, visuId, callback, callbackInfo) {
            if (contentId !== undefined) {
                var request = XHRPool.getXHR(callbackInfo);
                request.open('GET', _clientService + 'getEventSubscription?contentId=' + contentId + '&visuId=' + visuId);
                request.send(null, callback);
            } else {
                console.iatWarn('undefined contentId in method getEventSubscription');
            }
        },

        getSessionEventSubscription: function (callback, callbackInfo) {
            var request = XHRPool.getXHR(callbackInfo);
            request.open('GET', _clientService + 'getSessionEventSubscription');
            request.send(null, callback);

        },

        /********************
        *** TEXT related ****
        *********************/
        loadLanguages: function (callback) {
            var request = XHRPool.getXHR();
            request.open('GET', _clientService + 'getLanguages');
            request.send(null, callback);
        },

        switchLanguage: function (langKey, callback, callbackInfo) {
            if (langKey !== undefined) {
                var request = XHRPool.getXHR(callbackInfo);
                request.open('GET', _clientService + 'switchLanguage?language=' + langKey);
                request.send(null, callback);
            } else {
                console.iatWarn('undefined language key in method switchLanguage');
            }
        },

        loadTexts: function (langKey, callback, callbackInfo) {
            if (langKey !== undefined) {
                var request = XHRPool.getXHR(callbackInfo);
                request.open('GET', _clientService + 'getText?language=' + langKey);
                request.send(null, callback);
            } else {
                console.iatWarn('undefined language key in method loadTexts');
            }
        },

        loadSystemTexts: function (langKey, callback, callbackInfo) {
            if (langKey !== undefined) {
                var request = XHRPool.getXHR(callbackInfo);
                request.open('GET', _clientService + 'getSystemTexts?language=' + langKey);
                request.send(null, callback);
            } else {
                console.iatWarn('undefined language key in method loadSystemTexts');
            }
        },

        getAllUnitSymbols: function (langKey, callback, callbackInfo) {
            if (langKey !== undefined) {
                var request = XHRPool.getXHR(callbackInfo);
                request.open('GET', _clientService + 'getAllUnitSymbols?language=' + langKey);
                request.send(null, callback);
            } else {
                console.iatWarn('undefined language key in method getAllUnitSymbols');
            }
        },

        getUnitSymbols: function (langKey, arrCode, callback, callbackInfo) {
            if (langKey !== undefined) {

                var request = XHRPool.getXHR(callbackInfo);
                request.open('POST', _clientService + 'getUnitSymbols');
                request.send(JSON.stringify({
                    Data: {
                        'language': langKey,
                        'commonCodes': arrCode
                    }
                }), callback);
            } else {
                console.iatWarn('undefined language key in method getUnitSymbols');
            }
        },

        /***********************
        *** CULTURE related ***
        ***********************/
        loadCultures: function (callback) {
            var request = XHRPool.getXHR();
            request.open('GET', _clientService + 'loadCultures');
            request.send(null, callback);
        },

        switchCulture: function (key, callback) {
            if (key !== undefined) {
                var request = XHRPool.getXHR();
                request.open('GET', _clientService + 'switchCulture?culture=' + key);
                request.send(null, callback);
            } else {
                console.iatWarn('undefined culture key in method getUnitSymbols');
            }
        },

        /***********************
        *** MeasurementSystem related ***
        ***********************/
        loadMeasurementSystemList: function (callback) {
            var request = XHRPool.getXHR();
            request.open('GET', _clientService + 'getMeasurementSystemList');
            request.send(null, callback);
        },

        switchMeasurementSystem: function (key, callback, callbackInfo) {
            if (key !== undefined) {
                var request = XHRPool.getXHR(callbackInfo);
                request.open('GET', _clientService + 'setMeasurementSystem?measurementSystem=' + key);
                request.send(null, callback);
            } else {
                console.iatWarn('undefined MeasurementSystem key in method switchMeasurementSystem');
            }
        },

        /***********************
        *** EVENTLOGGING related ***
        ***********************/
        logEvents: function (data, callback) {
            var request = XHRPool.getXHR();
            request.open('POST', _baseService + 'sendEventLog');
            request.send(JSON.stringify({
                Data: data
            }), callback);
        },

        /***********************
        *** USER related ***
        ***********************/

        loadCurrentUser: function (callback) {
            var request = XHRPool.getXHR();
            request.open('GET', _clientService + 'getCurrentUser');
            request.send(null, callback);
        },

        setDefaultUser: function (callback) {
            var request = XHRPool.getXHR();
            request.open('GET', _clientService + 'setDefaultUser');
            request.send(null, callback);
        },

        loadUserRoles: function (callback, callbackInfo) {
            var request = XHRPool.getXHR(callbackInfo);
            request.open('GET', _clientService + 'getUserRoles');
            request.send(null, callback);
        },

        authenticateUser: function (username, password, callback) {
            var request = XHRPool.getXHR();
            request.open('POST', _clientService + 'authenticate');
            request.send(JSON.stringify({
                Data: {
                    'userID': username,
                    'password': password
                }
            }), callback);
        },

        setCurrentUser: function (user, callback) {
            var request = XHRPool.getXHR();
            request.open('POST', _clientService + 'setCurrentUser');
            request.send(JSON.stringify({
                Data: {
                    'user': user
                }
            }), callback);
        },

        userHasRoles: function (roles, callback) {
            var request = XHRPool.getXHR();
            request.open('POST', _clientService + 'userHasRoles');
            request.send(JSON.stringify({
                Data: {
                    'roles': roles
                }
            }), callback);
        },

        /*####################
        ### TextFormatter ###
        #####################*/

        formatText: function (text, args, callback) {
            var request = XHRPool.getXHR(),
                data = {
                    formatstring: text,
                    args: args
                };
            request.open('POST', _clientService + 'format');
            request.send(JSON.stringify({
                Data: data
            }), callback);
        },

        /*#######################
        ### CLIENTINFO ###
        #######################*/

        /**
        * @method setClientInformation
        * @param {String} data stringified info object
        */
        setClientInformation: function (data) {
            var request = XHRPool.getXHR();
            request.open('POST', _clientService + 'setClientInformation');
            request.send('{"Data":' + data + '}');
        },

        registerClient: function (visuId, callback) {
            var request = XHRPool.getXHR();
            request.open('GET', _clientService + 'registerclient' + ((visuId !== undefined) ? '?visuId=' + visuId : ''));
            request.send(null, callback);
        },

        /*#######################
        ### OPC UA ###
        #######################*/

        opcuaReadNodeHistory: function (data, parameter, callback, callbackInfo) {
            var request = XHRPool.getXHR(callbackInfo);
            request.open('POST', _clientService + 'opcua/readHistory');
            request.send(_requestData(data, parameter), callback);
        },

        opcuaReadHistoryCount: function (data, parameter, callback, callbackInfo) {
            var request = XHRPool.getXHR(callbackInfo);
            request.open('POST', _clientService + 'opcua/readHistoryCount');
            request.send(_requestData(data, parameter), callback);
        },

        opcuaReadHistoryStart: function (data, parameter, callback, callbackInfo) {
            var request = XHRPool.getXHR(callbackInfo);
            request.open('POST', _clientService + 'opcua/readHistoryStart');
            request.send(_requestData(data, parameter), callback);
        },

        opcuaReadHistoryEnd: function (data, parameter, callback, callbackInfo) {
            var request = XHRPool.getXHR(callbackInfo);
            request.open('POST', _clientService + 'opcua/readHistoryEnd');
            request.send(_requestData(data, parameter), callback);
        },

        opcuaBrowse: function (data, parameter, callback, callbackInfo) {
            var request = XHRPool.getXHR(callbackInfo);
            request.open('POST', _clientService + 'opcua/browse');
            request.send(_requestData(data, parameter), callback);
        },

        opcuaCallMethod: function (data, parameter, callback, callbackInfo) {
            var request = XHRPool.getXHR(callbackInfo);
            request.open('POST', _clientService + 'opcua/callMethod');
            request.send(_requestData(data, parameter), callback);
        },

        opcuaRead: function (data, parameter, callback, callbackInfo) {
            var request = XHRPool.getXHR(callbackInfo);
            request.open('POST', _clientService + 'opcua/read');
            request.send(_requestData(data, parameter), callback);
        }
    };
});
