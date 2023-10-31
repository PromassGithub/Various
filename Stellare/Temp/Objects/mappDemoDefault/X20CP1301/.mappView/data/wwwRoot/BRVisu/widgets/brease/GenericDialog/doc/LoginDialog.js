define(['brease/enum/Enum',
    'widgets/brease/GenericDialog/GenericDialog',
    'widgets/brease/GenericDialog/libs/config',
    'widgets/brease/GenericDialog/libs/models/dialogWidgetModel',
    'widgets/brease/GenericDialog/libs/enum/dialogResultEnum'],
function (Enum, GenericDialog, GenericDialogConfig, DialogWidgetModel, DialogResult) {
    'use strict';

    function _getUserNameInputName(self) {
        return self.config.prefixName + '_UserNameInput';
    }

    function _getPasswordInputName(self) {
        return self.config.prefixName + '_UserPasswordInput';
    }

    function _getRememberMeCheckBoxName(self) {
        return self.config.prefixName + '_RememberMeCheckBox';
    }

    function _getTextInput(self, name, type, placeholder, x, y) {
        var textInputWidget = new DialogWidgetModel();
        textInputWidget.name = name;
        textInputWidget.type = type;
        textInputWidget.x = x;
        textInputWidget.y = y;
        textInputWidget.width = '150px';

        textInputWidget.options = {
            'keyboard': self.config.keyboard,
            'placeholder': placeholder
        };

        return textInputWidget;
    }

    function _getRememberMeCheckBox(self) {
        var checkBoxWidget = new DialogWidgetModel();
        checkBoxWidget.name = _getRememberMeCheckBoxName(self);
        checkBoxWidget.type = 'widgets/brease/CheckBox';
        checkBoxWidget.x = 80;
        checkBoxWidget.y = 100;
        checkBoxWidget.width = '150px';

        checkBoxWidget.options = {
            'value': false,
            'text': 'Remember me'
        };

        return checkBoxWidget;
    }

    function _getDialogConfig(self) {
        var config = new GenericDialogConfig();

        // dialog
        config.forceInteraction = true;
        config.pointOfOrigin = Enum.PointOfOrigin.ELEMENT;
        config.contentWidth = 300;
        config.contentHeight = 140;
        config.stylePrefix = 'widgets_brease_GenericDialog';
        //config.style = self.config.style;

        // header
        config.header.text = 'Login dialog';

        // content
        var userNameInputName = _getUserNameInputName(self);
        var inputUserName = _getTextInput(self, userNameInputName, 'widgets/brease/TextInput', 'Username', 80, 20);

        var passwordInputName = _getPasswordInputName(self);
        var inputPassword = _getTextInput(self, passwordInputName, 'widgets/brease/Password', 'Password', 80, 60);

        var chbRememberMe = _getRememberMeCheckBox(self);

        config.widgets.push(inputUserName);
        config.widgets.push(inputPassword);
        config.widgets.push(chbRememberMe);

        //footer
        config.buttons.ok = true;
        config.buttons.cancel = true;

        return config;
    }

    function _dialogClosingHandler(self, e) {
        var userNameWidget = self.dialog.getWidgetByName(_getUserNameInputName(self));
        var passwordWidget = self.dialog.getWidgetByName(_getPasswordInputName(self));
        var rememberMeWidget = self.dialog.getWidgetByName(_getRememberMeCheckBoxName(self));

        self.config.userName = userNameWidget.getValue();
        self.config.userPassword = passwordWidget.getValue();
        self.config.rememberMe = rememberMeWidget.getValue();

        self.config.dialogResult = self.dialog.getDialogResult();
        self.closingDeferred.resolve(self.config);
        self.closingDeferred = null;
    }

    function LoginDialog() {
        this.dialog = null;
        this.config = null;
    }

    var p = LoginDialog.prototype;

    p.show = function (loginDialogConfig) {
        var self = this;
        this.closingDeferred = $.Deferred();

        this.dialog = new GenericDialog();
        this.config = loginDialogConfig;

        var dialogConfig = _getDialogConfig(this);

        this.dialog.onClosing().then(function (e) {
            _dialogClosingHandler(self, e);
        });
        this.dialog.show(dialogConfig, this.config.refElement);

        return this.closingDeferred.promise();
    };

    return LoginDialog;

});
