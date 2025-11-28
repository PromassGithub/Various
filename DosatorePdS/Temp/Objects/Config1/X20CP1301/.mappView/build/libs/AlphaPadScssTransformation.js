(function () {
    'use strict';

    const LF = '\n';

    const alphaPadBaseScss = `
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
            &.active,  &.selected {
              background-color:#FFA800;
            }
            position:absolute;
            white-space: nowrap;
            box-sizing: border-box;
            padding: 0;
            margin: 0;
            @include appearance(none);
            -webkit-tap-highlight-color: initial;
            outline: none;
            sub {
              font-size: 10px;
              position: absolute;
              bottom: 1px;
              right: 1px;
            }
            sup {
              font-size: 10px;
              position: absolute;
              top: 1px;
              right: 1px;
            }
        }
        .ActionImage {
          position:absolute;
          background-size:cover;
        }
        .ValueOutput:focus {
          outline:none;
        }
        .breaseIME {
            position:absolute;
            box-sizing: border-box;
            ol{
              background-color: transparent;
              font-family: inherit;
              font-size: inherit;
              color: inherit;

              li{
                list-style-position: inside; 
                padding: 5px; 
                white-space: nowrap; 
                color: inherit;
                background-color: transparent;
                font-size: inherit;
                font-family: inherit;
                border-top-style: none;
                border-bottom-style: none;
              }
              li:first-of-type{
                border-left-style: none;
              }
              li:last-of-type{
                border-right-style: none;
              }
            }
        }
        .breaseLayoutSelector {
            position:absolute;
            .dropdown {
                position: relative;
                height:100%;

                .button {
                    outline: none;
                    font-family: inherit;
                    margin: 0;
                    box-sizing: border-box;
                    padding: 0;
                    background-image: inherit;
                    color: inherit;
                    display:flex;
                    justify-content: center;
                    flex-direction: column;
                    height:100%;
                }

                .dropdownlist {
                    display: none;
                    position: absolute;
                    overflow: hidden;
                    background-color: #fff;
                    bottom: 20px;
                    left: -1px;
                    border: 1px solid #333;
                    z-index: 11;
                    background-image: inherit;
                    font-family: inherit;
                    color: inherit;

                    div {
                        padding: 18px 22px;
                        background-image: inherit;
                        background-color: inherit;
                        font-family: inherit;
                        color: inherit;
                        line-height: initial;
                    }

                    div.selected {
                        background-color:#FFA800;
                    }

                    &.open {
                        display: block;
                    }
                }
            }
        }
    `;

    let transformation = {
        /** 
         * Generates the widget.scss file for a custom alphapad.
         * Replaces AlphaPadCSS.xsl
         * @param {Object} xml *.alphapad xml converted to js object 
         * @returns alphapad scss file
         */
        alphaPadToScss(xml, { widgetName, cssClassName }) {
            this.widgetName = widgetName;
            return `@import "mixins.scss";${LF}    .${cssClassName}{${alphaPadBaseScss}${this.headerClass(xml.AlphaPad)}}${LF}${this.header(xml.AlphaPad)}${this.section(xml.AlphaPad)}${this.commonComponents(xml.AlphaPad)}`;
        },

        headerClass(node) {
            if (!Array.isArray(node.Header)) return '';
            let attr = node.Header[0].$;
            return `header.breaseKeyboardHeader {
        display:block;
        border-bottom-left-radius: 0;
        border-bottom-right-radius: 0;
        margin: 0px;
        height: ${attr && attr.height !== undefined ? attr.height : '42'}px;
        label {
            color: #fff;
            font-size: 18px;
            }
        }${LF}
    `;
        },

        header(node) {
            if (!Array.isArray(node.Header)) return '';
            let current = node.Header[0];
            const prefix = 'H';
            return `${this.label(current, prefix)}${this.nodeInfo(current, prefix)}`;
        },

        section(node) {
            if (!Array.isArray(node.Section)) return '';

            return node.Section.map((it, i) => {
                let attr = it.$;
                return `    #${this.widgetName}_S${i + 1} {
        position:absolute;
        display:inline-table;
        text-align:center;
        ${this.commonProps(attr)}
    }
${this.commonComponents(it, i + 1)}`;
            }).join('');
        },

        commonProps(attr) {
            if (attr === undefined) {
                return '';
            }
            let zIndex = attr.zIndex !== undefined ? `z-index:${attr.zIndex};` : '';
            let width = attr.width !== undefined ? `width:${attr.width}px;` : '';
            let height = attr.height !== undefined ? `height:${attr.height}px;` : '';

            return `top:${attr.top}px; left:${attr.left}px;${LF}        ${width} ${height} ${zIndex}`;
        },

        commonComponents(node, prefix) {
            return `${this.label(node, prefix)}${this.nodeInfo(node, prefix)}${this.value(node, prefix)}${this.valueButton(node, prefix)}${this.actionButton(node, prefix)}${this.actionImage(node, prefix)}${this.layoutSelector(node, prefix)}${this.ime(node, prefix)}`;
        },

        label(node, prefix) {
            if (!Array.isArray(node.Label)) return '';
            return node.Label.map((it, i) => {
                return `${id(this.widgetName, prefix, 'Label', i)} {
                    position:absolute;
                    ${this.commonProps(it.$)}
                    overflow:hidden;
                    display:block;
                    ${textAlign(it.$)}
                    ${multiLine(it.$)}
                }${LF}`;
            }).join('');
        },

        nodeInfo(node, prefix) {
            if (!Array.isArray(node.NodeInfo)) return '';
            return node.NodeInfo.map((it, i) => {
                return `    ${id(this.widgetName, prefix, 'NodeInfo', i)} {
        position:absolute;
        ${this.commonProps(it.$)}
        overflow:hidden;
        display:block;
        ${textAlign(it.$)}
        ${multiLine(it.$)}
    }${LF}`;
            }).join('');
        },

        value(node, prefix) {
            if (!Array.isArray(node.Value)) return '';
            return node.Value.map((it, i) => {
                let attr = it.$,
                    lineHeight = attr && attr.height !== undefined ? `line-height:${attr.height}px;` : '';
                return `    ${id(this.widgetName, prefix, 'Value', i)} {
        position:absolute;
        box-sizing:border-box;
        text-overflow:ellipsis;
        overflow:hidden;
        ${this.commonProps(it.$)}${lineHeight}
    }${LF}`;
            }).join('');
        },

        actionComponent(node, prefix, name) {
            if (!Array.isArray(node[name])) return '';
            return node[name].map((it, i) => {
                return `    ${id(this.widgetName, prefix, name, i)} {
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
        },

        layoutSelector(node, prefix) {
            return this.actionComponent(node, prefix, 'LayoutSelector');
        },

        ime(node, prefix) {
            return this.actionComponent(node, prefix, 'IME');
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
            return 'white-space:normal;';
        } else {
            return `text-overflow:ellipsis;${LF}        white-space:nowrap;`;
        }
    }

    module.exports = transformation;
})();
