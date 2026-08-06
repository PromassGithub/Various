module.exports = function (grunt) {
    'use strict';
    
    const path = require('path'),
        libraryFiles = require('../libs/libraryFiles'),
        debug = false;
    /**
    * @method derived_library
    * Task to create widget library files for custom widget libraries.  
    * Widget library can contain all types of custom widgets: derived, compound and keyboard.
    * @iatStudioExposed
    * @param {String} libName name of widget library (e.g. "WidgetLib1")
    * @param {String} target directory in project where widget libraries are built (e.g. "C\\:/ASProjects/Trunk/CompoundDemo/Temp/mappView/Widgets")
    * @param {String} [BRVisu] (optional) directory of brease core in installed TP (e.g. "C\\:/Program Files/BrAutomation/AS4101/AS/TechnologyPackages/mappView/5.19.0/IATC/BRVisu") 
    */
    grunt.registerTask('derived_library', 'task to create widget library files for custom widget libraries', function (libName, target, BRVisu) {
        
        let libDirectory = path.resolve(target, libName);
        let arWidgets = libraryFiles.findWidgets(libDirectory);
        
        writeFile(path.resolve(libDirectory, 'WidgetLibrary.xmlschemaset'), libraryFiles.createWidgetLibrary(arWidgets));
        writeFile(path.resolve(libDirectory, 'WidgetStyles.xmlschemaset'), libraryFiles.createWidgetStyles(arWidgets, libDirectory));
        writeFile(path.resolve(libDirectory, 'WidgetEventsActions.xmlschemaset'), libraryFiles.createWidgetEventsActions(arWidgets));
        writeFile(path.resolve(libDirectory, 'WidgetLibrary.mapping'), libraryFiles.createWidgetLibraryMapping(arWidgets, libDirectory, BRVisu));

        grunt.log.ok(`library files created for "${libName}"`); 
    });

    function writeFile(filePath, content) {
        if (debug) {
            grunt.log.writeln(`write file: ${filePath}`, 'green');
        }
        grunt.file.write(filePath, content);
    }

};
