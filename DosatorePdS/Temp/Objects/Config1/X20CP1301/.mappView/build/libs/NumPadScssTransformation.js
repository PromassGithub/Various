(function () {
    'use strict';

    const LF = '\n';

    const numPadBaseScss = `
        color: black;
        font-size:14px;
        background-size:cover;
        border: 9px solid #333333;
        button {
            border: 1px solid #555555;
            background-color:#FFF;
            background-size:cover;
            color:#000;
            font-size:20px;
            &.active {
            background-color:#FFA800;
            }
            
            position:absolute;
            @include displayFlexBox(false);
            @include flex-direction(row);
            white-space: nowrap;
            box-sizing: border-box;
            padding: 0;
            margin: 0;
            @include appearance(none);
            -webkit-tap-highlight-color: initial;
            outline: none;
            span {
                display:inline-block;
                width:100%;
                text-overflow: ellipsis;
                overflow: hidden;
                white-space: nowrap;
                pointer-events: none;
                box-sizing: border-box;
                margin: 0; padding:0 6px;
                @include flex(0 1 auto);
                @include align-self(center);
            }
        }
        .ActionImage {
            position:absolute;
            background-size:cover;
        }
        .maxValue {
            text-align: right;
        }
        .breaseNumpadNumericValue {
            border-color: #333;
            border-style: solid;
            border-width: 1px;
        }
        .unitInfo {
            position:absolute;
            overflow: hidden;
            display:block;
            box-sizing: border-box;
        }
    `;

    let transformation = {
        /** 
         * Generates the widget.scss file for a custom numpad.
         * Replaces NumPadCSS.xsl
         * @param {Object} xml *.numpad xml converted to js object 
         * @returns numpad scss file
         */
        numPadToScss(xml, { widgetName, cssClassName }) {
            this.widgetName = widgetName;
            return `@import "mixins.scss";${LF}.${cssClassName}{${numPadBaseScss}${this.headerClass(xml.NumPad)}}${LF}${this.header(xml.NumPad)}${this.section(xml.NumPad)}${this.commonComponents(xml.NumPad)}`;
        },

        headerClass(node) {
            if (!Array.isArray(node.Header)) return '';
            let attr = node.Header[0].$;
            return `header.breaseNumpadHeader {
                display:block;
                border-bottom-left-radius: 0;
                border-bottom-right-radius: 0;
                margin: 0px;
                height: ${attr && attr.height !== undefined ? attr.height : '33'}px;
                label {
                    color: #fff;
                    font-size: 18px;
                  }
                }`;
        },

        header(node) {
            if (!Array.isArray(node.Header)) return '';
            let current = node.Header[0];
            const prefix = 'H';
            return `${this.label(current, prefix)}${this.nodeInfo(current, prefix)}${this.unitInfo(current, prefix)}`;
        },

        section(node) {
            if (!Array.isArray(node.Section)) return '';
            let out = '';
            let current = node.Section;
            for (let i = 0; i < current.length; ++i) {
                let attr = current[i].$;
                out += `#${this.widgetName}_S${i + 1} {
                    position:absolute;
                    ${this.commonProps(attr)}
                }
                ${this.commonComponents(current[i], i + 1)}${LF}`;
            }
            return out;
        },

        commonProps(attr) {
            let zIndex = attr.zIndex !== undefined ? `z-index:${attr.zIndex};` : '';
            let width = attr.width !== undefined ? `width:${attr.width}px;` : '';
            let height = attr.height !== undefined ? `height:${attr.height}px;` : '';

            return `top:${attr.top}px; left:${attr.left}px;
            ${width}${height}${zIndex}`;
        },

        commonComponents(node, prefix) {
            return `${this.label(node, prefix)}${this.nodeInfo(node, prefix)}${this.unitInfo(node, prefix)}${this.value(node, prefix)}${this.slider(node, prefix)}${this.valueButton(node, prefix)}${this.actionButton(node, prefix)}${this.actionImage(node, prefix)}`;
        },
        
        label(node, prefix) {
            if (!Array.isArray(node.Label)) return '';
            return node.Label.map((it, i) => {
                return `${id(this.widgetName, prefix, 'Label', i)} {
                    position:absolute;
                    ${this.commonProps(it.$)}
                    overflow: hidden;
                    display:block;
                    ${textAlign(it.$)}
                    ${multiLine(it.$)}
                }${LF}`;
            }).join('');
        },

        nodeInfo(node, prefix) {
            if (!Array.isArray(node.NodeInfo)) return '';
            return node.NodeInfo.map((it, i) => {
                return `${id(this.widgetName, prefix, 'NodeInfo', i)} {
                    position:absolute;
                    ${this.commonProps(it.$)}
                    overflow: hidden;
                    display:block;
                    ${textAlign(it.$)}
                    ${multiLine(it.$)}
                }${LF}`;
            }).join('');
        },

        unitInfo(node, prefix) {
            if (!Array.isArray(node.UnitInfo)) return '';
            return node.UnitInfo.map((it, i) => {
                return `${id(this.widgetName, prefix, 'UnitInfo', i)} {
                    ${this.commonProps(it.$)}
                    overflow: hidden;
                    display:block;
                    ${textAlign(it.$)}
                }${LF}`;
            }).join('');
        },

        value(node, prefix) {
            if (!Array.isArray(node.Value)) return '';
            return node.Value.map((it, i) => {
                return `${id(this.widgetName, prefix, 'Value', i)} {
                    position:absolute;
                    box-sizing: border-box;
                    text-overflow: ellipsis;
                    overflow: hidden;
                    line-height: ${it.$.height}px;
                    ${this.commonProps(it.$)}
                }${LF}`;
            }).join('');
        },

        slider(node, prefix) {
            if (!Array.isArray(node.Slider)) return '';
            let importScss = `@import '../../system/widgets/NumPad/libs/NumPadSlider.scss';`;
            let slider = node.Slider.map((it, i) => {
                return `${id(this.widgetName, prefix, 'Slider', i)} {
                    position:absolute;
                    ${this.commonProps(it.$)}
                    .numpadSlider_track {
                        width: ${it.$.width}px;
                        .numpadSlider_track_inner {
                            width: ${it.$.width}px;
                        }
                    }
                }${LF}`;
            }).join('');
            return `${importScss}${LF}${slider}`;
        },

        actionComponent(node, prefix, name) {
            if (!Array.isArray(node[name])) return '';
            return node[name].map((it, i) => {
                return `${id(this.widgetName, prefix, name, i)} {
                    ${this.commonProps(it.$)}
                }${LF}`;
            }).join('');
        },

        valueButton(node, prefix) {
            return this.actionComponent(node, prefix, 'ValueButton');
        },

        actionButton(node, prefix) {
            return this.actionComponent(node, prefix, 'ActionButton');
        },

        actionImage(node, prefix) {
            return this.actionComponent(node, prefix, 'ActionImage');
        }
    };

    function id(widgetName, prefix, component, pos) {
        if (prefix) {
            return `#${widgetName}${'_S' + prefix}_${component}${pos + 1}`;
        } else {
            return `#${widgetName}_${component}${pos + 1}`;
        }
    }

    function textAlign(attr) {
        return attr.textAlign ? `text-align:${attr.textAlign};` : '';
    }

    function multiLine(attr) {
        if (attr.multiLine === 'true') {
            return 'white-space: normal;';
        } else {
            return `text-overflow: ellipsis;${LF}white-space: nowrap;`;
        }
    }

    module.exports = transformation;
})();
