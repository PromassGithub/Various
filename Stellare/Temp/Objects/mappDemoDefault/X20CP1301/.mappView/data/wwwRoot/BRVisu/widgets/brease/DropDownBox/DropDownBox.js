define([
    'brease/core/BaseWidget',
    'widgets/brease/DropDownBox/libs/config/Config',
    'widgets/brease/DropDownBox/libs/config/InitState',
    'widgets/brease/DropDownBox/libs/SubmitQueue',
    'brease/decorators/LanguageDependency',
    'brease/decorators/VisibilityDependency',
    'widgets/brease/DropDownBox/libs/view/DropDownBoxView/DropDownBoxView',
    'widgets/brease/DropDownBox/libs/reducer/DropDownBoxActions',
    'widgets/brease/DropDownBox/libs/reducer/DropDownBoxReducer',
    'widgets/brease/common/libs/external/redux',
    'widgets/brease/common/libs/redux/utils/UtilsList',
    'widgets/brease/common/libs/redux/utils/UtilsImage',
    'widgets/brease/common/libs/redux/utils/UtilsText',
    'widgets/brease/common/libs/BindingSync',
    'widgets/brease/common/libs/wfUtils/UtilsEditableBinding',
    'brease/decorators/DragAndDropCapability'
], function (SuperClass, Config, InitState, SubmitQueue, languageDependency, visibilityDependency, DropDownBoxView, DropDownBoxActions, DropDownBoxReducer, Redux, UtilsList, UtilsImage, UtilsText, BindingSync, UtilsEditableBinding, dragAndDropCapability) {

    'use strict';

    /**
     * @class widgets.brease.DropDownBox
     *
     * @mixins widgets.brease.common.DragDropProperties.libs.DroppablePropertiesEvents
     *
     * #Description
     * DropDownBox
     * @extends brease.core.BaseWidget
     *
     * @iatMeta studio:visible
     * true
     * @iatMeta category:Category
     * Selector
     * @iatMeta description:short
     * Liste von Texten
     * @iatMeta description:de
     * Zeigt eine Liste, aus welcher der Benutzer Elemente auswählen kann
     * @iatMeta description:en
     * Displays a list from where the user can select items
     */

    var defaultSettings = Config,

        WidgetClass = SuperClass.extend(function DropDownBox() {
            SuperClass.apply(this, arguments);
        }, defaultSettings),

        p = WidgetClass.prototype;

    p.init = function () {

        //Initialize superclass
        SuperClass.prototype.init.apply(this, arguments);

        //Define order for binding properties
        BindingSync.setupPropertyOrder(this, [
            {
                name: 'selectedValue',
                waitFor: ['dataProvider']
            }, {
                name: 'selectedIndex',
                waitFor: ['dataProvider']
            }]);

        // queue for submitChange requests
        this.submitQueue = new SubmitQueue(this);

        //Calculate init state
        var initState = InitState.calculateInitState(this.settings, this.isEnabled(), this.isVisible());

        //Create store
        this.store = Redux.createStore(DropDownBoxReducer, initState);

        //Update editor grid with the default values to match the par value id
        this.submitChangeToEditor();

        //Create View
        this.dropDownBoxView = new DropDownBoxView(this.store, this.el, this);

        //Subscribe master view to the store
        this.store.subscribe(this.dropDownBoxView.render.bind(this.dropDownBoxView));

    };

    p.valueChangeFromUI = function () {
        //Send value for the index if the value has changed
        this.submitChange();
        this.triggerToggleStateChanged();
    };

    /**
     * @method setStyle
     * @iatStudioExposed
     * @param {StyleReference} value
     */
    p.setStyle = function (style) {
        SuperClass.prototype.setStyle.apply(this, arguments);
        var action = DropDownBoxActions.styleChange(style);
        this.store.dispatch(action);
    };

    p.langChangeHandler = function () {
        var action = DropDownBoxActions.changeLanguage();
        this.store.dispatch(action);
    };

    p._setWidth = function (w) {
        SuperClass.prototype._setWidth.apply(this, arguments);
        var action = DropDownBoxActions.changeWidth(w);
        this.store.dispatch(action);
    };

    p._setHeight = function (h) {
        SuperClass.prototype._setHeight.apply(this, arguments);
        var action = DropDownBoxActions.changeHeight(h);
        this.store.dispatch(action);
    };

    /**
     * @method open
     * @iatStudioExposed
     * Opens the list
     */
    p.open = function () {
        var action = DropDownBoxActions.openList();
        this.store.dispatch(action);
        this.triggerToggleStateChanged();
    };

    /**
     * @method close
     * @iatStudioExposed
     * Closes the list
     */
    p.close = function () {
        var action = DropDownBoxActions.closeList();
        this.store.dispatch(action);
        this.triggerToggleStateChanged();
    };

    /**
     * @method toggle
     * @iatStudioExposed
     * Opens or closes the list depending on the actual status
     */
    p.toggle = function () {
        var action = DropDownBoxActions.toggleListStatus();
        this.store.dispatch(action);
        this.triggerToggleStateChanged();
    };

    /**
     * @method triggerToggleStateChanged
     * Triggers the event for a state change
     */
    p.triggerToggleStateChanged = function () {
        var state = this.store.getState();
        /**
         * @event ToggleStateChanged
         * @param {Boolean} newValue
         * @iatStudioExposed
         * Triggered when the list is opened or closed.
         */
        var ev = this.createEvent('ToggleStateChanged', {
            newValue: state.items.listOpen
        });
        ev.dispatch();
    };

    /**
     * @method setDataProvider
     * @iatStudioExposed
     * method to set the dataProvider
     * @param {ItemCollection} value ItemCollection (=Array) of objects of type brease.objects.ListEntry
     * @param {Boolean} [omitPrompt=false] (deprecated)
     * @paramMeta omitPrompt:deprecated=true
     */
    p.setDataProvider = function (provider) {
        var previous = _getActValues.call(this),
            triggeredByBinding = _triggeredByBinding(arguments[arguments.length - 1]);
        this.settings.dataProvider = provider;
        //Parse JSON to object
        var dataProviderObject = UtilsList.parseJSONtoObject(provider);
        //Generate the text elements
        var textElements = UtilsText.getTextsFromItems(dataProviderObject);
        var actionText = DropDownBoxActions.updateText(textElements);
        //Generate the image elements
        var imageList = UtilsImage.createImageList(dataProviderObject);
        var actionImage = DropDownBoxActions.updateImageList(imageList);
        //Generate the item list
        var itemList = UtilsList.getItemsFromItems(dataProviderObject);
        var actionItem = DropDownBoxActions.updateItemList(itemList);
        //Dispatch the actions
        this.store.dispatch(actionText);
        this.store.dispatch(actionImage);
        this.store.dispatch(actionItem);

        //Update new values to server immediately, if there is no other binding to selectedIndex or selectedValue
        if (!_hasBinding.call(this, 'selectedIndex') && !_hasBinding.call(this, 'selectedValue')) {
            this.submitChange({ previous: previous, triggeredByBinding: triggeredByBinding });
        } else {
            // otherwise give the binding the chance to set selectedIndex or selectedValue to a valid value
            this.submitChange({ previous: previous, triggeredByBinding: triggeredByBinding, deferred: true });
        }
    };

    /**
     * @method getDataProvider 
     * Returns dataProvider.
     * @return {ItemCollection}
     */
    p.getDataProvider = function () {
        return this.settings.dataProvider;
    };

    /**
     * @method setSelectedValue
     * @iatStudioExposed
     * sets the selected entry based on a value
     * @param {String} value
     * @param {Boolean} [omitPrompt=false] (deprecated)
     * @paramMeta omitPrompt:deprecated=true
     */
    p.setSelectedValue = function (value) {
        var previous = _getActValues.call(this),
            triggeredByBinding = _triggeredByBinding(arguments[arguments.length - 1]);
        this.settings.selectedValue = value;
        var action = DropDownBoxActions.updateSelectedValue(value);
        this.store.dispatch(action);

        // if update comes e.g. from CompoundWidget, then give a binding the chance to change selectedValue
        if (_hasBinding.call(this, 'selectedValue') && triggeredByBinding !== true) {
            this.submitChange({ previous: previous, triggeredByBinding: triggeredByBinding, deferred: true });
        } else {
            // otherwise send update immediately
            this.submitChange({ previous: previous, triggeredByBinding: triggeredByBinding });
        }
    };

    /**
     * @method getSelectedValue
     * @iatStudioExposed
     * Returns selectedValue.
     * @return {String}
     */
    p.getSelectedValue = function () {
        var state = this.store.getState();
        return state.items.selectedValue;
    };

    /**
     * @method setSelectedIndex
     * @iatStudioExposed
     * Sets the selected entry based on an index
     * @param {Integer} index
     * @param {Boolean} [omitPrompt=false] (deprecated)
     * @paramMeta omitPrompt:deprecated=true
     */
    p.setSelectedIndex = function (index) {
        var previous = _getActValues.call(this),
            triggeredByBinding = _triggeredByBinding(arguments[arguments.length - 1]);
        this.settings.selectedIndex = index;
        var action = DropDownBoxActions.updateSelectedItem(index);
        this.store.dispatch(action);

        // if update comes e.g. from CompoundWidget, then give a binding the chance to change selectedIndex
        if (_hasBinding.call(this, 'selectedIndex') && triggeredByBinding !== true) {
            this.submitChange({ previous: previous, triggeredByBinding: triggeredByBinding, deferred: true });
        } else {
            // otherwise send update immediately
            this.submitChange({ previous: previous, triggeredByBinding: triggeredByBinding });
        }
    };

    /**
     * @method getSelectedIndex
     * @iatStudioExposed
     * Returns selectedIndex.
     * @return {Integer}
     */
    p.getSelectedIndex = function () {
        var state = this.store.getState();
        return state.items.selectedIndex;
    };

    /**
     * @method setMultiLine
     * Sets multiLine
     * @param {Boolean} multiLine
     */
    p.setMultiLine = function (multiLine) {
        this.settings.multiLine = multiLine;
        var action = DropDownBoxActions.updateTextSettings({ multiLine: multiLine });
        this.store.dispatch(action);
    };

    /**
     * @method getMultiLine 
     * Returns multiLine.
     * @return {Boolean}
     */
    p.getMultiLine = function () {
        return this.settings.multiLine;
    };

    /**
     * @method setEllipsis
     * Sets ellipsis
     * @param {Boolean} ellipsis
     */
    p.setEllipsis = function (ellipsis) {
        this.settings.ellipsis = ellipsis;
        var action = DropDownBoxActions.updateTextSettings({ ellipsis: ellipsis });
        this.store.dispatch(action);
    };

    /**
     * @method getEllipsis 
     * Returns ellipsis.
     * @return {Boolean}
     */
    p.getEllipsis = function () {
        return this.settings.ellipsis;
    };

    /**
     * @method setWordWrap
     * Sets wordWrap
     * @param {Boolean} wordWrap
     */
    p.setWordWrap = function (wordWrap) {
        this.settings.wordWrap = wordWrap;
        var action = DropDownBoxActions.updateTextSettings({ wordWrap: wordWrap });
        this.store.dispatch(action);
    };

    /**
     * @method getWordWrap 
     * Returns wordWrap.
     * @return {Boolean}
     */
    p.getWordWrap = function () {
        return this.settings.wordWrap;
    };

    /**
     * @method setFitHeight2Items
     * Sets fitHeight2Items
     * @param {Boolean} fitHeight2Items
     */
    p.setFitHeight2Items = function (fitHeight2Items) {
        this.settings.fitHeight2Items = fitHeight2Items;
        var action = DropDownBoxActions.updateItemSettings({ fitHeight2Items: fitHeight2Items });
        this.store.dispatch(action);
    };

    /**
     * @method getFitHeight2Items 
     * Returns fitHeight2Items.
     * @return {Boolean}
     */
    p.getFitHeight2Items = function () {
        return this.settings.fitHeight2Items;
    };

    /**
     * @method setItemHeight
     * Sets itemHeight
     * @param {Integer} itemHeight
     */
    p.setItemHeight = function (itemHeight) {
        this.settings.itemHeight = itemHeight;
        var action = DropDownBoxActions.updateItemSettings({ itemHeight: itemHeight });
        this.store.dispatch(action);
    };

    /**
     * @method getItemHeight 
     * Returns itemHeight.
     * @return {Integer}
     */
    p.getItemHeight = function () {
        return this.settings.itemHeight;
    };

    /**
     * @method setImageAlign
     * Sets imageAlign
     * @param {brease.enum.ImageAlign} imageAlign
     */
    p.setImageAlign = function (imageAlign) {
        this.settings.imageAlign = imageAlign;
        var action = DropDownBoxActions.updateItemSettings({ imageAlign: imageAlign });
        this.store.dispatch(action);
    };

    /**
     * @method getImageAlign 
     * Returns imageAlign.
     * @return {brease.enum.ImageAlign}
     */
    p.getImageAlign = function () {
        return this.settings.imageAlign;
    };

    /**
     * @method setImagePath
     * Sets imagePath
     * @param {DirectoryPath} imagePath
     */
    p.setImagePath = function (imagePath) {
        this.settings.imagePath = imagePath;
        var action = DropDownBoxActions.updateImagePath(imagePath);
        this.store.dispatch(action);
    };

    /**
     * @method getImagePath 
     * Returns imagePath.
     * @return {DirectoryPath}
     */
    p.getImagePath = function () {
        return this.settings.imagePath;
    };

    /**
     * @method setListPosition
     * Sets listPosition
     * @param {brease.enum.Position} listPosition
     */
    p.setListPosition = function (listPosition) {
        this.settings.listPosition = listPosition;
        var action = DropDownBoxActions.updateListSettings({ listPosition: listPosition });
        this.store.dispatch(action);
    };

    /**
     * @method getListPosition 
     * Returns listPosition.
     * @return {brease.enum.Position}
     */
    p.getListPosition = function () {
        return this.settings.listPosition;
    };

    /**
     * @method setListWidth
     * Sets listWidth
     * @param {Integer} listWidth
     */
    p.setListWidth = function (listWidth) {
        this.settings.listWidth = listWidth;
        var action = DropDownBoxActions.updateListSettings({ listWidth: listWidth });
        this.store.dispatch(action);
    };

    /**
     * @method getListWidth 
     * Returns listWidth.
     * @return {Integer}
     */
    p.getListWidth = function () {
        return this.settings.listWidth;
    };

    /**
     * @method setMaxVisibleEntries
     * Sets maxVisibleEntries
     * @param {Integer} maxVisibleEntries
     */
    p.setMaxVisibleEntries = function (maxVisibleEntries) {
        this.settings.maxVisibleEntries = maxVisibleEntries;
        var action = DropDownBoxActions.updateListSettings({ maxVisibleEntries: maxVisibleEntries });
        this.store.dispatch(action);
    };

    /**
     * @method getMaxVisibleEntries 
     * Returns maxVisibleEntries.
     * @return {Integer}
     */
    p.getMaxVisibleEntries = function () {
        return this.settings.maxVisibleEntries;
    };

    /**
     * @method setCropToParent
     * Sets cropToParent
     * @param {brease.enum.CropToParent} cropToParent
     */
    p.setCropToParent = function (cropToParent) {
        this.settings.cropToParent = cropToParent;
        var action = DropDownBoxActions.updateListSettings({ cropToParent: cropToParent });
        this.store.dispatch(action);
    };

    /**
     * @method getCropToParent 
     * Returns cropToParent
     * @return {brease.enum.CropToParent}
     */
    p.getCropToParent = function () {
        return this.settings.cropToParent;
    };

    /**
     * @method setDisplaySettings
     * Sets displaySettings
     * @param {brease.enum.DropDownDisplaySettings} displaySettings
     */
    p.setDisplaySettings = function (displaySettings) {
        this.settings.displaySettings = displaySettings;
        var action = DropDownBoxActions.updateListSettings({ displaySettings: UtilsList.getShowValues(this.settings.displaySettings) });
        this.store.dispatch(action);
    };

    /**
     * @method getDisplaySettings 
     * Returns displaySettings
     * @return {brease.enum.DropDownDisplaySettings}
     */
    p.getDisplaySettings = function () {
        return this.settings.displaySettings;
    };

    /**
     * @event Click
     * Fired when element is clicked on.
     * @iatStudioExposed
     * @param {String} origin id of widget that triggered this event
     * @eventComment
     */
    p._clickHandler = function (e, additionalArguments) {
        SuperClass.prototype._clickHandler.call(this, e, { origin: this.elem.id });
    };

    p.setEditable = function (editable, metaData) {
        UtilsEditableBinding.handleEditable(editable, metaData, this, ['selectedIndex', 'selectedValue']);
    };

    p.updateVisibility = function (initial) {
        SuperClass.prototype.updateVisibility.apply(this, arguments);
        if (this.store !== undefined) {
            var action = DropDownBoxActions.changeVisible(this.isVisible());
            this.store.dispatch(action);
        }
    };

    p._enableHandler = function () {
        SuperClass.prototype._enableHandler.apply(this, arguments);
        var action = DropDownBoxActions.changeEnable(this.isEnabled());
        this.store.dispatch(action);
    };

    p.dispose = function () {
        this.dropDownBoxView.dispose();
        this.submitQueue.clear();
        SuperClass.prototype.dispose.apply(this, arguments);
    };

    p.suspend = function () {
        if (this.store !== undefined) {
            //Close the list
            var actionCloseList = DropDownBoxActions.closeList();
            this.store.dispatch(actionCloseList);
            //Set the status to innactive
            var actionInnactive = DropDownBoxActions.changeActive(false);
            this.store.dispatch(actionInnactive);
        }
        this.submitQueue.clear();
        SuperClass.prototype.suspend.apply(this, arguments);
    };

    p.wake = function () {
        if (this.store !== undefined) {
            //Set the status to active
            var action = DropDownBoxActions.changeActive(true);
            this.store.dispatch(action);
        }
        SuperClass.prototype.wake.apply(this, arguments);
    };

    p.submitChange = function (config) {
        this.submitChangeToEditor();
        var deferredCall = false;
        config = config || {};
        config.previous = config.previous || {};

        if (config && config.deferred === true) {
            this.submitQueue.add(config);
            return;
        } else if (this.submitQueue.length() > 0) {
            // get the values of selectedIndex and selectedValue before the latest submitChange calls
            config.previous = this.submitQueue.getPrevious();
            this.submitQueue.clear();
            deferredCall = true;
        }

        var state = this.store.getState();
        if (!UtilsList.isEqualIntBool(config.previous.selectedIndex, state.items.selectedIndex) || config.previous.selectedValue !== state.items.selectedValue) {
            /**
             * @event SelectedIndexChanged
             * @param {Integer} selectedIndex
             * @param {String} selectedValue 
             * @iatStudioExposed
             * Fired when selectedIndex or selectedValue changes.
             */
            var ev = this.createEvent('SelectedIndexChanged', {
                selectedIndex: this.getSelectedIndex(),
                selectedValue: this.getSelectedValue()
            });
            ev.dispatch();
        }

        var valueChange = {};
        if (config && config.triggeredByBinding === true) { // changes from binding
            if (deferredCall === true) {
                _addIfDifferent('selectedIndex', valueChange, state.items, config.previous);
                _addIfDifferent('selectedValue', valueChange, state.items, config.previous);
            } else {
                _addIfDifferent('selectedIndex', valueChange, state.items, this.settings);
                _addIfDifferent('selectedValue', valueChange, state.items, this.settings);
            }

        } else { // changes not from binding -> send changed values only
            
            _addIfDifferent('selectedIndex', valueChange, state.items, config.previous);
            _addIfDifferent('selectedValue', valueChange, state.items, config.previous);
        }
        this.settings.selectedIndex = state.items.selectedIndex;
        this.settings.selectedValue = state.items.selectedValue;

        if (valueChange.selectedIndex !== undefined || valueChange.selectedValue !== undefined) {
            this.sendValueChange(valueChange);
        }
    };

    p.submitChangeToEditor = function () {
        if (brease.config.editMode) {
            var state = this.store.getState();
            if (this.settings.selectedIndex !== state.items.selectedIndex || this.settings.selectedValue !== state.items.selectedValue) {
                iatd.model.setWidgetsProperties([
                    {
                        'WidgetId': this.elem.id,
                        'Properties': { 'selectedIndex': state.items.selectedIndex, 'selectedValue': state.items.selectedValue }
                    }
                ], 1234567890);
            }
        }
    };

    // private

    function _triggeredByBinding(metaData) {
        return metaData !== undefined && metaData.origin === 'server';
    }

    function _addIfDifferent(selectType, valueChange, stateValues, compareValues) {
        if (!_isEqual(selectType, stateValues[selectType], compareValues[selectType])) {
            valueChange[selectType] = stateValues[selectType];
        } 
    }

    function _isEqual(selectType, value1, value2) {
        if (selectType === 'selectedIndex') {
            return UtilsList.isEqualIntBool(value1, value2);
        } else {
            return value1 === value2;
        }
    }

    function _getActValues() {
        return {
            selectedIndex: this.getSelectedIndex(),
            selectedValue: this.getSelectedValue()
        };
    }

    function _hasBinding(attribute) {
        return this.bindings !== undefined && this.bindings[attribute] !== undefined;
    }

    return dragAndDropCapability.decorate(visibilityDependency.decorate(languageDependency.decorate(WidgetClass, true), false), false);

});
