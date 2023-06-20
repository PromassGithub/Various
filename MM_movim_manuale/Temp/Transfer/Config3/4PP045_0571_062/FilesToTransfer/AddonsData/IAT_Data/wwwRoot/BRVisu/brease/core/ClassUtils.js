define(['brease/core/Utils'], function (Utils) {

    'use strict';

    /**
    * @class brease.core.ClassUtils
    * @extends core.javascript.Object
    */
    var ClassUtils = {};

    function isCoreWidget(className) {
        return (typeof className.indexOf === 'function' && className.indexOf('brease.') === 0);
    }

    /**
    * @method className2Path
    * @static
    * Method to convert a className (fully qualified name in dot-notation) in a file path.  
    * e.g. className2Path('widgets.brease.Button') = 'widgets/brease/Button/Button'  
    * e.g. className2Path('widgets.brease.Button', true) = 'widgets/brease/Button/Button.js'  
    * e.g. className2Path('widgets.brease.Button', false, true) = 'widgets/brease/Button'   
    * e.g. className2Path('widgets.brease.Button', true, true) = 'widgets/brease/Button' -> isDir outperforms includeExt
    * @param {WidgetType} className
    * @param {Boolean} includeExt
    * @param {Boolean} isDir
    * @return {String}
    */
    ClassUtils.className2Path = function (className, includeExt, isDir) {
        if (!Utils.isString(className)) {
            return className;
        }
        var parts = className.split('.');
        if (parts.length < 3) {
            return className;
        }

        var path = className;

        if (isDir === true) {
            if (isCoreWidget(className)) {
                path = path.substring(0, path.lastIndexOf('.'));
            }
        } else {
            if (!isCoreWidget(className)) {
                path = path + '.' + parts[parts.length - 1];
            }
        }

        path = path.replace(/\./g, '/');
        if (isDir !== true && includeExt === true) {
            path += '.js';
        }
        return path;
    };

    /**
    * @method path2ClassName
    * @static
    * Method to convert a widget file path in a className (fully qualified name in dot-notation).  
    * e.g. path2ClassName('widgets/brease/Button') = 'widgets.brease.Button'  
    * e.g. path2ClassName('widgets.brease.Button/Button') = 'widgets.brease.Button'  
    * e.g. path2ClassName('widgets.brease.Button/Button.js') = 'widgets.brease.Button'   
    * @param {String} path
    * @return {WidgetType}
    */
    ClassUtils.path2ClassName = function (classPath) {
        
        if (!Utils.isString(classPath)) {
            return classPath;
        }
        if (classPath.indexOf('.js') !== -1) {
            classPath = classPath.substring(0, classPath.lastIndexOf('.'));
        }
        var parts = classPath.split('/');
        if (parts.length < 3) {
            return classPath;
        }
        parts.length = 3;

        return parts.join('.');

    };
    /**
    * @method isDerivedFrom
    * @static
    * Method to find out if a WidgetInstance inherits from a WidgetType (e.g. 'widgets.brease.Button')
    * @param {WidgetInstance} widget
    * @param {WidgetType} className
    * @return {Boolean}
    */
    ClassUtils.isDerivedFrom = function (widget, className) {
        return widget.settings.className === ClassUtils.className2Path(className, false, true) || (widget.constructor && widget.constructor.meta && widget.constructor.meta.inheritance && widget.constructor.meta.inheritance.indexOf(className) !== -1);
    };

    return ClassUtils;

});
