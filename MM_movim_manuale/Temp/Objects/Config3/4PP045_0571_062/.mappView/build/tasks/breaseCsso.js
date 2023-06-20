/*global module*/
module.exports = function (grunt) {
    'use strict';

    var moduleRequire = require('a.require'),
        modulePath = require('path'),
        moduleFs = require('fs'),
        csshelper = moduleRequire('iat/libs/css_helper');

    const maxFileSize = 16000000; // use something smaller than 16MB to be sure

    grunt.registerTask('breaseCsso', 'adapter for css optimizer', function () {

        grunt.file.setBase('.');

        var basePath = grunt.config('basePath'),
            projectPath = grunt.config('projectPath'),
            filePath = modulePath.resolve(projectPath, 'css/brease_core.css'),
            fileStats = moduleFs.statSync(filePath),
            fileSizeInBytes = fileStats.size;

        if (fileSizeInBytes >= maxFileSize) {
            var cssFile = grunt.file.read(filePath),
                parts = csshelper.split(cssFile, maxFileSize / 2, maxFileSize);

            csshelper.writeParts(parts, modulePath.resolve(basePath, 'temp/css/'), grunt, modulePath);
              
            // handle parts separately and concatenate them afterwards
            grunt.task.run('csso:splittedcss', 'concat:splittedcss');
        } else {
            grunt.task.run('csso:brease');
        }
    });

};
