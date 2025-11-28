define([
    'brease/core/Class'
], function (SuperClass) {

    'use strict';

    var ModuleClass = SuperClass.extend(function EditorHandles(widget) {
            SuperClass.call(this);
            this.widget = widget;
        }, null),

        p = ModuleClass.prototype;

    p.getHandles = function () {

        var self = this;
        return {
            moveHandles: [],
            pointHandles: [],
            resizeHandles: [{
                start: function () {
                },
                update: function (newBox, direction) {
                    switch (direction) {
                        case 'n':
                            if (self.widget.editorGrid.configuration.axisPosition === 'bottom') {
                                self.widget.settings.height = newBox.height;
                                self.widget.el.css('flex-basis', self.widget.settings.height);
                                self.widget.el.css('height', self.widget.settings.height);
                                self.widget.editorGrid.parentWidget.editorGrid.updateAllChildren();
                            }
                            break;

                        case 's':
                            if (self.widget.editorGrid.configuration.axisPosition === 'top') {
                                self.widget.settings.height = newBox.height;
                                self.widget.el.css('flex-basis', self.widget.settings.height);
                                self.widget.el.css('height', self.widget.settings.height);
                                self.widget.editorGrid.configuration.offsetY = self.widget.settings.height - 2;
                                self.widget.editorGrid.parentWidget.editorGrid.updateAllChildren();
                            }
                            break;

                        default:
                            console.iatWarn('Direction ' + direction + ' not valid');
                    }
                },
                finish: function () {
                    var returnBox = { height: self.widget.settings.height };
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
