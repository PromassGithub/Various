define(['brease/core/Class'], function (SuperClass) {

    'use strict';

    var ModuleClass = SuperClass.extend(function EditorHandles(widget) {
            SuperClass.call(this);
            this.widget = widget;
        }, null),

        p = ModuleClass.prototype;

    p.getHandles = function () {

        var self = this;
        return {
            pointHandles: [],
            resizeHandles: [{
                start: function () {
                },
                update: function (newBox) {
                    self.widget.settings.height = newBox.height;
                    self.widget.settings.width = newBox.width;
                    self.widget.settings.top = newBox.top;
                    self.widget.settings.left = newBox.left;
                    self.widget.el.css({
                        'height': self.widget.settings.height,
                        'width': self.widget.settings.width,
                        'top': self.widget.settings.top,
                        'left': self.widget.settings.left
                    });
                    self.widget.textWheel._updateElements();
                },
                finish: function () {
                    var returnBox = {
                        height: self.widget.settings.height,
                        width: self.widget.settings.width,
                        top: self.widget.settings.top,
                        left: self.widget.settings.left
                    };
                    return returnBox;
                },
                handle: function () {
                    return self.widget.elem;
                }
            }]
        };
    };

    p.getSelectionDecoratables = function () {
        return [this.widget.elem];
    };

    return ModuleClass;

});
