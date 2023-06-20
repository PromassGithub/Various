define(['brease/controller/objects/PageType'], function (PageType) {
    
    'use strict';

    /**
    * @class brease.controller.libs.Utils
    * @extends Object
    * @singleton
    */

    var stylePattern = new RegExp('.*_style_.*'),
        executeScript = 'ev' + 'al'; // forces an indirect call in global context

    function isString(item) {
        return (typeof item === 'string' || item instanceof String);
    }

    var Utils = {

        /**
        * @method findLoaders
        * find system.widgets.ContentLoader in an HTMLElement  
        * returns an array of HTMLElements  
        * order of elements is inside-out, that is reversed to the order of querySelectorAll  
        * for nested ContentLoader elements, the parent ContentLoader has a higher index than the inner ContentLoader  
        * @param {HTMLElement} elem  
        * @return {HTMLElement[]}
        */
        findLoaders: function (elem) {
            
            if (elem && typeof elem.querySelectorAll === 'function') {
                var loaders = elem.querySelectorAll('.systemContentLoader'),
                    length = loaders.length;
                if (length > 0) {
                    var ret = new Array(length);
                    for (var i = 0; i < length; i += 1) {
                        ret[length - (i + 1)] = loaders[i];
                    }
                    return ret;
                }
            }
            return [];
        },

        resetContentControls: function (elem) {
            if (elem && typeof elem.querySelectorAll === 'function') {
                var elems = elem.querySelectorAll('.breaseContentControl');

                for (var i = 0; i < elems.length; i += 1) {
                    brease.uiController.callWidget(elems[i].id, 'reset');
                } 
            }
        },

        setPageStyle: function (styleName, container, type) {

            if (isString(styleName) && isString(type)) {
                var $el = $(container), //container is either a HTMLElement or an id-selector
                    styleClass = Utils.pageStyleName(styleName, type);
                if ($el.length > 0) {
                    if (type === PageType.DIALOG) {
                        $el = $el.closest('[data-brease-widget="widgets/brease/DialogWindow"]');
                    }
                    var classList = $el[0].classList;

                    if (classList.contains(styleClass) === false) {

                        for (var i in classList) {
                            if (stylePattern.test(classList[i])) {
                                $el.removeClass(classList[i]);
                            }
                        }
                        $el.addClass(styleClass);
                    } 
                }
            }
        },

        pageStyleName: function (styleName, type) {
            return 'system_brease_' + type + '_style_' + styleName;
        },

        /**
        * @method appendHTML
        * interpret a string as html and set it as innerHTML of an HTMLElement    
        * contained script tags are evaluated (in global scope) and removed after evaluation  
        * @param {HTMLElement} elem  
        * @param {String} html  
        */
        appendHTML: function (elem, html) {
            if (elem && elem.innerHTML !== undefined && isString(html)) {
                elem.innerHTML = html;
                var scripts = elem.querySelectorAll('script');
                for (var i = 0; i < scripts.length; i += 1) {
                    window[executeScript](scripts[i].textContent); // indirect call forces global scope
                    scripts[i].parentNode.removeChild(scripts[i]);
                }
            }
        },

        injectCSS: function (css) {
            var styleElement;
            if (isString(css)) {
                if (!this.headElem) {
                    this.headElem = document.getElementsByTagName('head')[0];
                }
                styleElement = document.createElement('style');
                styleElement.textContent = css;
                this.headElem.appendChild(styleElement); 
            }
            return styleElement;
        },

        forceRepaint: function (elem) {

            var css = elem.style.cssText;
            elem.style.cssText += ';transform:rotateZ(0deg)';
            // eslint-disable-next-line no-unused-expressions
            elem.offsetHeight;
            elem.style.cssText = css;
        }

    };

    return Utils;
});
