define(['brease/events/EventDispatcher'], function (EventDispatcher) {

    'use strict';

    var InputElements = function () {
        this.elements = [];
        this.valueChangedListener = this.valueChangedListener.bind(this);
    };

    InputElements.prototype = new EventDispatcher();

    InputElements.prototype.addElement = function (element) {
        if (this.elements.indexOf(element) === -1) {
            this.elements.push(element);
            if (typeof element.addEventListener === 'function') {
                element.addEventListener('ValueChanged', this.valueChangedListener); 
            } 
        }
    };

    InputElements.prototype.valueChangedListener = function (e) {
        var value = (e && e.detail) ? e.detail.value : undefined;
        /**
        * @event ValueChanged
        * @param {Object} detail  
        * @param {Number} detail.value  
        * @param {String} type 'ValueChanged'
        */
        this.dispatchEvent({ type: 'ValueChanged', 
            detail: {
                'value': value
            } 
        }); 
    };

    return InputElements;
});
