define([], function () {
    'use strict';
    function DialogWidgetModel() {
        this.name = 'widget';
        this.id = '';
        this.type = '';
        this.width = 'auto';
        this.height = 'auto';
        this.x = 0;
        this.y = 0;
        this.options = {};
    }
    
    return DialogWidgetModel;
});
