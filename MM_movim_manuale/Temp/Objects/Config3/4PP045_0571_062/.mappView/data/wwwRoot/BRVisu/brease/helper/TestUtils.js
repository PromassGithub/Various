define(['brease/events/BreaseEvent',
    'brease/controller/WidgetController',
    'brease/controller/PageController', 
    'brease/controller/BindingController', 
    'brease/controller/ActionController',
    'brease/controller/EventController',
    'brease/controller/objects/Client',
    'brease/controller/libs/Utils',
    'brease/controller/WidgetParser',
    'brease/model/BindingModel',
    'brease/services/RuntimeService',
    'brease/helper/stubs/ServiceBridge'],
function (BreaseEvent, 
    widgetController, 
    pageController, 
    bindingController, 
    actionController, 
    eventController,
    client, 
    controllerUtils,
    widgetParser,
    bindingModel,
    runtimeService, 
    serviceBridge) {

    'use strict';
    
    var _lang = {}, 
        _mmsDeferred, _cultureDeferred;

    function switchLang(lang, config) {
        _lang.key = lang;
        _lang.start = Date.now();
        _lang.timeout = jasmine.getEnv().defaultTimeoutInterval;
        _lang.deferred = $.Deferred();
        _lang.config = config;

        document.body.addEventListener(BreaseEvent.LANGUAGE_CHANGED, switchLangReadyHandler);
        if (brease.language.getCurrentLanguage() !== lang) {
            brease.language.switchLanguage(lang);
        } else {
            checkLangReady();
        }
        return _lang.deferred.promise();
    }

    function switchLangReadyHandler(deferred) {
        document.body.removeEventListener(BreaseEvent.LANGUAGE_CHANGED, switchLangReadyHandler);
        checkLangReady();
    }

    function checkLangReady() {
        var kbdEl = $('#breaseKeyBoard'),
            config = _lang.config,
            waitForAttribute = (config && config.waitsFor === 'data-lang');

        if (brease.language.getCurrentLanguage() === _lang.key && (waitForAttribute !== true || kbdEl.attr('data-lang') === _lang.key)) {
            _lang.deferred.resolve(); 
        } else { 
            if (Date.now() - _lang.start < _lang.timeout) { 
                window.setTimeout(checkLangReady, 50); 
            } else {
                _lang.deferred.reject(); 
            }
        }
    }

    function switchMMS(mms) {
        _mmsDeferred = $.Deferred();
        document.body.addEventListener(BreaseEvent.MEASUREMENT_SYSTEM_CHANGED, switchMmsReadyHandler);
        if (brease.measurementSystem.getCurrentMeasurementSystem() !== mms) {
            brease.measurementSystem.switchMeasurementSystem(mms);
        } else {
            _mmsDeferred.resolve();
        }
        return _mmsDeferred.promise();
    }

    function switchMmsReadyHandler() {
        document.body.removeEventListener(BreaseEvent.MEASUREMENT_SYSTEM_CHANGED, switchMmsReadyHandler);
        _mmsDeferred.resolve();
    }

    function switchCulture(culture) {
        _cultureDeferred = $.Deferred();
        document.body.addEventListener(BreaseEvent.CULTURE_CHANGED, switchCultureReadyHandler);
        if (brease.culture.getCurrentCulture().key !== culture) {
            brease.culture.switchCulture(culture);
        } else {
            _cultureDeferred.resolve();
        }
        return _cultureDeferred.promise();
    }

    function switchCultureReadyHandler() {
        document.body.removeEventListener(BreaseEvent.CULTURE_CHANGED, switchCultureReadyHandler);
        _cultureDeferred.resolve();
    }

    function setConditions(conditions, callback, config) {
        var preconditions = [];
        if (conditions.lang !== undefined) {
            preconditions.push(switchLang(conditions.lang, config));
        }
        if (conditions.mms !== undefined) {
            preconditions.push(switchMMS(conditions.mms));
        }
        if (conditions.culture !== undefined) {
            preconditions.push(switchCulture(conditions.culture));
        }
        $.when.apply(null, preconditions).then(function () {
            callback();
        });
    }

    function runConditions(conditions, config) {

        var ready = jasmine.createSpy();

        runs(function () {
            setConditions(conditions, ready, config);
        });

        waitsFor(function () {
            return ready.callCount > 0;
        }, 'conditions to be set', 15000);
    }

    var TestUtils = {

        preConditions: function (title, conditions, config) {

            if (!config || config.type === 'describe') {
                describe(title, function () {
                    it('', function () {
                        runConditions(conditions, config);
                    });
                }); 
            }
            if (config && config.type === 'it') {
                it('', function () {
                    runConditions(conditions, config);
                });
            }
            if (config && config.type === 'runs') {
                runConditions(conditions, config);
            }
        },

        /**
        * @method logWithParent
        * write description of spec and description of parent suite (describe-block) to console
        * the returned method takes two arguments:
        *   the spec itself ('this' inside of it-block)
        *   config object
        * @param {Boolean} flag to enable or disable
        * @param {Object} parentConfig
        * @param {Color} parentConfig.color
        * @param {String} parentConfig.method of console to use
        * @return {Function}
        */
        logWithParent: function (flag, parentConfig) {
            if (flag) {
                parentConfig = parentConfig || {};
                parentConfig.method = (parentConfig.method) ? parentConfig.method : 'log';
                parentConfig.color = (parentConfig.color) ? parentConfig.color : '#999999';
                parentConfig.parent = (parentConfig.parent !== undefined) ? parentConfig.parent : true;
                return function (spec, config) {
                    if (!config) {
                        config = {};
                    }
                    if (console[parentConfig.method]) {
                        console[parentConfig.method]('%c' + ((config.prefix) ? config.prefix : '') + ((parentConfig.parent) ? spec.suite.parentSuite.description + spec.suite.description : '') + spec.description + ((config.suffix) ? config.suffix : ''), 'color:' + parentConfig.color);
                    } else {
                        console.log('%c' + ((config.prefix) ? config.prefix : '') + ((parentConfig.parent) ? spec.suite.parentSuite.description + spec.suite.description : '') + spec.description + ((config.suffix) ? config.suffix : ''), 'color:' + parentConfig.color);
                    }
                };
            } else {
                return function () { };
            }
        },

        /**
        * @method log
        * write description of spec to console
        * the returned method takes two arguments:
        *   the spec itself ('this' inside of it-block)
        *   config object
        * @param {Boolean} flag to enable or disable 
        * @param {Color} color
        * @param {String} method of console to use
        * @return {Function}
        */
        log: function (flag, color, method) {
            if (flag) {
                return function (spec, config) {
                    if (!config) {
                        config = {};
                    }
                    var message;
                    if (console[method]) {
                        message = '%c########### ' + ((config.prefix) ? config.prefix : '') + spec.description + ((config.suffix) ? config.suffix : '');
                        console[method](message, 'color:' + (color || '#999999'));
                    } else {
                        message = '%c########### ' + ((config.prefix) ? config.prefix : '') + spec.description + ((config.suffix) ? config.suffix : '');
                        console.log(message, 'color:' + (color || '#999999'));
                    }
                };
            } else {
                return function () { };
            }
        },

        logSuite: function (suite) {
            var prefix = (brease.config.jenkins === true) ? '\n[' : '[';
            var suffix = (brease.config.jenkins === true) ? ']' : ']';
            console.debug(prefix + ((suite && suite.spec && typeof suite.spec.replace === 'function') ? suite.spec.replace(/\./g, '/') : 'undefined') + suffix);
        },

        console: function (action, callThrough, config) {
            if (action === 'mock') {
                TestUtils.callThrough = callThrough;
                TestUtils.config = config || {};
                window.console = TestUtils.fakeConsole;
            } else {
                window.console = TestUtils.originalConsole;
            }
        },

        originalConsole: window.console,
        fakeConsole: {

            log: function () {
                if (TestUtils.callThrough || TestUtils.config.log === true) {
                    TestUtils.originalConsole.log.apply(TestUtils.originalConsole, arguments);
                }
            },
            warn: function () {
                if (TestUtils.callThrough || TestUtils.config.warn === true) {
                    TestUtils.originalConsole.warn.apply(TestUtils.originalConsole, arguments);
                }
            },
            debug: function () {
                if (TestUtils.callThrough || TestUtils.config.debug === true) {
                    TestUtils.originalConsole.debug.apply(TestUtils.originalConsole, arguments);
                }
            },
            error: function () {
                TestUtils.originalConsole.error.apply(TestUtils.originalConsole, arguments);
            },
            info: function () {
                if (TestUtils.callThrough || TestUtils.config.info === true) {
                    TestUtils.originalConsole.info.apply(TestUtils.originalConsole, arguments);
                }
            },
            trace: function () {
                if (TestUtils.callThrough || TestUtils.config.trace === true) {
                    TestUtils.originalConsole.trace.apply(TestUtils.originalConsole, arguments);
                }
            },
            time: function () {
                if (TestUtils.callThrough || TestUtils.config.time === true) {
                    TestUtils.originalConsole.time.apply(TestUtils.originalConsole, arguments);
                }
            },
            timeEnd: function () {
                if (TestUtils.callThrough || TestUtils.config.timeEnd === true) {
                    TestUtils.originalConsole.timeEnd.apply(TestUtils.originalConsole, arguments);
                }
            },
            iatWarn: function () {
                if (TestUtils.callThrough || TestUtils.config.iatWarn === true) {
                    TestUtils.originalConsole.iatWarn.apply(TestUtils.originalConsole, arguments);
                }
            },
            iatDebug: function () {
                if (TestUtils.callThrough || TestUtils.config.iatDebug === true) {
                    TestUtils.originalConsole.iatDebug.apply(TestUtils.originalConsole, arguments);
                }
            },
            iatDebugLog: function () {
                if (TestUtils.callThrough || TestUtils.config.iatDebugLog === true) {
                    TestUtils.originalConsole.iatDebug.apply(TestUtils.originalConsole, arguments);
                }
            },
            iatInfo: function () {
                if (TestUtils.callThrough || TestUtils.config.iatInfo === true) {
                    TestUtils.originalConsole.iatInfo.apply(TestUtils.originalConsole, arguments);
                }
            },
            dir: function () {
                TestUtils.originalConsole.dir.apply(TestUtils.originalConsole, arguments);
            },
            always: function () {
                TestUtils.originalConsole.log.apply(TestUtils.originalConsole, arguments);
            },
            alwaysWarn: function () {
                TestUtils.originalConsole.warn.apply(TestUtils.originalConsole, arguments);
            }
        },

        addMatchers: function (testcase, arType) {

            if (Array.isArray(arType)) {
                var matcher = {};
                arType.forEach(function (type) {
                    if (_customMatcher[type]) {
                        matcher[type] = _customMatcher[type];
                    }
                });
                
                testcase.addMatchers(matcher);
            }
        },

        resetFramework: function () {

            brease.config.editMode = false;
            brease.config.preLoadingState = false;
            jasmine.getEnv().defaultTimeoutInterval = 20000;
            serviceBridge.testServices.reset();
            pageController.reset();
            widgetController.reset(true);
            bindingModel.reset();
            pageController.rootContainer = brease.appElem;
            pageController.init(runtimeService);
            bindingController.init(runtimeService);
            brease.uiController.bindingController = bindingController;
            actionController.init(runtimeService);
            client.init(runtimeService);
            client.setValid(true);
        },

        /**
        * @method createWidgets
        * create a bunch of widgets and wait for their ready events  
        * usable in two different ways:  
        *
        * TestUtils.createWidgets(...).then(function () {
        *   (do something with the newly created widgets)
        * });
        *
        * or standalone as a runs/waitsFor bundle:  
        *
        * runs(function () {...});
        * TestUtils.createWidgets(...);
        * runs(function () {...});
        *
        * @param {WidgetConfig[]} widgets
        * @param {String} targetId Either the id of the HTMLElement which should be created to contain the widgets, or id of an already existing target.
        * @param {HTMLElement/jQuery/Selector} container Container where the target should be appended (can be null, if target already exists)
        * @param {String} [contentId] contentId for widget creation
        * @param {Object} targetConfig height and width of the HTMLElement which contains the widgets.
        * @return {Promise}
        */
        createWidgets: function (widgets, targetId, container, contentId, targetConfig) {

            var callback, target,
                deferred = new $.Deferred(),
                widgetIds = widgets.map(function (item) {
                    return item.id;
                });

            runs(function () {
                callback = jasmine.createSpy();
                target = $('#' + targetId);
                
                if (target.length > 0) {
                    target = target[0];
                } else {
                    target = $('<div id="' + targetId + '" style="height:0px; overflow:hidden;" />').appendTo(container)[0];
                    if (targetConfig) {
                        $(target).css({ height: targetConfig.height, width: targetConfig.width });    
                    }
                }
                target.addEventListener(BreaseEvent.WIDGET_READY, function (e) {
                       
                    if (widgetIds.indexOf(e.target.id) !== -1) {
                        callback();
                    }
                }, true);
                if (contentId !== undefined) {
                    brease.uiController.createWidgets(target, widgets.slice(0), true, contentId); 
                } else {
                    brease.uiController.createWidgets(target, widgets.slice(0), true); 
                }
            });

            waitsFor(function () {
                return callback.callCount >= widgets.length;
            }, 'widget creation', 3000);

            runs(function () {
                expect(callback.callCount).toEqual(widgets.length);
                deferred.resolve();
            });
            return deferred.promise();
        },

        /**
        * @method addContent
        * add a content html file and create widgets in it and wait for their ready events  
        * usable in two different ways:  
        *
        * TestUtils.addContent(...).then(function () {
        *   (do something with the newly created widgets)
        * });
        *
        * or standalone as a runs/waitsFor bundle:  
        *
        * runs(function () {...});
        * TestUtils.addContent(...);
        * runs(function () {...});
        *
        * @param {String} url
        * @param {String} targetId Either the id of the HTMLElement which should be created to contain the widgets, or id of an already existing target.
        * @param {HTMLElement/jQuery/Selector} container Container where the target should be appended (can be null, if target already exists)
        * @param {String} [contentId] contentId for widget creation
        * @param {Object} targetConfig height and width of the HTMLElement which contains the widgets.
        * @return {Promise}
        */
        addContent: function (url, targetId, container, contentId, targetConfig) {
            var callback = jasmine.createSpy(), 
                loadSpy = jasmine.createSpy(),
                target, 
                html,
                widgetIds = [],
                deferred = new $.Deferred();

            runs(function () {
                var $target = $('#' + targetId);
                if ($target.length > 0) {
                    target = $target[0];
                } else {
                    target = $('<div id="' + targetId + '" style="height:0px; overflow:hidden;" />').appendTo(container)[0];
                    if (targetConfig) {
                        $(target).css({ height: targetConfig.height, width: targetConfig.width });    
                    }
                }
                brease.pageController.loadHTML(url).done(function (loadedHtml) {
                    html = loadedHtml;
                    loadSpy();
                });
            });

            waitsFor(function () {
                return loadSpy.callCount === 1;
            }, 'content html loaded', 5000);

            runs(function () {

                controllerUtils.appendHTML(target, html);
                $(target).find('[data-brease-widget]').each(function () {
                    widgetIds.push(this.id);
                });

                target.addEventListener(BreaseEvent.WIDGET_READY, function (e) {
                    if (widgetIds.indexOf(e.target.id) !== -1) {
                        callback();
                    }
                }, true);
                widgetParser.parse(target, false, contentId);
            });

            waitsFor(function () {
                return callback.callCount >= widgetIds.length;
            }, 'widgets ready', 5000);

            runs(function () {
                console.log('all widgets ready');
                expect(callback.callCount).toEqual(widgetIds.length);
                deferred.resolve();
            });
            return deferred.promise();
        },

        /*
        * deferStub
        * util to spy on a _.defer call and fullfil it on demand  
        * only one call is supported simultaneously  
        * 
        * spyOn(_, 'defer').andCallFake(TestUtils.deferStub.call);
        * 
        * TestUtils.deferStub.release();
        */
        deferStub: {
            id: 0,
            _call: function () {
                this.fn = arguments[0];
                this.args = Array.prototype.slice.call(arguments, 1);
            },
            _release: function () {
                if (typeof this.fn === 'function') {
                    this.fn.apply(this.fn, this.args);
                }
                this.fn = undefined;
                this.args = undefined;
            }
        }

    };
    TestUtils.deferStub.call = TestUtils.deferStub._call.bind(TestUtils.deferStub);
    TestUtils.deferStub.release = TestUtils.deferStub._release.bind(TestUtils.deferStub);

    var _customMatcher = {
        toEqualArray: function (array) {
            this.message = function () {
                return 'Expected ' + JSON.stringify(this.actual) + ' to be array ' + JSON.stringify(array) + '.';
            };
            var arraysHaveSameMembers = function (x, y) {
                var equal = Array.isArray(x) && Array.isArray(y) && x.length === y.length;
                for (var i = 0; i < x.length; i += 1) {
                    equal = equal && (y.indexOf(x[i]) !== -1);
                }
                return equal;
            };
            return arraysHaveSameMembers(this.actual, array);
        }
    };

    return TestUtils;

});
