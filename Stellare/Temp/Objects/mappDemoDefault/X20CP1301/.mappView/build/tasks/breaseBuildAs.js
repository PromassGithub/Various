/*global module*/
module.exports = function (grunt) {
    'use strict';

    grunt.registerTask('breaseBuildAs', 'necessary build step for Automation Studio', function () {

        grunt.file.setBase('.');
        grunt.task.run('csso:themes', 'breaseCsso', 'breaseRelease');
    });

};
