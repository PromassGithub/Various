define(function (require) {
    'use strict';

    var dictionaries = new Map();

    function _load(mode) {
        return new Promise(function (resolve) {
            var _mode = mode.replace('-', '_');
            require(['system/widgets/KeyBoard/libs/external/dict_' + _mode, 'system/widgets/KeyBoard/libs/external/cdict_' + _mode], function (dict, cdict) {
                if (_hasCustomDictionaries()) {
                    cdict.load().then(function (entries) {
                        dictionaries.set(mode, Array.isArray(entries) ? entries.concat(dict) : dict);
                        resolve();
                    });
                } else {
                    dictionaries.set(mode, dict);
                    resolve();
                }
            });
        });
    }
    function _hasCustomDictionaries() {
        return brease.config.virtualKeyboards && brease.config.virtualKeyboards.CustomDictionaries;
    }
    return {
        get: function (value) {
            return dictionaries.get(value);
        },
        has: function (value) {
            return dictionaries.has(value);
        },
        load: function (mode) {
            return new Promise(function (resolve) {
                if (mode !== 'disabled') {
                    _load(mode).then(resolve);
                } else {
                    resolve();
                }
            });
            
        },
        MAX_FREQUENCY: 400,
        MIN_FREQUENCY: 0
    };
});
