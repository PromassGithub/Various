(function () {
    'use strict';

    const Utils = require('../iat/utils');
    const LF = '\n';

    // TODO: never gererate self closing tags!
    let transformation = {
        /** 
         * Generates the widget.html file for a custom numpad.
         * Replaces NumPadHTML.xsl
         * @param {Object} xml *.numpad xml converted to js object 
         * @returns numpad html file
         */
        numPadToHtml(xml, { qualifiedName, widgetName, cssClassName }) {
            this.widgetName = widgetName;
            return `<div id="breaseNumPad" class="${cssClassName}" data-brease-widget="${qualifiedName}">${LF}${this.header(xml.NumPad)}${this.section(xml.NumPad)}${this.commonComponents(xml.NumPad)}</div>`;
        },

        header(node) {
            if (!Array.isArray(node.Header)) return '';
            let current = node.Header[0];
            const prefix = 'H';
            return `<header class="breaseNumpadHeader">${LF}${this.label(current, prefix)}${this.nodeInfo(current, prefix)}${this.unitInfo(current, prefix)}</header>${LF}`;
        },

        section(node) {
            if (!Array.isArray(node.Section)) return '';
            return node.Section.map((it, i) => `<section id="${this.widgetName}_S${i + 1}">${LF}${this.commonComponents(it, i + 1)}</section>${LF}`).join('');
        },

        commonComponents(node, prefix) {
            return `${this.label(node, prefix)}${this.nodeInfo(node, prefix)}${this.unitInfo(node, prefix)}${this.value(node, prefix)}${this.slider(node, prefix)}${this.valueButton(node, prefix)}${this.actionButton(node, prefix)}${this.actionImage(node, prefix)}`;
        },

        label(node, prefix) {
            if (!Array.isArray(node.Label)) return '';
            return node.Label.map((it, i) => {
                let display = Utils.escape(it.$.display);
                return `<label ${id(this.widgetName, prefix, 'Label', i)} data-display="${display}" class="display">${display}</label>${LF}`;
            }).join('');
        },

        nodeInfo(node, prefix) {
            if (!Array.isArray(node.NodeInfo)) return '';
            return node.NodeInfo.map((it, i) => `<label ${id(this.widgetName, prefix, 'NodeInfo', i)} data-nodeattribute="${it.$.nodeAttribute}" class="nodeInfo"></label>${LF}`).join('');
        },

        unitInfo(node, prefix) {
            if (!Array.isArray(node.UnitInfo)) return '';
            // eslint-disable-next-line no-unused-vars
            return node.UnitInfo.map((it, i) => `<label ${id(this.widgetName, prefix, 'UnitInfo', i)} class="unitInfo"></label>${LF}`).join('');
        },

        value(node, prefix) {
            if (!Array.isArray(node.Value)) return '';
            return node.Value.map((it, i) => {
                let className;
                switch (it.$.value) {
                    case 'min': className = 'minValue'; break;
                    case 'max': className = 'maxValue'; break;
                    default: className = 'breaseNumpadNumericValue';
                }
                return `<div ${id(this.widgetName, prefix, 'Value', i)} class="${className}"></div>${LF}`;
            }).join('');
        },

        slider(node, prefix) {
            if (!Array.isArray(node.Slider)) return '';
            return node.Slider.map((it, i) => `<div class="breaseNumpadSlider" ${id(this.widgetName, prefix, 'Slider', i)}${createDataAttributes(it.$)}></div>${LF}`).join('');
        },

        valueButton(node, prefix) {
            if (!Array.isArray(node.ValueButton)) return '';
            return node.ValueButton.map((it, i) => {
                let display = Utils.escape(it.$.display);
                return `<button data-action="value" ${id(this.widgetName, prefix, 'ValueButton', i)} class="ValueButton" data-value="${it.$.value}" data-display="${display}">${LF}<span class="display">${display}</span>${LF}</button>${LF}`; 
            }).join('');
        },

        actionButton(node, prefix) {
            if (!Array.isArray(node.ActionButton)) return '';
            return node.ActionButton.map((it, i) => { 
                let display = Utils.escape(it.$.display);
                return `<button ${id(this.widgetName, prefix, 'ActionButton', i)} class="ActionButton" data-action="${it.$.action}" data-display="${display}">${LF}<span class="display">${display}</span>${LF}</button>${LF}`;
            }).join('');
        },

        actionImage(node, prefix) {
            if (!Array.isArray(node.ActionImage)) return '';
            return node.ActionImage.map((it, i) => `<div ${id(this.widgetName, prefix, 'ActionImage', i)} class="ActionImage" data-action="${it.$.action}"></div>${LF}`).join('');
        }
    };

    function createDataAttributes(attributes) {
        let out = '';
        const exclude = ['top', 'left', 'width', 'height', 'zIndex'];
        
        for (let name in attributes) {
            if (!exclude.includes(name)) {
                out += ` data-${name}="${attributes[name]}"`;
            }
        }
        return out;
    }

    function id(widgetName, prefix, component, pos) {
        if (prefix) {
            return `id="${widgetName}${'_S' + prefix}_${component}${pos + 1}"`;
        } else {
            return `id="${widgetName}_${component}${pos + 1}"`;
        }
    }

    module.exports = transformation;
})();
