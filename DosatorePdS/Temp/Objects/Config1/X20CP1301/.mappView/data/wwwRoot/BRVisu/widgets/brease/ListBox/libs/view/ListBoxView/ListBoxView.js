define(['widgets/brease/common/libs/redux/view/ListView/ListView',
    'widgets/brease/ListBox/libs/reducer/ListBoxActions',
    'brease/events/EventDispatcher'],
function (ListView, ListBoxActions, EventDispatcher) {

    'use strict';

    var ListBoxView = function (store, parent, widget) {
        this.el = parent;
        this.store = store;
        this.widget = widget;
        this.render();
    };
    ListBoxView.prototype = new EventDispatcher();

    var p = ListBoxView.prototype;

    p.render = function render() {
        //Remove the elements
        _removeElements(this);
        //Get the state
        var state = this.store.getState();
        //Add the CSS classes
        _addCssClasses(this.el,
            state.items.listSettings.fitHeight2Items,
            state.items.itemSettings.itemHeight,
            state.items.itemList.length,
            state.size.height);
        //Create the listView
        if (state.status.visible && state.status.active) {
            //Create the properties list
            var listProps = {
                status: state.status,
                items: state.items,
                listSettings: {
                    height: state.items.listSettings.height,
                    width: state.items.listSettings.width
                },
                text: state.text,
                image: state.image,
                onClick: (function (store, widget) {
                    return function (index, originalEvent) {
                        _dispatchSelectedItem(store, index, widget);
                        // A&P 601060: Listview jumps to wrong position on touchinput
                        // and preventDefault() prevents the default behavior(focus) after the touchend event.
                        originalEvent.preventDefault();
                        // A&P 733160: ListBox doesn't support mouse and keyboard combination
                        // therefore we have to set the focus here.
                        widget.elem.focus();
                    };
                })(this.store, this.widget)
            };
            this.listView = new ListView(listProps, this.el);
        }
        this.dispatchEvent({ type: 'ViewRendered' });
    };

    p.dispose = function dispose() {
        _removeElements(this);
    };

    function _removeElements(view) {
        if (view.listView !== undefined) {
            view.listView.dispose();
        }
    }

    function _addCssClasses(element, fitHeight2Items, itemHeight, numberOfItems, height) {
        element.addClass('breaseListBox ListBoxView');
        if (fitHeight2Items) {
            var topBorder = parseInt(element.css('border-top-width'), 10),
                bottomBorder = parseInt(element.css('border-bottom-width'), 10),
                sumBorder = topBorder + bottomBorder;
            element.css('height', itemHeight * numberOfItems + sumBorder);
        } else {
            element.css('height', height);
        }
    }

    function _dispatchSelectedItem(store, index, widget) {
        if (store.getState().status.enabled) {
            var action = ListBoxActions.updateSelectedItem(index);
            store.dispatch(action);
            //Store AS with the new values
            widget.valueChangeFromUI();
        }
    }

    return ListBoxView;

});
