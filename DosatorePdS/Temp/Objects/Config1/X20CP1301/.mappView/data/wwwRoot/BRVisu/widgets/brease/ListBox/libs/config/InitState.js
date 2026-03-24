define(['widgets/brease/common/libs/redux/utils/UtilsImage',
    'widgets/brease/common/libs/redux/utils/UtilsText',
    'widgets/brease/common/libs/redux/utils/UtilsList',
    'brease/enum/Enum'],
function (UtilsImage, UtilsText, UtilsList, Enum) {

    'use strict';

    var InitState = {};

    InitState.calculateInitState = function (settings, enabled, visible, editMode) {

        var initState = {};

        initState.text = {
            textElements: UtilsText.getTextsFromItems(settings.dataProvider),
            textSettings: {
                multiLine: settings.multiLine,
                wordWrap: settings.wordWrap,
                ellipsis: settings.ellipsis
            }
        };

        initState.image = {
            imageList: UtilsImage.createImageList(settings.dataProvider),
            imagePath: settings.imagePath,
            imageElements: UtilsImage.createImageElements(UtilsImage.createImageList(settings.dataProvider), settings.imagePath),
            imageSettings: {}
        };

        initState.items = {
            itemList: UtilsList.getItemsFromItems(settings.dataProvider, settings.selectedIndex),
            itemSettings: {
                itemHeight: settings.itemHeight,
                imageAlign: settings.imageAlign
            },
            selectedIndex: settings.selectedIndex,
            selectedValue: UtilsList.getSelectedValueFromItems(settings.dataProvider, settings.selectedIndex),
            previousSelectedIndex: 0,
            listOpen: false,
            listSettings: {
                fitHeight2Items: settings.fitHeight2Items,
                listPosition: undefined,
                listWidth: '100%',
                listHeight: '100%',
                maxVisibleEntries: undefined,
                cropToParent: undefined,
                showTexts: UtilsList.getShowValues(settings.displaySettings).showTexts,
                showImages: UtilsList.getShowValues(settings.displaySettings).showImages,
                showTextsInButton: UtilsList.getShowValues(settings.displaySettings).showTextsInButton,
                showImagesInButton: UtilsList.getShowValues(settings.displaySettings).showImagesInButton
            }
        };

        initState.status = {
            enabled: enabled,
            visible: visible,
            editMode: editMode,
            active: true
        };

        initState.size = {
            height: settings.height,
            width: settings.width
        };

        return initState;
    };

    return InitState;

});
