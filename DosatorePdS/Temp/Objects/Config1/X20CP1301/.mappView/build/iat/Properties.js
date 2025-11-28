(function () {

    'use strict';

    var Properties = {

            /**
         * Get info about a property defined in BaseWidget.
         * @param {String} name
         * @return {Object}
         */
            getBaseProp: function (name) {
                return _baseProp[name];
            },

            /**
         * Get names of all properties defined in BaseWidget.
         * @return {String[]}
         */
            getBasePropNames: function () {
                return Object.keys(_baseProp);
            }
        },
        _baseProp = {
            id: {
                type: 'WidgetId',
                use: 'required',
                hideable: false
            },
            enable: {
                type: 'Boolean',
                default: 'true',
                use: 'optional'
            },
            permissionOperate: {
                type: 'RoleCollection',
                use: 'optional'
            },
            permissionView: {
                type: 'RoleCollection',
                use: 'optional'
            },
            style: {
                type: 'StyleReference',
                default: 'default',
                use: 'optional'
            },
            tooltip: {
                type: 'String',
                default: '',
                use: 'optional'
            },
            visible: {
                type: 'Boolean',
                default: 'true',
                use: 'optional'
            },
            zIndex: {
                type: 'UInteger',
                use: 'required'
            },
            left: {
                type: 'Integer',
                use: 'optional'
            },
            top: {
                type: 'Integer',
                use: 'optional'
            },
            height: {
                type: 'AutoSize',
                use: 'optional'
            },
            width: {
                type: 'AutoSize',
                use: 'optional'
            },
            tabIndex: {
                type: 'Integer',
                use: 'optional'
            }
        };

    module.exports = Properties;

})();
