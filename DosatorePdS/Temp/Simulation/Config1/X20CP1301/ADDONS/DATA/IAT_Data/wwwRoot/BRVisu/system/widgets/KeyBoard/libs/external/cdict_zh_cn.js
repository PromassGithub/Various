define(function () {
    'use strict';

    var dictionary,
        defaultPath = 'assets/dict/cdict_zh_cn.json',
        pending,
        _path = '';
    _path = defaultPath;
    return {
        setPath: function (path) {
            _path = path;
        },
        load: function () {
            if (pending) { 
                pending();
                pending = undefined;
            }
            return new Promise(function (resolve) {
                pending = resolve;
                if (dictionary) {
                    resolve(dictionary);
                } else {
                    $.ajax(_path, { method: 'GET' }).then(function (cdict) {
                        resolve(Array.isArray(cdict) ? cdict : []);
                    });
                }
            }).then(function (cdict) {
                dictionary = cdict;
                return dictionary;
            });
        },
        reset: function () {
            dictionary = undefined;
            _path = defaultPath;
        }
    };
});
