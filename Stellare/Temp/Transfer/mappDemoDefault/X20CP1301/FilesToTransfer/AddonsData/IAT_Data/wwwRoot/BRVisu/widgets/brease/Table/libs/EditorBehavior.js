define([
    'brease/core/Class',
    'widgets/brease/Table/libs/EditorHandles',
    'brease/enum/Enum'
], function (
    SuperClass, EditorHandles, Enum
) {

    'use strict';

    var defaultSettings = {},
    
        EditorBehaviorClass = SuperClass.extend(function Model(widget) {
            SuperClass.apply(this, arguments);
            this.widget = widget;
        }, defaultSettings),

        p = EditorBehaviorClass.prototype;

    p.initialize = function () {
        this.throttledFunc = _.throttle(this.reinitialize, 500);
        _initEditor(this);
    };

    p.reinitialize = function () {
        this.widget.renderer.updateEditor();
    };

    p.childrenInitializedEditor = function () {
        // console.log('%c Children in Editor initialized!', 'background: #222; color: #bada55');
    };

    p.childrenUpdated = function () {
        
        if (this.widget.settings.dataOrientation === Enum.Direction.vertical) {
            // this.widget.container.children('.headerContainer').width(this.widget.container.find('.dataTables_scrollBody > .dataTable').width());
            // this.widget.container.children('.headerContainer').css('flex-direction', 'row');

            // //Update size of the tableitems
            // this.headerContainer.width(this.widget.container.find('.dataTables_scrollBody > .dataTable').width());
            // this.headerContainer.height(this.widget.settings.headerBarSize);
            
            this._updateColumnWidth();
            //console.log('%c' + this.widget.container.children('.headerContainer').width(), 'background-color:purple;color:green;');
        } else {
            // this.widget.container.children('.headerContainer').height(this.widget.container.find('.dataTables_scrollBody > .dataTable').height())
            //     .css('left', '0px')
            //     .css('top', '0px')
            //     .css('flex-direction', 'column');

            // //Update size of the tableitems
            // this.headerContainer.height(this.widget.container.find('.dataTables_scrollBody > .dataTable').height());
            // this.headerContainer.width(this.widget.settings.headerBarSize);
            // var headerChildrenC = this.headerChildren,
            //     columnWidth = this.widget.settings.headerBarSize;
            // this.widget.container.find('tr').each(function (i) {
            //     if (headerChildrenC.length === i) return;
            //     var itemHeight = brease.callWidget(headerChildrenC[i].id, 'getRowHeight');
            //     $(headerChildrenC[i]).height((itemHeight) > $(this).height() ? itemHeight : $(this).height());
            //     $(headerChildrenC[i]).width(columnWidth);
            // });
            this._updateRowHeight();
        }
        this.throttledFunc();
    };

    p.childrenAdded = function (e) {
        if (this.headerChildren === undefined) {
            this.headerChildren = this.widget.container.find('.breaseWidget[data-brease-widget]').detach();
            this.headerContainer = $('<div class="headerContainer" style="position:absolute;left:0px;right:0px;height:100%;width:100%;display:flex"></div>');
            (this.widget.settings.dataOrientation === Enum.Direction.vertical) ? this.headerContainer.css('flex-direction', 'row') : this.headerContainer.css('flex-direction', 'column');
            this.widget.container.prepend(this.headerContainer);
            this.widget.container.children('.headerContainer').append(this.headerChildren);

        } else {
            this.headerChildren = this.widget.container.find('.breaseWidget[data-brease-widget]').detach();
            this.widget.container.children('.headerContainer').append(this.headerChildren);
        }

        if (this.widget.settings.dataOrientation === Enum.Direction.vertical) {
            this._updateColumnWidth();
        } else {
            this._updateRowHeight();
        }
        this.throttledFunc();
    };

    p.childrenRemoved = function (e, index) {
        this.headerChildren.splice(index, 1);
        this.childrenUpdated();
    };

    p.dispose = function () {
        // Do something
    };

    p._updateColumnWidth = function () {
        this.headerContainer.height(this.widget.settings.headerBarSize).css('flex-direction', 'row');
        var headerChildren = this.headerChildren,
            rowHeight = this.widget.settings.headerBarSize,
            columnWidths = this.widget.settings.itemColumnWidths, totalWidth = 0, standardWidth = parseInt(this.widget.settings.columnWidth);
        this.headerChildren.each(function (i, item) {
            var w;
            if (columnWidths.length === 0) {
                w = brease.callWidget(item.id, 'getColumnWidth');
            } else {
                w = columnWidths[i];
            }
            w = (w > 0) ? w : standardWidth;
            totalWidth += w;
            $(headerChildren[i]).width(w);
            $(headerChildren[i]).height(rowHeight);
        });
        this.headerContainer.width(totalWidth);
    };

    p._updateRowHeight = function () {
        this.headerContainer.width(this.widget.settings.headerBarSize).css('flex-direction', 'column');
        var headerChildren = this.headerChildren,
            columnWidth = this.widget.settings.headerBarSize,
            rowHeights = this.widget.settings.itemRowHeights,
            totalHeight = 0, standardHeight = parseInt(this.widget.settings.rowHeight);
        this.widget.container.find('tr').each(function (i, item) {
            if (headerChildren.length === i) return;
            var h;
            if (rowHeights.length === 0) {
                h = brease.callWidget(item.id, 'getRowHeight');
            } else {
                h = rowHeights[i];
            }
            h = (h > 0) ? h : standardHeight;
            totalHeight += h;
            $(headerChildren[i]).height(h);
            $(headerChildren[i]).width(columnWidth);
        });

        this.headerContainer.height(totalHeight);
    };

    function _initEditor(that) {
        that.editMode = {};
        that.editMode.itemDefs = [];

        that.widget.el.find('[data-brease-widget]').each(function () {
            var d = $.Deferred();
            that.editMode.itemDefs.push(d);
        });

        $.when.apply($, that.editMode.itemDefs).done(function () {
            that.childrenInitializedEditor();
        });

        that.widget.el.addClass('iat-container-widget');

        var editorHandles = new EditorHandles(that.widget);
        that.widget.getHandles = function () {
            return editorHandles.getHandles();
        };
        that.widget.designer.getSelectionDecoratables = function () {
            return editorHandles.getSelectionDecoratables();
        };
    }

    return EditorBehaviorClass;
});
