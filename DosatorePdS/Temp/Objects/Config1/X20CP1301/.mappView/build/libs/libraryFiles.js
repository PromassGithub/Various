(function () {
    'use strict';

    const path = require('path'),
        grunt = require('grunt'),
        widgetLibraryPrepare = require('../iat/widgetLibraryPrepare'),
        LF = '\n',
        TAB = '  ',
        debug = false;

    function getWidgetInfo(libDirectory, widgetName) {
        let infoPath = path.resolve(libDirectory, widgetName + '/meta/' + widgetName + '.json');
        return grunt.file.readJSON(infoPath); 
    }

    var libraryFiles = {
        LF: LF,
        TAB: TAB,

        findWidgets: function (libDirectory) {

            let arWidgets = grunt.file.expand({
                filter: function (widget) {
                    return grunt.file.isDir(widget);
                },
                cwd: libDirectory
            }, '*');
            if (debug) {
                grunt.log.writeln('widgets:' + JSON.stringify(arWidgets));
            }
            return arWidgets;
        },
        
        createWidgetLibrary: function (arWidgets) {
            return widgetLibraryPrepare.createSchemaset(arWidgets.map(function (item) {
                return item + '/meta/' + item + '.xsd';
            }), {
                format: { active: (arWidgets.length > 0), LF: LF, TAB: TAB },
                type: 'content'
            });
        },
        
        createWidgetStyles: function (arWidgets, libDirectory, injectedGrunt) {
            let localGrunt = injectedGrunt || grunt;
            return widgetLibraryPrepare.createSchemaset(arWidgets.map(function (item) {
                if (localGrunt.file.exists(libDirectory + '/' + item + '/meta/' + item + '_Styles.xsd')) { 
                    return item + '/meta/' + item + '_Styles.xsd'; 
                }
            }), {
                format: { active: (arWidgets.length > 0), LF: LF, TAB: TAB },
                type: 'styles'
            });
        },
        
        createWidgetEventsActions: function (arWidgets) {
            return widgetLibraryPrepare.createSchemaset(arWidgets.map(function (item) {
                return item + '/meta/' + item + '_EventsActions.xsd';
            }), {
                format: { active: (arWidgets.length > 0), LF: LF, TAB: TAB },
                type: 'eventbinding'
            });
        },

        createWidgetLibraryMapping: function (arWidgets, libDirectory, BRVisu) {
            // directory where to find WidgetLibraryBaseMapping
            let typesPath = path.resolve(BRVisu || grunt.config('basePath'), '../../Schemas/common/widgetTypes');
            if (debug) {
                grunt.log.writeln(('typesPath:' + typesPath).green);
            }
            let baseMapping = grunt.file.readJSON(path.resolve(typesPath, 'WidgetLibraryBaseMapping.json'));
            // array of json files of widgets of the library
            let arWidgetInfo = arWidgets.map(getWidgetInfo.bind(null, libDirectory));
            return libraryFiles.createMapping(arWidgetInfo, baseMapping);
        },
        
        // mapping of widget types to AS types for action arguments, e.g. "String" -> "ANY_STRING
        createMapping: function (arWidgetInfo, baseMapping) {
            let xml = `<?xml version="1.0" encoding="utf-8"?>${(arWidgetInfo.length > 0) ? LF : ''}<Mappings>${(arWidgetInfo.length > 0) ? LF : ''}`;
            arWidgetInfo.forEach(function (widgetInfo) {
                if (widgetInfo.methods) {
                    widgetInfo.methods.forEach(function (method) {
                        if (method.iatStudioExposed && method.parameter) {
                            method.parameter.forEach(function (param) { 
                                let paramName = `${widgetInfo.name}.Action.${method.name}.${param.name}`;
                                let type = baseMapping[param.type];
                                if (!type) {
                                    grunt.log.writeln((`unknown base type in ${paramName}`).yellow);
                                    type = 'ANY_STRING';
                                }
                                xml += `${TAB}<Mapping parameter="${paramName}" type="${type}"/>${LF}`;
                            });
                        }
                    });
                }
            });
            return xml + '</Mappings>' + LF;
        }
    };

    module.exports = libraryFiles;

})();
