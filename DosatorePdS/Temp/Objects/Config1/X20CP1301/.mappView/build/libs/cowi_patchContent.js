(function () {
    'use strict';
    
    const libraryUtils = require('../libs/libraryUtils'),
        utils = require('../iat/utils'),
        DataTypes = require('../iat/DataTypes');
    
    function _findPropertyDefinition(propName, widgetInfo) {
        if (widgetInfo && Array.isArray(widgetInfo.properties)) {
            return widgetInfo.properties.find(it => it.name === propName); 
        }
    }

    function _patchDefaultValuesOfCommonProperties(widgetProps, widgetInfo) {   
        if (widgetProps.width === undefined) {
            let propDef = _findPropertyDefinition('width', widgetInfo);
            if (propDef) {
                widgetProps.width = propDef.defaultValue; 
            }
        }
        if (widgetProps.height === undefined) {
            let propDef = _findPropertyDefinition('height', widgetInfo);
            if (propDef) {
                widgetProps.height = propDef.defaultValue; 
            }
        }
    }

    function _patchWidgets(arWidgets, libraryName, childInfos) {
    
        if (Array.isArray(arWidgets[0].Widget)) {
            arWidgets[0].Widget.forEach(function (widgetNode) {
                let widgetProps = widgetNode['$'],
                    widgetType = widgetProps['xsi:type'],
                    widgetInfo = childInfos[widgetType];

                libraryUtils.patchLocalMediaPath(widgetProps, widgetInfo, libraryName, DataTypes);
                _patchDefaultValuesOfCommonProperties(widgetProps, widgetInfo);

                let arNestedWidgets = widgetNode.Widgets;
                if (Array.isArray(arNestedWidgets)) {
                    _patchWidgets(arNestedWidgets, libraryName, childInfos);
                }
            });
        }
        // remove strings in <Widgets>      </Widgets>
        if (utils.isString(arWidgets[0])) {
            arWidgets[0] = '';
        }
    }

    var patchCoWiContent = {

        run: function (WidgetsNode, libraryName, childInfos) {
            if (Array.isArray(WidgetsNode)) {
                _patchWidgets(WidgetsNode, libraryName, childInfos);
            }
        }
    };

    module.exports = patchCoWiContent;

})();
