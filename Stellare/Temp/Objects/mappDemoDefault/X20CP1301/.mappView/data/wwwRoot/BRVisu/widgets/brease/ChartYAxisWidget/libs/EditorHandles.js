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
                        case 'e':
                            if (self.widget.editorGrid.configuration.axisPosition === 'left') {
                                self.widget.settings.width = newBox.width;
                                self.widget.el.css('flex-basis', self.widget.settings.width);
                                self.widget.el.css('width', self.widget.settings.width);
                                self.widget.editorGrid.configuration.offsetX = self.widget.settings.width - 2;
                                self.widget.editorGrid.parentWidget.editorGrid.updateAllChildren();
                            }
                            break;

                        case 'w':
                            if (self.widget.editorGrid.configuration.axisPosition === 'right') {
                                self.widget.settings.width = newBox.width;
                                self.widget.el.css('flex-basis', self.widget.settings.width);
                                self.widget.el.css('width', self.widget.settings.width);
                                self.widget.editorGrid.parentWidget.editorGrid.updateAllChildren();
                                
                            }
                            break;

                        default:
                            console.iatWarn('Direction ' + direction + ' not valid');
                    }
                },
                finish: function () {
                    var returnBox = { width: self.widget.settings.width };
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
