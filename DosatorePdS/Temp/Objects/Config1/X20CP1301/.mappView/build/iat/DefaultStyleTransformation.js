(function () {
    'use strict';
        
    const ScssWriter = require('./ScssWriter');
    const LF = '\n';
    
    var defaultStyleTransformation = {

        /**
         * Create Widget_base scss from style default values
         * Replaces DefaultStyleTransformation.xslt
         * @param {String} name full object name (widgets.brease.Button, widgets.brease.OnlineChartHDA.XAxis)
         * @param {Object} widgetInfo widget json as object
         * @returns {String} scss ready for sass compiling
         */
        createBaseScss: function (name, widgetInfo) {
            let styleName = nameToStyleName(name);
            if (!widgetInfo.styleproperties) return '';
            let arStyleProperty = widgetInfo.styleproperties.StyleProperty;
            let baseStyle = '';
            if (Array.isArray(arStyleProperty) && arStyleProperty.length > 0) {
                baseStyle = `@mixin ${styleName}_base {${LF}${createDefaultEntries(arStyleProperty)}${LF}}${LF}${LF}`;
            }
            return `@import "mixins.scss";${LF}${baseStyle}`;
        },

        /**
         * Create Widget_default scss from widget_base scss 
         * Replaces DefaultStyleTransformation.xslt
         * @param {String} name full object name (widgets.brease.Button, widgets.brease.OnlineChartHDA.XAxis) 
         * @param {String} baseScss scss string
         * @returns {String} scss ready for sass compiling
         */
        createDefaultScss: function (name, baseScss) {
            let styleName = nameToStyleName(name);
            return `${baseScss}.${styleName}_style_default {${LF}@include ${styleName}_base${LF}}${LF}`;
        }
    };

    // widgets.libraryname.widgetname to widgets_libraryname_widgetname
    function nameToStyleName(name) {
        return name.replace(/\./g, '_'); 
    }

    function createDefaultEntries(styleProperties) {
        let out = '';
        for (let styleProperty of styleProperties) {
            if (styleProperty.$.default !== undefined && styleProperty.StyleElement !== undefined) {
                let value = styleProperty.$.default;
                out += styleProperty.StyleElement.map(style => {
                    return ScssWriter.createRule(value, style);
                }).join('');
            }
        }
        return out;
    }

    module.exports = defaultStyleTransformation;

})();
