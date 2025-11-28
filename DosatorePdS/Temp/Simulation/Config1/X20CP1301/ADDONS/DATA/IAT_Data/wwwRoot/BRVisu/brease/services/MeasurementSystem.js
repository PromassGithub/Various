define(['brease/events/BreaseEvent',
    'brease/events/SocketEvent',
    'brease/core/Utils'], 
function (BreaseEvent, SocketEvent, Utils) {

    'use strict';

    /**
    * @class brease.services.MeasurementSystem
    * @extends core.javascript.Object
    * MeasurementSystem service; available via brease.measurementSystem 
    * 
    * @singleton
    */
    var MeasurementSystem = {

        init: function (runtimeService) {
            _runtimeService = runtimeService;
            _runtimeService.addEventListener(SocketEvent.MEASUREMENT_SYSTEM_CHANGED, _measurementSystemChangedByServerHandler);
            document.body.addEventListener(BreaseEvent.LANGUAGE_CHANGED, updateMeasurementSystems);
            return this;
        },

        isReady: function () {
            var deferred = $.Deferred();
            _runtimeService.loadMeasurementSystemList(_loadMeasurementSystemListResponseHandler, { deferred: deferred });
            return deferred.promise();
        },

        /**
        * @method getMeasurementSystems
        * Method to get all loaded Measurement-Systems
        * @return {Object}
        */
        getMeasurementSystems: function () {
            return Utils.deepCopy(_mms);
        },

        /**
        * @method getCurrentMeasurementSystem
        * Method to get current selected Measurement-System
        * @return {Object}
        */
        getCurrentMeasurementSystem: function () {

            return _currentMeasurementSystem;
        },

        /**
        * @method switchMeasurementSystem
        * Method to change current selected Measurement-System
        * @param {String} key Key of one available Measurement-System (e.g. 'metric')
        */
        switchMeasurementSystem: function (key) {
            var deferred = $.Deferred();
            if (_mms[key] === undefined) {
                console.iatWarn('Measurement-System \u00BB' + key + '\u00AB is not defined!');
                deferred.resolve({ success: false });

            } else if (_currentMeasurementSystem === key) {
                deferred.resolve({ success: true });

            } else {
                _runtimeService.switchMeasurementSystem(key, _switchMeasurementSystemResponseHandler, { newKey: key, deferred: deferred });
            }

            return deferred.promise();
        }
    };

    /*
    /* PRIVATE
    */

    var _mms = {},
        _currentMeasurementSystem = '',
        _runtimeService;

    function updateMeasurementSystems() {
        _runtimeService.loadMeasurementSystemList(_updateMeasurementSystemListResponseHandler);
    }

    function _finish(callbackInfo, success, message) {
        if (success === true) {
            if (callbackInfo && callbackInfo.deferred) {
                callbackInfo.deferred.resolve(message); 
            }
        } else {
            console.iatDebug(message);
            if (callbackInfo && callbackInfo.deferred) {
                callbackInfo.deferred.reject(message);
            } 
        }
    }

    function _loadMeasurementSystemListResponseHandler(response, callbackInfo) {

        if (_.isObject(response) && response.success === true) {
            _mms = response.measurementSystemList;
            _currentMeasurementSystem = response.current_measurementSystem;
            document.body.dispatchEvent(new CustomEvent(BreaseEvent.MEASUREMENT_SYSTEM_LOADED, { detail: { currentMeasurementSystem: _currentMeasurementSystem } }));
            _finish(callbackInfo, true);
        } else {
            _finish(callbackInfo, false, 'MeasurementSystems load error');
        }
    }

    function _updateMeasurementSystemListResponseHandler(response, callbackInfo) {
        
        if (_.isObject(response) && response.success === true) {
            _mms = response.measurementSystemList;
            _currentMeasurementSystem = response.current_measurementSystem;
            document.body.dispatchEvent(new CustomEvent(BreaseEvent.MEASUREMENT_SYSTEM_LOADED, { detail: { currentMeasurementSystem: _currentMeasurementSystem } }));
            _finish(callbackInfo, true);
        } else {
            _finish(callbackInfo, false, 'MeasurementSystems load error');
        }
    }

    function _switchMeasurementSystemResponseHandler(response, callbackInfo) {
        
        if (response.success === true) {
            _currentMeasurementSystem = callbackInfo.newKey;
            callbackInfo.deferred.resolve({ success: true });
        } else {
            console.iatWarn('service switchMeasurementSystem failed!');
            callbackInfo.deferred.resolve({ success: false });
        }
        document.body.dispatchEvent(new CustomEvent(BreaseEvent.MEASUREMENT_SYSTEM_CHANGED, { detail: { currentMeasurementSystem: _currentMeasurementSystem } }));
    }

    function _isValidMMSEvent(e) {
        return e && e.detail && e.detail.currentMeasurementSystem !== undefined;
    }
    
    function _measurementSystemChangedByServerHandler(serverEvent) {
        if (!_isValidMMSEvent(serverEvent)) {
            return;
        }
        _currentMeasurementSystem = serverEvent.detail.currentMeasurementSystem;
        document.body.dispatchEvent(new CustomEvent(BreaseEvent.MEASUREMENT_SYSTEM_CHANGED, { detail: { currentMeasurementSystem: _currentMeasurementSystem } })); 
    }

    return MeasurementSystem;

});
