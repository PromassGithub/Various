define(['brease/core/Utils'], function (Utils) {

    'use strict';

    /**
    * @class brease.objects.Page
    * @alternateClassName Page
    * @extends Object
    *
    * @constructor
    * Creates a new Page instance.
    * @param {String} id
    * @param {String} type
    */
    /**
    * @property {String} id
    */
    /**
    * @property {String} type
    */
    var Page = function (id, type, visuId, data) {
        for (var key in data) {
            if (key !== 'assignments') {
                this[key] = data[key];
            }
        }
        this.id = id;
        this.visuId = visuId;
        this.type = type;
        
        this.assignments = Utils.arrayToObject(data.assignments, 'areaId');

    };

    return Page;

});
