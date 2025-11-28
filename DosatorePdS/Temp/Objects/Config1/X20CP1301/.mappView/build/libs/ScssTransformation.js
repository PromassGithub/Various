(function () {
    'use strict';
    
    const ScssWriter = require('../iat/ScssWriter');
    const Utils = require('../iat/utils');
    const widgetsDataCache = require('./WidgetsDataCache');

    const LF = '\n';
    const COWI_ID_PREFIX_PLACEHOLDER = '{ID_PREFIX}';
    const COWI_ID_PREFIX_SEPERATOR = 'Θ';
        
    // TODO: this class is a replacement of StyleBuilder.xslt
    // if we want to use this class for Contents, there are two features left to implement:
    // Structured Properties
    // Compound Widgets

    /**
    * module for transformation of content xml object to scss statements
    * @module libs/ScssTransformation
    */
    var transformation = {
        
        /**
        * @method widgetsToSass
        * Conversion of Widgets (from content xml) to scss 
        * @param {String} contentId
        * @param {Object} widgetsXMLNode
        * @param {Object} childInfos Infos about all child widgets; childInfos[widgetType] equals content of <Widget>.json
        * @return {String}
        */
        widgetsToSass: function (contentId, widgetsXMLNode, childInfos, childWidgetsList) {
            return `@import "mixins.scss";${LF}${recurseWidgets(contentId, widgetsXMLNode, childInfos, childWidgetsList)}`;
        }
    };

    // conversion of array StyleProperty to an object, for easier lookup if styleproperty exists
    function stylePropertyListToObject(ar) {
        var obj = {};
        if (Array.isArray(ar)) {
            ar.forEach(function (item) {
                let prop = item.$;
                let arStyle = item.StyleElement;
                obj[prop.name] = arStyle;
            }); 
        }
        return obj;
    }

    function containsStyleProperties(typeInfo) {
        return typeInfo && typeInfo.styleproperties;
    }

    function recurseWidgets(contentId, WidgetsNode, childInfos, childWidgetsList) {
        
        let out = '';
        if (Array.isArray(WidgetsNode[0].Widget)) {
            WidgetsNode[0].Widget.forEach(function (widgetNode) {
                const props = widgetNode.$;
                const styleId = `${contentId}_${props.id}`;
                const widgetType = props['xsi:type'];
                const typeInfo = childInfos[widgetType];

                out += projectedProps(styleId, props, typeInfo);
                // recursion for nested widgets
                if (widgetNode.Widgets) {
                    out += recurseWidgets(contentId, widgetNode.Widgets, childInfos, childWidgetsList);
                } else if (typeInfo && typeInfo.meta.isCompound) {
                    const css = widgetsDataCache.getContentCss(childWidgetsList[widgetType]); 
                    out += Utils.replaceAll(css, COWI_ID_PREFIX_PLACEHOLDER, `${styleId}${COWI_ID_PREFIX_SEPERATOR}`);
                }
                if (Array.isArray(widgetNode.Properties)) {
                    out += structProps(styleId, widgetNode.Properties[0], typeInfo);
                }
            }); 
        }
        return out; 
    }

    function projectedProps(styleId, props, typeInfo) {
        let out = '';
        if (containsStyleProperties(typeInfo)) {
            const arStyleProperty = typeInfo.styleproperties.StyleProperty;
        
            if (!typeInfo.objStyleProperty) {
            // cache this info to run the conversion only once per widget type
                typeInfo.objStyleProperty = stylePropertyListToObject(arStyleProperty); 
            }
            out += createDefault('width', arStyleProperty, props, styleId);
            out += createDefault('height', arStyleProperty, props, styleId);
            for (let propName in props) {
                const arStyle = typeInfo.objStyleProperty[propName];
                if (Array.isArray(arStyle)) {
                    const value = props[propName];
                    out += arStyle.map(style => {
                        return ScssWriter.createRule(value, style, styleId);
                    }).join('');
                }
            }
        }
        return out;
    }

    function structProps(styleId, properties, typeInfo) {
        let out = '';
        for (let propName in properties) {
            const structPropInfo = typeInfo.structuredproperties.find(prop => prop.name === propName);
            const idPrefix = `${styleId}_${propName}`;
            const elements = properties[propName];
            if (Array.isArray(elements[0].Element)) {
                out += elements[0].Element.map(elem => projectedProps(`${idPrefix}_${elem.$.id}`, elem.$, structPropInfo)).join('');
            }
        }
        return out;
    }

    function createDefault(name, arStyleProperty, props, styleId) {
        if (!props.hasOwnProperty(name)) {
            // todo use objStyleProperty for faster lookup?
            const propDef = arStyleProperty.find(prop => prop.$.name === name);
            if (propDef !== undefined) {
                const value = propDef.$.default;
                const arStyle = propDef.StyleElement;
                if (Array.isArray(arStyle)) {
                    return arStyle.map(style => {
                        return ScssWriter.createRule(value, style, styleId);
                    }).join('');
                }
            }
        }
        return '';
    }

    module.exports = transformation;

})();
