define(['widgets/brease/common/DragDropHandler/libs/dragDropBase',
    'widgets/brease/common/DragDropHandler/libs/dragDropTouch',
    'widgets/brease/common/DragDropHandler/libs/dragDropPointer'],
function (DragDropBase, DragDropTouch, DragDropPointer) {
    'use strict';

    function DragDropHandler() {
        if (DragDropHandler.supportsPointer()) {
            return new DragDropPointer();
        } else if (DragDropHandler.isTouch()) {
            return new DragDropTouch();
        } else {
            return new DragDropBase();
        }
    }
    DragDropHandler.supportsPointer = function () {
        if (window.PointerEvent) {
            return true;
        }
        return false;
    };
    DragDropHandler.isTouch = function () {
        return 'ontouchstart' in window || // works on most browsers 
            navigator.maxTouchPoints; // works on IE10/11 and Surface
    };

    return DragDropHandler;
});
