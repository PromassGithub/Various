(function () {
    'use strict';

    const LF = '\n',
        utils = require('../iat/utils');

    let transformation = {
        /** 
         * Generates the widget.html file for a custom alphapad.
         * Replaces AlphaPadHTML.xsl
         * @param {Object} xml *.alphapad xml converted to js object 
         * @returns alphapad html file
         */
        alphaPadToHtml(xml, { qualifiedName, widgetName, cssClassName }) {
            this.widgetName = widgetName;
            return `<div id="breaseKeyBoard" class="${cssClassName}" data-brease-widget="${qualifiedName}">${LF}${this.header(xml.AlphaPad)}${this.section(xml.AlphaPad)}${this.commonComponents(xml.AlphaPad)}</div>`;
        },

        header(node) {
            if (!Array.isArray(node.Header)) return '';
            let current = node.Header[0];
            const prefix = 'H';
            return `<header class="breaseKeyboardHeader">${LF}${this.label(current, prefix)}${this.nodeInfo(current, prefix)}${LF}</header>${LF}`;
        },

        section(node) {
            if (!Array.isArray(node.Section)) return '';
            //${this.commonComponents(it, i + 1)}
            return node.Section.map((it, i) => `<section id="${this.widgetName}_S${i + 1}">${LF}${this.commonComponents(it, i + 1)}</section>${LF}`).join('');
        },

        commonComponents(node, prefix) {
            return `${this.label(node, prefix)}${this.nodeInfo(node, prefix)}${this.value(node, prefix)}${this.valueButton(node, prefix)}${this.actionButton(node, prefix)}${this.actionImage(node, prefix)}${this.layoutSelector(node, prefix)}${this.ime(node, prefix)}`;
        },

        label(node, prefix) {
            if (!Array.isArray(node.Label)) return '';
            return node.Label.map((it, i) => {
                let display = utils.escape(it.$.display);
                return `<label ${id(this.widgetName, prefix, 'Label', i)} data-display="${display}" class="display">${LF}${display}</label>${LF}`;
            }).join('');
        },

        nodeInfo(node, prefix) {
            if (!Array.isArray(node.NodeInfo)) return '';
            return node.NodeInfo.map((it, i) => `<label ${id(this.widgetName, prefix, 'NodeInfo', i)} data-nodeattribute="${utils.escape(it.$.nodeAttribute)}" class="nodeInfo"></label>${LF}`).join('');
        },

        value(node, prefix) {
            if (!Array.isArray(node.Value)) return '';
            return node.Value.map((it, i) => {
                return `<input ${id(this.widgetName, prefix, 'Value', i)} type="text" readonly="readonly" autocomplete="off" class="ValueOutput"></input>${LF}`;
            }).join('');
        },

        valueButton(node, prefix) {
            if (!Array.isArray(node.ValueButton)) return '';
            return node.ValueButton.map((it, i) => {
                let escapedAttrs = {},
                    attrNames = ['display', 'shiftDisplay', 'specialDisplay', 'value', 'shiftValue', 'specialValue'];
                attrNames.forEach(function (attrName) {
                    escapedAttrs[attrName] = utils.escape(it.$[attrName]);
                });
                return `<button data-action="value" ${id(this.widgetName, prefix, 'ValueButton', i)} class="ValueButton" data-value="${escapedAttrs.value}" data-shift-value="${escapedAttrs.shiftValue}" data-special-value="${escapedAttrs.specialValue}" data-display="${escapedAttrs.display}" data-shift-display="${escapedAttrs.shiftDisplay}" data-special-display="${escapedAttrs.specialDisplay}">${LF}<sup>${escapedAttrs.shiftDisplay}</sup>${LF}<span>${escapedAttrs.display}</span>${LF}<sub>${escapedAttrs.specialDisplay}</sub>${LF}</button>${LF}`;
            }).join('');
        },

        actionButton(node, prefix) {
            if (!Array.isArray(node.ActionButton)) return '';
            
            return node.ActionButton.map((it, i) => {
                let display = utils.escape(it.$.display);
                return `<button ${id(this.widgetName, prefix, 'ActionButton', i)} class="ActionButton" data-action="${it.$.action}" data-display="${display}">${LF}<span class="display">${display}</span>${LF}</button>${LF}`;
            }).join('');
        },

        actionImage(node, prefix) {
            if (!Array.isArray(node.ActionImage)) return '';
            return node.ActionImage.map((it, i) => `<div ${id(this.widgetName, prefix, 'ActionImage', i)} class="ActionImage" data-action="${it.$.action}"></div>${LF}`).join('');
        },

        layoutSelector(node, prefix) {
            if (!Array.isArray(node.LayoutSelector)) return '';
            return node.LayoutSelector.map((it, i) => `<button ${id(this.widgetName, prefix, 'LayoutSelector', i)} class="breaseLayoutSelector"></button>${LF}`).join('');
        },

        ime(node, prefix) {
            if (!Array.isArray(node.IME)) return '';
            return node.IME.map((it, i) => `<div ${id(this.widgetName, prefix, 'IME', i)} class="breaseIME" data-brease-lang="${it.$.lang}"></div>${LF}`).join('');
        }
    };

    function id(widgetName, prefix, component, pos) {
        if (prefix) {
            return `id="${widgetName}${'_S' + prefix}_${component}${pos + 1}"`;
        } else {
            return `id="${widgetName}_${component}${pos + 1}"`;
        }
    }

    module.exports = transformation;
})();
