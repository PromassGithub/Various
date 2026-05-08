define(['brease/core/Class'
], function (SuperClass) {

    'use strict';

    var ModuleClass = SuperClass.extend(function EditorHandles(widget) {
            SuperClass.call(this);
                        
            this.widget = widget;
            this.oldSettings = {
                top: this.widget.settings.top,
                left: this.widget.settings.left,
                width: this.widget.settings.width,
                height: this.widget.settings.height
            };

        }, null),

        p = ModuleClass.prototype;

    p.getHandles = function () {

        var self = this;
        return {
            moveHandles: undefined, /* use default*/
            pointHandles: [],
            resizeHandles: [{

                start: function () {
                    _retainSettings(self);
                },

                update: function (newBox, direction) {

                    var updatedBox = {
                        size: newBox.width,
                        top: newBox.top,
                        left: newBox.left
                    };

                    switch (direction) {

                        case 'n':
                        case 's':

                            updatedBox.size = newBox.height;
                            updatedBox.top = newBox.top;
                            updatedBox.left = newBox.left + (self.oldSettings.height - updatedBox.size) / 2;
                            break;

                        case 'w':
                        case 'e':

                            updatedBox.size = newBox.width;
                            updatedBox.top = newBox.top + (self.oldSettings.width - updatedBox.size) / 2;
                            updatedBox.left = newBox.left;
                            break;

                        case 'nw':

                            updatedBox.size = Math.max(newBox.width, newBox.height);
                            updatedBox.top = newBox.top + newBox.height - updatedBox.size;
                            updatedBox.left = newBox.left + newBox.width - updatedBox.size;
                            break;

                        case 'ne':

                            updatedBox.size = Math.max(newBox.width, newBox.height);
                            updatedBox.top = newBox.top + newBox.height - updatedBox.size;
                            updatedBox.left = newBox.left;

                            break;

                        case 'sw':

                            updatedBox.size = Math.max(newBox.width, newBox.height);
                            updatedBox.top = newBox.top;
                            updatedBox.left = newBox.left + newBox.width - updatedBox.size;
                            break;

                        case 'se':

                            updatedBox.size = Math.max(newBox.width, newBox.height);
                            updatedBox.top = newBox.top;
                            updatedBox.left = newBox.left;
                            break;

                        default:
                            console.iatWarn('Direction ' + direction + ' not valid');
                    }
                    self.widget.settings.top = updatedBox.top;
                    self.widget.settings.left = updatedBox.left;
                    self.widget.settings.width = updatedBox.size;
                    self.widget.settings.height = updatedBox.size;

                    _redrawWidget(self);
                },

                finish: function () {

                    _redrawWidget(self);
                    return _compareSettings(self);
                },

                handle: function () {
                    return self.widget.renderer.backgroundShape;
                }
            }]
        };
    };

    p.getSelectionDecoratables = function () {
        return [this.widget.renderer.backgroundShape];
    };

    // private functions
    function _redrawWidget(self) {

        self.widget.el.css('top', parseInt(self.widget.settings.top, 10))
            .css('left', parseInt(self.widget.settings.left, 10));

        self.widget.renderer.redraw();
    }

    function _retainSettings(self) {

        self.oldSettings.top = parseInt(self.widget.settings.top, 10);
        self.oldSettings.left = parseInt(self.widget.settings.left, 10);
        self.oldSettings.width = parseInt(self.widget.settings.width, 10);
        self.oldSettings.height = parseInt(self.widget.settings.height, 10);
    }

    function _compareSettings(self) {

        var returnValue = {};

        if (self.widget.settings.top !== self.oldSettings.top) {
            returnValue.top = self.widget.settings.top;
        }
        if (self.widget.settings.left !== self.oldSettings.left) {
            returnValue.left = self.widget.settings.left;
        }
        if ((self.widget.settings.width !== self.oldSettings.width) || (self.widget.settings.height !== self.oldSettings.height)) {
            returnValue.height = self.widget.settings.height;
            returnValue.width = self.widget.settings.width;
        }

        return returnValue;
    }

    return ModuleClass;

});
