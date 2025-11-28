(function () {
    'use strict';

    const modulePath = require('path'),
        Utils = require('../iat/utils'),
        DataTypes = require('../iat/DataTypes');

    var patchXML = {

        /**
        * @method
        * @param {Object} compoundXML object with object represantation of cowi xml
        * @param {String} targetFolder folder where the cowi will be built
        * @param {String} libraryName name of widget library
        * @return {Object}
        */
        
        createWidgetObject: function (compoundXML, targetFolder, libraryName) {
            var obj = {
                name: compoundXML['$']['id'],
                library: libraryName
            };
            obj.dir = modulePath.resolve(targetFolder, obj.library + '/' + obj.name); //        <%targetFolder%>/widgetLibrary/widgetName
            obj.metaDir = modulePath.resolve(obj.dir, 'meta'); //                               <%targetFolder%>/widgetLibrary/widgetName/meta
            obj.metaClassPath = modulePath.resolve(obj.metaDir, obj.name); //                   <%targetFolder%>/widgetLibrary/widgetName/meta/widgetName
            obj.qualifiedName = 'widgets/' + obj.library + '/' + obj.name; //                   widgets/widgetLibrary/widgetName
            obj.filePath = 'widgets/' + obj.library + '/' + obj.name + '/' + obj.name; //       widgets/widgetLibrary/widgetName/widgetName
            obj.type = 'widgets.' + obj.library + '.' + obj.name; //                            widgets.widgetLibrary.widgetName

            obj.widgets = convertWidgets(compoundXML['Widgets']);

            obj.commonProps = {
                width: compoundXML['$']['width'],
                height: compoundXML['$']['height'],
                category: compoundXML['$']['category'],
                description: compoundXML['$']['description']
            };

            obj.customProps = convertProps(compoundXML['Properties']);
            obj.customEvents = convertEventActions(compoundXML['Events'], function (rawEvent) {
                var event = {};
                if (Array.isArray(rawEvent['Arguments'])) {
                    extend(event, convertArguments(rawEvent['Arguments']));
                } else if (Array.isArray(rawEvent['Mappings'])) {
                    event.mappings = rawEvent['Mappings'][0].Mapping;
                }
                if (Array.isArray(rawEvent['TriggerAction'])) {
                    event.triggerAction = rawEvent['TriggerAction'][0]['$'].name;
                }
                return event;
            });
            obj.customActions = convertEventActions(compoundXML['Actions'], function (rawAction) {
                var action = {};
                extend(action, convertArguments(rawAction['Arguments']));
                extend(action, convertActionMappings(rawAction['Mappings']));
                return action;
            });
            obj.eventBindings = compoundXML['EventBindings'];
            return obj;
        }
    };
    
    function convertWidgets(rawWidgets) {
        var widgets = {};
        if (Array.isArray(rawWidgets)) {
            var arWidgets = rawWidgets[0]['Widget'];
            if (Array.isArray(arWidgets)) {
                for (var i = 0; i < arWidgets.length; i += 1) {
                    var mainWidgets = arWidgets[i]['$'];
                    widgets[mainWidgets.id] = {
                        type: mainWidgets['xsi:type'],
                        id: mainWidgets.id
                    };
                    if (arWidgets[i]['Widgets']) {
                        extend(widgets, convertWidgets(arWidgets[i]['Widgets']));
                    }
                }
            }
        }
        return widgets;
    }
    
    function convertProps(arProperties) {
        var props = {};
        if (Array.isArray(arProperties)) {
            var arProps = arProperties[0]['Property'];
            if (Array.isArray(arProps)) {
                for (var i = 0; i < arProps.length; i += 1) {
                    var mainProps = arProps[i]['$'];
                    props[mainProps.name] = {
                        name: mainProps.name,
                        xsiType: mainProps['xsi:type'],
                        type: DataTypes.fullType(mainProps.type) || mainProps.type,
                        defaultValue: mainProps.defaultValue,
                        required: (mainProps.required === 'true' || mainProps.required === '1'),
                        readOnly: (mainProps.readOnly === 'true' || mainProps.readOnly === '1'),
                        localizable: (mainProps.localizable === 'true' || mainProps.localizable === '1'),
                        category: mainProps.category,
                        public: parsePublic(mainProps.public),
                        description: (arProps[i]['Description']) ? arProps[i]['Description'][0] : ''
                    };
                    if (props[mainProps.name].readOnly) {
                        props[mainProps.name].projectable = false;
                    }
                    if (mainProps.typeRefId) {
                        props[mainProps.name].typeRefId = mainProps.typeRefId;
                    }
                    if (mainProps.nodeRefId) {
                        props[mainProps.name].nodeRefId = mainProps.nodeRefId;
                    }

                    if (Array.isArray(arProps[i]['Mappings'])) {
                        props[mainProps.name].mappings = arProps[i]['Mappings'][0].Mapping;
                        props[mainProps.name].accumulatedMappings = accumulateMappings(Utils.deepCopy(arProps[i]['Mappings'][0].Mapping));
                    }
                    if (mainProps['xsi:type'] === 'LocalProperty') {

                        props[mainProps.name].changedEvent = mainProps.name + 'Changed';
                        if (Array.isArray(arProps[i]['Event'])) {
                            props[mainProps.name].changedEvent = arProps[i]['Event'][0]['$'].name;
                        }

                        props[mainProps.name].setAction = 'Set' + mainProps.name;
                        props[mainProps.name].getAction = 'Get' + mainProps.name;
                        if (Array.isArray(arProps[i]['Actions'])) {
                            var SetAction = arProps[i]['Actions'][0]['SetAction'];
                            if (SetAction) {
                                props[mainProps.name].setAction = SetAction[0]['$'].name; 
                            }
                            var GetAction = arProps[i]['Actions'][0]['GetAction'];
                            if (GetAction) {
                                props[mainProps.name].getAction = GetAction[0]['$'].name; 
                            }
                        }
                    }
                }
            }
        }
        return props;
    }

    function parsePublic(str) {
        if (str !== undefined) {
            return (str === 'true');
        } else {
            return false;
        }
    }

    function extend(obj1, obj2) {
        for (var key in obj2) {
            obj1[key] = obj2[key];
        }
    }

    function accumulateMappings(mappings) {
        var acm = {};
        if (Array.isArray(mappings)) {
            for (var i = 0; i < mappings.length; i += 1) {
                var mapping = mappings[i],
                    id = mapping['$'].widget;
                if (acm[id]) {
                    acm[id]['$'].property += ',' + mapping['$'].property;
                } else {
                    acm[id] = mapping;
                }
            }
            return objectValues(acm);
        } else {
            return [];
        }
    }
    
    function convertEventActions(raw, convertEntity) {
        var entities = {};
        if (Array.isArray(raw)) {
            var arEntities = raw[0][Object.keys(raw[0])[0]];
            if (Array.isArray(arEntities)) {
                for (var i = 0; i < arEntities.length; i += 1) {
                    var entity = arEntities[i]['$'];
                    entities[entity.name] = {
                        name: entity.name,
                        description: (arEntities[i]['Description']) ? arEntities[i]['Description'][0] : ''
                    };
                    if (convertEntity) {
                        extend(entities[entity.name], convertEntity(arEntities[i]));
                    }
                }
            }
        }
        return entities;
    }

    function convertArguments(rawArgs) {
        var obj = {};
        if (Array.isArray(rawArgs)) {
            obj.arguments = {};
            if (rawArgs[0]['Argument']) {
                for (const rawArg of rawArgs[0]['Argument']) {
                    obj.arguments[rawArg['$'].name] = {
                        name: rawArg['$'].name,
                        type: rawArg['$'].type,
                        optional: rawArg['$'].optional === 'true',
                        description: (rawArg['Description']) ? rawArg['Description'][0] : ''
                    };
                }
            }
        }
        return obj;
    }

    function convertActionMappings(rawMappings) {
        var action = {};
        if (Array.isArray(rawMappings)) {
            var arMappings = rawMappings[0].Mapping;
            action.rawMappings = arMappings;
            action.mappings = [];
            if (Array.isArray(arMappings)) {
                for (const rawMapping of arMappings) {
                    var mapping = {
                        widget: rawMapping['$'].widget,
                        action: rawMapping['$'].action
                    };
                    if (Array.isArray(rawMapping['Arguments'])) {
                        const arArgs = rawMapping['Arguments'][0]['Argument'];       
                        mapping.arguments = [];
                        for (const rawArg of arArgs) {
                            var arg = {
                                name: rawArg['$'].name,
                                mapTo: rawArg['$'].mapTo
                            };
                            mapping.arguments.push(arg);
                        }
                    }
                    action.mappings.push(mapping);
                }
            }
        }
        return action;
    }

    // polyfill for Object.values (available since node 7.0)
    function objectValues(obj) {
        return Object.keys(obj).map(key => obj[key]);
    }

    module.exports = patchXML;

})();
