define(['widgets/brease/KeyBoard/libs/external/wanakana', 'brease/events/BreaseEvent', 'widgets/brease/KeyBoard/libs/composer/RomajiToKana', 'widgets/brease/KeyBoard/libs/converter/KanaToKanji'], function (wanakana, BreaseEvent, composer, converter) {
    'use strict';

    var SuperClass = require('brease/core/Class'),
        Plugin = SuperClass.extend(function PluginWanaKana() {
            SuperClass.call(this);
        }),

	p = Plugin.prototype;

    p.init = function (keyboard) {
        var that = this;
        this.preventInput = true;
        this.keyboard = keyboard;
        this.debouncedBuildList = _.debounce(that._buildList, 300);
        this.eventsAttached = false;
        this.initEvents();
        this.startCursor = this.keyboard.getCursor();
        this.len = 0;
        this.items = [];
        this.oldValue = this.keyboard.getValue();
        composer.init();
    };

    p.show = function () {
        //console.log('show', this.value, this.keyboard.cursor);
        this.oldValue = this.keyboard.getValue();
        this.startCursor = this.keyboard.getCursor();
        this.cursor = 0;
        this.initEvents();
        composer.init();
    };

    p.hide = function () {
        this.initEvents(true);
        this.container.empty();
        this.debouncedBuildList.cancel();
        this.oldValue = '';
    };

    p.setCursor = function (cursor) {
        //console.debug('oldCursor:', this.cursor, 'newCursor:', cursor);
        this.cursor = cursor;
    };

    p.getCursor = function () {
        return this.cursor;
    };

    p.getItems = function () {
        return this.container.find('[class*="item"]');
    };

    p.onInput = function () {
        //console.log(this.keyboard.output.get(0).selectionStart, this.keyboard.output.get(0).selectionEnd, this.keyboard.output.get(0));
        //this.len += (cursor - this.cursor);
        //this.setCursor(cursor);
        //this.trigger = _getTrigger(val, this.cursor, this.len);


        //if (wanakana.isRomaji(this.trigger)) {
        //    this.debouncedBuildList();
        //} else {
        //    this.debouncedBuildList.cancel();
        //    this.container.empty();
        //    this.len = 0;
        //}

        //console.log('onInput:', this.trigger, this.cursor, this.len, val);
    };

    p.onDelete = function () {
        //this.len -= (this.cursor - cursor);
        //this.setCursor(cursor);
        //this.trigger = _getTrigger(val, this.cursor, this.len);
        //if (_.isString(val) && val.length === 0) {
        //    this.container.empty();
        //    this.debouncedBuildList.cancel();
        //    this.len = 0;
        //    return;
        //}
        //if (wanakana.isRomaji(this.trigger)) {
        //    this.debouncedBuildList();
        //} else {
        //    this.debouncedBuildList.cancel();
        //}
        //console.log('onDelete:', this.trigger, this.cursor, this.len, val);
    };

    p.onClear = function () {
        this.len = 0;
        this.value = '';
        this.oldValue = '';
        this.container.empty();
        composer.setValue('');
        composer.resetStartIndex();
        this.debouncedBuildList.cancel();
    };

    p.onSelectItem = function (e) {
        var value = e.currentTarget.textContent.split(" ")[1];

        _insertValue.call(this, value);
    };

    p.onSelectNext = function () {
        this.start += this.offset;
        this.end += this.offset;
        _draw.call(this);
    };

    p.onSelectPrev = function () {
        this.start -= this.offset;
        this.end -= this.offset;
        _draw.call(this);
    };

    p.dispose = function () {
        //console.log('dispose:');
        this.initEvents(true);
        this.oldValue = '';
        this.debouncedBuildList.cancel();
        composer.dispose();
        this.len = 0;
        this.cursor = 0;
    };

    p._buildList = function () {
        var val = composer.getValue();
        if (val.length !== 0) {
            var arrPhoneticInput = composer.parseInput(val);
            var arrCandidates = converter.getCandidates(val);
            arrCandidates.unshift(arrPhoneticInput[0]);
            if (arrPhoneticInput[1]) {
                arrCandidates.push(arrPhoneticInput[1]);
            }
            this.items = arrCandidates;
            _setPluginItems.call(this);
        } else {
            this.items = [];
            _setPluginItems.call(this);
        }
    };

    p.initEvents = function (remove) {
        if (!remove && this.eventsAttached) {
            return;
        } else if (!remove && !this.eventsAttached) {
            this.eventsAttached = true;
        } else {
            this.eventsAttached = false;
        }
        var eventType = remove ? _removeEvListener : _addEvListener,
            eventName = _getEventConfig(brease.config.virtualKeyboards),
            widget = this;
        if (!brease.config.editMode) {
            widget.container = widget.keyboard.el.find(".keyBoardPlugin");
            eventType(widget.keyboard.output, 'focus input', { self: widget, oldValue: widget.oldValue }, _onInput);
            eventType(widget.keyboard.output, eventName, { self: widget, oldValue: widget.oldValue }, _onClick);
            eventType(widget.container, eventName, '[class*="item"]', widget._bind('onSelectItem'));
            eventType(widget.container, eventName, '.next', widget._bind('onSelectNext'));
            eventType(widget.container, eventName, '.prev', widget._bind('onSelectPrev'));
        }
    };

    function _addEvListener(el, ev, sel, data, fn) {
        el.on(ev, sel, data, fn);
    }

    function _removeEvListener(el, ev, sel, data, fn) {
        el.off(ev, sel, data, fn);
    }
    function _onInput(e) {
        var that = e.data.self,
            inputEl = $(this),
            arrOldValue = e.data.self.oldValue.split(""),
            arrNewValue = inputEl.val().split(""), i;
        //console.log('_onFocus: selectionStart:', this.selectionStart, 'value:', composer.getStartIndex() + composer.getLen() + 1);
        //if (composer.getStartIndex() === -1) {
        //    composer.setValue('');
        //    composer.setStartIndex(this.selectionStart - 1);
        //}
        if (arrOldValue.length > arrNewValue.length) {
            for (i = 0; i < arrOldValue.length; i += 1) {
                if (arrOldValue[i] !== arrNewValue[0]) {
                    //console.log('Char:', arrNewValue[i], 'added on index: ', i, this.selectionStart);
                    if (composer.getStartIndex() === -1 || i < Math.abs(composer.getStartIndex() - 1)) {
                        composer.setValue('');
                        composer.setStartIndex(i);
                    }
                    if (wanakana.isRomaji(arrOldValue[i])) {
                        composer.removeChar(arrOldValue[i], i);
                        that.debouncedBuildList();
                        break;
                    } else {
                        composer.setValue('');
                        composer.setStartIndex(this.selectionStart);
                        that.debouncedBuildList.cancel();
                    }
                } else {
                    arrNewValue.shift();
                }
            }
        } else if (arrOldValue.length < arrNewValue.length) {
            for (i = 0; i < arrNewValue.length; i += 1) {
                if (arrNewValue[i] !== arrOldValue[0]) {
                    //console.log('Char:', arrNewValue[i], 'added on index: ', i, this.selectionStart);
                    if (composer.getStartIndex() === -1 || i < Math.abs(composer.getStartIndex() - 1)) {
                        composer.setValue('');
                        composer.setStartIndex(i);
                    }
                    if (wanakana.isRomaji(arrNewValue[i])) {
                        composer.addChar(arrNewValue[i], i);
                        that.debouncedBuildList();
                        break;
                    } else {
                        composer.setValue('');
                        composer.setStartIndex(this.selectionStart);
                        that.debouncedBuildList.cancel();
                    }
                } else {
                    arrOldValue.shift();
                }
            }
        } else if (composer.getValue() === '') {
            composer.setStartIndex(this.selectionStart);
        }
        that.oldValue = inputEl.val();
    }
    function _onClick() {
        if (this.selectionStart < composer.getStartIndex() || this.selectionStart > composer.getStartIndex() + composer.getLen()) {
            composer.setStartIndex(this.selectionStart);
            composer.setValue('');
        }
        //console.log('startIndex:', composer.getStartIndex(), 'value:', composer.getValue());
        //that.oldValue = '';
    }

    function _insertValue(value) {
        //var cursor = this.keyboard.getCursor(),
        var actValue = this.keyboard.value,
            index = composer.getStartIndex(),
            valueLen = composer.getLen(),
			preValue = actValue.substr(0, index),
			postValue = actValue.substr(index + valueLen);

        var sendValue = preValue + value + postValue;
        composer.setValue('');
        index = preValue.length + value.length;
        composer.setStartIndex(index);
        //console.log('_insertValue:', composer.getValue(), composer.getStartIndex());
        this.oldValue = sendValue;
        this.keyboard.setValue(sendValue);
        this.keyboard.setCursor(index);
        this.items = [];

        _setPluginItems.call(this);
    }

    function _setPluginItems() {
        this.start = 0;
        this.end = 5;
        this.offset = this.end;
        if (this.end > this.items.length) {
            this.end = this.items.length;
        }

        _draw.call(this);
    }

    function _draw() {
        this.container.empty().append(_createHTMLContent.call(this));
    }

    function _createHTMLContent() {
        var html = "",
            items = this.items.slice(this.start, this.end);

        items.forEach(function (actItem, idx, arrItems) {
            if (idx === 0 && this.start > 0) {
                html += '<div class="pluginList"><div class="prev">-</div>';
            } else if (idx === 0) {
                html += '<div class="pluginList"><div></div>';
            }

            html += '<div class="itemLarge">' + idx + ' ' + actItem + '</div>';

            if (idx === arrItems.length - 1 && this.end < this.items.length) {
                html += '<div class="next">+</div></div>';
            } else if (idx === arrItems.length - 1) {
                html += '</div>';
            }
        }, this);

        return html;
    }

    function _getEventConfig(kbdConf) {
        if (!kbdConf) {
            return BreaseEvent.CLICK;
        }
        if (kbdConf.InputProcessing) {
            return kbdConf.InputProcessing.onKeyDown === true ? BreaseEvent.MOUSE_DOWN : BreaseEvent.CLICK;
        } else {
            return BreaseEvent.CLICK;
        }
    }

    return new Plugin();

});
