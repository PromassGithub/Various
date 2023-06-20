define(function () {

    'use strict';

    return function MockedView() {

        this.update = function () {
            this.updated = true;
        };

        this.isUpdated = function () {
            return this.updated;
        };

        this.reset = function () {
            this.updated = false;
        };

    };

});
