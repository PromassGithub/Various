define(function () {

    'use strict';

    /**
    * @class brease.services.libs.User
    * @extends Object
    */
    /**
    * @property {String} userID
    */
    /**
    * @property {String} displayName
    */
    
    var User = function (userID, displayName, isAuthenticated) {
        this.userID = userID;
        this.displayName = displayName || userID;
        this.isAuthenticated = (isAuthenticated === true);
    };

    User.fromServerData = function (data) {
        if (data) {
            return new User(data.userID, data.displayName, data.isAuthenticated); 
        } else {
            return new User();
        }
    };

    return User;
});
