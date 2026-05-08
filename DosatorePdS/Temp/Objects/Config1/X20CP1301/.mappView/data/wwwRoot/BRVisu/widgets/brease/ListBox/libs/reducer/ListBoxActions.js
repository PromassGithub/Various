define(['widgets/brease/common/libs/redux/reducers/Text/TextActions',
    'widgets/brease/common/libs/redux/reducers/Image/ImageActions',
    'widgets/brease/common/libs/redux/reducers/Status/StatusActions',
    'widgets/brease/common/libs/redux/reducers/Size/SizeActions',
    'widgets/brease/common/libs/redux/reducers/List/ListActions'],
function (TextActions, ImageActions, StatusActions, SizeActions, ListActions) {

    'use strict';

    /**
    * @class widgets.brease.ListBox.libs.reducer.ListBoxActions
    * @iatMeta studio:visible
    * false
    */

    var ListBoxActions = _.assign({}, TextActions, ImageActions, StatusActions, SizeActions, ListActions);

    return ListBoxActions;

});
