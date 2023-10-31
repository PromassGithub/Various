define(['brease/core/Utils', 'brease/events/BreaseEvent', 'brease/events/SocketEvent', 'brease/events/ClientSystemEvent', 'brease/enum/Enum'], function (Utils, BreaseEvent, SocketEvent, ClientSystemEvent, Enum) {

    'use strict';

    /**
    * @class brease.services.User
    * @extends core.javascript.Object
    * User service; available via brease.user 
    * Authentification is a two step process
    *   First step is to authenticate the username and pw
    *   Second step is to set the user via setCurrentUser
    * Example of usage:
    * 
    *       <script>
    *           require(['brease', 'brease/events/BreaseEvent'], function (brease, BreaseEvent) {
    *               
    *               brease.user.authenticateUser('username', '****').then(        
    *                   successCallBackFunction,
    *                   errorCallBackFunction
    *               });
    *           });
    *       </script>
    * 
    * @singleton
    */
    var User = {

        /*
        /* PUBLIC
        */

        init: function (runtimeService) {
            _runtimeService = runtimeService;
            _currentUser = null;
            return this;
        },

        isReady: function () {
            _deferredReady = $.Deferred();
            _load();
            return _deferredReady.promise();
        },

        getSeparators: function () {
            return {
                dsp: '.',
                gsp: ','
            };
        },
        /**
        * @method authenticateUser
        * @async
        * Async function to authenticate a user (first step of login)
        *
        *       brease.user.authenticateUser('username', '****').then(        
        *           function(user) {
        *               //Success Callback
        *           },
        *           function() {
        *               //Error Callback
        *           }
        *       });
        *
        * @param {String} username
        * @param {String} password
        * @return {Promise}
        */
        authenticateUser: function (username, password) {
            _deferAuth = $.Deferred();
            _runtimeService.authenticateUser(username, password, _authenticateResponseHandler);
            return _deferAuth.promise();
        },

        /**
        * @method setCurrentUser
        * @async
        * Async function to set a user (second step of login)
        *
        *       brease.user.setCurrentUser('user').then(        
        *           function() {
        *               //Success Callback
        *           },
        *           function() {
        *               //Error Callback
        *           }
        *       });
        *
        * @param {Object} user User Object 
        * @return {Promise}
        */
        setCurrentUser: function (user) {
            _deferUser = $.Deferred();
            _runtimeService.setCurrentUser(user, _setUserResponseHandler);
            return _deferUser.promise();
        },

        /**
        * @method loadCurrentUser
        * @async
        * Async function to get the current User
        *
        *       brease.user.loadCurrentUser().then(        
        *           function(user) {
        *               //Success Callback
        *           },
        *           function() {
        *               //Error Callback
        *           }
        *       });
        *
        * @return {Promise}
        */
        loadCurrentUser: function () {
            _deferUser = $.Deferred();
            if (_currentUser !== undefined && _currentUser !== null) {
                _deferUser.resolve(_currentUser);
            } else {
                _runtimeService.loadCurrentUser(_getUserResponseHandler);
            }

            return _deferUser.promise();
        },

        /**
        * @method getCurrentUser
        * @return {Object} _currentUser
        */
        getCurrentUser: function () {
            return _currentUser;
        },

        /**
        * @method setDefaultUser
        * @async
        * Async function to set the default user
        *
        *       brease.user.setDefaultUser().then(        
        *           function(user) {
        *               //Success Callback
        *           },
        *           function() {
        *               //Error Callback
        *           }
        *       });
        *
        * @return {Promise}
        */
        setDefaultUser: function () {
            _deferUser = $.Deferred();
            _runtimeService.setDefaultUser(_setUserResponseHandler);
            return _deferUser.promise();
        },

        /**
        * @method hasOneOfRoles
        * returns true if the current user has one of the provided roles
        * @param {RoleCollection} roles Array of role names, e.g. ['Administrators','Guest']
        * @return {Boolean}
        */
        hasOneOfRoles: function (roles) {
            return User.permission(roles, User.getUserRoles());
        },

        /**
        * @method permission
        * returns true if the two arrays intersect
        * returns false if one of the arrays is empty or not an array
        * @param {RoleCollection} value
        * @param {RoleCollection} arRoles
        * @return {Boolean}
        */
        permission: function (value, arRoles) {
            var i;
            if (!Array.isArray(value) || value.length === 0) {
                return false;
            }
            if (!Array.isArray(arRoles) || arRoles.length === 0) {
                return false;
            }
            if (value.length < arRoles.length) {
                for (i = 0; i < value.length; i += 1) {
                    if (arRoles.indexOf(value[i]) !== -1) {
                        return true;
                    }
                }
            } else {
                for (i = 0; i < arRoles.length; i += 1) {
                    if (value.indexOf(arRoles[i]) !== -1) {
                        return true;
                    }
                }
            }
            return false;
        },

        /**
        * @method getUserRoles
        * @return {Array}
        */
        getUserRoles: function () {
            return _roles;
        },

        /**
        * @method loadUserRoles
        * @async
        * Async function to get roles of user from server. Can be used with deferred object or callback.  
        *  
        *  
        *       $.when(
        *           brease.user.loadUserRoles()
        *       ).then(function (roles) {
        *           // Example return value: ["Administrators","Guest"]
        *       });
        *
        * or
        *
        *       brease.user.loadUserRoles(function(roles) {
        *           // Example return value: ["Administrators","Guest"]
        *       });
        * 
        * @param {Function} [callback]
        *
        * @return {Promise}
        */
        loadUserRoles: function (callback) {
            var deferred = $.Deferred();

            _runtimeService.loadUserRoles(_loadUserRolesResponseHandler, { deferred: deferred, callback: callback });

            return deferred.promise();
        },

        loginAction: function (username, password) {
            _deferAction = $.Deferred();
            _runtimeService.authenticateUser(username, password, _loginActionAuthResponseHandler);
            return _deferAction.promise();
        }
    };

    function _loginActionAuthResponseHandler(data) {
        if (data.success === true && data.user !== undefined && data.user.isAuthenticated === true) {
            _runtimeService.setCurrentUser(data.user, _loginActionSetUserResponseHandler.bind(null, data.user.userID));
        } else {
            _loginActionResolve(false, data.user.userID);
        }
    }

    function _loginActionResolve(success, userName) {
        _deferAction.resolve({ success: success });
        var e = {
            event: (success) ? ClientSystemEvent.LOGIN_SUCCESS : ClientSystemEvent.LOGIN_FAILED,
            source: {
                type: 'clientSystem.Event'
            },
            eventArgs: {
                userName: userName
            }
        };
        _runtimeService.sendEvent(e);
    }

    function _loginActionSetUserResponseHandler(userName, data) {
        _loginActionResolve(data.success, userName);
    }

    var _deferredReady,
        _deferAuth,
        _deferUser,
        _deferAction,
        _currentUser,
        _roles = [],
        _runtimeService;

    function _loadUserRolesResponseHandler(responseData, callbackInfo) {
        if (responseData.success && responseData.roles) {
            _roles = responseData.roles.sort();
        }
        _resolve(callbackInfo.deferred, callbackInfo.callback, responseData.roles);
    }

    function _resolve(deferred, callback, result) {
        if (Utils.isFunction(callback)) {
            callback(result);
        }
        deferred.resolve(result);
    }

    function _load() {
        _runtimeService.addEventListener(SocketEvent.USER_CHANGED, _userChangedHandler);
        _runtimeService.loadCurrentUser(_initLoadUserResponseHandler);
    }

    function _initLoadUserResponseHandler(data) {
        if (data.success === true) {
            _currentUser = data.user;
            document.body.dispatchEvent(new CustomEvent(BreaseEvent.USER_LOADED, { detail: data.user }));

            // load user roles after initial user load
            $.when(
                brease.user.loadUserRoles()
            ).then(function () {
                _deferredReady.resolve();
            });

        } else {
            _deferredReady.reject();
        }
    }

    function _authenticateResponseHandler(data) {

        if (data.success === true && data.user !== undefined && data.user.isAuthenticated === true) {
            _deferAuth.resolve(data.user);
            brease.loggerService.log(Enum.EventLoggerId.CLIENT_USER_AUTHENTICATE_OK, Enum.EventLoggerCustomer.BUR, Enum.EventLoggerVerboseLevel.OFF, Enum.EventLoggerSeverity.SUCCESS, [data.user.userID]);
        } else {
            _deferAuth.reject(data.user);
            brease.loggerService.log(Enum.EventLoggerId.CLIENT_USER_AUTHENTICATE_FAIL, Enum.EventLoggerCustomer.BUR, Enum.EventLoggerVerboseLevel.OFF, Enum.EventLoggerSeverity.ERROR, [data.user.userID]);
        }

    }

    function _setUserResponseHandler(data) {

        if (data.success === true) {
            _deferUser.resolve();
            brease.loggerService.log(Enum.EventLoggerId.CLIENT_USER_SETUSER_OK, Enum.EventLoggerCustomer.BUR, Enum.EventLoggerVerboseLevel.OFF, Enum.EventLoggerSeverity.SUCCESS);

        } else {
            _deferUser.reject();
            brease.loggerService.log(Enum.EventLoggerId.CLIENT_USER_SETUSER_FAIL, Enum.EventLoggerCustomer.BUR, Enum.EventLoggerVerboseLevel.OFF, Enum.EventLoggerSeverity.ERROR);
        }

    }

    function _getUserResponseHandler(data) {
        if (data.success) {
            _currentUser = data.user;
            _deferUser.resolve(data.user);
        } else {
            _deferUser.reject();
        }

    }

    function _userChangedHandler(e) {

        _currentUser = e.detail.user;

        // load user roles after user has changed
        $.when(
            brease.user.loadUserRoles()
        ).then(function () {
            document.body.dispatchEvent(new CustomEvent(BreaseEvent.ROLES_CHANGED));
        });

        document.body.dispatchEvent(new CustomEvent(BreaseEvent.USER_CHANGED, { detail: _currentUser }));
        brease.loggerService.log(Enum.EventLoggerId.CLIENT_USER_USERCHANGE, Enum.EventLoggerCustomer.BUR, Enum.EventLoggerVerboseLevel.OFF, Enum.EventLoggerSeverity.INFORMATIONAL, [_currentUser.userID]);
    }

    return User;
});
