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
        utils = require('../iat/utils'),
        xsdPrepare = require('../iat/xsdPrepare'),
        jsPrepare = require('../iat/jsPrepare'),
        styleParser = require('../iat/styleParser'),
        json2xml = require('../iat/json2xml'),
        patchKeyboard = require('./keyboard_patchObj'),
        keyboardJsPrepare = require('./keyboard_jsPrepare'),
        elemValidator = require('./keyboard_elementsValidator'),
        defaultStyleTransformation = require('../iat/DefaultStyleTransformation'),
        numPadHtmlTransformation = require('./NumPadHtmlTransformation'),
        numPadScssTransformation = require('./NumPadScssTransformation'),
        alphaPadHtmlTransformation = require('./AlphaPadHTMLTransformation'),
        alphaPadScssTransformation = require('./AlphaPadScssTransformation'),
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
            let common = loadCommonFiles(grunt.config('basePath'));
            let result = {
                success: [],
                error: []
            };
            for (let lib of buildCfg.libs) {
                for (let srcFile of lib.keyboard) {
                    try {
                        createKeyboard(lib, srcFile, buildCfg, common);
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
            templateJS: {
                NumPad: grunt.file.read(modulePath.resolve(basePath, 'templates/NumPadTemplate.js')),
                KeyBoard: grunt.file.read(modulePath.resolve(basePath, 'templates/KeyBoardTemplate.js'))
            },
            templateStyle: {
                NumPad: grunt.file.read(modulePath.resolve(basePath, 'templates/NumPadTemplate.style')),
                KeyBoard: grunt.file.read(modulePath.resolve(basePath, 'templates/KeyBoardTemplate.style'))
            }
        };
    }

    function createKeyboard(lib, srcFile, buildCfg, common) {
        grunt.file.defaultEncoding = 'utf8';

        // read source xml file
        var xmlString = grunt.file.read(srcFile);

        // convert src xml to js object
        _xmlConvert.xml2js(xmlString, {
            trim: true
        }, function (errArg, xmlObj) {
            if (errArg !== null) {
                throw new Error('Error at XML conversion: ' + errArg);
            }
            if (debug) {
                grunt.file.write(modulePath.resolve('/Temp/mvLog/keyboardXML.json'), JSON.stringify(xmlObj));
            }
            if (xmlObj) {

                // xml of Keyboard as js object
                var keyboardType = (xmlObj['NumPad']) ? 'NumPad' : 'AlphaPad',
                    keyboardXML = xmlObj[keyboardType],
                    displayName = keyboardXML['$']['display'],
                    // keyboardWidget infos (path, name, type, properties, etc)
                    widgetObject = createWidgetObject(keyboardXML, keyboardType, buildCfg.targetFolder, lib.name),
                    // base class (system.widgets.Keyboard or system.widgets.NumPad) widget info (path, name, etc)
                    baseClassObject = createBaseClassObject(buildCfg.corePath, widgetObject.baseType);

                if (debug) {
                    grunt.log.writeln('name:' + widgetObject.name);
                    grunt.log.writeln('qualifiedName:' + widgetObject.qualifiedName);
                    grunt.file.write(modulePath.resolve('/Temp/mvLog/keyboardWidget.json'), JSON.stringify(widgetObject));
                    grunt.file.write(modulePath.resolve('/Temp/mvLog/baseClassObject.json'), JSON.stringify(baseClassObject));
                }

                // validate number of elements
                var result = elemValidator.validate(xmlObj, keyboardType);
                if (result.success !== true) {
                    throw new Error('Error at XML validation: ' + result.err);
                }

                // json of base class widget (=complete widget info, generated by widget compiler)
                let baseClassWidget = utils.deepCopy(widgetsDataCache.getMetaData({ [baseClassObject.type]: baseClassObject })[baseClassObject.type]);

                // json of keyboardWidget as result of baseClassWidget patched with additional info and not as result of a widget compiler
                var widgetInfo = patchKeyboard.run(baseClassWidget, widgetObject, grunt, debug);

                grunt.file.write(widgetObject.metaClassPath + '.json', JSON.stringify(widgetInfo));

                let cssClassName = `brease_${widgetObject.qualifiedName.replace(/\//g, '_')}`;
                if (keyboardType === 'NumPad') {
                    let numPadHtmlTargetPath = modulePath.resolve(widgetObject.dir, `${widgetObject.name}.html`);
                    let numPadHtml = numPadHtmlTransformation.numPadToHtml(xmlObj, { qualifiedName: widgetObject.qualifiedName, widgetName: widgetObject.name, cssClassName });
                    grunt.file.write(numPadHtmlTargetPath, numPadHtml);

                    let numPadScssTargetPath = modulePath.resolve(widgetObject.dir, `css/${widgetObject.name}.scss`);
                    let numPadScss = numPadScssTransformation.numPadToScss(xmlObj, { qualifiedName: widgetObject.qualifiedName, widgetName: widgetObject.name, cssClassName });
                    grunt.file.write(numPadScssTargetPath, numPadScss);
                } else {
                    // alphapad.html file
                    let alphaPadHtmlTargetPath = modulePath.resolve(widgetObject.dir, `${widgetObject.name}.html`);
                    let alphaPadHtml = alphaPadHtmlTransformation.alphaPadToHtml(xmlObj, { qualifiedName: widgetObject.qualifiedName, widgetName: widgetObject.name, cssClassName });
                    grunt.file.write(alphaPadHtmlTargetPath, alphaPadHtml);
                    // alphapad.scss file
                    let alphaPadScssTargetPath = modulePath.resolve(widgetObject.dir, `css/${widgetObject.name}.scss`);
                    let alphaPadScss = alphaPadScssTransformation.alphaPadToScss(xmlObj, { qualifiedName: widgetObject.qualifiedName, widgetName: widgetObject.name, cssClassName });
                    grunt.file.write(alphaPadScssTargetPath, alphaPadScss);
                }

                let widgetCssTargetPath = modulePath.resolve(widgetObject.dir, 'css/' + widgetObject.name + '.sass.css');
                let widgetCss = sass.renderSync({
                    file: modulePath.resolve(widgetObject.dir, 'css/' + widgetObject.name + '.scss'),
                    outputStyle: 'compressed',
                    includePaths: [modulePath.resolve(buildCfg.corePath + '/css/libs')]
                });
                grunt.file.write(widgetCssTargetPath, widgetCss.css);

                // widget js file
                var templateJS = common.templateJS[baseClassObject.name],
                    widgetJS = keyboardJsPrepare.createWidgetJS(templateJS, widgetObject, baseClassObject);
                grunt.file.write(modulePath.resolve(widgetObject.dir, widgetObject.name + '.js'), widgetJS);

                // widget style file
                var templateStyle = common.templateStyle[baseClassObject.name],
                    widgetStyle = createWidgetStyle(templateStyle, widgetObject, widgetObject.commonProps);
                grunt.file.write(widgetObject.metaClassPath + '.style', widgetStyle);
                var widgetStyleObj = styleParser.parseXML(widgetStyle);
                widgetInfo.styleproperties = widgetStyleObj.styleProperties;

                // from here, the keyboard build corresponds to the widget build
                // meta infos for use in JS
                var additionalMeta = { keyboard: { type: widgetObject.keyboardType } };
                if (displayName) {
                    additionalMeta.keyboard.displayName = displayName;
                }
                var classInfo = jsPrepare.run(widgetInfo, widgetObject.qualifiedName, baseClassObject.type, false, additionalMeta);
                grunt.file.write(modulePath.resolve(widgetObject.dir, 'designer/ClassInfo.js'), classInfo);

                let baseScssTargetPath = widgetObject.metaClassPath + '_base.scss';
                let baseScssString = defaultStyleTransformation.createBaseScss(widgetInfo.name, widgetInfo);
                grunt.file.write(baseScssTargetPath, baseScssString);

                let defaultScssTargetPath = widgetObject.metaClassPath + '_default.scss';
                let defaultScssString = defaultStyleTransformation.createDefaultScss(widgetInfo.name, baseScssString);
                grunt.file.write(defaultScssTargetPath, defaultScssString);

                let defaultCssTargetPath = widgetObject.metaClassPath + '_default.sass.css';
                let defaultCss = sass.renderSync({
                    data: defaultScssString,
                    outputStyle: 'compressed',
                    includePaths: [modulePath.resolve(buildCfg.corePath + '/css/libs')]
                });
                grunt.file.write(defaultCssTargetPath, defaultCss.css);

                // remove non-public properties and related events
                // we have to do this after creation of ClassInfo and Widget.js, because we need them in the widget but not in the interface to AS
                removeNonPublic(widgetInfo, ['events', 'properties']);

                // widget xsd file
                var widgetXsd = xsdPrepare.run(widgetInfo, {
                    prettify: true
                }, DataTypes, Properties);
                grunt.file.write(widgetObject.metaClassPath + '.xsd', widgetXsd);

                //styles of the base class widget as an JS object extracted from .widget file {styleProperties.StyleProperty:[],propertyGroups}                
                var superStyleObj = styleParser.parseFile(baseClassObject.dir + '/meta/' + baseClassObject.name + '.widget', grunt);
                styleParser.merge(widgetInfo.name, superStyleObj.styleProperties, widgetStyleObj.styleProperties);

                // this method creates the xml of stylable properties for the .widget file
                // and sets default values in superStyle if they exist in compoundWidget
                var stylablePropsXML = createStyleXML(superStyleObj, widgetObject);

                // widget xml (.widget file)
                var widgetXMLFile = widgetObject.metaClassPath + '.widget',
                    widgetXML = createWidgetFile(widgetInfo, json2xml, stylablePropsXML, superStyleObj.propertyGroups);

                grunt.file.write(widgetXMLFile, widgetXML);

                // widget styles xsd file
                var stylesXsd = xsdPrepare.runWidgetStyleDefinition(widgetInfo, {
                    prettify: true
                });
                if (stylesXsd !== undefined && stylesXsd !== '') {
                    grunt.file.write(widgetObject.metaClassPath + '_Styles.xsd', stylesXsd);
                } else {
                    deleteFile(widgetObject.metaClassPath + '_Styles.xsd');
                }

                // widget events/actions xsd file
                var eventActionXsd = xsdPrepare.runEventActionDefinition(widgetInfo, {
                    prettify: true
                }, DataTypes);
                if (eventActionXsd !== undefined && eventActionXsd !== '') {
                    grunt.file.write(widgetObject.metaClassPath + '_EventsActions.xsd', eventActionXsd);
                } else {
                    deleteFile(widgetObject.metaClassPath + '_EventsActions.xsd');
                }
            }
        });
    }

    function createStyleXML(superStyle, widgetObject) {
        // set default values if they exist in keyboardWidget
        for (var i = 0; i < superStyle.styleProperties.StyleProperty.length; i += 1) {
            var prop = superStyle.styleProperties.StyleProperty[i]['$'],
                propName = prop['name'];
            if (widgetObject.commonProps !== undefined && widgetObject.commonProps[propName] !== undefined && ['width', 'height', 'top', 'left', 'zIndex'].indexOf(propName) === -1) {
                prop.default = widgetObject.commonProps[propName];
                prop.owner = widgetObject.type;
            }
        }
        var styleXML = _xmlConvert.js2xml({
            StyleProperties: superStyle.styleProperties
        });

        return styleXML;
    }

    function createWidgetFile(widgetInfo, json2xml, stylablePropsXML, propertyGroupsObj) {

        // remove not_styleable properties from normal properties
        if (Array.isArray(widgetInfo.properties)) {

            for (var i = widgetInfo.properties.length - 1; i >= 0; i -= 1) {
                var property = widgetInfo.properties[i];
                if (property.cssProp === true) {
                    widgetInfo.properties.splice(i, 1);
                } else {
                    if (property.setAction) {
                        delete property.setAction;
                    }
                    if (property.getAction) {
                        delete property.getAction;
                    }
                }

            }
        }

        // generate xml from widgetInfo
        var xml = json2xml.convert(widgetInfo, {
            prettify: {
                enable: true
            }
        });

        // adding styleable properties and propertyGroups to xml
        var groupXml = _xmlConvert.js2xml({
            PropertyGroups: propertyGroupsObj
        });

        var insertIndex = xml.lastIndexOf('</Widget>');
        xml = xml.substring(0, insertIndex) + ((propertyGroupsObj) ? groupXml + '\n' : '') + stylablePropsXML + '\n' + xml.substring(insertIndex);

        if (Array.isArray(widgetInfo.eventBindings) && Array.isArray(widgetInfo.eventBindings[0].EventBinding)) {
            var eventBindingXML = _xmlConvert.js2xml({
                EventBindings: widgetInfo.eventBindings[0]
            });
            insertIndex = xml.lastIndexOf('</Widget>');
            xml = xml.substring(0, insertIndex) + eventBindingXML + '\n' + xml.substring(insertIndex);
        }
        return xml;

    }

    function removeNonPublic(widgetInfo, types) {
        var i;

        if (types.indexOf('properties') !== -1 && Array.isArray(widgetInfo.properties)) {
            for (i = widgetInfo.properties.length - 1; i >= 0; i -= 1) {
                var property = widgetInfo.properties[i];
                if (property.public === false) {
                    widgetInfo.properties.splice(i, 1);
                }
            }
        }
        if (types.indexOf('methods') !== -1 && Array.isArray(widgetInfo.methods)) {
            for (i = widgetInfo.methods.length - 1; i >= 0; i -= 1) {
                var method = widgetInfo.methods[i];
                if (method.public === false) {
                    widgetInfo.methods.splice(i, 1);
                }
            }
        }
        if (types.indexOf('events') !== -1 && Array.isArray(widgetInfo.events)) {
            for (i = widgetInfo.events.length - 1; i >= 0; i -= 1) {
                var event = widgetInfo.events[i];
                if (event.public === false) {
                    widgetInfo.events.splice(i, 1);
                }
            }
        }
    }

    function createWidgetStyle(template, widgetObject, commonProps) {
        var newFile = template.replace('__WIDGET_NAME__', widgetObject.type);
        newFile = newFile.replace('__WIDTH__', commonProps.width);
        newFile = newFile.replace('__HEIGHT__', commonProps.height);

        return newFile;
    }

    function createBaseClassObject(ROOT, baseType) {
        var obj = {
            type: 'system.widgets.' + baseType
        };
        obj.metaDir = modulePath.resolve(ROOT, 'system/widgets/' + baseType + '/meta');
        obj.name = obj.type.substring(obj.type.lastIndexOf('.') + 1);
        obj.filePath = utils.className2Path(obj.type);
        obj.qualifiedName = utils.className2Path(obj.type, false, true);
        obj.dir = modulePath.resolve(ROOT, 'system/widgets/' + baseType);
        return obj;
    }

    function createWidgetObject(keyboardXML, keyboardType, ROOT, libraryName) {
        var obj = {
            name: keyboardXML['$']['id'],
            library: libraryName
        };
        obj.dir = modulePath.resolve(ROOT, obj.library + '/' + obj.name); //           <%ROOT%>/widgetLibrary/widgetName
        obj.metaDir = modulePath.resolve(obj.dir, 'meta'); //                          <%ROOT%>/widgetLibrary/widgetName/meta
        obj.metaClassPath = modulePath.resolve(obj.metaDir, obj.name); //              <%ROOT%>/widgetLibrary/widgetName/meta/widgetName
        obj.qualifiedName = 'widgets/' + obj.library + '/' + obj.name; //               widgets/widgetLibrary/widgetName
        obj.filePath = 'widgets/' + obj.library + '/' + obj.name + '/' + obj.name; //   widgets/widgetLibrary/widgetName/widgetName
        obj.type = 'widgets.' + obj.library + '.' + obj.name; //                        widgets.widgetLibrary.widgetName
        obj.keyboardType = keyboardType;
        obj.baseType = (obj.keyboardType === 'NumPad') ? 'NumPad' : 'KeyBoard';

        obj.commonProps = {
            width: keyboardXML['$']['width'],
            height: keyboardXML['$']['height']
        };
        return obj;
    }

    function deleteFile(path) {
        if (grunt.file.exists(path)) {
            grunt.file.delete(path);
        }
    }

    module.exports = builder;

})();
