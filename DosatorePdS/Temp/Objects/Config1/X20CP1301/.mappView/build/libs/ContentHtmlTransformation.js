(function () {
    'use strict';
        
    const Utils = require('../iat/utils');
    const widgetsDataCache = require('./WidgetsDataCache');

    const ID_SEPERATOR = '_';
    const COWI_ID_PLACEHOLDER = '{COWI_ID}';

    const transformation = {
        // replacement of HTMLBuilder.xslt
        contentToHtml: function (contentId, widgetsXMLNode, childInfo, childWidgetsList, isCowi = false) {
            const widgets = widgetsXMLNode[0].Widget;
            const script = transformation.widgetsToScript(widgets, contentId, childInfo, childWidgetsList, isCowi);
            const childs = transformation.widgetsToHtml(widgets, contentId, childWidgetsList);
            return `<script>${script}</script>${childs}`;
        },
        // create script of html file, i.e: brease.setOptions("contentId_Button1",{ "className":"widgets/brease/Button","parentCoWiId":"{COWI_ID}"});
        widgetsToScript: function (widgets, contentId, childInfo, childWidgetsList, isCowi) {
            let script = ``;
            if (!Array.isArray(widgets)) {
                return script;
            }
            for (let widget of widgets) {
                const fullWidgetId = contentId + ID_SEPERATOR + widget.$.id;
                const objectLiteral = propsToJs(widget, childInfo, childWidgetsList, isCowi ? null : contentId);
                script += `brease.setOptions("${fullWidgetId}",${objectLiteral});\n`;
                if (widget.Widgets) {
                    script += transformation.widgetsToScript(widget.Widgets[0].Widget, contentId, childInfo, childWidgetsList, isCowi);
                }
            }
            return script;
        },

        widgetsToHtml: function (widgets, contentId, childWidgetsList) {
            let html = ``;
            if (!Array.isArray(widgets)) {
                return html;
            }
            for (let widget of widgets) {
                const props = widget.$;
                const xsiType = props['xsi:type'];
                const widgetType = Utils.replaceAll(xsiType, '\\.', '/');
                const fullWidgetId = contentId + ID_SEPERATOR + props.id;
                const widgetHtmlObj = widgetsDataCache.getHtmlObj(childWidgetsList[xsiType]);
                const elemName = Object.keys(widgetHtmlObj)[0];
                const elemProps = widgetHtmlObj[elemName].$;
                const instruction = {
                    useDOM: elemProps['data-instruction-useDOM'] === 'true',
                    addStyleClass: elemProps['data-instruction-addStyleClass'] === 'true',
                    loadContent: elemProps['data-instruction-loadContent'] === 'true'
                };
                const standardAttributes = createStandardHtmlAttributes(elemName, fullWidgetId, widgetType, props);
                let otherAttributes = ``;
                let widgetDOM = ``;
                if (instruction.useDOM) {
                    otherAttributes = createHtmlAttributes(elemProps);
                    widgetDOM = copyChildDOM(fullWidgetId, widgetsDataCache.getHtml(childWidgetsList[xsiType]));
                }
                if (instruction.addStyleClass) {
                    const stylePath = Utils.replaceAll(xsiType, '\\.', '_');
                    const styleName = props.style ? `${stylePath}_style_${props.style}` : `${stylePath}_style_default`;
                    let classVal = styleName;
                    if (elemProps.class) {
                        classVal = elemProps.class + ' ' + styleName;
                    }
                    otherAttributes += ` class="${classVal}"`;
                } else if (elemProps.class) {
                    otherAttributes += ` class="${elemProps.class}"`;
                }
                let innerChilds = '';
                if (widget.Widgets) {
                    innerChilds = transformation.widgetsToHtml(widget.Widgets[0].Widget, contentId, childWidgetsList);
                } else if (instruction.loadContent) {
                    const widgetContent = widgetsDataCache.getContent(childWidgetsList[xsiType]);
                    // xslt replaces all placeholders in script. In html it replaces only in id attribtue... 
                    // no one will use the cowi placeholder outside id so we should be good.
                    innerChilds = Utils.replaceAll(widgetContent, COWI_ID_PLACEHOLDER, fullWidgetId);
                }
                html += `<${elemName} ${standardAttributes}${otherAttributes}>${innerChilds}${widgetDOM}</${elemName}>`;
            }
            return html;
        }
    };

    function propsToJs(widget, childInfo, childWidgetsList, contentId) {
        const xsiType = widget.$['xsi:type'];
        const widgetInfo = childInfo[xsiType];
        const className = Utils.replaceAll(widgetInfo.name, '\\.', '/');
        const widgetHtmlObj = widgetsDataCache.getHtmlObj(childWidgetsList[xsiType]);
        const elemName = Object.keys(widgetHtmlObj)[0];
        const elemProps = widgetHtmlObj[elemName].$;
        const styleClassAdded = elemProps['data-instruction-addStyleClass'] === 'true' ? ',"styleClassAdded":true' : '';
        const parentProp = contentId !== null ? `"parentContentId":"${contentId}"` : `"parentCoWiId":"{COWI_ID}"`;
        return `{${projectedPropsToJs(widget, widgetInfo, contentId)}"className":"${className}",${parentProp}${styleClassAdded}}`;
    }

    function projectedPropsToJs(widget, widgetInfo, contentId) {
        const props = widget.$;
        let js = '';
        // cowi build already patches all widgets in content with width and height so we would not need this check
        // TODO: we can remove this if if also in test all widgets have a width and height
        if (contentId !== null) {
            js = `${createDefaultAttribute('width', widgetInfo, props)}${createDefaultAttribute('height', widgetInfo, props)}`;
        }
        for (let propName in props) {
            if (propName === 'xsi:type' || propName === 'id') {
                continue;
            }
            let propType;
            let propDef = widgetInfo.properties.find(it => it.name === propName);
            if (propDef) {
                propType = propDef.type;
            } else if (Array.isArray(widgetInfo.styleproperties.StyleProperty)) {
                propDef = widgetInfo.styleproperties.StyleProperty.find(it => it.$.name === propName);
                if (propDef === undefined) {
                    continue;
                }
                propType = propDef.$.type;
            } else {
                continue;
            }
            const propValue = props[propName];
            // empty String or RoleCollection are ok, ignore all other empty props
            if (propValue.length > 0 || propType === 'String' || propType === 'RoleCollection') {
                js += `"${propName}": ${Utils.parsePropertyValueForJS(propValue, propType, contentId)},`;
            }
        }
        if (Array.isArray(widget.Properties)) {
            const idPrefix = `${contentId}_${props.id}`;
            js += structPropsToJs(widget.Properties[0], widgetInfo, idPrefix);
        }
        return js;
    }

    function createDefaultAttribute(name, widget, props) {
        if (!props.hasOwnProperty(name)) {
            const propDef = widget.properties.find(it => it.name === name);
            if (propDef !== undefined) {
                return `"${name}": ${Utils.parsePropertyValueForJS(propDef.defaultValue, propDef.type)},`;
            }
        }
        return '';
    }

    function structPropsToJs(properties, widgetInfo, idPrefix) {
        let js = '';
        for (let propName in properties) {
            const structPropInfo = widgetInfo.structuredproperties.find(prop => prop.name === propName);
            const idPrefixNew = `${idPrefix}_${propName}`;
            js += `"${propName}":{${structPropElementsToJs(properties[propName][0], structPropInfo, idPrefixNew)}},`;
        }
        return js;
    }

    function structPropElementsToJs(elements, structPropInfo, idPrefix) {
        if (!Array.isArray(elements.Element)) return '';
        return elements.Element.map(elem => `"${idPrefix}_${elem.$.id}":{${projectedPropsToJs(elem, structPropInfo, null).replace(/,$/, '')}}`).join(',');
    }

    function createStandardHtmlAttributes(elemName, fullWidgetId, widgetType, props) {
        let attributes = `id="${fullWidgetId}" data-brease-widget="${widgetType}"`;
        if (elemName === 'canvas') {
            if (props.width) {
                attributes += ` width="${props.width}"`;
            }
            if (props.height) {
                attributes += ` height="${props.height}"`;
            }
        }
        return attributes;
    }

    function createHtmlAttributes(attributes) {
        let html = '';
        for (let attrName in attributes) {
            if (attrName !== 'id' && attrName !== 'class' && attrName !== 'data-brease-widget' && !attrName.startsWith('data-instruction')) {
                html += ` ${attrName}="${attributes[attrName]}"`;
            }
        }
        return html;
    }

    function copyChildDOM(fullWidgetId, html) {
        html = cleanupChildDOM(html);
        const startIndex = html.indexOf('>') + 1;
        const endIndex = html.lastIndexOf('<');
        const inner = html.substring(startIndex, endIndex);
        return Utils.replaceAll(inner, '{WIDGET_ID}', fullWidgetId);
    }

    function cleanupChildDOM(dom) {
        return dom.replace(/(<html>[\s\S]*?<\/html>)|(<body>[\s\S]*?<\/body>)|(<head>[\s\S]*?<\/head>)|(<meta>[\s\S]*?<\/meta>)|(<link>[\s\S]*?<\/link>)|(<title>[\s\S]*?<\/title>)|(<base>[\s\S]*?<\/base>)|(<style>[\s\S]*?<\/style>)|(<script>[\s\S]*?<\/script>)|(<!--[\s\S]*?-->)/g, '');
    }
    
    module.exports = transformation;

})();
