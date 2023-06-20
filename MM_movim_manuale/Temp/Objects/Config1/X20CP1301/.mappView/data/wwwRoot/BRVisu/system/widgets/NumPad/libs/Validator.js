define(['brease/events/EventDispatcher'], function (EventDispatcher) {

    'use strict';

    var Validator = function () {
        this.valid = true;      
        this.settings = {};
    };

    Validator.prototype = new EventDispatcher();
    
    Validator.prototype.setConfig = function (minValue, maxValue) {
        this.settings.minValue = minValue;
        this.settings.maxValue = maxValue;
    };
    
    Validator.prototype.changeListener = function (e) {
        this.check(e.detail.value);
    };

    Validator.prototype.check = function (value) {
        if (value < this.settings.minValue) {
            this.valid = false;
        } else if (value > this.settings.maxValue) {
            this.valid = false;
        } else {
            this.valid = true;
        }
        
        /**
        * @event Validation
        * @param {Object} detail  
        * @param {Boolean} detail.valid  
        * @param {String} type 'Validation'
        */
        this.dispatchEvent({ type: 'Validation', 
            detail: {
                'valid': this.valid
            } });
    };

    return Validator;
});
