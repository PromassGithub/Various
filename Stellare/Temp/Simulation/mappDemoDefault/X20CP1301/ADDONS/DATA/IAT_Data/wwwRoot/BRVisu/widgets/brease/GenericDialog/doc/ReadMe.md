# GenericDialog

First of all, note that <code>GenericDialog</code> Widget extends <code>Window</code> Window widget.

A <code>GenericDialog</code> is a floating window that contains a title bar and a content area. The dialog window can be moved and closed with the 'x' icon by default.

If the content length exceeds the maximum height, a scrollbar will automatically appear.

A bottom button bar and semi-transparent modal overlay layer are common options that can be added.


## Theming
This widget can be styled via theme styling in the same way as other widgets.

```xml
    <Style id="default" xsi:type="widgets.brease.GenericDialog"
    headerGradient="linear-gradient(to bottom, #4A4A4A 0%,#7C7C7C 100%)" 
    borderColor="#7C7C7C" /> 
```

## Basic usage

The following code shows a dialog with a Label widget inside.

```javascript
        define(['widgets/brease/GenericDialog/GenericDialog',
            'widgets/brease/GenericDialog/libs/config',
            'widgets/brease/GenericDialog/libs/models/dialogWidgetModel'],
            function (GenericDialog, GenericDialogConfig, DialogWidgetModel){
                var dialog = new GenericDialog();

                var dialogConfig = new GenericDialogConfig();   
                dialogConfig.contentWidth = 200;
                dialogConfig.contentHeight = 50;
                dialogConfig.header.text = "Some Title";

                // Add Label
                var labelWidget = new DialogWidgetModel();
                labelWidget.name = "label1";
                labelWidget.type = "widgets/brease/Label";
                labelWidget.x = 20;
                labelWidget.y = 20;
                labelWidget.options = {
                    "text": "Here is some message!"
                };

                dialogConfig.widgets.push(labelWidget)

                dialog.show(dialogConfig);
            });        
```

![Basic Dialog](./Images/BasicDialog.JPG "Basic Dialog")

## Options

All options are defined in /libs/config.js

For further information see ([/libs/config.js](../libs/config.js))

## Methods

| Method                            |  Description                                 |
|-----------------------------------|----------------------------------------------|
| show(config, refElement)          | Opens the Dialog on the page <br/><b>config</b> GenericDialog configuration <br/><b>refElement</b>DOM element to which should defined the as the <b>pointOfOrigin</b> |
| hide()                            | Closes the dialog, without any dialog result |
| close()                           | Closes the dialog, with dialog result <b>CLOSE</b>
| isOpen()                          | <b>true</b> if dialog is open, otherwise false  |
| onClosing()                       | Returns a <b>deferredObject</b> which is resolved before dialog is disposed   |
| getDialogResult()                 | Returns the closing result of the dialog, which describes how the dialog was closed |
| getWidgetByName(name)             | Returns a widget inside the dialog, identified by the <b>name</b> paramter |
| getWidgetIdByName(name)           | Returns the ID of a widget inside the dialog, identified by configured name |
| addWidget(DialogWidgetModel)      | Adds widget to the dialog. Usefull for adding widgets dynamically when dialog is already open. |
| removeWidget(DialogWidgetModel)   | Removes widget from the dialog. Usefull for removing widgets dynamically when dialog is already open. |
| updateContentSize(width, height)  | Update the height and width of the content area of the Dialog. The content area is the container where widgets can be placed. |
| dispose()                         | This method cleans up the data of the dialog. Mostly for internal usage.|

# Events

| Method                            |  Description                                  |
|-----------------------------------|-----------------------------------------------|
| BreaseEvent.WINDOW_SHOW           | Called when dialog is shown                   |
| BreaseEvent.WIDGET_READY          | Called when content is parsed                 |
| "window_closing"                  | Called when dialog starts closing             |
| BreaseEvent.CLOSED                | Called when closing of dialog is finished     |




## Advanced usage


The following code shows a dialog with a Label widget and a TextInput widget inside. And when dialog returns <code>DialogResultEnum.OK</code> The value of TextInput is written to console. 

```javascript
        define(['widgets/brease/GenericDialog/GenericDialog',
            'widgets/brease/GenericDialog/libs/config',
            'widgets/brease/GenericDialog/libs/models/dialogWidgetModel',
            'widgets/brease/GenericDialog/libs/enum/DialogResultEnum'],
            function (GenericDialog, GenericDialogConfig, DialogWidgetModel, DialogResult){
                var dialog = new GenericDialog();

                var dialogConfig = new GenericDialogConfig();   
                dialogConfig.contentWidth = 240;
                dialogConfig.contentHeight = 50;
                dialogConfig.header.text = "Some Title";

                // Add Label
                var labelWidget = new DialogWidgetModel();
                labelWidget.name = "label1";
                labelWidget.type = "widgets/brease/Label";
                labelWidget.x = 20;
                labelWidget.y = 20;
                labelWidget.options = {
                    "text": "Input"
                };
                dialogConfig.widgets.push(labelWidget)
                
                // Add TedtInput
                var textInputWidget = new DialogWidgetModel();
                textInputWidget.name = "TextInput1";
                textInputWidget.type = "widgets/brease/TextInput";
                textInputWidget.x = 120;
                textInputWidget.y = 20;
                textInputWidget.width = "100px";
                textInputWidget.options = {
                    "value": ""
                };
                dialogConfig.widgets.push(textInputWidget)

                dialog.onClosing().then(function (e) {
                    if(dialog.getDialogResult() === DialogResult.OK){
                        var textInputWidget = dialog.getWidgetByName("TextInput1");
                        console.log(textInputWidget.getValue());
                    }
                 });
                dialog.show(dialogConfig);
            }); 
```

 
 


 