define([
    'brease/core/Class'
], function (
    SuperClass
) {

    'use strict';

    var TextWheel = SuperClass.extend(function TextWheel(widget) {
            SuperClass.call(this);
            this.widget = widget;
            this.initialize();
        }, null),

        p = TextWheel.prototype;

    p.initialize = function () {
        // could be used for performance increase
        //this.redrawList = _.debounce(this.redrawListDebounced, 5, { trailing: true, leading: false });

        // TODO: Find a good transitionTime value. transitionTime sets the time used for the selection animation.
        this.transitionTime = this.widget.settings.transitionTime !== undefined ? this.widget.settings.transitionTime : 200;        
        this.marker1 = $('<div id="marker1" class="marker">');
        this.marker2 = $('<div id="marker2" class="marker">');
        this.fragment = $('<div>').addClass('itemFragment');
        this.wheel = $('<div id="textWheel"></div>')
            .append([this.fragment, this.marker1, this.marker2])
            .appendTo(this.widget.el);
    };

    p.setWidgetSettings = function (settings) {
        this.settings = settings;
    };

    p._getWheelHeight = function () {        
        return this.wheel.css('height');
    };

    p._updateMarkerPositions = function () {
        var halfItemPadding = parseInt(this.settings.itemPadding, 10) / 2;
        var halfItemHeight = parseInt(this.settings.itemHeight, 10) / 2;
        var halfWheelHeight = parseInt(this._getWheelHeight(), 10) / 2;
        var marker1Height = parseInt(this.marker1.css('height'), 10);
        this.marker1Top = halfWheelHeight - halfItemHeight - halfItemPadding - marker1Height / 2;
        this.marker2Top = halfWheelHeight + halfItemHeight + halfItemPadding - marker1Height / 2;
        this.marker1.css('top', this.marker1Top + 'px');
        this.marker2.css('top', this.marker2Top + 'px');
        this.marker1Bottom = this.marker1Top + parseInt(this.marker1.css('height'), 10);
        this._recalculateOffsetLimits();
    };

    p.redrawList = function (settings) {
        this.settings = settings;
        if (this.settings.dataProvider.length > 0) {
            this.fillListWheel();
        } else {
            this.fragment.empty();
        }
    };

    p.fillListWheel = function () {
        var index = 0, item;
        var dataProvider = this.settings.dataProvider;
        if (dataProvider !== undefined) {
            if (this.currentSelected) {
                this.currentSelected.removeClass('selected');
            }
            this._cleanUp();
            var imagePath = this.settings.imagePath;
            var imageAlign = this.settings.imageAlign;
            dataProvider.forEach(function (dpEntry) {
                var textToShow = this.getTextToShow(dpEntry.text);
                if (imagePath === '') {
                    item = $('<div><span></span></div>');
                } else {
                    if (imageAlign === 'left') {
                        item = $('<div><img></img><span></span></div>');
                    } else if (imageAlign === 'right') {
                        item = $('<div><span></span><img></img></div>');
                    }
                    item.children('img').attr('src', dpEntry.image);
                }
                item
                    .attr({ 'data-index': index, 'data-value': dpEntry.value })
                    .children('span').text(textToShow);
                index = this._addItemToFragment(item, index);
            }, this);
            this._updateItemHeight(this.settings.itemHeight);
        }
    };

    p.getTextToShow = function (text) {
        if (brease.language.isKey(text)) {
            text = brease.language.getTextByKey(brease.language.parseKey(text));
        }

        return text;
    };

    p._addItemToFragment = function (item, index) {
        if (item) {
            item = this._addAlignmentToItem(item);
            item = this._addTextAlignmentToItem(item);
            this.fragment.append(item);
            index += 1;
            return index;
        }
    };

    p._cleanUp = function () {
        this.fragment.empty();
        this.oldOffset = undefined;
    };

    p._addAlignmentToItem = function (item) {
        if (this.settings.itemAlign === 'center') {
            item.css({ 'margin-left': 'auto', 'margin-right': 'auto' });
        } else if (this.settings.itemAlign === 'left') {
            item.css({ 'margin-left': '0', 'margin-right': 'auto' });
        } else if (this.settings.itemAlign === 'right') {
            item.css({ 'margin-left': 'auto', 'margin-right': '0' });
        }
        return item;
    };

    p._addTextAlignmentToItem = function (item) {
        if (this.settings.textAlign !== undefined) {
            item.find('span').css('text-align', this.settings.textAlign);
        }
        return item;
    };

    p._recalculateOffsetLimits = function () {
        var itemPadding = parseInt(this.settings.itemPadding, 10);
        var marker1Height = parseInt(this.marker1.css('height'), 10);
        this.widget._setMax(this.marker1Bottom + (itemPadding / 2) - marker1Height / 2);
        this.widget._setMin((this.settings.dataProvider.length - 1) * -(parseInt(this.settings.itemHeight, 10) + itemPadding) + (itemPadding / 2) + this.marker1Bottom - marker1Height / 2);
    };

    p.updateFragmentOffset = function (offset) {
        if (offset >= this.widget.min && offset <= this.widget.max) {
            this.fragment.css('top', offset);
        }
    };

    p._moveToIndex = function (index) {
        var self = this;
        var allowClassChange = false;
        this.index = index;
        var itemPadding = parseInt(this.settings.itemPadding, 10);
        var offset = index * -(parseInt(this.settings.itemHeight, 10) + itemPadding) + (itemPadding / 2) + this.marker1Bottom - parseInt(this.marker1.css('height'), 10) / 2;
        var target = self.fragment.children()[index];
        if (this.oldOffset) {
            if (this.oldOffset !== offset) {
                allowClassChange = true;
            }
        } else {
            allowClassChange = true;
        }

        this.oldOffset = offset;

        if (brease.config.editMode) {
            this.fragment.css('top', offset);
            removeSelectedClass(target, self, allowClassChange);
            addSelectedClass(target, self, allowClassChange);
            self._setPositionBasedItemAppearance();
        } else {
            this.fragment.animate(
                {
                    top: offset
                },
                {
                    duration: self.transitionTime,
                    easing: 'linear',
                    step: function () {
                        removeSelectedClass(target, self, allowClassChange);
                        self._setPositionBasedItemAppearance();
                    },
                    complete: function () {
                        removeSelectedClass(target, self, allowClassChange);
                        addSelectedClass(target, self, allowClassChange);
                        self._setPositionBasedItemAppearance();
                    }
                }
            );
        }
        this.widget._setOffset(offset);
    };

    p._updateItemHeight = function (itemHeight) {
        this.settings.itemHeight = itemHeight;
        this._updateElements();
    };

    p._updateItemPadding = function (itemPadding) {
        this.settings.itemPadding = itemPadding;
        this._updateElements();
    };

    p._updateElements = function () {
        this._setItemHeightAndPadding();
        this._updateItemImageWidth();
        this._adjustTextAlignment();
        this._updateMarkerPositions();
        this._moveToIndex(this.index);
    };

    p._setItemHeightAndPadding = function () {
        var itemHeight = this.settings.itemHeight;
        var itemPadding = this.settings.itemPadding;
        this.fragment.find('div').each(function (i, item) {
            $(item).css({ 'height': itemHeight, 'margin-bottom': itemPadding });
        });
    };

    p._updateItemImageWidth = function () {
        this.fragment.find('div img').each(function () {
            var image = $(this);
            image.css('width', image.css('height'));
        });
    };

    p._adjustTextAlignment = function () {
        var imageAlign = this.settings.imageAlign;
        this.fragment.find('div').each(function () {
            var span = $(this).find('span');
            var image = $(this).find('img');

            if (span.length && image.length) {
                if (span.css('textAlign') === 'center') {
                    var imageWidth = parseInt(image.css('width'), 10);
                    span.css('margin-left', imageAlign === 'left' ? -imageWidth : imageWidth);
                } else {
                    span.css('margin-left', 0);
                }
            }
        });
    };

    p._setPositionBasedItemAppearance = function () {

        this.wheelBoundingBox = this.wheel.get(0).getBoundingClientRect();

        var wheelTop = this.wheelBoundingBox.top;
        var wheelVerticalCenter = (this.wheelBoundingBox.top + this.wheelBoundingBox.bottom) / 2;
        var topToCenterDistance = wheelVerticalCenter - wheelTop;
        // eslint-disable-next-line no-unused-vars
        var distanceToCenter = Number.MAX_SAFE_INTEGER;
        var wheelWidth = parseInt(this.wheel.css('width'), 10);
        var minWidth = wheelWidth * (this.settings.minItemWidth / 100);
        var maxWidth = wheelWidth * (this.settings.maxItemWidth / 100);
        var range = maxWidth - minWidth;
        // eslint-disable-next-line no-unused-vars
        var selectedItemIndex = parseInt(this.fragment.find('div.selected').attr('data-index'), 10);

        this.fragment.find('div').each(function () {
            var itemBoundingBox = this.getBoundingClientRect();
            var itemVerticalCenter = (itemBoundingBox.top + itemBoundingBox.bottom) / 2;
            var distanceToCenter = Math.abs(wheelVerticalCenter - itemVerticalCenter);
            var dtcPercentage = 100 * distanceToCenter / topToCenterDistance;
            var percentage = (100 - dtcPercentage) / 100;

            percentage = parseFloat(percentage.toFixed(2));
            var item = $(this);
            // opacity
            item.css('opacity', percentage);

            // width
            if (item.hasClass('selected')) {
                item.css('width', wheelWidth);
            } else {
                var newWidth = minWidth + range * percentage;
                if (newWidth > maxWidth) {
                    newWidth = maxWidth;
                }
                item.css('width', newWidth);
            }
        });
    };

    p._findClosestItemToWidgetCenter = function () {

        var widgetBoundingBox = this.widget.elem.getBoundingClientRect();
        var widgetVerticalCenter = (widgetBoundingBox.top + widgetBoundingBox.bottom) / 2;
        var closestDistanceToCenter = Number.MAX_SAFE_INTEGER;
        var closestItem;

        this.fragment.find('div').each(function () {
            var itemBoundingBox = this.getBoundingClientRect();
            var itemVerticalCenter = (itemBoundingBox.top + itemBoundingBox.bottom) / 2;
            var currentDistanceToCenter = Math.abs(widgetVerticalCenter - itemVerticalCenter);

            if (currentDistanceToCenter < closestDistanceToCenter) {
                closestDistanceToCenter = currentDistanceToCenter;
                closestItem = this;
            }
        });

        return closestItem;
    };

    function removeSelectedClass(target, self, allowClassChange) {
        if (target && self && allowClassChange) {
            if (self.currentSelected) {
                self.currentSelected.removeClass('selected');
            }
        }
    }

    function addSelectedClass(target, self, allowClassChange) {
        if (target && self && allowClassChange) {
            $(target).addClass('selected');
            self.currentSelected = $(target);
            self.widget.currentSelected = $(target);
        }
    }

    return TextWheel;

});
