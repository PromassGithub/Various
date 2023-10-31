define(function () {
    'use strict';
    function LoginDialogConfig() {

        this.prefixName = '';
        this.style = '';
        this.keyboard = true;
        this.refElement = null;

        this.userName = '';
        this.userPassword = '';
        this.rememberMe = false;

        this.dialogResult = '';
    }

    return LoginDialogConfig;
});
