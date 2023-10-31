define([
    'brease/core/Class'
], function (SuperClass) {

    'use strict';

    var ModuleClass = SuperClass.extend(function EditorHandles(widget) {
            SuperClass.call(this);
            this.widget = widget;
            this.selected = {
                graphWidget: false,
                graphAvatar: false,
                graph: false
            };
        //_registerEditClickHandler(this);
        }, null),

        p = ModuleClass.prototype;

    p.getHandles = function () {

        return {
            moveHandles: [],
            pointHandles: [],
            resizeHandles: []
        };
    };

    p.getSelectionDecoratables = function () {
        var list = [];

        list.push(this.widget.elem);
        if (this.widget.editorGrid.graphAvatarContainer) {
            list.push(this.widget.editorGrid.graphAvatar[0][0]);
        }

        return list;
    };

    //function _registerEditClickHandler(designer) {
    //    designer.widget._editClickHandler = function (e) { return designer._editClickHandler(e); };
    //    designer.widget._outsideClickHandler = function (e) { return designer._outsideClickHandler(e); };

    //    designer.widget.el.on(BreaseEvent.EDIT.CLICK, designer.widget._bind(function (e) {
    //        designer._editClickHandler(e);
    //    }));
    //    $(designer.widget.editorGrid.graphAvatar[0][0]).on(BreaseEvent.EDIT.CLICK, designer.widget._bind(function (e) {
    //        designer._editClickHandler(e);
    //    }));
    //    designer.widget.el.one(BreaseEvent.WIDGET_READY, designer.widget._bind(function (e) {
    //        var event = designer.widget.createEvent("HandlesChanged");
    //        event.dispatch();
    //    }));
    //}

    //p._editClickHandler = function (e) {
    //    var self = this;
    //    if (!self.selected.graph) {
    //        _setSelected(self, true);
    //        $(document).on(BreaseEvent.EDIT.MOUSE_UP, self.widget._bind('_outsideClickHandler'));

    //    } else {
    //        if (e.target === self.widget.editorGrid.graphAvatar[0][0]) {
    //            _setSelectedElem(self, false);
    //            if (self.selected.graphAvatar) {

    //                var event = self.widget.createEvent("HandlesChanged");
    //                event.dispatch();
    //            }
    //        } else {
    //            if (e.target === self.widget.elem) {
    //                _setSelectedElem(self, true);
    //            }
    //        }
    //    }
    //};

    //p._outsideClickHandler = function (e) {
    //    var self = this;
    //    if ((self.widget.elem === null) || ((self.widget.elem !== e.target) && (!$.contains(self.widget.elem, e.target)))) {
    //        $(document).off(BreaseEvent.EDIT.MOUSE_UP, self.widget._bind('_outsideClickHandler'));
    //        _setSelected(self, false);
    //    }
    //};

    //function _setSelected(self, value) {
    //    if (value === true) {
    //        self.selected.graph = true;
    //    } else {
    //        self.selected.graph = false;
    //    }
    //}

    //function _setSelectedElem(self, flagGraphWidget) {
    //    if (flagGraphWidget) {

    //        self.selected.graphWidget = true;
    //        self.selected.graphAvatar = false;
    //    } else {
    //        self.selected.graphWidget = false;
    //        self.selected.graphAvatar = true;
    //    }

    //    var event = self.widget.createEvent("HandlesChanged");
    //    event.dispatch();
    //}

    return ModuleClass;

});
