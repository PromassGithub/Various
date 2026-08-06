module.exports = function (grunt) {
    'use strict';
    
    const path = require('path'),
        libraryFiles = require('../libs/libraryFiles'),
        compoundBuilder = require('../libs/CompoundBuilder'),
        derivedBuilder = require('../libs/DerivedBuilder'),
        keyboardBuilder = require('../libs/KeyboardBuilder'),
        buildJson = 'build.json',
        buildReportJson = 'buildReport.json';

    /**
    * @method libraryBuild
    * Task to create all widgets and library files for customized widget libraries.  
    * Widget library can contain all types of customized widgets: derived, compound and keyboard.
    * All file paths to input files and folders are provided via build.json file.
    * If there is an error during building a widget it will be reported via buildReport.json and the widget gets removed from the library.
    * @iatStudioExposed
    * @param {String} srcFile path to build.json
    */
    grunt.registerTask('libraryBuild', 'task to create customized widgets library including all widgets', function (srcFile) {
        grunt.file.defaultEncoding = 'utf8';

        let buildCfg = createBuildConfig(srcFile);
        let keyBoardErrors = keyboardBuilder.create(buildCfg);
        let derivedErrors = derivedBuilder.create(buildCfg).concat(keyBoardErrors);
        let errors = compoundBuilder.create(buildCfg).concat(derivedErrors);

        buildCfg.libs.forEach(lib => {
            let libDirectory = path.resolve(buildCfg.targetFolder, lib.name);
            let arWidgets = libraryFiles.findWidgets(libDirectory);
            
            grunt.file.write(path.resolve(libDirectory, 'WidgetLibrary.xmlschemaset'), libraryFiles.createWidgetLibrary(arWidgets));
            grunt.file.write(path.resolve(libDirectory, 'WidgetStyles.xmlschemaset'), libraryFiles.createWidgetStyles(arWidgets, libDirectory));
            grunt.file.write(path.resolve(libDirectory, 'WidgetEventsActions.xmlschemaset'), libraryFiles.createWidgetEventsActions(arWidgets));
            grunt.file.write(path.resolve(libDirectory, 'WidgetLibrary.mapping'), libraryFiles.createWidgetLibraryMapping(arWidgets, libDirectory, buildCfg.corePath));
    
            grunt.log.ok(`library files created for "${lib.name}"`); 
        });
        grunt.file.write(buildCfg.reportFile, JSON.stringify(errors));
    });

    function createBuildConfig(srcFile) {
        let buildCfg;
        try {
            buildCfg = grunt.file.readJSON(srcFile);
            buildCfg.reportFile = srcFile.replace(buildJson, buildReportJson);
            if (grunt.file.exists(buildCfg.reportFile)) {
                grunt.file.delete(buildCfg.reportFile, { force: true });
            }
        } catch (err) {
            grunt.fail.fatal(err);
        }
        buildCfg.targetFolder = (buildCfg.targetFolder && buildCfg.targetFolder !== 'null') ? buildCfg.targetFolder : path.resolve(grunt.config('wwwRoot'), '/BRVisu/widgets');
        buildCfg.corePath = (buildCfg.corePath && buildCfg.corePath !== 'null') ? buildCfg.corePath : path.resolve(grunt.config('basePath'), '../BRVisu');
        buildCfg.customWidgets = (!buildCfg.customWidgets || buildCfg.customWidgets === 'null') ? path.resolve(buildCfg.targetFolder, '../../../Logical/mappView/Widgets') : buildCfg.customWidgets; // ATTENTION: this is an assumption, which could change in future
        buildCfg.derivedWidgets = (!buildCfg.derivedWidgets || buildCfg.derivedWidgets === 'null') ? buildCfg.targetFolder : buildCfg.derivedWidgets;
        buildCfg.breaseWidgets = (buildCfg.corePath.indexOf('wwwRoot') !== -1) ? path.resolve(buildCfg.corePath, 'widgets') : path.resolve(buildCfg.corePath, '../../Widgets'); // ATTENTION: this is an assumption, which could change in future
        return buildCfg;
    }
};
