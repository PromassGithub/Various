define([], function () {

    'use strict';

    var GenericUnitTestMatchers = {};

    GenericUnitTestMatchers.compareJQUERYObject = function (expected) {
        var identicalClass = false,
            identicalID = false,
            identicalTag = false;

        if (this.actual.attr('class') === expected.attr('class')) {
            identicalClass = true;
        }
        if (this.actual.attr('id') === expected.attr('id')) {
            identicalID = true;
        }
        if (this.actual[0].tagName === expected[0].tagName) {
            identicalTag = true;
        }
    
        if (identicalClass && identicalID && identicalTag) {
            return true;
        } else {
            return false;
        }
    };

    GenericUnitTestMatchers.compareHTMLNode = function (expected) {
        var identicalHTML = false;
        if (this.actual.outerHTML === expected) {
            identicalHTML = true;
        }
        return identicalHTML;
    };

    GenericUnitTestMatchers.isFunction = function () {
        var isFunction = false;
        if (typeof this.actual === 'function') {
            isFunction = true;
        }
        return isFunction;
    };
    
    return GenericUnitTestMatchers;
});
