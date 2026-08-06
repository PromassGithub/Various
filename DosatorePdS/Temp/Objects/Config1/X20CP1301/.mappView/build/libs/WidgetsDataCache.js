(function () {
    'use strict';

    const grunt = require('grunt'),
        path = require('path'),
        xml2js = require('xml2js');

    /**
     * Used to load widget html and widget json.
     */
    let dataCache = {
        metaData: new Map(),
        html: new Map(),
        htmlObj: new Map(),
        content: new Map(),
        contentCss: new Map(),

        /**
         * Get widget.json content as object
         * @param {Object} widgetsInfo { 'widgets.brease.button': { metaDir: '.../meta', name: 'button' } }
         * @returns {Object} meta data
         */
        getMetaData(widgetsInfo) {
            let childInfos = {};
            for (var type in widgetsInfo) {
                if (dataCache.metaData.has(type)) {
                    childInfos[type] = dataCache.metaData.get(type);
                } else {
                    const jsonPath = path.resolve(widgetsInfo[type].metaDir, widgetsInfo[type].name + '.json');
                    if (!grunt.file.exists(jsonPath)) {
                        throw new Error(`Widget-Type '${type}' does not exist (path: ${jsonPath})!`);
                    }
                    childInfos[type] = grunt.file.readJSON(jsonPath);
                    dataCache.metaData.set(type, childInfos[type]);
                }
            }
            return childInfos;
        },

        /**
         * Get widget.html
         * @param {Object} widgetsInfo { metaDir: '.../meta', name: 'button' }
         * @returns {String} html
         */
        getHtml(widgetInfo) {
            if (!dataCache.html.has(widgetInfo.type)) {
                let htmlFilePath = path.resolve(widgetInfo.dir, widgetInfo.name + '.html');
                let html = grunt.file.read(htmlFilePath);
                dataCache.html.set(widgetInfo.type, html);
            }
            return dataCache.html.get(widgetInfo.type);
        },

        /**
         * Loads widget.html and converts it to object (with xml2js) so it can be better used in js
         * @param {Object} widgetsInfo { metaDir: '.../meta', name: 'button' }
         * @returns {Object} html as object
         */
        getHtmlObj(widgetInfo) {
            if (!dataCache.htmlObj.has(widgetInfo.type)) {
                let html = dataCache.getHtml(widgetInfo);
                xml2js.parseString(html, { trim: true }, (errArg, xml) => {
                    errArg = null;
                    dataCache.htmlObj.set(widgetInfo.type, xml);
                });
            }
            return dataCache.htmlObj.get(widgetInfo.type);
        },

        /**
         * Get widgets.html (cowi content html)
         * @param {Object} widgetInfo { metaDir: '.../meta', name: 'button' }
         * @returns {String} html
         */
        getContent(widgetInfo) {
            if (!dataCache.content.has(widgetInfo.type)) {
                const contentFilePath = path.resolve(widgetInfo.dir, 'content/widgets.html');
                let content = grunt.file.read(contentFilePath);
                // clean contents of root div necessary for xslt => we have to do this until we change this in cowi build
                const cutStart = '<div>\n'.length;
                const cutEnd = '</div>'.length;
                content = content.slice(cutStart, -cutEnd);
                dataCache.content.set(widgetInfo.type, content);
            }
            return dataCache.content.get(widgetInfo.type);
        },

        /**
         * Get widgets.css (cowi content)
         * @param {Object} widgetInfo { metaDir: '.../meta', name: 'button' }
         * @returns {String} css
         */
        getContentCss(widgetInfo) {
            if (!dataCache.contentCss.has(widgetInfo.type)) {
                const contentCssFilePath = path.resolve(widgetInfo.dir, 'content/widgets.css');
                const contentCss = grunt.file.read(contentCssFilePath);
                dataCache.contentCss.set(widgetInfo.type, contentCss);
            }
            return dataCache.contentCss.get(widgetInfo.type);
        },

        /**
         * Clear all cached data.
         */
        clear() {
            dataCache.metaData.clear();
            dataCache.html.clear();
            dataCache.htmlObj.clear();
        }
    };

    module.exports = dataCache;
})();
