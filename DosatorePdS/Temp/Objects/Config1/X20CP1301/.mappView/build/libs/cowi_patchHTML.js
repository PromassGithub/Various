(function () {
    'use strict';

    const Utils = require('../iat/utils'),
        delimiter = 'Θ';

    var patchHTML = {

        /**
        * @method
        * @param {String} htmlString
        * @param {Object} compoundWidget
        * @param {String} compoundWidget.name
        * @param {Object} compoundWidget.customProps user defined properties of compoundWidget defined in <Property> tags
        * @return {String}
        */  
        run: function (htmlString, compoundWidget) {
            return addDefaultValuesOfCustomProps(replaceCoWiID(htmlString, compoundWidget), compoundWidget);
        }
    };
        
    function replaceCoWiID(htmlString, compoundWidget) {
        let idRegex1 = new RegExp('id="' + compoundWidget.name + '_', 'g'),
            idRegex2 = new RegExp('setOptions\\("' + compoundWidget.name + '_', 'g');
        
        htmlString = htmlString.replace(idRegex1, 'id="{COWI_ID}' + delimiter);
        htmlString = htmlString.replace(idRegex2, 'setOptions("{COWI_ID}' + delimiter);

        return htmlString;
    }
    
    function addDefaultValuesOfCustomProps(htmlString, compoundWidget) {
        let defaultValues = setDefaultValuesOfCustomProps(compoundWidget);
        if (htmlString.includes('</script>')) {
            return htmlString.replace(/<\/script>/, defaultValues + '</script>');
        } else {
            return htmlString + ((defaultValues !== '') ? `<script>${defaultValues}</script>` : '');
        }
    }
    
    function setDefaultValuesOfCustomProps(compoundWidget) {

        var js = '';

        for (var propName in compoundWidget.customProps) {
            var prop = compoundWidget.customProps[propName];

            if (Array.isArray(prop.mappings)) {

                var parsedDefaultValue = Utils.parseValueForJS(prop.defaultValue, prop.type),
                    strMapping = '';

                prop.mappings.forEach(function (mapping) {
                    var widgetId = mapping['$'].widget,
                        widgetProp = mapping['$'].property;

                    strMapping += ((strMapping !== '') ? ',' : '') + `{id:'{COWI_ID}${delimiter}${widgetId}',prop:'${widgetProp}'}`;
                });
                strMapping = '[' + strMapping + ']';

                js += `brease.setOptionsMapping('{COWI_ID}', '${prop.name}', ${strMapping}, ${parsedDefaultValue});\n`;
            }
        }

        return js;
    }

    module.exports = patchHTML;

})();
