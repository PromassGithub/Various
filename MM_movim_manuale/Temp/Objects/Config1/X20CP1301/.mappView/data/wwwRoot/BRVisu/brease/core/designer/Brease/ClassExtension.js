define(['brease/core/Utils', 'brease/core/ClassUtils'], function (Utils, ClassUtils) {

    'use strict';

    /**
    * @class brease.designer.Brease.ClassExtension
    * @embeddedClass
    * @virtualNote 
    * Functionality of brease, available in editMode only. Available through the designer object of brease.
    *
    *       $.when(
    *           brease.designer.isWidgetAllowedIn('widgets.brease.Button','widgets.brease.GroupBox')
    *       ).then(function (result) {
    *           console.log(result);
    *       });
    *       
    * or
    *
    *       brease.designer.isWidgetAllowedIn('widgets.brease.Button','widgets.brease.GroupBox', function(result) {
    *           console.log(result);
    *       });
    *       
    */

    var _designer = {

        /**
        * @method isWidgetAllowedIn
        * @async
        * Async function to check if a widget allows another widget as child. Can be used with deferred object or callback.  
        * @param {WidgetType} childType
        * @param {WidgetType} parentType
        * @param {Function} [callback]
        * @return {Promise}
        */
        isWidgetAllowedIn: function (childType, parentType, callback) {

            var deferred = $.Deferred();

            var childClassInfoPath = ClassUtils.className2Path(childType, false, true) + '/designer/ClassInfo.js',
                parentClassInfoPath = ClassUtils.className2Path(parentType, false, true) + '/designer/ClassInfo.js';

            require([childClassInfoPath, parentClassInfoPath], function (childClassInfo, parentClassInfo) {

                _resolve(deferred, callback, _parentAllowsChild(parentClassInfo.meta, childClassInfo.meta) && _childAllowsParent(childClassInfo.meta, parentClassInfo.meta));
            });

            return deferred.promise();
        },

        /**
        * @method getInitialProperties
        * @async
        * Async function to get initial properties for widget instantiation on a position. Can be used with deferred object or callback.  
        * @param {Integer} x
        * @param {Integer} y
        * @param {WidgetType} widgetType
        * @param {Function} [callback]
        * @return {Promise}
        */
        getInitialProperties: function (x, y, widgetType, callback) {

            var deferred = $.Deferred();

            var classPath = ClassUtils.className2Path(widgetType, false),
                classInfoPath = ClassUtils.className2Path(widgetType, false, true) + '/designer/ClassInfo.js';

            require([classPath, classInfoPath], function (widgetClass, classInfo) {
                if (classInfo.classExtension && widgetClass.extended !== true) {
                    classInfo.classExtension.extend(widgetClass);
                }
                var result = widgetClass.static.getInitialProperties(x, y);
                _resolve(deferred, callback, result);
            });

            return deferred.promise();
        },

        /**
        * @method className2Path
        * Sync function to convert a widgetType in a file path.  
        * e.g. className2Path('widgets.brease.Button') = 'widgets/brease/Button/Button'  
        * e.g. className2Path('widgets.brease.Button', true) = 'widgets/brease/Button/Button.js'  
        * e.g. className2Path('widgets.brease.Button', false, true) = 'widgets/brease/Button'   
        * e.g. className2Path('widgets.brease.Button', true, true) = 'widgets/brease/Button' -> isDir outperforms includeExt
        * @param {WidgetType} widgetType 
        * @param {Boolean} includeExt include file extension
        * @param {Boolean} isDir return path to widget directory
        * @return {FilePath/DirectoryPath}
        */
        className2Path: function () {
            return ClassUtils.className2Path.apply(null, arguments);
        }
    };

    function _resolve(deferred, callback, result) {
        if (Utils.isFunction(callback)) {
            callback(result);
        }
        deferred.resolve(result);
    }

    function _parentAllowsChild(parentMeta, childMeta) {

        var allowedChildren = parentMeta.children,
            inheritance = childMeta.inheritance;

        if (allowedChildren.indexOf('*') !== -1) {
            return true;
        } else {
            var allowed = false;
            for (var i = 0; i < inheritance.length; i += 1) {
                if (allowedChildren.indexOf(inheritance[i]) !== -1) {
                    allowed = true;
                    break;
                }
            }
            return allowed;
        }
    }

    function _childAllowsParent(childMeta, parentMeta) {

        var allowedParents = childMeta.parents,
            requestedParent = parentMeta.className,
            allParentsAllowed = allowedParents.indexOf('*') !== -1,
            requestedParentAllowed = allowedParents.indexOf(requestedParent) !== -1,
            requestedParentSuperClassAllowed = false;

        // for derived widgets we have to look at the SuperClass of the parent too
        if (parentMeta.isDerived === true) {
            var parentSuperClass = parentMeta.inheritance[1];
            requestedParentSuperClassAllowed = allowedParents.indexOf(parentSuperClass) !== -1;
        }
        return allParentsAllowed || requestedParentAllowed || requestedParentSuperClassAllowed;
    }

    return {
        extend: function (brease) {
            brease.designer = _designer;
        }
    };

});
