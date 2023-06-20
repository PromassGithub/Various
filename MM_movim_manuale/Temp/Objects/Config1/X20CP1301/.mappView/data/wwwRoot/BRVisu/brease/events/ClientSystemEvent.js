define(['brease/core/Utils'], function (Utils) {

    'use strict';

    /** 
    * @enum {String} brease.events.ClientSystemEvent 
    */
    
    /**
    * @property {string} CONTENT_LOADED='ContentLoaded'
    * @readonly
    * @static
    */
    /**
    * @property {string} DISABLED_CLICK='DisabledClick'
    * @readonly
    * @static
    */
    /**
    * @property {string} DIALOG_CLOSED='DialogClosed'
    * @readonly
    * @static
    */
    /**
    * @property {string} DIALOG_OPENED='DialogOpened'
    * @readonly
    * @static
    */
    /**
    * @property {string} KEY_DOWN='KeyDown'
    * @readonly
    * @static
    */
    /**
    * @property {string} KEY_PRESS='KeyPress'
    * @readonly
    * @static
    */
    /**
    * @property {string} KEY_UP='KeyUp'
    * @readonly
    * @static
    */
    /**
    * @property {string} LOGIN_FAILED='LoginFailed'
    * @readonly
    * @static
    */
    /**
    * @property {string} LOGIN_SUCCESS='LoginSuccess'
    * @readonly
    * @static
    */
    /**
    * @property {string} SYSTEM_SWIPE='SystemSwipe'
    * @readonly
    * @static
    */
    /**
    * @property {string} TOOLTIPMODE_ACTIVATED='TooltipModeActivated'
    * @readonly
    * @static
    */
    /**
    * @property {string} TOOLTIPMODE_DEACTIVATED='TooltipModeDeactivated'
    * @readonly
    * @static
    */
    var ClientSystemEvent = {};

    Utils.defineProperty(ClientSystemEvent, 'CONTENT_LOADED', 'ContentLoaded');
    Utils.defineProperty(ClientSystemEvent, 'DISABLED_CLICK', 'DisabledClick');
    Utils.defineProperty(ClientSystemEvent, 'DIALOG_CLOSED', 'DialogClosed');
    Utils.defineProperty(ClientSystemEvent, 'DIALOG_OPENED', 'DialogOpened');
    Utils.defineProperty(ClientSystemEvent, 'KEY_DOWN', 'KeyDown');
    Utils.defineProperty(ClientSystemEvent, 'KEY_PRESS', 'KeyPress');
    Utils.defineProperty(ClientSystemEvent, 'KEY_UP', 'KeyUp');
    Utils.defineProperty(ClientSystemEvent, 'LOGIN_FAILED', 'LoginFailed');
    Utils.defineProperty(ClientSystemEvent, 'LOGIN_SUCCESS', 'LoginSuccess');
    Utils.defineProperty(ClientSystemEvent, 'SYSTEM_SWIPE', 'SystemSwipe');
    Utils.defineProperty(ClientSystemEvent, 'TOOLTIPMODE_ACTIVATED', 'TooltipModeActivated');
    Utils.defineProperty(ClientSystemEvent, 'TOOLTIPMODE_DEACTIVATED', 'TooltipModeDeactivated');
    return ClientSystemEvent;

});
