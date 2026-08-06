define(['DOMPurify', 'brease/enum/Enum'], function (DOMPurify, Enum) {

    'use strict';

    /**
    * @class brease.core.Utils
    * @extends core.javascript.Object
    */
    var jRegex = /'/g,
        Utils = {};

    Utils.defineProperty = function (obj, propName, propValue, enumerable, configurable, writable) {
        var config = {
            enumerable: (enumerable !== undefined) ? enumerable : true, // true if this property shows up during enumeration of the properties on the corresponding object.
            configurable: (configurable !== undefined) ? configurable : false, // true if the type of this property descriptor may be changed and if the property may be deleted from the corresponding object.
            writable: (writable !== undefined) ? writable : false, // true if the value associated with the property may be changed with an assignment operator.
            value: propValue
        };
        //console.log('defineProperty(' + propName + ')', config);
        Object.defineProperty(obj, propName, config);
    };

    /**
    * @method deepCopy
    * @static
    * Returns a deep copy of an object
    * @param {Object} obj
    * @return {Object} 
    */
    Utils.deepCopy = function (obj) {
        return _deepCopy(obj);
    };

    /**
    * @method extendDeepToNew
    * @static
    * Extends obj1 with properties of obj2  
    * If a property exists on both objects, it's overwritten with the value of obj2  
    * Array properties are handled like objects, means they are extended  
    * e.g.  
    * obj1   = {a: [1,2,3]}  
    * obj2   = {a: [5,4]}  
    * extend = {a: [5,4,3]}  
    * @param {Object} obj1
    * @param {Object} obj2
    * @return {Object} 
    */
    Utils.extendDeepToNew = function (obj1, obj2) {
        return _deepExtend(_deepCopy(obj1), obj2);
    };

    /**
    * @method extendOptionsToNew
    * @static
    * Extends obj1 with properties of obj2  
    * If a property exists on both objects, it's overwritten with the value of obj2 
    * If a property is an object, it's extended  
    * Array properties are handled like primitive datatypes, means they are overwritten  
    * e.g.  
    * obj1   = {a: [1,2,3]}  
    * obj2   = {a: [5,4]}  
    * extend = {a: [5,4]}  
    * e.g.  
    * obj1   = {a: {b:0}}  
    * obj2   = {a: {c:1}}  
    * extend = {a: {b:0, c:1}}  
    * @param {Object} obj1
    * @param {Object} obj2
    * @return {Object} 
    */
    Utils.extendOptionsToNew = function (obj1, obj2) {
        return _deepOptionsExtend(_deepCopy(obj1), obj2);
    };

    /**
    * @method extendOptions
    * @static
    * Extends obj1 with properties of obj2  
    * If a property exists on both objects, it's overwritten with the value of obj2  
    * Properties of type array and object are handled like primitive datatypes, means they are overwritten  
    * e.g.  
    * obj1   = {a: [1,2,3]}  
    * obj2   = {a: [5,4]}  
    * extend = {a: [5,4]}  
    * e.g.  
    * obj1   = {a: {b:0}}  
    * obj2   = {a: {c:1}}  
    * extend = {a: {c:1}}  
    * @param {Object} obj1
    * @param {Object} obj2
    * @return {Object} 
    */
    Utils.extendOptions = function (obj1, obj2) {
        return _optionsExtend(_deepCopy(obj1), obj2);
    };
        
    Utils.uniqueArray = function (arr) {
        if (!arr || typeof arr.filter !== 'function' || typeof arr.lastIndexOf !== 'function') {
            return arr;
        }
        return arr.filter(
            function (item, index, arr) { 
                return arr.lastIndexOf(item) === index;
            });
    };

    Utils.prependChild = function (container, child) {
        if (container instanceof Node === false) {
            throw new SyntaxError('first argument has to be of type Node');
        }
        if (child instanceof Node === false) {
            throw new SyntaxError('second argument has to be of type Node');
        }
        if (container.firstChild !== null) {
            container.insertBefore(child, container.firstChild);
        } else {
            container.appendChild(child);
        }
    };

    Utils.elemContains = function (container, child) {
        return $.contains(container, child);
    };

    /**
    * @method getPositionedParent
    * @static
    * Returns the closest positioned ancestor
    * @param {HTMLElement} elem
    * @return {HTMLElement}
    */
    Utils.getPositionedParent = function (elem) {
        var parentElement = elem.parentElement;
        while (parentElement && $.css(parentElement, 'position') === 'static') {
            parentElement = parentElement.parentElement;
        }
        // if we don't have a positioned parent container, then return the element of the root of the document.
        return parentElement || document.documentElement;
    };

    /**
    * @method parseElementData
    * @static
    * Method to parse JSON strings in data-attributes.  
    * Example:  
    *
    *       <div id='d01' data-brease-widget='DateTimeOutput' data-brease-options='{"date":{"pattern":"Y"}}'></div>
    *       <script>
    *       var options = Utils.parseElementData(document.getElementById('d01'), 'brease-options');
    *       </script>
    *
    * @param {HTMLElement} elem
    * @param {String} dataKey Is added to "data-", to build attribute name. E.g. "brease-options" gives "data-brease-options".
    * @return {core.javascript.Object}
    */
    Utils.parseElementData = function (elem, dataKey) {

        var attrName = 'data-' + dataKey,
            attrValue = elem.getAttribute(attrName);

        if (!attrValue) {
            return {};
        }
        var obj = Utils.parsePseudoJSON(attrValue, 'Illegal data in attribute ' + attrName + ' for widget ' + elem.id + ', widget will have default values!');
        
        return obj || {};

    };

    /**
    * @method parsePseudoJSON
    * @static
    * Method to parse JSON strings with reversed quotes.  
    * E.g. parsePseudoJSON("{'a':0,'b':'string'}")  
    * Returns undefined, if parsing fails  
    * @param {String} str
    * @param {String} message warn message if parsing fails; if this argument is undefined, the JS parse error is used as message
    * @return {core.javascript.Object}
    */
    Utils.parsePseudoJSON = function (str, message) {

        var obj;
        if (!Utils.isString(str)) {
            if (message) {
                console.iatWarn(message); 
            } else {
                console.iatWarn('SyntaxError: input (' + str + ') is not a string'); 
            }
            return obj;
        }
        try {
            return JSON.parse(str.replace(jRegex, '"'));
        } catch (error) {
            if (message) {
                console.iatWarn(message); 
            } else {
                console.iatWarn(error.toString()); 
            }
        }
        return obj;
    };

    // used for unit tests to provide the same date for functions which request date
    // e.g. in DateTimeoutput tests
    Utils.getActDate = function () {
        return new Date();
    };

    // used for unit tests to allow to spy on userAgent
    Utils.getUserAgent = function () {
        return navigator.userAgent;
    };

    var id = 1, 
        prefixPool = 'abcdefghijklmnopqrstuvwxyz';

    /**
    * @method uniqueID
    * @static
    * Returns an application wide unique ID. 
    * @param {String} [prefix]
    * @return {String}
    */
    Utils.uniqueID = function (prefix) {

        var pre = prefix || prefixPool[Math.ceil(Math.random() * 25)];
        id += 1;
        return pre + '_' + id;

    };

    /**
    * @method radToDeg
    * @static
    * Method to convert radian to degree. 
    * @param {Number} rad
    * @return {Number} degree
    */
    Utils.radToDeg = function (rad) {
        return (180 / Math.PI) * rad;
    };

    /**
    * @method degToRad
    * @static
    * Method to convert degree to radian. 
    * @param {Number} degree
    * @return {Number} rad
    */
    Utils.degToRad = function (degree) {
        return (degree / 180) * Math.PI;
    };

    Utils.isString = function (item) {
        return (typeof item === 'string' || item instanceof String);
    };

    Utils.isBoolean = function (value) {
        return value === true || value === false;
    };

    Utils.isBlank = function (item) {
        return (!item || /^\s*$/.test(item));
    };

    Utils.isWidget = function (obj) {
        return (obj && typeof obj._bind === 'function' && obj.settings !== undefined && obj.settings.className !== undefined && obj.settings.className.indexOf('widgets') !== -1);
    };

    Utils.isObject = function (item) {
        return (item instanceof Object);
    };

    Utils.isFunction = function (item) {
        return (typeof item === 'function');
    };

    Utils.isNumeric = function (item) {

        return !isNaN(item) && item !== '' && item !== true && item !== false && item !== null;
    };

    Utils.getter = function (attribute) {
        var data;
        if (this.isStructuredProperty(attribute)) {
            data = this.parseStructuredProperty(attribute);
            return _methodName('get', data.attribute);
        } else {
            return _methodName('get', attribute);
        }
    };

    Utils.setter = function (attribute) {
        var data;
        if (this.isStructuredProperty(attribute)) {
            data = this.parseStructuredProperty(attribute);
            return _methodName('set', data.attribute);
        } else {
            return _methodName('set', attribute);
        }
    };

    Utils.isStructuredProperty = function (attribute) {
        return attribute.indexOf('[') > 0;
    };
    /**
    * @method isPercentageValue
    * @static
    * Returns true if the passed value is a string and ends with %. Useful to check if a widget dimension is configured
    * in percent
    * @param {ANY} value
    * @return {Boolean} 
    */
    Utils.isPercentageValue = function (value) {
        return Utils.isString(value) && value.endsWith('%');
    };

    /**
    * @method getPercentageWidth
    * @static
    * Get width in px for a child element which has defined percentage width based on ancestor element.
    * I.e its used when parent element has width=auto so calculation has to be based on ancestor element.
    * @param {String} percentageWidth i.e '50%'
    * @param {Element} ancestor Base element for calculation
    * @return {Number} Floating point number
    */
    Utils.getPercentageWidth = function (percentageWidth, ancestor) {
        var computedStyle = getComputedStyle(ancestor);
        var border = parseInt(computedStyle.getPropertyValue('border-left-width'), 10) + parseInt(computedStyle.getPropertyValue('border-right-width'), 10);
        var padding = parseInt(computedStyle.getPropertyValue('padding-left'), 10) + parseInt(computedStyle.getPropertyValue('padding-right'), 10);
        var scaleFactor = Utils.getScaleFactor(ancestor);
        var innerWidth = ancestor.getBoundingClientRect().width - border * scaleFactor - padding * scaleFactor;
        return (parseInt(percentageWidth, 10) / 100) * innerWidth;
    };

    /**
    * @method parseStructuredProperty
    * @static
    * Returns additional information which instance and which 
    * attribute of the structured property was changed when 
    * receiving a value change from the server
    * @param {String} attribute
    * @return {Object}
    * @return {String} return.path
    * @return {String} return.instanceName
    * @return {String} return.attribute
    * @return {String} return.subAttribute
    */
    Utils.parseStructuredProperty = function (attribute) {
        var arrData = attribute.replace(/\].|\[/g, '|').split('|'),
            data = {
                path: '_' + arrData[0] + '_' + arrData[1],
                instanceName: arrData[1],
                attribute: arrData[0],
                subAttribute: arrData[2]
            };
        return data;
    };

    /**
   * @method getScaleFactor
   * @static
   * Returns the actual scale factor of an HTMLElement
   * @param {HTMLElement} elem
   * @return {Number} 
   */
    Utils.getScaleFactor = function (elem) {
        var factor = 1;
        if (elem instanceof Element && typeof elem.getBoundingClientRect === 'function') {
            var width = $(elem).outerWidth();
            if (width > 0) {
                factor = elem.getBoundingClientRect().width / width;
            }
        }
        return factor;
    };
    /**
    * @method getTransformedScaleFactor
    * @static
    * Returns the actual scale factor of an HTMLElement 
    * takes css transformations into account
    * @param {HTMLElement} elem
    * @return {Number} 
    */
    Utils.getTransformedScaleFactor = function (elem) {
        var factor = 1;
        if (elem instanceof Element && typeof window.getComputedStyle === 'function' && typeof elem.getBoundingClientRect === 'function') {
            // var transform = window.getComputedStyle(elem, null).getPropertyValue('transform'),
            //    matrix = transform.indexOf('matrix') !== -1 ? transform.replace(/matrix|\(|\)|\s/gi, '').split(',') : [],
            var matrix = Utils.getMatrix(elem),
                width = $(elem).outerWidth();
            // for rotation of 90deg or 270deg getBoundingClientRect().height
            // will contain the width value of the element for calculation
            if (matrix[1] === '1' || matrix[1] === '-1') {
                if (width > 0) {
                    factor = elem.getBoundingClientRect().height / width;
                }
            } else if (width > 0) {
                factor = elem.getBoundingClientRect().width / width;
            }
        }
        return factor;
    };
    /**
    * @method getMatrix
    * @static
    * Returns the actual matrix of an HTMLElement 
    * @param {HTMLElement} elem
    * @return {Number} 
    */
    Utils.getMatrix = function (elem) {
        var matrix,
            transform = window.getComputedStyle(elem, null).getPropertyValue('transform');
        matrix = transform.indexOf('matrix') !== -1 ? transform.replace(/matrix|\(|\)|\s/gi, '').split(',') : [];

        return matrix;
    };
    /**
    * @method closestWidgetElem
    * @static
    * Returns the closest HTMLElement which is a widget.  
    * Returns the HTMLElement itself, if it is a widget.  
    * Returns the root node, if no parent widget exists (document.body or documentFragment)  
    * @param {HTMLElement} elem
    * @return {core.html.Node} 
    */
    Utils.closestWidgetElem = function (elem) {

        if (Utils.hasClass(elem, 'breaseWidget')) {
            return elem;
        } else {
            var cur = elem, parent;
            while (cur !== document.body) {
                if (Utils.hasClass(cur, 'breaseWidget')) {
                    break;
                } else {
                    parent = cur.parentNode;
                    if (parent) {
                        cur = parent;
                    } else {
                        break;
                    }
                }
            }

            return cur;
        }
    };
    /**
    * @method getClosestDialogElem
    * @static
    * Returns the closest HTMLElement which is a dialog or generic dialog.  
    * Returns the HTMLElement itself, if it is a dialog or generic dialog.
    * Returns null if elem is not inside of a dialog or generic dialog
    * @param {HTMLElement} elem
    * @return {core.html.Node|null} 
    */
    Utils.getClosestDialogElem = function (elem) {
        var cur = elem,
            parent, result = null;
        if (!(cur instanceof HTMLElement)) {
            return result;
        } else {
            while (cur !== document.body) {
                if (Utils.hasClass(cur, 'breaseDialogWindow') || Utils.hasClass(cur, 'breaseGenericDialog')) {
                    result = cur;
                    break;
                } else {
                    parent = cur.parentNode;
                    if (parent) {
                        cur = parent;
                    } else {
                        break;
                    }
                }
            }
        }
        return result;
    };
    /**
    * @method parentWidgetElem
    * @static
    * Returns the closest parent node which is a widget.  
    * Returns undefined, if no parent widget exists.
    * @param {HTMLElement} elem
    * @return {core.html.Node} 
    */
    Utils.parentWidgetElem = function (elem) {

        var cur = elem, 
            parent, result;

        while (cur !== document.body && cur !== null) {
            parent = cur.parentNode;
            if (Utils.hasClass(parent, 'breaseWidget')) {
                result = parent;
                break;
            } else {
                cur = parent;
            }
        }

        return result;
    };

    /**
   * @method isSameWidgetElem
   * @static
   * Returns true if two nodes are part of the same widget
   * @param {HTMLElement} sourceElem
   * @param {HTMLElement} targetElem
   * @return {Boolean}
   */
    Utils.isSameWidgetElem = function (sourceElem, targetElem) {
        return Utils.closestWidgetElem(sourceElem) === Utils.closestWidgetElem(targetElem);
    };

    /**
    * @method getChromeScale
    * @static
    * Returns the actual scale factor of an HTMLElement and 1 for Chrome Browser >= 58
    * @param {HTMLElement} elem
    * @return {Number} 
    */
    Utils.getChromeScale = function (elem) {

        var userAgent = Utils.getUserAgent(),
            chromeIndex = userAgent.toLowerCase().indexOf('chrome'),
            isChrome = chromeIndex !== -1,
            majorVersion = 0;

        if (isChrome) {
            majorVersion = parseInt(userAgent.substring(chromeIndex + 7), 10);
        }
        if (isChrome && majorVersion >= 58) {
            return 1;
        } else {
            return Utils.getScaleFactor(elem);
        }
    };

    Utils.logError = function (e, method) {
        method = method || 'log';
        if (e.stack) {
            console[method]('%c' + e.stack, 'color:red;');
        } else if (e.name && e.message) {
            console[method]('%c' + e.name + ': ' + e.message, 'color:red;');
        } else if (e.message) {
            console[method]('%cError: ' + e.message, 'color:red;');
        } else {
            console[method]('%cError in try/catch; log trace for more info', 'color:red;');
        }
    };

    Utils.getStylesheetByHref = function (href) {
        var stylesheet;
        if (href !== '') {
            for (var i = 0; i < document.styleSheets.length; i += 1) {
                if (document.styleSheets[i].href && document.styleSheets[i].href.indexOf(href) !== -1) {
                    stylesheet = document.styleSheets[i];
                    break;
                }
            }
        }
        return stylesheet;
    };

    var methodReg = /\(([\s\S]*?)\)/;

    Utils.getFunctionArguments = function getFunctionArguments(func) {
        if (typeof func !== 'function') {
            throw new SyntaxError('argument has to be of type function');
        }
        var params = methodReg.exec(func);

        if (params && params[1] !== '') {
            return params[1].replace(/ /g, '').split(',');
        } else {
            return [];
        }
    };

    Utils.getOriginalEvent = function (e) {
        var events = [e];
        while (e && typeof e.originalEvent !== 'undefined') {
            // break circular reference of originalEvent (happens with jquery.click())
            if (events.indexOf(e.originalEvent) !== -1) {
                return e;
            }
            events.push(e.originalEvent);
            e = e.originalEvent;
        }
        return e;
    };

    Utils.getPointerId = function (e) {
        var pointerId;
        if (e.detail && e.detail.pointerId !== undefined) {
            pointerId = e.detail.pointerId;
        } else {
            var oE = Utils.getOriginalEvent(e);
            if (oE.pointerId !== undefined) {
                pointerId = oE.pointerId;
            } else if (oE.changedTouches && oE.changedTouches.length > 0) {
                pointerId = oE.changedTouches[0].identifier;
            }
        }
        return pointerId;
    };
    /**
    * @method getWidgetId
    * @static
    * Method to retrieve the widget id without the content id prefix
    * @param {String} contentId // content the widget belongs to
    * @param {String} widgetId  // id of the widget
    * @return {String}
    */
    Utils.getWidgetId = function (contentId, widgetId) {
        var result = widgetId;
        if (typeof widgetId.indexOf === 'function' && widgetId.indexOf(contentId) === 0) {
            result = widgetId.slice(((contentId.length > 0) ? 1 + contentId.length : 0), widgetId.length);
        }
        return result;
    };

    Utils.getOffsetOfEvent = function (e) {

        var originalEvent = Utils.getOriginalEvent(e),
            offset = { x: 0, y: 0 };

        if (originalEvent.changedTouches !== undefined && originalEvent.changedTouches.length > 0) {
            var touch0 = originalEvent.changedTouches[0];
            if (touch0.pageX !== undefined) {
                offset.x = touch0.pageX; 
            }
            if (touch0.pageY !== undefined) {
                offset.y = touch0.pageY; 
            }
        } else if (originalEvent.pageX !== undefined) {
            offset.x = originalEvent.pageX;
            offset.y = originalEvent.pageY;
        }
        //console.log('getOffsetOfEvent:', offset);
        return offset;
    };

    Utils.hasClass = function (elem, cssClass) {
        return elem !== null && elem !== undefined && ((elem.className !== undefined && typeof elem.className.indexOf === 'function' && elem.className.indexOf(cssClass) !== -1) || (elem.classList !== undefined && elem.classList.value !== undefined && elem.classList.value.indexOf(cssClass) !== -1));
    };

    /**
    * @method addClass
    * @static
    * Method to add the specified class to a HTMLElement
    * @param {HTMLElement} node
    * @param {String} className
    */
    Utils.addClass = function (node, className) {
        var current = '';
        if (node && typeof node.getAttribute === 'function' && typeof node.setAttribute === 'function' && Utils.isString(className)) {
            var act = node.getAttribute('class');
            if (act) {
                current = '' + act;
            }
            if (current !== '') {
                if (current.split(' ').indexOf(className) === -1) {
                    node.setAttribute('class', current + ' ' + className);
                }
            } else {
                node.setAttribute('class', className);
            }
        }
    };

    /**
    * @method removeClass
    * @static
    * Method to remove the specified class to a HTMLElement
    * @param {HTMLElement} node
    * @param {String} className
    */
    Utils.removeClass = function (node, className) {
        var current = '';
        if (node && typeof node.getAttribute === 'function' && typeof node.setAttribute === 'function' && Utils.isString(className)) {
            var tmp = node.getAttribute('class');
            if (tmp) {
                current = '' + tmp;
            }
            if (current !== '') {
                if (current.indexOf(' ') !== -1) {
                    var classNames = ('' + current).split(' '),
                        index = classNames.indexOf(className);
                    while (index !== -1) {
                        classNames.splice(index, 1);
                        index = classNames.indexOf(className);
                    }
                    node.setAttribute('class', classNames.join(' '));
                } else if (current === className) {
                    node.setAttribute('class', '');
                }
            }
        }
    };

    /**
    * @method removeClassByRegExp
    * @static
    * Method to remove the class with a specified prefix to a HTMLElement
    * @param {HTMLElement} node
    * @param {RegEx} regExp
    */
    Utils.removeClassByRegExp = function (node, regExp) {
        if (node && typeof node.getAttribute === 'function' && typeof node.setAttribute === 'function' && typeof node.hasAttribute === 'function') {
            if (node.hasAttribute('class')) {
                var current = node.getAttribute('class'),
                    regExps = current.match(regExp);
                if (regExps !== null) {
                    node.setAttribute('class', current.replace(regExps[0], ''));
                }
            }
        }
    };

    Utils.arrayToObject = function (arr, prop) {
        if (!Array.isArray(arr)) {
            throw new SyntaxError('first argument has to be of type Array');
        }
        if (prop !== undefined && !Utils.isString(prop)) {
            throw new SyntaxError('second argument has to be of type String');
        }
        var obj = {},
            item, key;
        for (var i = 0, l = arr.length; i < l; i += 1) {
            item = arr[i];
            key = (prop !== undefined && item[prop] !== undefined) ? item[prop] : '' + i;
            obj[key] = item;
        }
        return obj;
    };

    Utils.transferProperties = function (source, target, keys) {
        if (!Utils.isObject(source)) {
            throw new SyntaxError('first argument has to be of type Object');
        }
        if (!Utils.isObject(target)) {
            throw new SyntaxError('second argument has to be of type Object');
        }
        if (!Array.isArray(keys)) {
            throw new SyntaxError('third argument has to be of type Array');
        }
        for (var i = 0, len = keys.length; i < len; i += 1) {
            target[keys[i]] = source[keys[i]];
        }
    };

    Utils.ensureVisuId = function (visuId) {
        return Utils.isString(visuId) ? visuId.toLowerCase() : visuId;
    };

    /**
    * @method getHighestZindex
    * @static
    * Returns the maximum z-index of a NodeList or jquery collection
    * @param {core.html.NodeList/core.jQuery} nodeList
    * @return {Integer} 
    */
    Utils.getHighestZindex = function (nodeList) {

        var maxIndex = 0,
            actIndex = 0,
            l = nodeList.length;

        for (var i = l - 1; i >= 0; i -= 1) {
            actIndex = parseFloat(Utils.getCSSValue(nodeList[i], 'z-index'));
            if (actIndex > maxIndex) {
                maxIndex = actIndex;
            }
        }

        return maxIndex;
    };

    /**
    * @method getDimension
    * @static
    * Returns the width and height of an element
    * @param {core.jQuery} el
    * @return {Object} 
    */
    Utils.getDimension = function (el) {
        var elem,
            style,
            compWidth,
            compHeight,
            dimension = {
                width: 0,
                height: 0
            };
        if (el && typeof el.get === 'function') {
            elem = el.get(0);
        }
        if (elem && elem.nodeType === 1) {
            style = window.getComputedStyle(elem, null);
            compWidth = parseFloat(style.getPropertyValue('width'));
            compHeight = parseFloat(style.getPropertyValue('height'));
            dimension.width = isNaN(compWidth) ? el.innerWidth() : compWidth;
            dimension.height = isNaN(compHeight) ? el.innerHeight() : compHeight;
        }

        return dimension;
    };

    Utils.getCSSValue = function (node, propName) {
        return window.getComputedStyle(node).getPropertyValue(propName);
    };

    Utils.isVisible = function (elem) {
        return !!(elem.offsetWidth || elem.offsetHeight || elem.getClientRects().length) && window.getComputedStyle(elem).visibility !== 'hidden';
    };

    Utils.addTimestamp = function (url) {
    
        url += ((url.indexOf('?') !== -1) ? '&' : '?') + 't=' + Date.now();
        return url;
    };

    /**
    * @method roundTo
    * Returns the value of a number rounded to decimalPlaces.    
    * e.g. roundTo(5.092, 1) = 5.1  
    * e.g. roundTo(-5.092, 1) = -5.1  
    * roundTo behaves like Math.round: when the fractional portion is exactly 0.5, the argument is rounded to the next integer in the direction of +∞.  
    * (see <a href="https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Math/round" target="_blank" style="text-decoration:underline;">Math.round</a>)  
    * e.g. roundTo(+2.15,1) = 2.2  
    * and  roundTo(-2.15,1) = 2.1  
    * @param {Number} value
    * @param {Integer} decimalPlaces positive integer >= 0
    * @return {Number}
     */
    Utils.roundTo = function (value, power) {
        if (isNaN(value) || isNaN(power)) {
            return NaN;
        }
        if (value === 0) {
            return value;
        }
        power = Math.max(0, parseInt(power, 10));
        
        // we use Math.round(value+'e'+power) if possible instead of Math.round(value*Math.pow(10, power)), as it is more exact
        var round = Math.round(value + 'e' + power),
            factor = Math.pow(10, power);

        if (isNaN(round)) {
            return Math.round(value * factor) / factor; 
        } else {
            return round / factor; 
        }
    };

    Utils.fileTimeToDate = function (fileTime) {
        return new Date(fileTime / 1e4 - 11644473600000);
    };

    Utils.fileTimeFromDate = function (date) {
        return date.getTime() * 1e4 + 116444736000000000;
    };

    /**
    * @method parseJSON
    * @static
    * Method to parse a JSON string and avoid throwing a Syntax error for invalid string
    * @param {String} str
    * @return {Object} 
    * @return {Object} return.obj contains the parsed object, if parsing is successful
    * @return {String} return.error contains the error message, if parsing fails
    */
    Utils.parseJSON = function (str) {
        var result = {};
        try {
            result.obj = JSON.parse(str);
        } catch (e) {
            result.error = e.toString();
        }
        return result;
    };

    /**
    * @method getBackgroundImageUrl
    * @static
    * Get the url of the background-image css property of an HTMLElement
    * @param {HTMLElement} elem
    * @return {String}
    */
    Utils.getBackgroundImageUrl = function (elem) {
        if (!elem || typeof elem.getAttribute !== 'function') {
            return undefined;
        }
        var css = $(elem).css('background-image');
        if (!Utils.isString(css) || css.indexOf('url') !== 0) {
            return undefined;
        }
        return css.match(/url\([^)]+\)/gi)[0].split(/[()'"]+/)[1];
    };

    /**
    * @method getBRPanelType
    * @static
    * Get the B&R panel type out of the userAgent string.  
    * Typical return values: 'PPT30', 'PPT50', 'PPC50', etc.  
    * @param {String} userAgent userAgent string from navigator.userAgent
    * @return {String}
    */
    Utils.getBRPanelType = function (userAgent) {
        userAgent = '' + userAgent;
        var BR = userAgent.indexOf('BRPanel'),
            type;

        if (BR !== -1) {
            type = userAgent.substring(userAgent.indexOf('BRPanel'));
            type = type.substring(type.indexOf('(') + 1, type.indexOf(';'));
        }
        return type;
    };

    /**
    * @method isT30
    * @static
    * @param {String} userAgent userAgent string from navigator.userAgent
    * @return {Boolean}
    */
    Utils.isT30 = function (userAgent) {
        return Utils.getBRPanelType(userAgent) === 'PPT30';
    };

    /**
    * @method hasSameOrigin
    * @static
    * Checks if the url has the same origin as baseURL.
    * Can be used to block requests to thrid party servers.
    * @param {String} src any url
    * @return {Boolean}
    */
    Utils.hasSameOrigin = function (src) {
        return new URL(document.baseURI).origin === new URL(src, document.baseURI).origin;
    };

    /**
     * @method sanitizeHtml
     * @static
     * You can feed it with a string/node full of dirty HTML and it will return a string/node (unless configured otherwise) with clean HTML. 
     * It will strip out everything that contains dangerous HTML and thereby prevent XSS attacks and other nastiness.
     * The provided node will be santized "in place" so the original node is returned. Make sure this node is not attached to the dom before sanitize!
     * Removed items will be logged.
     * This method does nothing if config.WidgetData.securityPolicy=Enum.SecurityPolicy.OFF - dirty html is returned!
     * @param {String|core.html.Node} dirty string or DOM node
     */
    Utils.sanitizeHtml = function (dirty) {
        if (brease.config.WidgetData.securityPolicy === Enum.SecurityPolicy.OFF) {
            return dirty;
        }
        var options = {
            ADD_TAGS: ['foreignObject']
        };
        if (dirty instanceof Node) {
            options.IN_PLACE = true;
            options.RETURN_DOM = true;
        }
        var sanitized = DOMPurify.sanitize(dirty, options);

        if (DOMPurify.removed.length) {
            _logSanitizeHtmlWarning();
        }
        return sanitized;
    };

    /**
     * @method createNullObjectFromPrototype
     * @static
     * Create a null object from an object.
     * The returned object has empty (dummy) methods instead of the objects methods!
     * ATTENTION: The null object is not a complete copy or mock object, as all methods have no return value and the object does not mirror object properties.
     * @param {Object} obj
     * @return {Object}
     */
    Utils.createNullObject = function (obj) {
        var nullObject = {};
        if (obj) {
            for (var key in obj) {
                if (typeof obj[key] === 'function') {
                    nullObject[key] = function () {};
                }
            } 
        }
        return nullObject;
    };

    function _logSanitizeHtmlWarning() {
        var code = Enum.EventLoggerId.DOCUMENT_CONTENT_SANITIZED;
        var verboseLevel = Enum.EventLoggerVerboseLevel.OFF;
        var severity = Enum.EventLoggerSeverity.WARNING;
        var nodeType = DOMPurify.removed[0].element ? 'element' : 'attribute';
        var nodeName = DOMPurify.removed[0][nodeType].localName;
        brease.loggerService.log(code, Enum.EventLoggerCustomer.BUR, verboseLevel, severity, [nodeType, nodeName]);
    }

    function _methodName(prefix, attribute) {
        return prefix + attribute.substring(0, 1).toUpperCase() + attribute.substring(1);
    }

    function _deepCopy(o) {
        // faster than $.extend and JSON.parse/stringify
        var newO;

        if (typeof o !== 'object') {
            return o;
        } else if (Utils.isString(o)) {
            return o.valueOf();
        }
        if (!o) {
            return o;
        }

        if (Array.isArray(o)) {
            newO = [];
            for (var i = 0, l = o.length; i < l; i += 1) {
                newO[i] = _deepCopy(o[i]);
            }
            return newO;
        }

        newO = {};
        for (var k in o) {
            newO[k] = _deepCopy(o[k]);
        }
        return newO;
    }

    function _deepExtend(o1, o2) {

        if (o1 !== undefined && o1 !== null) {
            var k, p;
            for (k in o2) {
                p = o2[k];
                if (p !== undefined) {
                    if (typeof p !== 'object' || p === null) {
                        o1[k] = p;

                    } else if (Array.isArray(p)) {
                        if (!Array.isArray(o1[k])) {
                            o1[k] = _deepCopy(p);
                        } else {
                            _arrayExtend(o1[k], p);
                        }
                    } else {
                        if (o1[k] === undefined) {
                            o1[k] = _deepCopy(p);
                        } else {
                            o1[k] = _deepExtend(o1[k], p);
                        }
                    }
                }
            }
            return o1;
        } else {
            if (o2 !== undefined) {
                return o2;
            } else {
                return o1;
            }
        }
    }

    function _arrayExtend(a1, a2) {
        for (var i = 0, l = a2.length; i < l; i += 1) {
            if (a2[i] !== undefined) {
                if (typeof a2[i] !== 'object' || a2[i] === null) {
                    a1[i] = a2[i];
                } else {
                    a1[i] = _deepExtend(a1[i], a2[i]);
                }
            }
        }
    }

    function _deepOptionsExtend(o1, o2) {

        if (o1 !== undefined && o1 !== null) {
            var k, p;
            for (k in o2) {
                p = o2[k];
                if (p !== undefined) {
                    if (typeof p !== 'object' || p === null) {
                        o1[k] = p;

                    } else if (Array.isArray(p)) {
                        o1[k] = _deepCopy(p);
                    } else {
                        if (o1[k] === undefined) {
                            o1[k] = _deepCopy(p);
                        } else {
                            o1[k] = _deepExtend(o1[k], p);
                        }
                    }
                }
            }
            return o1;
        } else {
            if (o2 !== undefined) {
                return o2;
            } else {
                return o1;
            }
        }
    }

    function _optionsExtend(obj1, obj2) {

        if (obj1 !== undefined && obj1 !== null) {
            for (var key2 in obj2) {
                var prop2 = obj2[key2];
                if (prop2 !== undefined) {
                    obj1[key2] = _deepCopy(prop2);
                }
            }
            return obj1;
        } else {
            if (obj2 !== undefined) {
                return _deepCopy(obj2);
            } else {
                return obj1;
            }
        }
    }

    return Utils;

});
