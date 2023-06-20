define(['brease/controller/libs/LogCode',
    'brease/controller/libs/Areas',
    'brease/objects/AreaInfo',
    'brease/controller/libs/Containers',
    'brease/controller/objects/ContentStatus',
    'brease/controller/objects/PageType',
    'brease/core/Utils'],
function (LogCode, Areas, AreaInfo, containers, ContentStatus, PageType, Utils) {

    'use strict';

    var ContentValidator = {};

    ContentValidator.injectDependencies = function (obj) {
        if (obj.visuModel) {
            this.visuModel = obj.visuModel;
        }
        if (obj.contentManager) {
            this.contentManager = obj.contentManager;
        }
        if (obj.loaderPool) {
            this.loaderPool = obj.loaderPool;
        }
    };

    /**
        * @method getTargetForContent
        * Validates if a content load is allowed and returns area and assignment  
        * in case of success=false, additional info is returned, which is needed in PageLogger, dependent of returned statusCode  
        * @param {Object} data
        * @param {String} data.contentId
        * @param {String} data.areaId
        * @param {String} data.pageId
        * @param {brease.controller.objects.PageType} data.pageType
        * @param {Boolean} force
        * @return {Object} response
        * @return {Boolean} response.success
        * @return {brease.controller.libs.LogCode} response.statusCode LogCode for PageLogger in case of success=false
        * @return {Object} response.data
        * @return {Object} response.data.area
        * @return {Object} response.data.assignment
        * @return {String} [response.data.contentId]
        * @return {String} [response.data.containerId]
        * @return {String} [response.data.areaId]
        * @return {String} [response.data.pageId]
        * @return {String} [response.data.layoutId]
        */
    ContentValidator.getTargetForContent = function (data, force) {

        // content to load has to exist and must not be in creation or already loaded, except force is set
        var response = (force !== true) ? _validateContent(data.contentId) : { success: true };
        if (!response.success) {
            return response;
        }

        // page has to exist and has to be currently loaded
        var containerId, page;
        response = _validatePage(data.pageId, data.pageType);
        if (!response.success) {
            return response;
        } else {
            page = response.data.page;
            containerId = response.data.containerId;
        }

        // area has to be part of layout of page
        var area;
        response = _validateArea(data, page, containerId);
        if (!response.success) {
            return response;
        } else {
            area = response.data.area;
        }

        // A&P 629100: strategy for loadContentInArea: not allowed as long old or new content is pending or inQueue
        var currentContentId = _findContentOfArea(area, page),
            oldContentPending = currentContentId && (ContentValidator.contentManager.isPending(currentContentId) || ContentValidator.contentManager.getActiveState(currentContentId) === ContentStatus.inQueue),
            newContentId = data.contentId,
            newContentPending = ContentValidator.contentManager.isPending(newContentId) || ContentValidator.contentManager.getActiveState(newContentId) === ContentStatus.inQueue;
            
        if (newContentPending || oldContentPending) {
            response.success = false;
            response.statusCode = LogCode.CONTENT_LOADING_IN_PROCESS;
            response.data = { areaId: data.areaId, pageId: data.pageId, layoutId: page.layout };
            return response;
        }

        // create new assignment with desired contentid
        var assignment = _createAssignment(page, data.areaId, data.contentId);

        if (response.success === true) {
            response.data = {
                area: area,
                assignment: assignment
            };
        }

        return response;
    };

    /**
        * @method getTargetForWidget
        * Returns areaId, pageId and areaDivId of the created area and page for the loading of a content into a ContentControl  
        * @param {String} widgetId
        * @param {String} contentId id of the content to be loaded
        * @param {String} parentContentId id of the content, where the widget is located
        * @param {ZoomType} zoomMode
        * @param {Object} size
        * @param {jQuery} $LayoutArea jquery object of the layoutArea in the widget; at first load this area does not exist -> $LayoutArea.length=0
        * @return {Object} 
        * @return {String} return.pageId id of the created virtual page for the assignment of the content to the area
        * @return {Object} return.areaId id of area, where the content is loaded
        * @return {Object} return.areaDivId id of div of area, where the content is loaded
        */
    ContentValidator.getTargetForWidget = function (widgetId, contentId, parentContentId, zoomMode, size, $LayoutArea) {
        var areaId = 'A0',
            layoutId = widgetId,
            pageId = 'virtualPage_' + widgetId,
            areaInfo = new AreaInfo(areaId, { width: size.realWidth, cssWidth: size.cssWidth, height: size.realHeight, cssHeight: size.cssHeight, top: 0, left: 0 }),
            parentContent = ContentValidator.visuModel.getContentById(parentContentId),
            areaObj;

        if ($LayoutArea.length === 0) {
            ContentValidator.visuModel.addLayout(layoutId, { id: layoutId, areas: {} });
            ContentValidator.visuModel.addArea(layoutId, areaInfo);
            ContentValidator.visuModel.addPage(pageId, { id: pageId, layout: layoutId, type: 'Page', visuId: (parentContent) ? parentContent.visuId : ContentValidator.visuModel.startVisuId, assignments: {} });
            ContentValidator.visuModel.addAssignment(areaId, pageId, { areaId: areaId, contentId: contentId, type: 'Content', zoomMode: zoomMode });
            containers.addContainer(widgetId, { currentPage: pageId });

            areaObj = Areas.add(widgetId, layoutId, areaInfo, 'Page');
            var widgetElem = document.getElementById(widgetId);
            if (widgetElem) {
                widgetElem.appendChild(areaObj.div);
            }
        } else {
            areaObj = Areas.getArea(widgetId, layoutId, areaId, 'Page');
            areaObj.$div = $LayoutArea;
            areaObj.div = $LayoutArea[0];
            areaObj.$innerBox = $LayoutArea.find(' > .ScrollBox');
            areaObj.innerBox = areaObj.$innerBox[0];
            areaObj.info = areaInfo;
        }

        return {
            areaDivId: (areaObj) ? areaObj.id : undefined,
            areaId: areaId,
            pageId: pageId
        };
    };

    // create a new assignment from an existing assignment
    // used when exchanging contents with loadContentInArea or laodContentInDialogArea
    function _createAssignment(page, areaId, contentId) {
        var assignment = {},
            originalAssignment = ContentValidator.visuModel.findAssignment(page, areaId);
        if (originalAssignment) {
            assignment = Utils.deepCopy(originalAssignment);
        }
        assignment.contentId = contentId;
        return assignment;
    }

    function _findContentOfArea(area, page) {
        var loaderElem = document.querySelectorAll('#' + area.id + ' [data-brease-widget="system/widgets/ContentLoader"]'),
            contentId;

        if (loaderElem.length === 0) {
            contentId = page.assignments[area.info.id].contentId;
        } else {
            contentId = loaderElem[0].getAttribute('data-brease-contentid');
        }

        return contentId === undefined ? page.assignments[area.info.id].contentId : contentId;
    }

    function _validateContent(contentId) {
        var content = ContentValidator.visuModel.getContentById(contentId);

        if (content === undefined || content.virtual === true) {
            return {
                success: false,
                statusCode: LogCode.CONTENT_NOT_FOUND,
                data: { contentId: contentId }
            };
        } else if (ContentValidator.loaderPool.isContentLoaded(contentId) === true) {
            return {
                success: false,
                statusCode: LogCode.CONTENT_IS_ACTIVE,
                data: { contentId: contentId }
            };
        } 

        return {
            success: true,
            statusCode: 0,
            data: {}
        };
    }

    function _validatePage(pageId, pageType) {
        var response = {
            success: true,
            statusCode: 0,
            data: {}
        };

        if (pageType === PageType.PAGE) {
            response.data.page = ContentValidator.visuModel.getPageById(pageId);
            if (!response.data.page) {
                response.success = false;
                response.statusCode = LogCode.PAGE_NOT_FOUND;
                response.data = {
                    pageId: pageId,
                    isStartPage: false
                };
                return response;
            }
        } else if (pageType === PageType.DIALOG) {
            response.data.page = ContentValidator.visuModel.getDialogById(pageId);
            if (!response.data.page) {
                response.success = false;
                response.statusCode = LogCode.DIALOG_NOT_FOUND;
                response.data = {
                    dialogId: pageId
                };
                return response;
            }
        }
        response.data.containerId = containers.getContainerForPage(pageId);
        if (response.data.containerId === undefined) {
            response.success = false;
            response.statusCode = LogCode.PAGE_NOT_CURRENT;
            response.data = {
                pageId: pageId
            };

        }
        return response;
    }

    function _validateArea(data, page, containerId) {
        
        if (ContentValidator.visuModel.pageHasArea(data.areaId, page) === false) {
            return { 
                success: false,
                statusCode: LogCode.AREA_NOT_FOUND,
                data: { areaId: data.areaId, pageId: data.pageId, layoutId: page.layout }
            };
        }
        var area = Areas.getArea(containerId, page.layout, data.areaId, page.type);
        if (!area) {
            return { 
                success: false,
                statusCode: LogCode.AREA_NOT_FOUND,
                data: { areaId: data.areaId, pageId: data.pageId, layoutId: page.layout }
            };
        }

        return { 
            success: true,
            statusCode: 0,
            data: { area: area } 
        };
    }

    return ContentValidator;
});
