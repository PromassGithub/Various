module.exports = function (grunt) {
    'use strict';
    
    const path = require('path');
    const Utils = require('../iat/utils');
    const childWidgets = require('../libs/childWidgets');
    const widgetsDataCache = require('../libs/widgetsDataCache');
    const xml2js = require('xml2js');
    const contentHtmlTransformation = require('../libs/ContentHtmlTransformation');
    const scssTransformation = require('../libs/ScssTransformation');

    /**
    * @method contentBuild
    * Task to create html and scss files for multiple contents. This task replaces the HtmlBuilder.xsl and StyleBuilder.xsl called by Automation Studio.
    * @iatStudioExposed
    * @param {String} buildJsonPath path to json build config
    */
    grunt.registerTask('contentBuild', 'task to create html and scss files for a content', function (buildJsonPath) {
        grunt.file.defaultEncoding = 'utf8';

        const buildCfg = createBuildConfig(buildJsonPath);
        let errors = [];
        
        for (let tp of buildCfg.technologyPackages) {
            const scss = tp.contents.map(srcFile => {
                try {
                    return compile(srcFile, tp, buildCfg);
                } catch (err) {
                    grunt.log.writeln(err.message);
                    errors.push({
                        srcFile: srcFile,
                        message: err.message
                    });
                }
            }).join('');

            if (tp.scssTarget) {
                grunt.file.write(tp.scssTarget, scss);
            }
        }
        grunt.file.write(buildCfg.reportFile, JSON.stringify(errors));
    });

    function createBuildConfig(srcFile) {
        let buildCfg;
        try {
            buildCfg = grunt.file.readJSON(srcFile);
            buildCfg.reportFile = srcFile.replace('.json', 'Report.json');
            if (grunt.file.exists(buildCfg.reportFile)) {
                grunt.file.delete(buildCfg.reportFile, { force: true });
            }
        } catch (err) {
            grunt.fail.fatal(err);
        }
        buildCfg.corePath = buildCfg.corePath === undefined ? '../../BRVisu' : buildCfg.corePath;
        buildCfg.widgetPath = path.resolve(buildCfg.corePath, 'widgets');
        return buildCfg;
    }

    function compile(srcFile, cfg, buildCfg) {
        const contentXML = grunt.file.read(srcFile);
        let scss = '';

        xml2js.parseString(contentXML, {
            trim: true
            // eslint-disable-next-line no-unused-vars
        }, (errArg, xmlObj) => {
            if (!xmlObj) {
                grunt.log.writeln('error in xml2js');
                throw Error('error in xml2js');
            }
            const contentNode = xmlObj['Content']; 
            const contentId = contentNode.$.id;
            const usedWidgetTypes = Utils.uniqueArray(childWidgets.findUsedWidgetTypes(contentNode.Widgets[0].Widget)).sort();
            const childWidgetsList = childWidgets.find(grunt, path, usedWidgetTypes, buildCfg.widgetPath, buildCfg.widgetPath, buildCfg.widgetPath);
            const childInfos = widgetsDataCache.getMetaData(childWidgetsList);

            const htmlTargetPath = path.resolve(cfg.htmlTargetFolder, `${contentId}.html`);
            const htmlString = contentHtmlTransformation.contentToHtml(contentId, contentNode.Widgets, childInfos, childWidgetsList);
            grunt.file.write(htmlTargetPath, htmlString);    

            const scssString = scssTransformation.widgetsToSass(contentId, contentNode.Widgets, childInfos, childWidgetsList); 
            if (cfg.scssTarget && cfg.scssTarget.length > 0) {
                scss = scssString;
            } else {
                const scssTargetPath = path.resolve(cfg.scssTargetFolder, `${contentId}.scss`);
                grunt.file.write(scssTargetPath, scssString);
            }
        });
        return scss;
    }
};
