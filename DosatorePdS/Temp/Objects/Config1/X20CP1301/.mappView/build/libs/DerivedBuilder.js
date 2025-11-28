(function () {
    'use strict';

    const modulePath = require('path'),
        grunt = require('grunt'),
        sass = require('node-sass'),
        _moduleXml2js = require('xml2js'),
        _xmlBuilder = new _moduleXml2js.Builder({ headless: true }),
        _xmlConvert = {
            xml2js: _moduleXml2js.parseString,
            js2xml: _xmlBuilder.buildObject.bind(_xmlBuilder)
        },
        DataTypes = require('../iat/DataTypes'),
        Properties = require('../iat/Properties'),
        libraryUtils = require('./libraryUtils'),
        utils = require('../iat/utils'),
        xsdPrepare = require('../iat/xsdPrepare'),
        jsPrepare = require('../iat/jsPrepare'),
        styleParser = require('../iat/styleParser'),
        templateParser = require('../iat/templateParser'),
        json2xml = require('../iat/json2xml'),
        defaultStyleTransformation = require('../iat/DefaultStyleTransformation'),
        widgetsDataCache = require('./widgetsDataCache'),
        debug = false;

    /**
    * 
    * @module libs/DerivedBuilder
    */
    let builder = {
        
        /**
         * Build muliple derived widgets with build.json file.
         * @param {Object} buildCfg 
         * @returns {Array} source file paths of files with build errors
         */
        create(buildCfg) {
            if (debug) {
                grunt.log.writeln('buildCfg.targetFolder:' + buildCfg.targetFolder);
                grunt.log.writeln('buildCfg.breaseWidgets:' + buildCfg.breaseWidgets);
                grunt.log.writeln('corePath:' + buildCfg.corePath);
            }
            let common = loadCommonFiles(grunt.config('basePath'));
            let result = {
                success: [],
                error: []
            };
            for (let lib of buildCfg.libs) {
                for (let srcFile of lib.derived) {
                    try {
                        createDerived(lib, srcFile, buildCfg, common);
                    } catch (err) {
                        grunt.log.writeln(err.message);
                        result.error.push({
                            lib: lib.name,
                            srcFile: srcFile,
                            message: err.message
                        });
                    }
                }
            }
            return result.error;
        }
    };

    function loadCommonFiles(basePath) {       
        return {
            templateJS: grunt.file.read(modulePath.resolve(basePath, 'templates/WidgetTemplate.js'))
        };
    }

    function createDerived(lib, srcFile, buildCfg, common) {
        // read source file
        let returnValue;
        var srcXML = grunt.file.read(srcFile);
        // parse xml to a javascript object
        // eslint-disable-next-line no-unused-vars
        _xmlConvert.xml2js(srcXML, { trim: true }, (errArg, xmlObj) => {
            if (xmlObj) {
    
                var widgetObject = parseXMLObject(xmlObj['DerivedWidget'], buildCfg.targetFolder, lib.name),
                    ancestorObject = getAncestorObject(widgetObject, utils, buildCfg.breaseWidgets);
                try {
                    let baseInfo = utils.deepCopy(widgetsDataCache.getMetaData({ [ancestorObject.type]: ancestorObject })[ancestorObject.type]),
                        widgetInfo = patchInfo(baseInfo, widgetObject);
                    // write Widget.json before removing not_styleable props
                    writeFile(widgetObject.metaClassPath + '.json', JSON.stringify(widgetInfo));
                    
                    let baseScssTargetPath = widgetObject.metaClassPath + '_base.scss';
                    let baseScssString = defaultStyleTransformation.createBaseScss(widgetInfo.name, widgetInfo);
                    writeFile(baseScssTargetPath, baseScssString);

                    let defaultScssTargetPath = widgetObject.metaClassPath + '_default.scss';
                    let defaultScssString = defaultStyleTransformation.createDefaultScss(widgetInfo.name, baseScssString);
                    writeFile(defaultScssTargetPath, defaultScssString);

                    let defaultCssTargetPath = widgetObject.metaClassPath + '_default.sass.css';
                    let defaultCss = sass.renderSync({
                        data: defaultScssString,
                        outputStyle: 'compressed',
                        includePaths: [modulePath.resolve(buildCfg.corePath + '/css/libs')]
                    });
                    writeFile(defaultCssTargetPath, defaultCss.css);
    
                    // widget html file
                    var templateHTML = widgetsDataCache.getHtml(ancestorObject);
                    let widgetHTML = createWidgetHTML(templateHTML, ancestorObject, widgetObject);
                    writeFile(widgetObject.dir + '/' + widgetObject.name + '.html', widgetHTML);
    
                    // widget js file
                    let widgetJS = createWidgetJS(common.templateJS, ancestorObject, widgetObject, widgetInfo);
                    writeFile(widgetObject.dir + '/' + widgetObject.name + '.js', widgetJS);
    
                    // meta infos and class extension for designer
                    var classInfo = jsPrepare.run(widgetInfo, widgetObject.qualifiedName, ancestorObject.type, false, { isDerived: true });
                    writeFile(widgetObject.dir + '/designer/ClassInfo.js', classInfo);
    
                    // widget xsd file
                    // task 'xsdPrepare' is running in widget_compiler before properties with hide=true are removed
                    // therefore we have to add them here to get a correct xsd, which restricts the BaseWidget.xsd
                    patchBaseProps(widgetInfo, widgetObject);
                    var widgetXsd = xsdPrepare.run(widgetInfo, {
                        prettify: true
                    }, DataTypes, Properties);
                    writeFile(widgetObject.metaClassPath + '.xsd', widgetXsd);
    
                    // widget styles xsd file
                    var stylesXsd = xsdPrepare.runWidgetStyleDefinition(widgetInfo, {
                        prettify: true
                    });
                    if (stylesXsd !== undefined && stylesXsd !== '') {
                        writeFile(widgetObject.metaClassPath + '_Styles.xsd', stylesXsd);
                    } else {
                        deleteFile(widgetObject.metaClassPath + '_Styles.xsd');
                    }
    
                    // widget events/actions xsd file
                    var eventActionXsd = xsdPrepare.runEventActionDefinition(widgetInfo, {
                        prettify: true
                    }, DataTypes);
                    if (eventActionXsd !== undefined && eventActionXsd !== '') {
                        writeFile(widgetObject.metaClassPath + '_EventsActions.xsd', eventActionXsd);
                    } else {
                        deleteFile(widgetObject.metaClassPath + '_EventsActions.xsd');
                    }
    
                    //styles of the ancestor widget as an JS object extracted from .widget file {styleProperties.StyleProperty:[],propertyGroups}                
                    var superStyle = styleParser.parseFile(ancestorObject.dir + '/meta/' + ancestorObject.name + '.widget', grunt);
    
                    // this method creates the style xml for the .widget file
                    // and sets default values in superStyle if they exist in widgetObject
                    var styleXML = createStyleXML(superStyle, widgetObject);
    
                    var styleFile = createStyleFile(ancestorObject, widgetObject, superStyle, widgetInfo);
                    if (styleFile !== '') {
                        writeFile(widgetObject.metaClassPath + '.style', styleFile);
                    }
    
                    // copy binding templates
                    var arBtpl = grunt.file.expand({ cwd: ancestorObject.dir + '/meta/' }, '*.btpl');
                    if (arBtpl.length > 0) {
                        for (var i = 0; i < arBtpl.length; i += 1) {
                            var xml = grunt.file.read(ancestorObject.dir + '/meta/' + arBtpl[i]);
                            xml = xml.replace(ancestorObject.qualifiedName, widgetObject.qualifiedName);
                            grunt.file.write(widgetObject.metaDir + '/' + arBtpl[i], xml);
                        }
                    }
                    // A&P 762365 remove properties with hide = true (added by patchBaseProps) 
                    // before creating the .widget file
                    widgetInfo.properties = widgetInfo.properties.filter((prop) => prop.hide !== true);
                    // widget xml
                    var widgetXMLFile = widgetObject.metaClassPath + '.widget',
                        widgetXML = createWidgetFile(widgetInfo, styleXML, widgetObject.dir);
    
                    writeFile(widgetXMLFile, widgetXML);
    
                    returnValue = widgetObject;
                } catch (err) {
                    if (buildCfg.reportFile) {
                        deleteWidget(widgetObject);
                    }
                    throw err;
                }
            }
        });
        return returnValue;
    }

    function writeFile(path, content) {
        if (debug) {
            grunt.log.writeln(('write ' + path).cyan);
        }
        grunt.file.write(path, content);
    }

    function deleteFile(path, options) {
        if (grunt.file.exists(path)) {
            grunt.file.delete(path, options);
        }
    }

    function parseXMLObject(widgetXMLObject, ROOT, libraryName) {
        var obj = {
            name: widgetXMLObject['$']['name'],
            library: libraryName,
            category: widgetXMLObject['$']['category'],
            props: widgetXMLObject['Widget'][0]['$']
        };
        obj.dir = ROOT + '/' + obj.library + '/' + obj.name; // <%ROOT%>/widgetLibrary/widgetName
        obj.metaDir = obj.dir + '/meta'; // <%ROOT%>/widgetLibrary/widgetName/meta
        obj.metaClassPath = obj.metaDir + '/' + obj.name; // <%ROOT%>/widgetLibrary/widgetName/meta/widgetName
        obj.qualifiedName = 'widgets/' + obj.library + '/' + obj.name; // widgets/widgetLibrary/widgetName
        obj.filePath = 'widgets/' + obj.library + '/' + obj.name + '/' + obj.name; // widgets/widgetLibrary/widgetName/widgetName
        obj.type = 'widgets.' + obj.library + '.' + obj.name; // widgets.widgetLibrary.widgetName
        return obj;
    }

    function getAncestorObject(widgetObject, utils, ROOT) {
        var obj = {
            type: widgetObject.props['xsi:type']
        };
        var info = obj.type.split('.');
        obj.library = info[1];
        obj.name = obj.type.substring(obj.type.lastIndexOf('.') + 1);
        obj.filePath = utils.className2Path(obj.type);
        obj.qualifiedName = utils.className2Path(obj.type, false, true);
        obj.dir = ROOT + '/' + obj.library + '/' + obj.name;
        obj.metaDir = obj.dir + '/meta';
        return obj;
    }

    function createWidgetHTML(templateHTML, ancestorObject, widgetObject) {
        return templateHTML.replace(ancestorObject.qualifiedName, widgetObject.qualifiedName);
    }

    function createWidgetJS(templateJS, ancestorObject, widgetObject, widgetInfo) {

        var newJS = templateJS.replace('SUPER_CLASS_PATH', ancestorObject.filePath);
        newJS = newJS.replace('SUPER_CLASS', ancestorObject.type);
        newJS = newJS.replace('WIDGET_LIBRARY', widgetObject.library);
        newJS = newJS.replace(/WIDGET_NAME/g, widgetObject.name);

        var properties = widgetInfo.properties,
            settings = {};
        for (var i = 0; i < properties.length; i += 1) {
            var prop = properties[i],
                propName = prop['name'];
            if (widgetObject.props[propName] !== undefined && prop.defaultValue !== undefined) {
                var parsedValue = parseValue(widgetObject.props[propName], prop['type']);
                if (DataTypes.isObject(prop['type']) === false) {
                    settings[propName] = parsedValue;
                } else if (typeof parsedValue === 'object') {
                    // write object data types only if parsing was successful
                    settings[propName] = parsedValue;
                }
            }
        }
        newJS = newJS.replace('DEFAULT_SETTINGS', JSON.stringify(settings, null, 8));
        return newJS;
    }

    function createBaseStyles(template, widgetObject, widgetInfo) {

        var properties = widgetInfo.properties,
            settings = {
                width: false,
                height: false,
                top: false,
                left: false
            };
        for (var i = 0; i < properties.length; i += 1) {
            var propName = properties[i]['name'];
            if (settings[propName] !== undefined) {
                settings[propName] = true;
            }
        }

        var baseStyles = template;
        if (widgetObject.props['width'] !== undefined) {
            baseStyles = baseStyles.replace('DEFAULT_WIDTH', widgetObject.props['width']);
        } else {
            baseStyles = baseStyles.replace('default="DEFAULT_WIDTH"', '');
        }
        if (settings['width'] === true) {
            baseStyles = baseStyles.replace('###HIDE_WIDTH###', '');
        } else {
            baseStyles = baseStyles.replace('###HIDE_WIDTH###', 'hide="true"');
        }
        if (widgetObject.props['height'] !== undefined) {
            baseStyles = baseStyles.replace('DEFAULT_HEIGHT', widgetObject.props['height']);
        } else {
            baseStyles = baseStyles.replace('default="DEFAULT_HEIGHT"', '');
        }
        if (settings['height'] === true) {
            baseStyles = baseStyles.replace('###HIDE_HEIGHT###', '');
        } else {
            baseStyles = baseStyles.replace('###HIDE_HEIGHT###', 'hide="true"');
        }

        return baseStyles;
    }

    function mergeStyles(styleProperties, baseStyles) {
        var startTag = '<StyleProperties>';
        return startTag + '\n' + baseStyles + ((styleProperties === '<StyleProperties/>') ? '</StyleProperties>' : styleProperties.substring(startTag.length));
    }

    function parseSTYLE(template, styleProperties, widgetObject) {

        var newSTYLE = template.replace('WIDGET_LIBRARY', widgetObject.library);
        newSTYLE = newSTYLE.replace(/WIDGET_NAME/g, widgetObject.name);

        newSTYLE = newSTYLE.replace('###STYLE_PROPERTIES###', styleProperties);

        return newSTYLE;
    }

    function createStyleFile(ancestorObject, widgetObject, superStyle, widgetInfo) {

        // remove styleproperties without default value and styleproperties with hide=true
        for (var i = superStyle.styleProperties.StyleProperty.length - 1; i >= 0; i -= 1) {
            var prop = superStyle.styleProperties.StyleProperty[i]['$'];
            if (prop.hide === 'true' || prop.default === undefined) {
                superStyle.styleProperties.StyleProperty.splice(i, 1);
            }
        }

        if (superStyle.styleProperties.StyleProperty.length > 0 || widgetInfo.styleproperties.StyleProperty.length > 0) {
            var styleProperties = styleParser.merge(widgetObject.type, superStyle.styleProperties, widgetInfo.styleproperties, ['width', 'height', 'top', 'left', 'zIndex']);
            var stylePropertiesXml = _xmlConvert.js2xml({
                StyleProperties: styleProperties
            });
            var purgedStyleProperties = purgeStyleProperties(stylePropertiesXml, ancestorObject, widgetObject);

            var baseStyles = createBaseStyles(grunt.file.read(grunt.config('basePath') + '/templates/BaseStyles.style'), widgetObject, widgetInfo),
                mergedStyles = mergeStyles(purgedStyleProperties, baseStyles);

            return parseSTYLE(grunt.file.read(grunt.config('basePath') + '/templates/WidgetTemplate.style'), mergedStyles, widgetObject);
        } else {
            return '';
        }
    }

    function createStyleXML(superStyle, widgetObject) {
        // set default values if they exist in widgetObject
        for (var i = 0; i < superStyle.styleProperties.StyleProperty.length; i += 1) {
            var prop = superStyle.styleProperties.StyleProperty[i]['$'],
                propName = prop['name'];
            if (widgetObject.props[propName] !== undefined && ['top', 'left', 'zIndex'].indexOf(propName) === -1) {
                prop.default = widgetObject.props[propName];
            }
        }
        // revert js object to xml
        var styleXML = _xmlConvert.js2xml({
            StyleProperties: superStyle.styleProperties
        });

        return styleXML;
    }

    function patchInfo(widgetInfo, widgetObject) {
        widgetInfo.meta.superClass = widgetInfo.name;
        widgetInfo.meta.isDerived = true;
        widgetInfo.meta.abstract = false;
        widgetInfo.name = widgetObject.type;
        widgetInfo.meta.filePath = widgetObject.filePath + '.js';
        widgetInfo.meta.inheritance.unshift(widgetObject.type);
        widgetInfo.dependencies.widgets.unshift(widgetObject.filePath + '.js');
        if (widgetObject.category) {
            if (!Array.isArray(widgetInfo.categories.Category)) {
                widgetInfo.categories.Category = [];
            }
            widgetInfo.categories.Category.push(widgetObject.category);
        }
        libraryUtils.patchLocalMediaPath(widgetObject.props, widgetInfo, widgetObject.library, DataTypes);
        overwriteDefaults(widgetObject, 'props', widgetInfo.properties, 'defaultValue');
        overwriteDefaults(widgetObject, 'styleProps', widgetInfo.styleproperties.StyleProperty, 'default');

        return widgetInfo;
    }

    function patchBaseProps(widgetInfo, widgetObject) {
        var contains = {},
            baseProps = ['top', 'left', 'height', 'width'];
        for (var i = 0; i < widgetInfo.properties.length; i += 1) {
            contains[widgetInfo.properties[i].name] = true;
        }
        for (var j = 0; j < baseProps.length; j += 1) {
            if (contains[baseProps[j]] === undefined) {
                widgetInfo.properties.push({
                    name: baseProps[j],
                    type: (baseProps[j] === 'top' || baseProps[j] === 'left') ? 'Integer' : 'Size',
                    owner: widgetObject.type,
                    hide: true
                });
            }
        }
    }

    /*
    * overwrite default values for all properties, if they exist in the derived widget xml, except of top,left,zIndex
    * top,left,zIndex do not need a default value; these properties are set, when a widget is added to a content
    * required properties are changed to optional, otherwise a default value would not be possible
    */
    function overwriteDefaults(widgetObject, type, properties, defaultAttr) {
        for (var i = 0; i < properties.length; i += 1) {
            var prop = select(properties, i, type),
                propName = prop['name'];
            if (widgetObject.props[propName] !== undefined && ['top', 'left', 'zIndex'].indexOf(propName) === -1) {
                prop[defaultAttr] = widgetObject.props[propName];
                if (prop.required !== undefined) {
                    prop.required = false;
                }
            }
        }
    }

    function select(properties, i, type) {
        if (type === 'props') {
            return properties[i];
        } else {
            return properties[i]['$'];
        }
    }

    function parseValue(value, type) {
        var retVal;
        if (DataTypes.isInteger(type)) {
            retVal = parseInt(value, 10);
        } else if (DataTypes.isNumber(type) || (type === 'Size' && value.indexOf('%') === -1)) {
            retVal = parseFloat(value);
        } else if (DataTypes.isBoolean(type)) {
            retVal = (value.toLowerCase() === 'true');
        } else if (DataTypes.isObject(type)) {
            try {
                retVal = (value !== '') ? JSON.parse(value.trim().replace(/'/g, '"')) : '';
            } catch (e) {
                console.log('Warn: invalid value for object type ' + type + ', JSON.parse failed');
                retVal = value;
            }
        } else {
            retVal = value;
        }
        //console.log('in[' + value + ',' + type + ']->out[' + typeof retVal + ']:' + JSON.stringify(retVal))
        return retVal;
    }

    function purgeStyleProperties(styleProperties, ancestorObject, widgetObject) {
        // REMOVE owner
        styleProperties = styleProperties.replace(/owner="brease.core.BaseWidget"/g, '');
        styleProperties = styleProperties.replace(new RegExp('owner="widgets\\.brease\\.' + ancestorObject.name + '"', 'g'), '');
        styleProperties = styleProperties.replace(new RegExp('owner="widgets\\.' + widgetObject.library + '\\.' + widgetObject.name + '"', 'g'), '');

        // REMOVE attribute defaultStyle: allowed in .widget file only
        styleProperties = styleProperties.replace(/ defaultStyle="default"/, '');

        return styleProperties;
    }

    function createWidgetFile(widgetInfo, stylablePropsXML, widgetDirectory) {
        // remove not_styleable properties from normal properties
        if (Array.isArray(widgetInfo.properties)) {
            for (var i = widgetInfo.properties.length - 1; i >= 0; i -= 1) {
                if (widgetInfo.properties[i].cssProp === true) {
                    widgetInfo.properties.splice(i, 1);
                }
            }
        }

        // generate xml from widgetInfo
        var xml = json2xml.convert(widgetInfo, {
            prettify: {
                enable: true
            }
        });

        // add binding templates to xml
        xml = templateParser.run(xml, widgetDirectory + '/meta', grunt);

        // adding styleable properties
        var insertIndex = xml.lastIndexOf('</Widget>');
        xml = xml.substring(0, insertIndex) + stylablePropsXML + '\n' + xml.substring(insertIndex);

        return xml;

    }

    function deleteWidget(widgetObject) {
        deleteFile(widgetObject.dir, { force: true });
        // remove lib dir also if its empty
        let libDir = widgetObject.dir.substring(0, widgetObject.dir.lastIndexOf(widgetObject.name));
        if (grunt.file.expand(`${libDir}*/*.js`).length === 0) {
            deleteFile(libDir, { force: true });
        }
    }

    module.exports = builder;

})();
