define(function (require) {

    'use strict';

    var SuperClass = require('brease/core/Class'),
        Enum = require('brease/enum/Enum'),
        BreaseEvent = require('brease/events/BreaseEvent'),
        ModuleClass = SuperClass.extend(function EditorHandles(widget) {
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
            _registerEditClickHandler(this);

        }, null),
        indentFromUpperRightCorner = 20,
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

    p.getHandles = function () {
        return {
            moveHandles: [/*this._getMoveHandle()*/],
            resizeHandles: [/*this._getResizeHandle()*/],
            pointHandles: []
        };
    };

    // Private Functions
    p._getMoveHandle = function () {
        var self = this, containerHandle, buttonHandle;

        containerHandle = {
            start: function () { _retainSettings(self); },
            finish: function () { return _compareSettings(self); },
            update: function (newPosX, newPosY) {

                if (self.widget.settings.docking === Enum.ImageAlign.right || self.widget.settings.docking === Enum.ImageAlign.left) {
                    self.widget.settings.top = newPosY;
                    self.widget.el.css('top', parseInt(self.widget.settings.top, 10));
                } else {
                    self.widget.settings.left = newPosX;
                    self.widget.el.css('left', parseInt(self.widget.settings.left, 10));
                }

                var event = self.widget.createEvent('HandlesChanged');
                event.dispatch();
            },

            handle: function () {
                var handlePosition, container = self.widget.container[0].getBoundingClientRect();

                container.top = parseInt(container.top, 10);
                container.left = parseInt(container.left, 10);
                container.width = parseInt(self.widget.settings.width, 10);
                container.height = parseInt(self.widget.settings.height, 10);

                handlePosition = {
                    x: container.left + indentFromUpperRightCorner - parseInt($('.iatd-content').css('marginLeft'), 10),
                    y: container.top - parseInt($('.iatd-content').css('marginTop'), 10)
                };

                return handlePosition;
            }
        };
        buttonHandle = {
            start: function () { _retainSettings(self); },
            finish: function () {
                return _compareSettings(self);
            },
            update: function (newPosX, newPosY) {
                var offset;
                if (self.widget.settings.docking === Enum.ImageAlign.right || self.widget.settings.docking === Enum.ImageAlign.left) {

                    offset = newPosY - self.widget.settings.top;
                } else {
                    offset = newPosX - self.widget.settings.left;
                }

                self.widget.settings.buttonOffset = offset;
                self.widget._setButtonOffset();
                self.widget._updateEditDimensions();

                var event = self.widget.createEvent('HandlesChanged');
                event.dispatch();

            },

            handle: function () {

                var handlePosition,
                    container = self.widget.el.position();

                container.top = parseInt(container.top, 10);
                container.left = parseInt(container.left, 10);
                container.width = parseInt(self.widget.el.css('width'), 10);
                container.height = parseInt(self.widget.el.css('height'), 10);

                handlePosition = {
                    x: container.left + indentFromUpperRightCorner,
                    y: container.top - indentFromUpperRightCorner /* as otherwise mousedown event may be sent to button and interpreted as click */
                };

                switch (self.widget.settings.docking) {
                    case Enum.ImageAlign.top: {
                        handlePosition.x += self.widget.settings.buttonOffset;
                        handlePosition.y += container.height + indentFromUpperRightCorner;
                        break;
                    }
                    case Enum.ImageAlign.bottom: {
                        handlePosition.x += self.widget.settings.buttonOffset;
                        break;
                    }
                    case Enum.ImageAlign.right: {
                        handlePosition.y += self.widget.settings.buttonOffset;
                        break;
                    }
                    case Enum.ImageAlign.left: {
                        handlePosition.x += container.width - parseInt(self.widget.button.css('width'), 10);
                        handlePosition.y += self.widget.settings.buttonOffset;
                    }
                }
                return handlePosition;
            }
        };

        if (self.selected.container) {
            return containerHandle;
        }

        return buttonHandle;
    };

    p._getResizeHandle = function () {
        var self = this;
        if (self.widget.el.hasClass('show')) {
            return {
                start: function () { return _retainSettings(self); },
                update: function (newBox, direction) {
                    self.widget.settings.width = newBox.width;
                    self.widget.settings.height = newBox.height;

                    self.widget._updateEditDimensions();
                },
                finish: function () { return _compareSettings(self); },
                handle: function () {
                    return self.widget.container[0];
                }
            };
        }
        return {
            start: function () { return _retainSettings(self); },
            update: function (newBox, direction) {
                self.widget.settings.buttonWidth = newBox.width;
                self.widget.settings.buttonHeight = newBox.height;

                self.widget._updateEditDimensions();
            },
            finish: function () { return _compareSettings(self); },
            handle: function () {
                return self.widget.button[0];
            }
        };
    };

    p._editClickHandler = function (e) {
        var self = this;
        if (!self.selected.flyout) {
            _setSelected(self, true);
            $(document).on(BreaseEvent.EDIT.MOUSE_UP, self.widget._bind('_outsideClickHandler'));

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
            $(document).off(BreaseEvent.EDIT.MOUSE_UP, self.widget._bind('_outsideClickHandler'));
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

    function _registerEditClickHandler(designer) {
        designer.widget._editClickHandler = function (e) { return designer._editClickHandler(e); };
        designer.widget._outsideClickHandler = function (e) { return designer._outsideClickHandler(e); };

        designer.widget.el.on(BreaseEvent.EDIT.CLICK, designer.widget._bind(function (e) {
            designer._editClickHandler(e);
        }));
        designer.widget.el.one(BreaseEvent.WIDGET_READY, designer.widget._bind(function (e) {
            var event = designer.widget.createEvent('HandlesChanged');
            event.dispatch();
        }));
    }

    function _retainSettings(self) {

        self.oldSettings.buttonOffset = self.widget.settings.buttonOffset;
        self.oldSettings.buttonWidth = self.widget.settings.buttonWidth;
        self.oldSettings.buttonHeight = self.widget.settings.buttonHeight;
        self.oldSettings.top = self.widget.settings.top;
        self.oldSettings.left = self.widget.settings.left;
        self.oldSettings.width = self.widget.settings.width;
        self.oldSettings.height = self.widget.settings.height;

    }

    function _compareSettings(self) {
        var returnValue = {};

        if (self.widget.settings.buttonOffset !== self.oldSettings.buttonOffset) { returnValue.buttonOffset = self.widget.settings.buttonOffset; }
        if (self.widget.settings.buttonWidth !== self.oldSettings.buttonWidth) { returnValue.buttonWidth = self.widget.settings.buttonWidth; }
        if (self.widget.settings.buttonHeight !== self.oldSettings.buttonHeight) { returnValue.buttonHeight = self.widget.settings.buttonHeight; }

        if (self.widget.settings.top !== self.oldSettings.top) { returnValue.top = self.widget.settings.top; }
        if (self.widget.settings.left !== self.oldSettings.left) { returnValue.left = self.widget.settings.left; }
        if (self.widget.settings.width !== self.oldSettings.width) { returnValue.width = self.widget.settings.width; }
        if (self.widget.settings.height !== self.oldSettings.height) { returnValue.height = self.widget.settings.height; }

        var event = self.widget.createEvent('HandlesChanged');
        event.dispatch();

        return returnValue;
    }

    return ModuleClass;

});
