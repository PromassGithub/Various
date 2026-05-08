define(function () {

    'use strict';

    var ClassExtension = {
        extend: function (WidgetClass) {
            WidgetClass.static.getInitialProperties = function (x, y) {
                
                var content = $('.iatd-content'),
                    dimension =
                    {
                        height: content.height(),
                        width: content.width()
                    };

                if (y < dimension.height / 2) {
                    if (x < dimension.width / 2) {
                        if (x < y) {
                            return {
                                left: 0,
                                top: y
                            };
                        }
                    } else {
                        if (dimension.width - x < y) {
                            return {
                                left: 0,
                                top: y,
                                docking: 'right'
                            };
                        }
                    }
                    return {
                        left: x,
                        top: 0,
                        docking: 'top'
                    };

                } else {
                    
                    if (x < dimension.width / 2) {
                        if (x < dimension.height - y) {
                            return {
                                left: 0,
                                top: y
                            };
                        }
                    } else {
                        if (dimension.width - x < dimension.height - y) {
                            return {
                                left: 0,
                                top: y,
                                docking: 'right'
                            };
                        }
                    }
                    return {
                        left: x,
                        top: 0,
                        docking: 'bottom'
                    };

                }

            };
            WidgetClass.extended = true;
        }
    };

    return ClassExtension;

});
