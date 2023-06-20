define([
    'widgets/brease/common/libs/BoxLayout'
], function (BoxLayout) {

    'use strict';

    var HTMLView = function (props, parent) {
        this.render(props, parent);
    };

    var p = HTMLView.prototype;

    p.render = function render(props, parent) {
        this.el = $(BoxLayout.createBox());
        this.el.addClass('HTMLView');
        //Check if we are fed HTML otherwise treat as text!
        if (props.html[0] === '<') {
            this.el.html(props.html);
        } else {
            this.span = $('<span></span>');
            _addCssClasses(this.el, props.textSettings, props.selected);
            this.span.text(props.html);
            this.el.append(this.span);
        }
        parent.append(this.el);
    };

    p.dispose = function dispose() {
        this.span.remove();
        this.el.remove();
    };

    function _addCssClasses(element, textSettings, selected) {
        if (textSettings.ellipsis === true) {
            element.addClass('ellipsis');
        } else {
            element.removeClass('ellipsis');
        }
        if (selected) {
            element.addClass('textSelected');
        } else {
            element.removeClass('textSelected');
        }
        if (textSettings.multiLine === true) {
            element.addClass('multiLine');
            if (textSettings.wordWrap === true) {
                element.addClass('wordWrap');
                element.removeClass('multiLine');
            } else {
                element.removeClass('wordWrap');
            }
            if (textSettings.breakWord === true) {
                element.addClass('breakWord');
                element.removeClass('multiLine');
            } else {
                element.removeClass('breakWord');
            }
        } else {
            element.removeClass('breakWord');
            element.removeClass('wordWrap');
            element.removeClass('multiLine');
        }
    }

    return HTMLView;

});
