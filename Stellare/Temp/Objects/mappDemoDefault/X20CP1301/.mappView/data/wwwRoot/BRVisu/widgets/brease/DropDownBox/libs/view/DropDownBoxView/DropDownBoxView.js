define([
    'widgets/brease/common/libs/redux/view/ListView/ListView',
    'widgets/brease/common/libs/redux/view/ItemView/ItemView',
    'widgets/brease/DropDownBox/libs/reducer/DropDownBoxActions',
    'brease/enum/Enum',
    'brease/core/Utils',
    'brease/events/BreaseEvent',
    'brease/controller/PopUpManager'
], function (ListView, ItemView, DropDownBoxActions, Enum, Utils, BreaseEvent, popupManager) {

    'use strict';

    var DropDownBoxView = function (store, parent, widget) {
        this.el = parent;
        this.store = store;
        this.widget = widget;
        this.render();
    };

    var p = DropDownBoxView.prototype;

    p.render = function render() {

        this.dispose();

        this.el.addClass('breaseDropDownBox DropDownBoxView');
        var state = this.store.getState();

        if (state.status.visible && state.status.active) {

            var actualItem = state.items.itemList[state.items.selectedIndex],
                selectedText = actualItem === undefined ? undefined : state.text.textElements[actualItem.textId],
                selectedImage = actualItem === undefined ? undefined : state.image.imageElements[actualItem.imageId];

            var itemProps = {
                imageIndicator: {
                    showImage: true
                },
                text: {
                    text: selectedText === undefined ? '' : selectedText.displayText,
                    textSettings: state.text.textSettings,
                    showText: state.items.listSettings.showTextsInButton
                },
                image: {
                    image: selectedImage === undefined ? undefined : selectedImage.imagePath,
                    showImage: state.items.listSettings.showImagesInButton
                },
                itemSettings: {
                    itemHeight: '100%',
                    imageAlign: state.items.itemSettings.imageAlign
                },
                status: {
                    enabled: state.status.enabled,
                    visible: state.status.visible,
                    selected: state.items.listOpen,
                    lastItem: true
                },
                onClick: _updateListStatus.bind(this)
            };
            this.itemView = new ItemView(itemProps, this.el);

            if (state.items.listOpen) {
                this.listContainer = $("<div id='" + this.el[0].id + "_listBoxWrapper' class='listBoxContainer " + state.style.styleToApply + "'></div>");
                this.arrow = $("<div class='arrow'></div>");
                this.listContainer.append(this.arrow);
                $(document.body).append(this.listContainer);
                var borderCorrection = _getBorderFromList(this.listContainer);
                var scaleFactor = Utils.getScaleFactor(this.el[0]);
                var buttonSize = { height: this.el[0].offsetHeight, width: this.el[0].offsetWidth };
                var targetContainer = _fetchParentContainer(this.el);
                var listPosition = _calculateListPosition(this.el, buttonSize, borderCorrection, state.items.listSettings, scaleFactor, targetContainer);
                this._listContainerSizePos(this.listContainer, listPosition, scaleFactor, this.el, targetContainer);
                _layoutArrowList(this.el, this.listContainer, this.arrow, state.items.listSettings.listPosition, buttonSize, listPosition.width, scaleFactor);
                //Override listSettings
                var listProps = {
                    status: state.status,
                    items: state.items,
                    text: state.text,
                    image: state.image,
                    onClick: (function (store, widget, element) {
                        return function (index, originalEvent) {
                            _dispatchSelectedItem(store, index, widget, originalEvent, element);
                            originalEvent.preventDefault();
                        };
                    })(this.store, this.widget, this.el)
                };
                this.listView = new ListView(listProps, this.listContainer);
                this.closeOnMouseDownBound = _closeListOnMouseDown.bind(this);
                this.closeOnWheelBound = _closeListOnWheel.bind(this);
                $(document.body).on(BreaseEvent.MOUSE_DOWN, this.closeOnMouseDownBound);
                $(document.body).on('wheel', this.closeOnWheelBound);
            }
        }
    };

    p.dispose = function dispose() {
        if (this.listView !== undefined) {
            this.listView.dispose();
        }
        if (this.itemView !== undefined) {
            this.itemView.dispose();
        }
        if (this.arrow !== undefined) {
            this.arrow.remove();
        }
        if (this.listContainer !== undefined) {
            this.listContainer.remove();
        }
        if (this.closeOnMouseDownBound !== undefined) {
            $(document.body).off(BreaseEvent.MOUSE_DOWN, this.closeOnMouseDownBound);
        }
        if (this.closeOnWheelBound !== undefined) {
            $(document.body).off('wheel', this.closeOnWheelBound);
        }
        if (this.closeOnMouseMoveBound !== undefined) {
            $(document.body).off(BreaseEvent.MOUSE_MOVE, this.closeOnMouseMoveBound);
        }
    };

    function _dispatchSelectedItem(store, index, widget, originalEvent, element) {
        //Trigger the widget _clickHandler in order to have the Click event from BaseWidget
        var coordinates = element[0].getBoundingClientRect();
        originalEvent.clientX = coordinates.left;
        originalEvent.clientY = coordinates.top;
        // eslint-disable-next-line no-useless-call
        widget._clickHandler.call(widget, originalEvent);
        if (store.getState().status.enabled) {
            var action = DropDownBoxActions.updateSelectedItem(index);
            store.dispatch(action);
            //Store AS with the new values
            widget.valueChangeFromUI();
        }
    }

    function _updateListStatus(event) {
        //Save the actual timeStamp to avoid inmediate close of the list
        this.openEventTimeStamp = event.timeStamp;
        if (this.store.getState().status.enabled) {
            var action = DropDownBoxActions.toggleListStatus();
            this.store.dispatch(action);
            this.widget.triggerToggleStateChanged();
        }
    }

    function _closeListOnMouseDown(event) {
        //If the event is different from the open event and it is not comming
        // from an element of the widget itself -> close list
        if (this.openEventTimeStamp !== event.timeStamp && !$.contains(this.listContainer.find('.ListView')[0], event.target) &&
            !$.contains(this.el[0], event.target)) {
            _closeList(this.store, this.widget);
        } else if ($.contains(this.el[0], event.target)) {
            this.closeOnMouseMoveBound = _closeOnMouseMove.bind(this);
            $(document.body).on(BreaseEvent.MOUSE_MOVE, this.closeOnMouseMoveBound);
        }
    }

    function _closeOnMouseMove(event) {
        _closeList(this.store, this.widget);
    }

    function _closeListOnWheel(event) {
        if (!$.contains(this.listContainer.find('.ListView')[0], event.target)) {
            _closeList(this.store, this.widget);
        }
    }

    function _closeList(store, widget) {
        var action = DropDownBoxActions.closeList();
        store.dispatch(action);
        widget.triggerToggleStateChanged();
    }

    p._listContainerSizePos = function (container, position, scaleFactor, $element, targetContainer) {

        // AuP 685990: fix listposition if visualization is zoomed ( * scaleFactor)
        var endPos = position.left + position.width * scaleFactor,
            targetContainerOffset, targetContainerWidth, targetContainerRightBoundary;
        // AuP 666055: fix listView position, if a DropDownBox is inside a DialogWindow or a GenericDialog
        // Due to the test in mSpecUIPropDropDownBox.js, this check is currently still necessary.
        if ($element) {
            targetContainerOffset = {
                left: targetContainer.parentEl.offset().left
            };
            targetContainerWidth = parseInt(targetContainer.parentEl.width(), 10);
            targetContainerRightBoundary = targetContainerOffset.left + targetContainerWidth;
            if (targetContainer.sDialog) {

            } else {
                if (endPos > targetContainerRightBoundary) {
                    position.left = targetContainerRightBoundary - position.width * scaleFactor;
                }
                if (position.left < targetContainerOffset.left) {
                    position.left = targetContainerOffset.left;
                }
            }
        }
        container.css({
            'position': 'absolute',
            'height': position.height,
            'width': position.width,
            'top': position.top,
            'left': position.left,
            'z-index': position.zIndex,
            'transform': 'scale(' + scaleFactor + ',' + scaleFactor + ')',
            'transform-origin': '0px 0px 0px'
        });

    };

    function _fetchParentContainer($element) {
        var $parentObjDialogWindow = $element.closest('.breaseDialogWindow'),
            $parentObjGenericDialog = $element.closest('.breaseGenericDialog');
        if ($parentObjDialogWindow.length === 0 && $parentObjGenericDialog.length === 0) {
            return {
                parentEl: brease.appView,
                sDialog: false
            };
        } else {
            return {
                parentEl: $parentObjDialogWindow.length !== 0 ? $parentObjDialogWindow : $parentObjGenericDialog,
                sDialog: true
            };
        }
    }

    function _calculateListPosition($elem, buttonSize, borderCorrection, listSettings, scaleFactor, targetContainer) {
        var positionList = {},
            listHeight = listSettings.listHeight + borderCorrection,
            elemOffset = $elem.offset(),
            scaledButtonSize = {
                height: buttonSize.height * scaleFactor,
                width: buttonSize.width * scaleFactor
            },
            scaledList = {
                height: listHeight * scaleFactor,
                width: listSettings.listWidth * scaleFactor
            },
            scaledArrowSize = 8 * scaleFactor,
            cropParentlimitContainer = _getLimitContainer(listSettings.cropToParent, targetContainer, scaleFactor, $elem);

        switch (listSettings.listPosition) {
            case Enum.Position.bottom:
                positionList = _calcPositionListBottom(elemOffset, scaledButtonSize, listHeight, scaledArrowSize, scaledList, cropParentlimitContainer, scaleFactor);
                break;
            case Enum.Position.top:
                positionList = _calcPositionListTop(elemOffset, scaledButtonSize, listHeight, scaledList, cropParentlimitContainer, scaleFactor, targetContainer);
                break;
            case Enum.Position.left:
                positionList = _calcPositionListLeft(elemOffset, scaledButtonSize, listHeight, scaledList, cropParentlimitContainer, scaleFactor, targetContainer);
                break;
            case Enum.Position.right:
                positionList = _calcPositionListRight(elemOffset, scaledButtonSize, listHeight, scaledList, cropParentlimitContainer, scaleFactor, targetContainer);
                break;
            case Enum.Position.center:
                positionList = _calcPositionListCenter(elemOffset, scaledButtonSize, listHeight, scaledList, cropParentlimitContainer, scaleFactor, targetContainer);
                break;
            case Enum.Position.middle:
                positionList = _calcPositionListMiddle(elemOffset, scaledButtonSize, listHeight, scaledList, cropParentlimitContainer, scaleFactor);
                break;
        }
        positionList.width = listSettings.listWidth;
        positionList.zIndex = popupManager.getHighestZindex() + 1;
        return positionList;
    }

    function _calcPositionListBottom(elemOffset, scaledButtonSize, listHeight, scaledArrowSize, scaledList, cropParentlimitContainer, scaleFactor) {
        var positionListBottom = {}, heightCorrection = 0;

        positionListBottom.top = elemOffset.top + scaledButtonSize.height;

        positionListBottom.left = elemOffset.left + scaledButtonSize.width / 2 - scaledList.width / 2;

        listHeight = listHeight + scaledArrowSize;
        heightCorrection = (positionListBottom.top + listHeight * scaleFactor - cropParentlimitContainer.bottomLimit) / scaleFactor;
        positionListBottom.height = heightCorrection > 0 ? listHeight - heightCorrection : listHeight;

        return positionListBottom;
    }

    function _calcPositionListTop(elemOffset, scaledButtonSize, listHeight, scaledList, cropParentlimitContainer, scaleFactor, refElemParent) {
        var positionListTop = {}, heightCorrection = 0;

        positionListTop.top = getHeightTopCorrection('top', elemOffset, scaleFactor, cropParentlimitContainer, scaledButtonSize, scaledList, listHeight).top;

        positionListTop.left = elemOffset.left + scaledButtonSize.width / 2 - scaledList.width / 2;

        heightCorrection = getHeightTopCorrection('top', elemOffset, scaleFactor, cropParentlimitContainer, scaledButtonSize, scaledList, listHeight).heightCorrection;
        positionListTop.height = listHeight - heightCorrection;

        return positionListTop;
    }

    function _calcPositionListLeft(elemOffset, scaledButtonSize, listHeight, scaledList, cropParentlimitContainer, scaleFactor, refElemParent) {
        var positionListLeft = {}, heightCorrection = 0;

        positionListLeft.top = _getTopCorrection(cropParentlimitContainer, refElemParent, scaleFactor, elemOffset, scaledButtonSize, listHeight);

        positionListLeft.left = elemOffset.left - scaledList.width;

        heightCorrection = (positionListLeft.top + scaledList.height - cropParentlimitContainer.bottomLimit) / scaleFactor;
        positionListLeft.height = heightCorrection > 0 ? listHeight - heightCorrection : listHeight;

        return positionListLeft;
    }

    function _calcPositionListRight(elemOffset, scaledButtonSize, listHeight, scaledList, cropParentlimitContainer, scaleFactor, refElemParent) {
        var positionListRight = {}, heightCorrection = 0;

        positionListRight.top = _getTopCorrection(cropParentlimitContainer, refElemParent, scaleFactor, elemOffset, scaledButtonSize, listHeight);

        positionListRight.left = elemOffset.left + scaledButtonSize.width;

        heightCorrection = (positionListRight.top + scaledList.height - cropParentlimitContainer.bottomLimit) / scaleFactor;
        positionListRight.height = heightCorrection > 0 ? listHeight - heightCorrection : listHeight;

        return positionListRight;
    }
    function _calcPositionListCenter(elemOffset, scaledButtonSize, listHeight, scaledList, cropParentlimitContainer, scaleFactor, refElemParent) {
        var positionListCenter = {}, heightCorrection = 0;

        positionListCenter.top = _getTopCorrection(cropParentlimitContainer, refElemParent, scaleFactor, elemOffset, scaledButtonSize, listHeight);

        positionListCenter.left = elemOffset.left + scaledButtonSize.width / 2 - scaledList.width / 2;

        heightCorrection = (positionListCenter.top + listHeight * scaleFactor - cropParentlimitContainer.bottomLimit) / scaleFactor;
        positionListCenter.height = heightCorrection > 0 ? listHeight - heightCorrection : listHeight;

        return positionListCenter;
    }

    function _calcPositionListMiddle(elemOffset, scaledButtonSize, listHeight, scaledList, cropParentlimitContainer, scaleFactor) {
        var positionListMiddle = {}, heightCorrection = 0;

        positionListMiddle.top = getHeightTopCorrection('middle', elemOffset, scaleFactor, cropParentlimitContainer, scaledButtonSize, scaledList, listHeight).top;

        positionListMiddle.left = elemOffset.left + scaledButtonSize.width / 2 - scaledList.width / 2;

        heightCorrection = (positionListMiddle.top + listHeight * scaleFactor - cropParentlimitContainer.bottomLimit) / scaleFactor;
        positionListMiddle.height = heightCorrection > 0 ? listHeight - heightCorrection : listHeight;

        return positionListMiddle;
    }

    function _getLimitContainer(cropToParent, refContainerParent, scaleFactor, $elem) {
        var refContainerParentOffset;
        if (cropToParent === Enum.CropToParent.height || cropToParent === Enum.CropToParent.both) {
            refContainerParentOffset = {
                top: refContainerParent.parentEl.offset().top,
                height: refContainerParent.parentEl.height()
            };
            return {
                bottomLimit: refContainerParentOffset.top + refContainerParentOffset.height * scaleFactor,
                topLimit: refContainerParentOffset.top,
                cropToParent: cropToParent
            };
        } else {
            // AuP 666055: fix listView position, if DropDownBox is inside DialogWindow or GenericDialog
            if (refContainerParent.sDialog) {
                return {
                    bottomLimit: brease.bodyEl.height(),
                    topLimit: 0,
                    cropToParent: cropToParent
                };
            } else {
                return {
                    bottomLimit: brease.appView.height(),
                    topLimit: 0,
                    cropToParent: cropToParent
                };
            }
        }
    }

    function _getTopCorrection(cropParentlimitContainer, refElemParent, scaleFactor, elemOffset, scaledButtonSize, listHeight) {
        // AuP 681440: list with listPosition left or right or center is cropped, if cropToParent is set to none.
        if (elemOffset.top - cropParentlimitContainer.topLimit < 0 || listHeight - cropParentlimitContainer < 0) {
            return cropParentlimitContainer.topLimit;
        } else if (cropParentlimitContainer.cropToParent === 'none' &&
            listHeight * scaleFactor >= refElemParent.height && elemOffset.top - listHeight + scaledButtonSize.height > 0) {
            return elemOffset.top - listHeight * scaleFactor + refElemParent.height;
        } else {
            return elemOffset.top;
        }
    }

    function getHeightTopCorrection(position, elemOffset, scaleFactor, cropParentlimitContainer, scaledButtonSize, scaledList, listHeight) {
        switch (position) {
            case Enum.Position.top:
                if ((elemOffset.top - listHeight * scaleFactor) - cropParentlimitContainer.topLimit < 0) {
                    return {
                        heightCorrection: ((elemOffset.top - listHeight * scaleFactor) - cropParentlimitContainer.topLimit) / -scaleFactor,
                        top: cropParentlimitContainer.topLimit
                    };
                } else {
                    return {
                        top: elemOffset.top - listHeight * scaleFactor,
                        heightCorrection: 0
                    };
                }
            case Enum.Position.middle:
                if (((elemOffset.top + scaledButtonSize.height / 2 - scaledList.height / 2) - cropParentlimitContainer.topLimit < 0)) {
                    return {
                        heightCorrection: (elemOffset.top - listHeight * scaleFactor - cropParentlimitContainer.topLimit) / -scaleFactor,
                        top: cropParentlimitContainer.topLimit
                    };
                } else {
                    return {
                        top: elemOffset.top + scaledButtonSize.height / 2 - scaledList.height / 2,
                        heightCorrection: 0
                    };
                }
        }
    }

    function _layoutArrowList($elem, container, arrow, listPosition, ItemSize, listWidth, scaleFactor) {
        switch (listPosition) {
            case Enum.Position.bottom:
                container.addClass('bottom');
                arrow.addClass('bottom');
                arrow.css('margin-left', listWidth / 2 - 8);
                break;
            case Enum.Position.top:
                container.addClass('top');
                arrow.addClass('top');
                arrow.css('margin-left', listWidth / 2 - 8);
                break;
            case Enum.Position.left:
                container.addClass('left');
                arrow.addClass('left');
                arrow.css('margin-top', (($elem.offset().top - arrow.offset().top) / scaleFactor + ItemSize.height / 2 - 8));
                break;
            case Enum.Position.right:
                container.addClass('right');
                arrow.addClass('right');
                arrow.css('margin-top', (($elem.offset().top - arrow.offset().top) / scaleFactor + ItemSize.height / 2 - 8));
                break;
            case Enum.Position.center:
                container.addClass('center');
                arrow.addClass('center');
                break;
            case Enum.Position.middle:
                container.addClass('right');
                arrow.addClass('middle');
                break;
        }
    }

    function _getBorderFromList(elementParent) {
        var dummyDiv = $('<div class="ListView Container"></div>');
        elementParent.append(dummyDiv);
        var topBorder = parseInt(dummyDiv.css('border-top-width'), 10),
            bottomBorder = parseInt(dummyDiv.css('border-bottom-width'), 10),
            sumBorder = topBorder + bottomBorder;
        dummyDiv.remove();
        return sumBorder;
    }

    return DropDownBoxView;

});
