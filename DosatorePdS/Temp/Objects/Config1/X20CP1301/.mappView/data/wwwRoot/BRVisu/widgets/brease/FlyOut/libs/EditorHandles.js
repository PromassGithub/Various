define(['brease/core/Class', 
    'brease/enum/Enum',
    'brease/events/BreaseEvent'], 
function (SuperClass, Enum, BreaseEvent) {

    'use strict';

    var ModuleClass = SuperClass.extend(function EditorHandles(widget) {
            SuperClass.call(this);

            this.widget = widget;
            this.oldSettings = {
                top: this.widget.settings.top,
                left: this.widget.settings.left,
                width: this.widget.settings.width,
                height: this.widget.settings.height,
                buttonWidth: this.widget.settings.buttonWidth,
                buttonHeight: this.widget.settings.buttonHeight,
                //Not V1
                buttonOffset: this.widget.settings.buttonOffset
            };
            this.selected = {
                button: false,
                container: false,
                flyout: false
            };
            _registerEventHandler(this);

        }, null),
        p = ModuleClass.prototype;

    p.isRotatable = function () { return false; };

    p.getSelectionDecoratables = function () {
        var list = [];
        list.push(this.widget.container[0]);
        if (this.widget.button !== undefined) {
            list.push(this.widget.button[0]);
        }
        return list;
    };

    p.trySetProperty = function (name, value) {
        var changeset = {};
        changeset[name] = value;
        if (name === 'docking' || Enum.Position.hasOwnProperty(name)) {
            var docking = name === 'docking' ? value : this.widget.settings.docking;
            switch (docking) {
                case Enum.ImageAlign.left:
                case Enum.ImageAlign.right:
                    changeset['left'] = 0;
                    break;
                case Enum.ImageAlign.top:
                case Enum.ImageAlign.bottom:
                    changeset['top'] = 0;
                    break;
            }
        }
        return changeset;
    };

    p.getHandles = function () {
        return {
            moveHandles: [],
            resizeHandles: [],
            pointHandles: []
        };
    };

    // Private Functions

    p._editClickHandler = function (e) {
        var self = this;
        if (!self.selected.flyout) {
            _setSelected(self, true);
            $(document).on(BreaseEvent.EDIT.MOUSE_UP, self._bind('_outsideClickHandler'));

        } else {
            if (e.target === self.widget.button[0]) {
                _setSelectedElem(self, false);
                if (self.selected.button) {
                    self.widget.toggle();

                    var event = self.widget.createEvent('HandlesChanged');
                    event.dispatch();
                }
            } else {
                if (e.target === self.widget.container[0]) {
                    _setSelectedElem(self, true);
                }
            }
        }
    };

    p._outsideClickHandler = function (e) {
        var self = this;
        if ((self.widget.elem === null) || ((self.widget.elem !== e.target) && (!$.contains(self.widget.elem, e.target)))) {
            $(document).off(BreaseEvent.EDIT.MOUSE_UP, self._bind('_outsideClickHandler'));
            _setSelected(self, false);
        }
    };

    function _setSelected(self, value) {
        if (value === true) {
            self.selected.flyout = true;
        } else {
            self.selected.flyout = false;
        }
    }

    function _setSelectedElem(self, flagContainer) {
        if (self.widget.el.hasClass('show') && flagContainer) {

            self.selected.container = true;
            self.selected.button = false;
        } else {
            self.selected.container = false;
            self.selected.button = true;
        }

        var event = self.widget.createEvent('HandlesChanged');
        event.dispatch();
    }

    function _registerEventHandler(designer) {

        designer.widget.el.on(BreaseEvent.EDIT.CLICK, '.breaseButton', designer._bind('_editClickHandler'));
        designer.widget.el.one(BreaseEvent.WIDGET_READY, function () {
            designer.widget.createEvent('HandlesChanged').dispatch();
        });
    }

    return ModuleClass;

});
