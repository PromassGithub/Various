define(['brease/events/SocketEvent'], function (SocketEvent) {

    'use strict';

    /**
    * @class brease.controller.ConnectionController
    * @extends Object
    * controls server connections
    * @singleton
    */
    var ConnectionController = {
            init: function (runtimeService, systemMessage, reconnectHandler, transferFinishedHandler) {
                _reconnectHandler = reconnectHandler || window.location.reload.bind(window.location);
                _transferFinishedHandler = transferFinishedHandler || window.location.reload.bind(window.location);
                runtimeService.addEventListener(SocketEvent.CONNECTION_STATE_CHANGED, _connectionStateChangedHandler.bind(this, systemMessage));
                runtimeService.addEventListener(SocketEvent.TRANSFER_START, _transferStartHandler.bind(this, systemMessage));
                runtimeService.addEventListener(SocketEvent.TRANSFER_FINISH, _transferFinishHandler.bind(this, systemMessage));
            }
        },
        _transferInProcess = false,
        _reconnectHandler, _transferFinishedHandler;

    function _connectionStateChangedHandler(systemMessage, e) {
        if (e.detail.state === true) {
            systemMessage.clear();
            _reconnectHandler();
        } else if (_transferInProcess !== true) {
            document.body.dispatchEvent(new CustomEvent(SocketEvent.CONNECTION_STATE_CHANGED, { detail: { state: e.detail.state } }));
            systemMessage.showMessage(brease.language.getSystemTextByKey('BR/IAT/brease.common.connectionError.text'));
        }
    }

    function _transferStartHandler(systemMessage) {
        _transferInProcess = true;
        systemMessage.showMessage(brease.language.getSystemTextByKey('BR/IAT/brease.common.transferStart'));
    }

    function _transferFinishHandler(systemMessage) {
        _transferInProcess = false;
        systemMessage.clear();
        _transferFinishedHandler();
    }

    return ConnectionController;

});
