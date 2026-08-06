define(function () {

    'use strict';

    /**
    * @class brease.objects.WidgetObject
    * @alternateClassName WidgetObject
    * @extends Object
    */
    /**
    * @method constructor
    * Creates a new WidgetObject instance.
    * @param {Object} data
    * @param {String} data.id
    * @param {ContentReference} data.contentId
    * @param {brease.enum.WidgetState} data.state
    * @param {brease.enum.WidgetState} data.suspendedState
    * @param {brease.objects.WidgetInstance} data.widget
    * @param {Object} data.options
    */
    /**
    * @property {String} id
    */
    /**
    * @property {ContentReference} contentId
    */
    /**
    * @property {brease.enum.WidgetState} state
    */
    /**
    * @property {brease.enum.WidgetState} suspendedState
    */
    /**
    * @property {brease.objects.WidgetInstance} widget
    */
    /**
    * @property {Object} options
    */
    var WidgetObject = function (data) {
        var self = this;
        ['id', 'contentId', 'state', 'suspendedState', 'widget', 'options'].forEach(function (key) {
            if (data[key] !== undefined) {
                self[key] = data[key]; 
            }
        });
    };
    
    WidgetObject.prototype.toJSON = function () {
        var info = {},
            self = this;
        ['id', 'contentId', 'state', 'suspendedState', 'options'].forEach(function (key) {
            if (self[key] !== undefined) {
                info[key] = self[key]; 
            }
        });
        info.widget = (this.widget) ? '[object widget]' : ((this.widget === null) ? 'null' : 'undefined');
        return info;
    };
    
    return WidgetObject;

});
