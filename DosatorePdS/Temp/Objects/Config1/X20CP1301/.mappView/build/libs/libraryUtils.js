(function () {
    'use strict';

    function _patchPath(propName, propType, objProps, libraryName, moduleDataTypes) {
        if (objProps[propName] !== undefined) {
            if (moduleDataTypes.isPath(propType)) {
                objProps[propName] = libraryUtils.patchMediaPath(objProps[propName], libraryName);
            } else if (moduleDataTypes.isPathCollection(propType)) {
                objProps[propName] = libraryUtils.patchMediaPathCollection(objProps[propName], libraryName);
            }
        }
    }

    var libraryUtils = {

        patchMediaPath: function patchMediaPath(str, libraryName) {
            if (str.indexOf('LocalMedia/') === 0) {
                str = str.replace(/LocalMedia\//, 'LibraryMedia/' + libraryName + '/');
            } 
            return str;
        },
        
        patchMediaPathCollection: function patchMediaPathCollection(str, libraryName) {
            if (str.indexOf('\'LocalMedia/') !== -1) {
                str = str.replace(/'LocalMedia\//g, '\'LibraryMedia/' + libraryName + '/');
            }
            return str;
        },
        
        patchLocalMediaPath: function patchLocalMediaPath(objProps, widgetInfo, libraryName, moduleDataTypes) {

            if (widgetInfo && Array.isArray(widgetInfo.properties)) {
                widgetInfo.properties.forEach(function (prop) {
                    var propName = prop.name,
                        propType = prop.type;
                    _patchPath(propName, propType, objProps, libraryName, moduleDataTypes);
                }); 
            }
            if (widgetInfo && widgetInfo.styleproperties && Array.isArray(widgetInfo.styleproperties.StyleProperty)) {
                widgetInfo.styleproperties.StyleProperty.forEach(function (prop) {
                    var propName = prop.$.name,
                        propType = prop.$.type;
                    _patchPath(propName, propType, objProps, libraryName, moduleDataTypes);
                }); 
            }
            return objProps;
        }
    };

    module.exports = libraryUtils;

})();
