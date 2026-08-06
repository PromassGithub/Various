define(['brease/enum/Enum', 'brease/core/Utils'], function (Enum, Utils) {

    'use strict';

    /**
    * @class brease.core.ContainerUtils
    * @extends core.javascript.Object
    */
    var ContainerUtils = {};

    /**
    * @method inheritProperty
    * @static
    * Used to set a property of all child widgets to a certain value. (e.g.: property visible of container widget affects property parantVisibleState of child widgets)
    * @param {core.html.NodeList/core.jQuery} nodeList a list of HTMLElements
    * @param {String} property the name of the property to set
    * @param {Any} value the value of the property to set
    */
    ContainerUtils.inheritProperty = function (nodeList, property, value) {
        if (nodeList instanceof NodeList) {
            Array.prototype.forEach.call(nodeList, handleChild);
        } else if (nodeList instanceof $) {
            nodeList.each(function () {
                handleChild(this);
            });
        }

        function handleChild(elem) {
            if (setChildPropertyFailed.call(elem, property, value)) {
                brease.uiController.addWidgetOption(elem.id, property, value);
            }
        }
    };
    function setChildPropertyFailed(property, value) {
        return isChildInitializing.call(this) || callChildWidgetFailed.call(this, property, value);
    }
    function callChildWidgetFailed(property, value) {
        return brease.uiController.callWidget(this.id, Utils.setter(property), value) === null;
    }
    function isChildInitializing() {
        return brease.uiController.getWidgetState(this.id) < Enum.WidgetState.INITIALIZED;
    }
    return ContainerUtils;

});
