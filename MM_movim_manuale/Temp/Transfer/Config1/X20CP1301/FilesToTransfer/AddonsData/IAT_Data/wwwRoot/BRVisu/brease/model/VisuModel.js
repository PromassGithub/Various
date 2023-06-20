define(['brease/events/BreaseEvent', 'brease/events/SocketEvent', 'brease/core/Utils', 'brease/controller/objects/PageType', 'brease/controller/objects/AssignTypes', 'brease/controller/objects/VisuStatus', 'brease/controller/libs/LogCode', 'brease/objects/Content', 'brease/objects/Page', 'brease/objects/AreaInfo', 'brease/objects/Navigation', 'brease/services/LoadedByBootstrapper'],
    function (BreaseEvent, SocketEvent, Utils, PageType, AssignTypes, VisuStatus, LogCode, Content, Page, AreaInfo, Navigation, loadedByBootstrapper) {

        'use strict';

        /**
        * @class brease.model.VisuModel
        * @extends Object
        * controls visu(s)
        * @singleton
        */
        var VisuModel = {

            init: function (runtimeService, logger) {
                if (logger) {
                    _logger = logger;
                }
                if (runtimeService) {
                    _runtimeService = runtimeService;
                    _runtimeService.addEventListener(SocketEvent.VISU_ACTIVATED, _visuActivatedHandler);
                }
                _initModel();
                _pendingVisus.reset();
                return this;
            },

            activateVisu: function (visuId, callbackInfo) {
                visuId = Utils.ensureVisuId(visuId);
                if (callbackInfo.visuId) {
                    callbackInfo.visuId = Utils.ensureVisuId(callbackInfo.visuId);
                }
                var visu = _visuModel.visus[visuId],
                    deferred = $.Deferred();

                if (visu === undefined || visu.status !== VisuStatus.LOADED) {
                    deferred.reject((visu !== undefined) ? visu.status : VisuStatus.NOT_FOUND, undefined, callbackInfo);
                } else {
                    if (visu.active !== true) {
                        visu.activateDeferred = deferred;
                        visu.callbackInfo = callbackInfo;
                        _runtimeService.activateVisu(visuId, _activateVisuResponse, callbackInfo);
                        _pendingVisus.push(visuId);
                    } else {
                        deferred.resolve(callbackInfo);
                    }
                }
                return deferred.promise();
            },

            deactivateVisu: function (visuId) {
                visuId = Utils.ensureVisuId(visuId);
                if (_visuModel.visus[visuId]) {
                    _runtimeService.deactivateVisu(visuId);
                    _visuModel.visus[visuId].active = false;
                    document.body.dispatchEvent(new CustomEvent(BreaseEvent.VISU_DEACTIVATED, { detail: { visuId: visuId } }));
                }
            },

            loadVisuData: function (visuId, rootContainerId) {
                var deferred = $.Deferred();
                visuId = Utils.ensureVisuId(visuId);
                if (visuId === undefined) {
                    _logger.log(LogCode.VISU_NOT_FOUND, { visuId: visuId, container: brease.appElem });
                    deferred.reject(visuId);
                } else {
                    var visuData = loadedByBootstrapper.get('visu'),
                        callbackInfo = { visuId: visuId, deferred: deferred, isRoot: true, rootContainerId: rootContainerId };
                    if (visuData && visuData.id === visuId) {
                        _loadVisuDataResponseHandler({ success: true, visuData: visuData }, callbackInfo);
                    } else {
                        _runtimeService.loadVisuData(visuId, _loadVisuDataResponseHandler, callbackInfo);
                    }
                }

                return deferred.promise();
            },
            getPageById: function (id) {
                return _visuModel.pages[id];
            },
            getNavById: function (id) {
                return _visuModel.navigations[id];
            },
            getVisuById: function (id) {
                return _visuModel.visus[Utils.ensureVisuId(id)];
            },
            getVisuByStartpage: function (pageId) {
                var visu;
                for (var visuId in _visuModel.visus) {
                    if (_visuModel.visus[visuId].startPage === pageId) {
                        visu = _visuModel.visus[visuId];
                        break;
                    }
                }
                return visu;
            },
            getDialogById: function (id) {
                return _visuModel.dialogs[id];
            },
            getContentById: function (id) {
                return _visuModel.contents[id];
            },
            isValidContent: function (id) {
                return _visuModel.contents[id] !== undefined;
            },
            getLayoutById: function (id) {
                return _visuModel.layouts[id];
            },
            getThemes: function () {
                return _visuModel.themes;
            },
            pageHasArea: function (areaId, page) {
                var success = false,
                    layout = this.getLayoutById(page.layout);

                if (layout && layout.areas) {
                    success = (layout.areas[areaId] !== undefined);
                }
                return success;
            },
            findAssignment: function (page, areaId) {
                return page.assignments[areaId];
            },
            findNav4page: function (pageId) {
                var nav;
                for (var navId in _visuModel.navigations) {

                    if (_visuModel.navigations[navId].pages[pageId] !== undefined) {
                        nav = _visuModel.navigations[navId];
                        break;
                    }
                }
                return nav;
            },

            parseVisuData: function (visuData, visuId) {

                return _parseVisuData(visuData, visuId);
            },

            // check if all pending visus are activated
            // activated means: visu is a known visu and its active state is not undefined
            allActivated: function () {
                var activated = false,
                    visu;
                //console.always('allActivated', 'warn')
                for (var i = 0; i < _pendingVisus.length(); i += 1) {
                    visu = _visuModel.visus[_pendingVisus.get(i)];
                    activated = visu !== undefined && visu.active !== undefined;
                    //console.log(_pendingVisus.get(i) + ',defined:' + (visu !== undefined) + ',activated:' + activated);
                    if (activated === false) {
                        return false;
                    }
                }
                _pendingVisus.reset();
                return true;
            },

            addContent: function (id, content) {
                if (_visuModel.contents[id] === undefined) {
                    if (!content.id) {
                        content.id = id;
                    }
                    _visuModel.contents[id] = content;
                }
            },

            addPage: function (id, page) {
                if (_visuModel.pages[id] === undefined) {
                    _visuModel.pages[id] = page;
                }
            },

            removePage: function (id) {
                if (_visuModel.pages[id] !== undefined) {
                    _visuModel.pages[id] = undefined;
                }
            },

            addDialog: function (id, dialog) {
                if (_visuModel.dialogs[id] === undefined) {
                    _visuModel.dialogs[id] = new Page(id, PageType.DIALOG, dialog.visuId, dialog);
                }
            },

            removeDialog: function (id) {
                if (_visuModel.dialogs[id] !== undefined) {
                    _visuModel.dialogs[id] = undefined;
                }
            },

            addLayout: function (id, layout) {
                if (_visuModel.layouts[id] === undefined) {
                    _visuModel.layouts[id] = layout;
                }
            },

            removeLayout: function (id) {
                if (_visuModel.layouts[id] !== undefined) {
                    _visuModel.layouts[id] = undefined;
                }
            },

            /*
            * @method addArea
            * add an area to a layout
            * @param {String} layoutId
            * @param {brease.model.objects.AreaInfo} area
            */
            addArea: function (layoutId, area) {
                var layout = _visuModel.layouts[layoutId];
                if (layout.areas[area.id] === undefined) {
                    layout.areas[area.id] = new AreaInfo(area.id, area);
                }
            },

            addAssignment: function (id, pageId, assignment) {
                var page = _visuModel.pages[pageId];
                if (page.assignments[id] === undefined) {
                    page.assignments[id] = assignment;
                }
            },

            getVisuData: function () {
                return _visuModel;
            },

            allContents: function () {
                return _visuModel.contents;
            },

            /**
            * @method getContentsOfPage
            * get contents of a certain page
            * @param {string} pageId
            * @param {string} pageType
            * @return {Content[]}
            */
            getContentsOfPage: function (pageId, pageType) {
                return _contentsOfPage(pageId, pageType);
            }
        };

        Object.defineProperty(VisuModel, 'startPageId', {
            get: function () {
                return _visuModel.startPageId;
            },
            enumerable: true,
            configurable: false
        });

        Object.defineProperty(VisuModel, 'startThemeId', {
            get: function () {
                return _visuModel.startThemeId;
            },
            enumerable: true,
            configurable: false
        });

        Object.defineProperty(VisuModel, 'startVisuId', {
            get: function () {
                return _visuModel.startVisuId;
            },
            enumerable: true,
            configurable: false
        });

        var _logger,
            _runtimeService,
            _visuModel,
            _pendingVisus = {
                stack: [],
                reset: function () {
                    this.stack.length = 0;
                },
                length: function () {
                    return this.stack.length;
                },
                get: function (i) {
                    return this.stack[i];
                },
                push: function (item) {
                    this.stack.push(item);
                }
            };

        function _initModel(rootVisuData, rootVisuId) {
            _visuModel = {
                pages: {},
                dialogs: {},
                layouts: {},
                contents: {},
                navigations: {},
                visus: {},
                themes: []
            };

            if (rootVisuData) {
                _visuModel.startPageId = rootVisuData.startPage;
                _visuModel.startVisuId = rootVisuId;
                _visuModel.startThemeId = rootVisuData.startTheme;
                _visuModel.configurations = rootVisuData.configurations;
            }
            if (brease.config.mocked) {
                window.visuModel = _visuModel; 
            }
        }

        function _findAssignedVisu(page) {
            var visuId;
            for (var key in page.assignments) {
                var assignment = page.assignments[key];
                if (assignment.type === AssignTypes.VISU && _visuModel.visus[assignment.contentId] === undefined) {
                    visuId = assignment.contentId = Utils.ensureVisuId(assignment.contentId);
                    break;
                }
            }
            return visuId;
        }

        function _findUnloadedVisu() {
            var visuId;
            for (var pageId in _visuModel.pages) {
                visuId = _findAssignedVisu(_visuModel.pages[pageId]);
                if (visuId) {
                    break;
                }
            }
            if (visuId === undefined) {
                for (var dialogId in _visuModel.dialogs) {
                    visuId = _findAssignedVisu(_visuModel.dialogs[dialogId]);
                    if (visuId) {
                        break;
                    }
                }
            }
            return visuId;
        }

        function _loadVisuDataResponseHandler(response, callbackInfo) {

            if (response.success === true && response.visuData) {

                if (!Utils.isObject(response.visuData.layouts) || Object.keys(response.visuData.layouts).length === 0) {
                    _logger.log(LogCode.NO_LAYOUTS_FOUND, { visuId: callbackInfo.visuId });
                }
                if (!Utils.isObject(response.visuData.pages) || Object.keys(response.visuData.pages).length === 0) {
                    _logger.log(LogCode.NO_PAGES_FOUND, { visuId: callbackInfo.visuId });
                }
                if (callbackInfo.isRoot === true) {
                    _initModel(response.visuData, callbackInfo.visuId);
                    _visuModel.visus[callbackInfo.visuId] = new Visualization(callbackInfo.visuId, response.visuData.startPage, callbackInfo.rootContainerId);
                    _extend(response.visuData, callbackInfo.visuId, true);
                } else {
                    _visuModel.visus[callbackInfo.visuId] = new Visualization(callbackInfo.visuId, response.visuData.startPage);
                    _extend(response.visuData, callbackInfo.visuId);

                }
            } else {
                _visuModel.visus[callbackInfo.visuId] = {
                    status: (response.status === 'parsererror') ? VisuStatus.MALFORMED : VisuStatus.NOT_FOUND
                };
            }

            var unloadedVisu = _findUnloadedVisu();
            if (unloadedVisu !== undefined) {
                _runtimeService.loadVisuData(unloadedVisu, _loadVisuDataResponseHandler, {
                    visuId: unloadedVisu, deferred: callbackInfo.deferred, isRoot: false
                });
            } else {
                callbackInfo.deferred.resolve(_visuModel.configurations);
            }
        }

        function _extend(visuData, visuId) {

            _mergeThemes(visuData.themes); // merge before parse, as themes will be removed
            visuData = _parseVisuData(visuData, visuId);

            $.extend(true, _visuModel, visuData);
        }

        function _mergeThemes(themes) {
            if (Array.isArray(themes)) {
                for (var i = 0; i < themes.length; i += 1) {
                    if (_visuModel.themes.indexOf(themes[i]) === -1) {
                        _visuModel.themes.push(themes[i]);
                    }
                }
            }
        }

        function _parseVisuData(loadedVisuData, visuId) {

            var visuData = {
                pages: {},
                dialogs: {},
                layouts: {},
                contents: {},
                navigations: {}
            };

            // pages store which visu they belong to
            for (var pageId in loadedVisuData.pages) {
                var page = loadedVisuData.pages[pageId];
                visuData.pages[pageId] = new Page(pageId, PageType.PAGE, visuId, page);
            }

            // dialogs store which visu they belong to
            for (var dialogId in loadedVisuData.dialogs) {
                var dialog = loadedVisuData.dialogs[dialogId];
                visuData.dialogs[dialogId] = new Page(dialogId, PageType.DIALOG, visuId, dialog);
            }

            // areas store their id
            for (var layoutId in loadedVisuData.layouts) {
                var layout = loadedVisuData.layouts[layoutId];
                layout.id = layoutId;
                for (var aid in layout.areas) {
                    layout.areas[aid] = new AreaInfo(aid, layout.areas[aid]);
                }
                visuData.layouts[layout.id] = layout;
            }

            // contents store their id and visuId
            for (var contentId in loadedVisuData.contents) {
                var content = loadedVisuData.contents[contentId];
                visuData.contents[contentId] = new Content(contentId, visuId, { path: content.path, width: content.width, height: content.height, configurations: content.configurations });
            }
            // parsing of Navigations; for better finding linking pages
            for (var navId in loadedVisuData.navigations) {
                visuData.navigations[navId] = new Navigation(navId, loadedVisuData, _logger);
            }
            return visuData;
        }

        function _visuActivatedHandler(e) {

            var visuId = e.detail.visuId,
                visu = _visuModel.visus[visuId];
            if (!visu) {
                return;
            }
            var deferred = visu.activateDeferred,
                callbackInfo = visu.callbackInfo;

            visu.active = true;
            window.clearTimeout(visu.timeout);
            delete visu.callbackInfo;
            delete visu.timeout;
            //console.log('%c' + BreaseEvent.VISU_ACTIVATED + ':' + e.detail.visuId, 'color:red');
            document.body.dispatchEvent(new CustomEvent(BreaseEvent.VISU_ACTIVATED, {
                detail: {
                    visuId: visuId, active: visu.active
                }
            }));
            if (deferred) {
                deferred.resolve(callbackInfo);
            }
        }

        // response can be positive or negative
        // a visu is activated, if active!=undefined
        function _activateVisuResponse(response, callbackInfo) {
            //console.log('_activateVisuResponse:' + JSON.stringify(response), callbackInfo)
            var visu = _visuModel.visus[callbackInfo.visuId];
            if (visu) {
                var deferred = visu.activateDeferred,
                    responseCode = (response !== undefined && response.status !== undefined) ? response.status.code : undefined;

                if (responseCode !== 0) {
                    deferred.reject(VisuStatus.ACTIVATE_FAILED, responseCode, callbackInfo);
                } else if (visu.active !== true) { // it's possible that VisuActivated is sent before activateVisuResponse
                    visu.timeout = window.setTimeout(function () {
                        brease.messenger.announce('VISU_NOT_ACTIVATED', { visuId: callbackInfo.visuId });
                    }, 30000);
                }
            }
        }

        function _contentsOfPage(pageId, pageType) {
            var contents = [],
                page = (pageType === PageType.DIALOG) ? VisuModel.getDialogById(pageId) : VisuModel.getPageById(pageId);
            if (page) {
                for (var aid in page.assignments) {

                    var assignment = page.assignments[aid];

                    switch (assignment.type) {
                        case AssignTypes.CONTENT:
                            if (VisuModel.isValidContent(assignment.contentId)) {
                                contents.push(assignment.contentId);
                            }
                            break;

                        case AssignTypes.PAGE:
                            contents.push.apply(contents, _contentsOfPage(assignment.contentId));
                            break;

                        case AssignTypes.VISU:

                            var embededVisuId = assignment.contentId,
                                visu = VisuModel.getVisuById(embededVisuId);

                            if (visu && visu.status === VisuStatus.LOADED) {
                                contents.push.apply(contents, _contentsOfPage(visu.startPage));
                            }

                            break;
                    }
                } 
            }
            return contents;
        }

        // Interne Objekte

        // *** Visualization ***

        function Visualization(id, startPage, containerId) {

            this.id = id;
            this.startPage = startPage;
            this.status = VisuStatus.LOADED;
            this.containerId = containerId;
        }

        return VisuModel.init();

    });
