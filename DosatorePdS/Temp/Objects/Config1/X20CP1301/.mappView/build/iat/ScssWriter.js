(function () {
    'use strict';
        
    const LF = '\n',
        TAB = '\t';
        
    let scssWriter = {

        /**
         * Creates scss rules for indexed and normal styles.
         * @param {String} value style value 
         * @param {String} style single style element from widget json
         * @param {String} styleId (optional) creates a id selector for style
         * @returns {String} scss
         */
        createRule: function (value, style, styleId) {
            let attribute = style.$.attribute;
            let selector = style.$.selector;
            let indexed = style.$.indexed;
            let idsuffix = style.$.idsuffix || '';
            let rule = '';
            if (!indexed) {
                rule = `${selstart(selector)}${toCSSProperty(attribute, value, selector)}${LF}${selend(selector)}`; 
            } else {
                // ATTENTION: if the values of the list themselves contain ',', the pure splitting by ',' results in a wrong array (A&P 772955).
                // For ColorList, where rgb and rgba values are allowed, this is solved in replacing the values inside rgb() and rgba().
                // As Colors are the only values in CSS which can contain ',', this should be safe.
                // eslint-disable-next-line no-unused-vars
                rule = value.replace(/\([0-9, ]*\)/g, '').split(',').map((item, i) => {
                    // only length and index are relevant, the result statement takes the whole value and not item
                    let index = '' + (i + 1);
                    let sel = selector.replace(/\$index/g, index);
                    let attr = attribute.replace(/\$index/g, index);
                    return `${selstart(sel)}${toCSSProperty(attr, value, selector)}${LF}${selend(selector)}`;
                }).join('');
            }
            if (styleId) {
                rule = `#${styleId}${idsuffix} {${rule}}${LF}`; 
            }
            return rule;
        }
    };
        
    function toCSSProperty(attribute, value, selector) {
        let tab = selector ? TAB + TAB : TAB;
        if (attribute.includes('$value')) {
            return `${tab}${attribute.replace(/\$value/g, value)};`;
        } else {
            return `${tab}${attribute}: ${value};`;
        }
    }

    function selstart(selection) {
        return selection ? `${TAB}${selection} {${LF}` : '';
    }

    function selend(selection) {
        return selection ? `${TAB}}${LF}` : '';
    }

    module.exports = scssWriter;

})();
