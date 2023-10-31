define([
    'brease/core/Class'
], function (
    SuperClass
) {

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

                update: function (newBox, _direction) {

                    self.widget.settings.height = newBox.height;
                    self.widget.settings.width = newBox.width;
                    self.widget.settings.top = newBox.top;
                    self.widget.settings.left = newBox.left;

                    _redrawWidget(self);
                },
                finish: function () {
                    var returnBox = {
                        top: self.widget.settings.top,
                        left: self.widget.settings.left,
                        height: self.widget.settings.height,
                        width: self.widget.settings.width
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

    function _redrawWidget(self) {
        self.widget.el.css('top', parseInt(self.widget.settings.top, 10));
        self.widget.el.css('left', parseInt(self.widget.settings.left, 10));
        self.widget.el.css('height', self.widget.settings.height);
        self.widget.el.css('width', self.widget.settings.width);
        if (self.widget.settings.tableItemIds.length > 0) {
            self.widget.renderer.updateEditor();
        }
    }

    return ModuleClass;
});
