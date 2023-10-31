define(['brease/events/BreaseEvent', 'brease/core/Utils'], function (BreaseEvent, Utils) {

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
            return this;
        },

        isReady: function () {
            _loadDeferred = $.Deferred();
            _load();
            return _loadDeferred.promise();
        },

        /**
        * @method getMeasurementSystems
        * Method to get all loaded Measurement-Systems
        * @return {Object}
        */
        getMeasurementSystems: function () {

            return Utils.deepCopy(_mms);
        },

        updateMeasurementSystems: function () {
            _updateDeferred = $.Deferred();
            if (_currentLanguage !== brease.language.getCurrentLanguage()) {
                _runtimeService.loadMeasurementSystemList(_updateMeasurementSystemListResponseHandler);
                _currentLanguage = brease.language.getCurrentLanguage();
            } else {
                _updateDeferred.reject('language is current');
            }

            return _updateDeferred.promise();

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
            //console.log('switchMeasurementSystem:', key);
            _switchDeferred = $.Deferred();
            if (_mms[key] === undefined) {
                console.iatWarn('Measurement-System \u00BB' + key + '\u00AB is not defined!');
                _switchDeferred.resolve({ success: false });

            } else if (_currentMeasurementSystem === key) {
                //console.iatInfo('Measurement-System \u00BB' + key + '\u00AB is current!');
                _switchDeferred.resolve({ success: true });

            } else {
                _runtimeService.switchMeasurementSystem(key, _switchMeasurementSystemResponseHandler, { newKey: key });

            }

            return _switchDeferred.promise();
        }
    };

    /*
    /* PRIVATE
    */

    var _mms = {},
        _currentMeasurementSystem = '',
        _currentLanguage,
        _switchDeferred,
        _loadDeferred,
        _updateDeferred,
        _runtimeService;

    function _finish(deferred, success, message) {

        if (success === true) {
            deferred.resolve(message);
        } else {
            deferred.reject(message);
        }
    }

    function _load() {

        _runtimeService.loadMeasurementSystemList(_loadMeasurementSystemListResponseHandler);
    }

    function _loadMeasurementSystemListResponseHandler(response) {

        if (_.isObject(response) && response.success === true) {
            //console.log('_loadMeasurementSystemListResponseHandler:', response);
            _mms = response.measurementSystemList;
            _currentMeasurementSystem = response.current_measurementSystem;
            document.body.dispatchEvent(new CustomEvent(BreaseEvent.MEASUREMENT_SYSTEM_LOADED, { detail: { currentMeasurementSystem: _currentMeasurementSystem } }));
            _finish(_loadDeferred, true);
        } else {
            _finish(_loadDeferred, false, 'MeasurementSystems load error');
        }
    }

    function _updateMeasurementSystemListResponseHandler(response) {

        if (_.isObject(response) && response.success === true) {
            //console.log('_updateMeasurementSystemListResponseHandler:', response);
            _mms = response.measurementSystemList;
            _currentMeasurementSystem = response.current_measurementSystem;
            document.body.dispatchEvent(new CustomEvent(BreaseEvent.MEASUREMENT_SYSTEM_LOADED, { detail: { currentMeasurementSystem: _currentMeasurementSystem } }));
            _finish(_updateDeferred, true);
        } else {
            _finish(_updateDeferred, false, 'MeasurementSystems load error');
        }
    }

    function _switchMeasurementSystemResponseHandler(response, callbackInfo) {
        //console.log('_switchMeasurementSystemResponseHandler:', callbackInfo);
        if (response.success === true) {
            _currentMeasurementSystem = callbackInfo.newKey;
            _switchDeferred.resolve({ success: true });
        } else {
            console.iatWarn('service switchMeasurementSystem failed!');
            _switchDeferred.resolve({ success: false });
        }
        document.body.dispatchEvent(new CustomEvent(BreaseEvent.MEASUREMENT_SYSTEM_CHANGED, { detail: { currentMeasurementSystem: _currentMeasurementSystem } }));
    }

    return MeasurementSystem;

});
