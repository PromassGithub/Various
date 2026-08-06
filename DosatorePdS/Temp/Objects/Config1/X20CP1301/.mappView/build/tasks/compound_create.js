module.exports = function (grunt) {

    'use strict';

    const modulePath = require('path'),
        compoundBuilder = require('../libs/CompoundBuilder'),
        derivedBuilder = require('../libs/DerivedBuilder'),
        keyboardBuilder = require('../libs/KeyboardBuilder'),
        buildJson = 'build.json',
        buildReportJson = 'buildReport.json';

    /**
    * @method compound_create
    * @param {String} srcFile path to build.json  
    * format example at jsBuild/doc/build.exampleAS.json
    */
    grunt.registerTask('compound_create', 'task for creation of compound widgets', function (srcFile) {

        grunt.file.defaultEncoding = 'utf8';

        let buildCfg = createBuildConfig(srcFile);
        let keyBoardErrors = keyboardBuilder.create(buildCfg);
        let derivedErrors = derivedBuilder.create(buildCfg).concat(keyBoardErrors);
        let errors = compoundBuilder.create(buildCfg).concat(derivedErrors);

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
        buildCfg.targetFolder = (buildCfg.targetFolder && buildCfg.targetFolder !== 'null') ? buildCfg.targetFolder : modulePath.resolve(grunt.config('wwwRoot'), '/BRVisu/widgets');
        buildCfg.corePath = (buildCfg.corePath && buildCfg.corePath !== 'null') ? buildCfg.corePath : modulePath.resolve(grunt.config('basePath'), '../BRVisu');
        buildCfg.customWidgets = (!buildCfg.customWidgets || buildCfg.customWidgets === 'null') ? modulePath.resolve(buildCfg.targetFolder, '../../../Logical/mappView/Widgets') : buildCfg.customWidgets; // ATTENTION: this is an assumption, which could change in future
        buildCfg.derivedWidgets = (!buildCfg.derivedWidgets || buildCfg.derivedWidgets === 'null') ? buildCfg.targetFolder : buildCfg.derivedWidgets;
        buildCfg.breaseWidgets = (buildCfg.corePath.indexOf('wwwRoot') !== -1) ? modulePath.resolve(buildCfg.corePath, 'widgets') : modulePath.resolve(buildCfg.corePath, '../../Widgets'); // ATTENTION: this is an assumption, which could change in future
        return buildCfg;
    }
};
