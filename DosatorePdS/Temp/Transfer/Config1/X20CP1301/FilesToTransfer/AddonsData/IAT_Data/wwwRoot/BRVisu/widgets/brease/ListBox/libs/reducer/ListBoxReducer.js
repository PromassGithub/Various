define(['widgets/brease/ListBox/libs/reducer/ListBoxActions',
    'widgets/brease/common/libs/redux/reducers/Text/TextReducer',
    'widgets/brease/common/libs/redux/reducers/Image/ImageReducer',
    'widgets/brease/common/libs/redux/reducers/Status/StatusReducer',
    'widgets/brease/common/libs/redux/reducers/Size/SizeReducer',
    'widgets/brease/common/libs/redux/reducers/List/ListReducer',
    'widgets/brease/common/libs/external/redux'],
function (ListBoxActions, TextReducer, ImageReducer, StatusReducer, SizeReducer, ListReducer, Redux) {

    'use strict';

    return Redux.combineReducers({
        text: TextReducer,
        items: ListReducer,
        image: ImageReducer,
        status: StatusReducer,
        size: SizeReducer
    });

});
