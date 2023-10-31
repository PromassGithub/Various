define([
    'brease/core/Class',
    'widgets/brease/common/libs/external/jquery.dataTables',
    'brease/enum/Enum',
    'brease/events/BreaseEvent',
    'brease/core/Types',
    'widgets/brease/Table/libs/InputHandler',
    'widgets/brease/Table/libs/ScrollHandler',
    'widgets/brease/common/libs/wfUtils/UtilsImage'
], function (
    SuperClass, dataTables, Enum, BreaseEvent, 
    Types, InputHandler, ScrollHandler, UtilsImage
) {

    'use strict';

    /**
     * @class widgets.brease.Table.libs.Renderer
     * @extends brease.core.Class
     */

    var Renderer = SuperClass.extend(function Renderer(widget, options) {
            SuperClass.call(this);
            this.widget = widget;
            this.settings = widget.settings;
            this.options = options;
            this.displayedColumns = 0;
            this.initialize();
        }, null),

        p = Renderer.prototype;

    p.initialize = function () {
        //change table base class
        $.fn.dataTable.ext.classes.sTable = 'dataTable';

        //set dataTables to throw errors in console
        $.fn.dataTableExt.sErrMode = this.options.errorMode;
        //We want to throttle our functions and not debounce them, as debounce will wait until a series of
        //calls are finished or at least the interaval specified which might create a race condition.
        //The throttle function on the other hand will always be called at the interval specified.
        //The tableSize has to be high as the process for instantiating the table is slow and needs to done
        //as few times as possible therefore it's better to collect as much data as possible at once and
        //update at a slower interval. Don't set below 500ms.
        this.debounceUpdateTableSize = _.throttle(this.updateTableSizeDebounced.bind(this), this.settings.initRefreshRate);
        this.debounceUpdateTableDataOnly = _.throttle(this.updateTableDataOnlyDebounced.bind(this), this.settings.refreshRate);

        _addTableNode(this);

        this.busy = false;

        this.initScrollHandler();

        if (!brease.config.editMode) {
            this.inputHandler = new InputHandler(this.widget, this);
        }
    };

    p.initScrollHandler = function () {
        this.scrollHandler = new ScrollHandler(this.widget, this, this.options);
    };

    p.updateEditor = function () {
        if (this.tableHeaderEl !== undefined) {
            this.tableHeaderEl.parent().remove();
        }
        _createHeaderWrapper(this);
        _generate(this);
        this.scrollHandler.initializeScroller(true, true);
        this.refreshScroller();

        this.updateTable();
    };

    //Called in editor and runtime
    p.setInitData = function (data) {
        if (this.tableHeaderEl !== undefined) {
            this.tableHeaderEl.parent().remove();
            this.scrollHandler.removeScroller();
        }
        _createHeaderWrapper(this);
        _generate(this);
        this.scrollHandler.initializeScroller(true, false);
        this.refreshScroller();
    };

    p.updateTable = function () {
        this.setRendererBusy();
        if (this.table === undefined) {
            this._buildTable(false);
        } else {
            this.updateTableSize();
        }
    };

    p.updateTableSize = function () {
        this.debounceUpdateTableSize();
    };

    p.updateTableSizeDebounced = function () {
        if (this.table !== undefined) {
            _clearTable(this);
            _addTableNode(this);
            this._buildTable(true);
        }
    };

    /**
     * Function to call when the data only has been updated by a tableitem
     */
    p.updateTableDataOnly = function () {
        this.debounceUpdateTableDataOnly();
    };

    /**
     * DEBOUNCED FUNCTION - DO NOT CALL. Call updateTableDataOnly!!!!!!
     * This method updates the data of the widget without reinstatiating
     * the widget. That is table configuration and all other values are
     * kept and only the data is updated, by using the internal DataTables
     * function rows.remove, rows.add and draw which are much faster than
     * recreating the DataTable.
     * 
     */
    p.updateTableDataOnlyDebounced = function () {
        if (this.scrollHandler.isScrollActive() && this.settings.stopRefreshAtScroll) return;
        this.widget.model.sliceDataAccordingToTableConfig(this.widget.settings.tableConfiguration);
        this._updateTableDataOnly();
    };

    /**
     * helper function to the updateTableDataOnlyDebounced function
     */
    p._updateTableDataOnly = function () {
        if (!this.table) return;
        this.table.rows().remove();
        
        //we must update the data sorting (horz) before we get a copy of it to feed into the datatables
        if (this.settings.dataOrientation === Enum.Direction.horizontal && this.settings.permOrder !== '') {
            var or =  this.widget.model.findIndexOfActualItem(this.settings.permOrder[0]);
            if (or > -1) this.widget.model.sortDataHorizontally(or, this.settings.permOrder[1]);
        }
        
        this.table.rows.add(this.widget.model.getData());
        this.table.draw(false);

        if (this.settings.maxHeight) {
            _resize(this.widget);
        }

        if (this.settings.dataOrientation === 'vertical') {
            this.selectItem('row', this.settings.selectedRow, false);
        } else {
            this.selectItem('column', this.settings.selectedColumn, false);
        }
    };

    p.updateRow = function (data, rowIndex) {
        this.setRendererBusy();
        var renderer = this;
        rowIndex = this.widget.model.findIndexOfActualItem(rowIndex);
        if (rowIndex === -1)  return;
        
        $.each(this.table.row(rowIndex).nodes().toJQuery().children(), function (index, node) {
            var t = data[index];
            t = renderer._prepareString(rowIndex, t);
            node.innerHTML = t;
        });

        _drawCallback.call(this);
    };

    p.updateColumn = function (data, columnIndex) {
        this.setRendererBusy();
        var renderer = this;
        columnIndex = this.widget.model.findIndexOfActualItem(columnIndex);
        if (columnIndex === -1)  return;

        $.each(this.table.cells(null, columnIndex).nodes().toArray(), function (index, node) {
            var t = data[index];
            t = renderer._prepareString(columnIndex, t);
            node.innerHTML = t;
        });

        _drawCallback.call(this);
    };

    p.updateCell = function (rowIndex, columnIndex, value, cellElem) {
        this.setRendererBusy();
        var cells = this.table.cell(cellElem);
        if (cells[0].length > 0) {
            cells.data(value);
        }
        if (typeof rowIndex === 'number' && typeof columnIndex === 'number') {
            cellElem = this.table.cell(rowIndex, columnIndex).node();
        }
        if (cellElem !== undefined && cellElem.className.indexOf('hidden') === -1) {
            value = this._prepareString(columnIndex, value);
            cellElem.innerHTML = value;
        }

        _drawCallback.call(this);
    };

    /**
     * Use when a data cell is updated
     * @param {HTMLElement} elem
     * @returns {String[]}
     */
    p.getUpdatedData = function (elem) {
        if (this.settings.dataOrientation === Enum.Direction.vertical) {
            return this.table.column(elem).data().toArray(); 
        } else {
            return this.table.row(elem).data();
        }
    };

    p._prepareString = function (colIndex, t) {
        if (colIndex === null) {
            colIndex = this.inputHandler.itemIndex;
        }
        if (this.widget.settings.tableItemTypes[colIndex] === 'widgets/brease/TableItem') {
            //Optimize so we only do split/reverse/join x2 if there is a breakline available
            if (t.includes('<br>')) {
                t = t.replace(/<(?!br>)/g, '&lt;'); //Regex for negative lookahead i.e. all < not followed by a 'br />'
                //ECMA5 does not support negative lookbehind, therefore we have to reverse the string and apply a negative lookahead and reverse the string again
                //This is guaranteed a culprit on the speed and should be removed as soon as possible and replaced with the next optimized line
                //t = t.replace(/(?<!\<br \/)/g, '&gt;');  //Regex for negative lookbehind, i.e. all > not preceeded by '<br /'
                t = t.split('').reverse().join('');
                t = t.replace(/>(?!rb<)/g, ';tg&');
                t = t.split('').reverse().join('');
            } else {
                t = t.replace(/</g, '&lt;');                
                t = t.replace(/>/g, '&gt;');
            }
        }
        if (this.settings.multiLine) {
            t = t.replace(/\\n/g, '<br>');
        }
        return t;
    };

    p._itemSelectHandler = function (e) {
        if (brease.config.editMode) return;

        var selectedTarget,
            selectedItems, col, row, _DT_CellIndex;

        var extpolVal = this._extrapolateCorrectCellIndex(e);
        _DT_CellIndex = extpolVal[0];
        selectedTarget = extpolVal[1];

        if (!_DT_CellIndex) return;
            
        col = _DT_CellIndex.column;
        row = _DT_CellIndex.row;
        if (this.widget.settings.dataOrientation === Enum.Direction.vertical) {
            col = this.widget.model.getActualItem(col);
            row = this.getPerpendicularItem(row);
        } else {
            col = this.getPerpendicularItem(col);
            row = this.widget.model.getActualItem(row);
        }

        //A click should perpetuate when an item is disabled, only if the entire widget
        //is disabled should we stop the click and pass a disabled click instead!
        if (this.widget.isDisabled) {
            //If the widget is disabled, we still need to forward a click to the tableItem so it can dispatch
            //a disabled click
            this.widget._forwardClickEvent(e, (this.widget.settings.dataOrientation === Enum.Direction.vertical) ? col : row);
            return;
        }

        if (this.settings.selection) {
            //Remove previous selection
            this._updatePreviouslySelectedItem(this.options.selectableItem);
            //Update with new one
            selectedItems = this._updateSelectedItem(this.options.selectableItem, selectedTarget);
        }

        var data = {
            event: e,
            type: this.options.selectableItem,
            rowIndex: row,
            columnIndex: col
        };
        if (this.widget.settings.dataOrientation === Enum.Direction.vertical) {
            data.tableRow = _DT_CellIndex.row;
            data.tableColumn = _DT_CellIndex.column;
            this.previouslySelectedItemNbr = _DT_CellIndex.row;
        } else {
            data.tableRow = row;
            data.tableColumn = col;
            this.previouslySelectedItemNbr = col;
        }

        this.widget[this.options.selectionCallbackFn](data);

        /**
         * @event SelectedRowChanged
         * Triggered when any value in the table is changed
         * Used only by the Database widget!
         */
        var ev = this.widget.createEvent('SelectedRowChanged', { 'itemSelected': selectedItems });
        ev.dispatch();
        
    };

    p._extrapolateCorrectCellIndex = function (e) {
        
        var selectedTarget, _DT_CellIndex;

        if (e.target.tagName !== 'TD') {
            selectedTarget = $(e.target).parent();
            _DT_CellIndex = selectedTarget[0]._DT_CellIndex;
        } else {
            selectedTarget = e.target;
            _DT_CellIndex = selectedTarget._DT_CellIndex;
        }

        return [_DT_CellIndex, selectedTarget];
    };

    /**
     * This method will take the previously selected item and remove
     * the selected class from it
     * @param {String} columnOrRow a value that can either be 'column' or 'row'
     */
    p._updatePreviouslySelectedItem = function (columnOrRow) {
        var previouslySelectedItems = this.table[columnOrRow](this.previouslySelectedItemNbr).nodes(), 
            i = 0, listOfItems = [];
        if (columnOrRow === 'row' && previouslySelectedItems[0]) {
            previouslySelectedItems[0].classList.remove('selected');
            listOfItems = previouslySelectedItems[0].children;
        } else if (columnOrRow === 'column' && previouslySelectedItems[0]) {
            listOfItems = previouslySelectedItems;
        }

        for (i = 0; i < listOfItems.length; i += 1) {
            listOfItems[i].classList.remove('selected');
        }
    };

    /**
     * This method will take the set the new selected item and add
     * the selected class to it
     * @param {String} columnOrRow a value that can either be 'column' or 'row'
     * @param {Object} selectedTarget
     * @returns {Object[]}
     */
    p._updateSelectedItem = function (columnOrRow, selectedTarget) {
        var selectedItems = this.table[columnOrRow](selectedTarget).nodes(),
            i = 0, listOfItems = [];

        if (columnOrRow === 'row' && selectedItems[0]) {
            selectedItems[0].classList.add('selected');
            listOfItems = selectedItems[0].children;
        } else if (columnOrRow === 'column' && selectedItems[0]) {
            listOfItems = selectedItems;
        }

        for (i = 0; i < listOfItems.length; i += 1) {
            listOfItems[i].classList.add('selected');
        }

        return selectedItems;
    };

    p.selectItem = function (columnOrRow, index, deselectOther) {
        var itemsToSelect, i = 0;
        index = this.convertPerpendicularItemToTableIndex(index);

        if (deselectOther) {
            this._updatePreviouslySelectedItem(columnOrRow);
        }

        if (this.settings.selection) {
            this.previouslySelectedItemNbr = index;
            itemsToSelect = this.table[columnOrRow](index).nodes();
            
            for (var k = 0; k < itemsToSelect.length; k += 1) {
                if (itemsToSelect[k] !== undefined) {
    
                    itemsToSelect[k].classList.add('selected');
    
                    if (columnOrRow === 'row') {
                        for (i = 0; i < itemsToSelect[k].children.length; i += 1) {
                            itemsToSelect[k].children[i].classList.add('selected');
                        }
                    }
                }
            }
        }
    };
    /**
     * @method updateHeaderItems
     */
    p.updateHeaderItems = function () {
        //Stop trailing debounce function in test
        if (!this.widget.model.getTableDataBoundaries(this.displayedColumns) || !this.widget.elem) return;

        //Re-add all cols to the colgroup, that way we only have to remove
        var table = this.widget.elem.getElementsByTagName('table')[0];
        var colgroup = this.widget.elem.getElementsByTagName('colgroup')[0];
        this._removeColGroup(colgroup);
        this._addColGroup(table);

        for (var h = 0; h < this.settings.itemFinalVisibility.length; h += 1) {
            var header = this.tableHeaderEl.children()[h];
            this._updateHeaderItem(header, this.settings.itemFinalVisibility[h], h);
        }
        
        if (this.table === undefined) {
            this.table = this.tableBodyEl.DataTable();
        }
        this.refreshScroller();
    };

    /**
     * Helper method to the updateHeaderItems to reduce complexity
     * This is where the most of the works is done a headerItem
     * passed in will be evaluated and classes updated accordingly
     * @param {Object} header the header element
     * @param {Boolean} visibile determines wither a header item is visible or not 
     * @param {Integer} the position of the header in the list
     */
    p._updateHeaderItem = function (header, visible, position) {
        if (!visible) {
            this._helperHandleClass('hidden', header);
        } else {
            this._helperRemoveClass('hidden', header);
        }
        if (visible && !this.settings.itemFinalEnableState[position]) {
            this._helperHandleClass('disabled', header);
        } else {
            this._helperRemoveClass('disabled', header);
        }
        if (visible) {
            this._applyIndStyle(position, header);
        }
    };

    /**
     * @method _helperHandleClass
     * @private
     * This method is a helper class to the _handleClasses method. It will add or remove the class to the node that is passed.
     * @param {String} cls class passed to the function.
     * @param {HTMLElement|HTMLElement[]} node the node as a HTMLElement which should be modified.
     * @returns {Boolean} returns the comp value as is to be used further up the foodchain.
     */
    p._helperHandleClass = function (cls, node) {
        if (!node) return;
        node.classList.add(cls);
    };

    /**
     * @method _helperRemoveClass
     * @private
     * This method is a helper class to remove a class.
     * @param {String} cls class passed to the function.
     * @param {HTMLElement|HTMLElement[]} node the node as a HTMLElement which should be modified.
     * @returns {Boolean} returns the comp value as is to be used further up the foodchain.
     */
    p._helperRemoveClass = function (cls, node) {
        if (!node) return;
        node.classList.remove(cls);
    };

    /**
     * @method _applyIndStyle
     * @private
     * This class will apply the inividual style to the corresponding row, if the table is not using table styling (i.e. using table item styling).
     * @param {UInteger} item the corresponding item in the table configuration
     * @param {HTMLElement} node the node as a HTMLE<lement which should be modified.
     */
    p._applyIndStyle = function (item, cellNode) {
        if (!this.settings.useTableStyling) {
            //we split the tableitemtype incase the item belongs to custom widget, brease in es[1] is not guaranteed
            var es = this.settings.tableItemTypes[item].split('/');
            cellNode.classList.add(es[0] + '_' + es[1] + '_' + es[2] + '_style_' + this.settings.itemStyling[item]);
            cellNode.classList.add('override');
        }
    };

    /**
     * @method _getColumnWidth
     * @private
     * This method will return the column width for the colgroup for a given item index. If the table is in horizontal mode
     * we don't need to care as it's only the vertical orientation that can take on diffferent column sizes.
     * @param {UInteger} i the index of the column that needs to be looked up in the list 
     * @returns {UInteger} the width of the given item
     */
    p._getColumnWidth = function (i) {
        var w = (this.settings.dataOrientation === Enum.Direction.vertical && 
            this.settings.itemColumnWidths[i] !== undefined &&
            this.settings.itemColumnWidths[i] !== 0) ? this.settings.itemColumnWidths[i] : this.settings.columnWidth;
        return parseInt(w, 10);
    };

    /**
     * @method _removeColGroup
     * This method removes the colgroup and all subsequent children so that we faster can instantiate a correct table
     * @param {HTMLElement} colgroup the colgroup we want to remove
     */
    p._removeColGroup = function (colgroup) {
        if (colgroup === undefined) return;
        colgroup.parentNode.removeChild(colgroup);
    };
    
    /**
     * @method _addColGroup
     * This method adds the colgroup and all subsequent children so that we faster can instantiate a correct table
     * @param {HTMLElement} parent the table we want to add the colgroup to
     */
    p._addColGroup = function (parent) {
        var colgroup = document.createElement('colgroup'), width = 0,
            columns = this.widget.model.getTableDataBoundaries(this.displayedColumns).columns;
        for (var i = 0; i < columns; i += 1) {
            if (this.settings.dataOrientation === Enum.Direction.vertical && !this.settings.itemFinalVisibility[i]) continue;
            var col = document.createElement('col');
            col.width = this._getColumnWidth(i) + 'px';
            col.setAttribute('br-index', i);
            colgroup.appendChild(col);
            width += this._getColumnWidth(i);
        }
        
        this.widget.el.find('table').width(width);
        parent.insertBefore(colgroup, parent.firstChild);
    };

    p.updateTexts = function () {
        this.setRendererBusy();
        var renderer = this;
        $.each(this.tableHeaderEl.children(), function (index, headerNode) {
            $(headerNode).children('span').text(renderer.settings.headerTexts[index]);
            $(headerNode).children('span').html(renderer.widget.model._breakLine($(headerNode).children('span').html()));
        });

        _drawCallback.call(this);
    };

    p.getColumnClasses = function (items) {
        var ret = [];
        for (var item = 0; item <= items; item += 1) {
            var it = this.widget.model.getActualItem(item);
            if (it === undefined) continue;
            var classes = [];
            classes.push(this.getIndividualItemStyling(it));
            classes.push(this.getTableItemEnableState(it));
            var totalClasses = '';
            classes.forEach(function (cls) {
                if (cls.length === 0) return;
                totalClasses += cls + ' ';
            });
            totalClasses = totalClasses.trim();
            it = this.widget.model.findIndexOfActualItem(it);
            ret.push({ className: totalClasses, targets: it });
        }
        return ret;
    };

    p.getHorzColumnClasses = function () {
        var ret = [], columns = this.widget.model.getColumnsInHorzTable();
        this.displayedColumns = 0;
        for (var col = 0; col < columns.length; col += 1) {
            var totalClasses = ''; 
            // var classes = this.getTableConfigClassesRows(columns[col]);
            var classes = this.getTableConfigClassesColumn(columns[col]);
            classes.forEach(function (classe) {
                if (classe.length === 0) return;
                totalClasses += classe;
            });
            ret.push({ className: totalClasses, targets: col });

            if (totalClasses === '') {
                this.displayedColumns += 1;
            }
        }
        return ret;
    };

    p.getTableItemEnableState = function (item) {
        return (this.widget.settings.itemFinalEnableState[item] && !this.widget.isDisabled) ? '' : 'disabled';
    };

    p.getTableConfigClassesColumn = function (index) {
        var conf = this.settings.tableConfiguration['specColumns'];
        return this.getTableConfigClasses(conf, index);
    };

    p.getTableConfigClassesRows = function (index) {
        var conf = this.settings.tableConfiguration['specRows'];
        return this.getTableConfigClasses(conf, index);
    };

    p.getIndividualItemStyling = function (item) {
        if (!this.settings.useTableStyling && this.settings.tableItemTypes[item]) {
            var es = this.settings.tableItemTypes[item].split('/');
            return es[0] + '_' + es[1] + '_' + es[2] + '_style_' + this.settings.itemStyling[item] + ' override';
        }
        return '';
    };

    p.getTableConfigClasses = function (conf, index) {
        var ret = [];
        if (conf) {
            var confSingle = conf.find(function (c) { if (c.index === index) { return c; } }),
                confMulti = conf.find(function (c) {
                    if ((c.from <= index && index <= c.to) || (c.from <= index && c.to === undefined) || (c.from === undefined && index <= c.to)) {
                        return c;
                    }
                });

            if ((confSingle && confSingle.disable) || (confMulti && confMulti.disable)) {
                ret.push('disabled');
            }

        }
        return ret;
    };

    /**
     * this method will return the class name even or odd depending on
     * whether row position. Must be used for cells in the vertical
     * table when individual styling is applied
     * @param {Integer} index
     * @returns {String|undefined}
     */
    p.getRowClass = function (index) {  
        if (!this.settings.useTableStyling) {
            return (index % 2 === 0) ? 'even' : 'odd';
        }
        return undefined;
    };

    p._defineItemsThatAreEnabled = function (conf, direction) {

        this.settings.itemFinalEnableState = _.fill(Array(this.settings.itemEnableStates.length), true); // new Array(this.settings.itemEnableStates.length).fill(true);

        // First rewrite all indices to range system
        var widget = this;
        if (conf && conf[direction]) {
            conf[direction].forEach(function (c) {
                widget.settings.itemFinalEnableState = widget._evaluateConfPosition(c, widget.settings.itemFinalEnableState, (c.disable === true || c.disable === 'true'));
            });
        }

        for (var k = 0; k < this.settings.itemFinalEnableState.length; k += 1) {
            this.settings.itemFinalEnableState[k] = (this.settings.itemEnableStates[k] && this.settings.itemFinalEnableState[k]);
        }
    };

    p._defineItemsThatAreVisible = function (conf, direction) {

        this.settings.itemFinalVisibility =  _.fill(Array(this.settings.itemVisibility.length), true);  //new Array(this.settings.itemVisibility.length).fill(true);

        // First rewrite all indices to range system
        var widget = this;
        if (conf && conf[direction]) {
            conf[direction].forEach(function (c) {
                widget.settings.itemFinalVisibility = widget._evaluateConfPosition(c, widget.settings.itemFinalVisibility, (c.visible === false || c.visible === 'false'));
            });
        }
        this.displayedColumns = 0;
        for (var k = 0; k < this.settings.itemFinalVisibility.length; k += 1) {
            this.settings.itemFinalVisibility[k] = (this.settings.itemVisibility[k] && this.settings.itemFinalVisibility[k]);
            this.displayedColumns += (this.settings.itemFinalVisibility[k]) ? 1 : 0;
        }
    };

    /**
     * This method will take one tableConfigurationItem and determine whether
     * the item on should be visible/invisible or enabled/disabled
     * @param {Object} c config item
     * @param {Integer} c.index index of an item
     * @param {Integer} c.to starting position of range of items
     * @param {Integer} c.from ending position of range of items
     * @param {Boolean[]} itemFinalListVisOrDis list of the items indicating their stati
     * @returns {Boolean[]} updated list of the items indicating their stati
     */
    p._evaluateConfPosition = function (c, itemFinalListVisOrDis, run) {
        if (run) {
            if (c.index !== undefined && c.index < itemFinalListVisOrDis.length) itemFinalListVisOrDis[c.index] = false;
            if (c.from !== undefined || c.to !== undefined) {
                c.from = (c.from !== undefined) ? c.from : 0;
                c.to = (c.to !== undefined) ? c.to : itemFinalListVisOrDis.length;
                for (var i = c.from; i <= c.to; i += 1) {
                    if (i >= itemFinalListVisOrDis.length) continue;
                    itemFinalListVisOrDis[i] = false;
                }
            }
        }
        return itemFinalListVisOrDis;
    };
    
    /**
     * @method _updateColumnsOrRows
     * @private
     * The sole purpose of this function is so that the drawCallback
     * function can update the cell images accordingly. Before it only
     * called the _fitBackGroundImagesToRowHeight which works fine in 
     * vertical mode but not horizontal. For horizontal we might have
     * individual row heights.
     */
    p._updateColumnsOrRows = function () {
        if (this.settings.dataOrientation === Enum.Direction.vertical) {
            _fitBackgroundImagesToRowHeight(this.widget, this.settings.rowHeight);
        } else {
            var self = this;
            $.each(this.settings.itemRowHeights, function (index, height) {
                //update images if necessary
                if (self.settings.tableItemTypes[index].includes('ImageList')) {
                    index = self.widget.model.findIndexOfActualItem(index);
                    _fitBackgroundImagesToRowHeight(self.widget, height, index);
                }
            });
        }
    };

    /**
     * @method updateColumnWidths
     * This method will update the width in all columns in the table according to order of 
     * the (first one is only for header elements) the headerSize, then the individual 
     * item columnWidth and finally the cellSize/columnWidth given in the table. From this
     */
    p.updateColumnWidths = function () {
        var headerElements = (this.tableHeaderEl) ? this.tableHeaderEl.children() : [],
            colWidth = 0,
            totalcolumnWidth = 0;

        for (var i = 0; i < this.settings.tableItemIds.length; i += 1) {
            colWidth = (this.settings.dataOrientation === Enum.Direction.horizontal && this.settings.headerSize !== 0) ? this.settings.headerBarSize : this._getColumnWidth(i);
                        
            if (this.settings.tableItemTypes[i].includes('ImageList')) {
                _fitBackgroundImagesToRowHeight(this.widget, this.settings.rowHeight);
            }
            if (headerElements[i]) $(headerElements[i]).outerWidth(colWidth);
            totalcolumnWidth += colWidth;
        }

        //Finally update the header container of the widget if we are in horizontal mode
        if (this.settings.dataOrientation === Enum.Direction.horizontal) {
            var header = this.widget.el.find('.headerContainer');
            var headerWidth = (this.settings.dataOrientation === Enum.Direction.horizontal) ? colWidth : totalcolumnWidth;
            header.width(headerWidth);
            header.children().width(headerWidth);
        }
    };

    p.updateRowHeights = function (initial) {
        this.setRendererBusy();

        var tableRows = this.tableBodyEl.find('tr'),
            headerElements = (this.tableHeaderEl) ? this.tableHeaderEl.children() : [],
            renderer = this;

        if (this.settings.dataOrientation === Enum.Direction.horizontal) {
            $.each(renderer.settings.itemRowHeights, function (index, height) {
                var actualRowPos = renderer.widget.model.findIndexOfActualItem(index);
                if (actualRowPos === -1) return;
                if (height === 0 || height === undefined) {
                    height = renderer.settings.rowHeight;
                }
                $(tableRows[index]).height(height);
                if (headerElements[index]) $(headerElements[index]).outerHeight(height);

                //update images if necessary
                if (renderer.settings.tableItemTypes[actualRowPos].includes('ImageList')) {
                    _fitBackgroundImagesToRowHeight(renderer.widget, height, actualRowPos);
                }
            });
        } else if (this.settings.dataOrientation === Enum.Direction.vertical) {
            tableRows.height(this.settings.rowHeight);
        }

        if (!initial) {
            this.refreshScroller();
            _drawCallback.call(this);
        }
    };

    /**
     * This method will update the ordering of the table
     * and then order the redraw of the rows
     * @param {Integer} index
     */
    p.updateTableOrder = function (index) {
        if (!this.table) return;
        var currOrder = this.widget.getInternalOrderState(index), cnt;
        this._updateImages(index, currOrder);
        if (currOrder === undefined) { // Resets order original setup -- I hope
            cnt = this.widget.model.getNumberOfItems();
            currOrder = 'asc';
        } else {
            cnt = this.widget.model.findIndexOfActualItem(index);
        }

        this.settings.order = [cnt, currOrder];
        this.settings.permOrder = [index, currOrder];

        if (this.settings.dataOrientation === Enum.Direction.horizontal) {
            this.widget.model.sortDataHorizontally(cnt, currOrder);
        }
        this.table.order(this.settings.order);
        
        if (!this.widget.model.getIsProcessedDatasetEmpty()) {
            this._updateTableDataOnly();
        }
    };

    p.updateOrder = function () {
        //update sorting position to the new place in case it has changed
        //after a tableConfig update
        if (this.settings.permOrder) {
            var order = this.widget.model.findIndexOfActualItem(this.settings.permOrder[0]);
            if (order === -1 || this.settings.dataOrientation === Enum.Direction.horizontal) {
                this.settings.order = '';
            } else {
                this.settings.order = [order, this.settings.permOrder[1]];
            }
        }
    };

    /**
     * This method will update the triangle images in the table header
     * indicating which direction a table item is currently sorted on,
     * it will also reset the images of all items which are currently not
     * sorted.
     * @param {Integer} index
     * @param {String} currOrder directional order of the sort, can be of the values 'asc' or 'desc'
     */
    p._updateImages = function (index, currOrder) {
        if (this.settings.showSortingButton) {
            for (var i = 0; i < this.settings.tableItemIds.length; i += 1) {
                var topTriangle = '', bottomTriangle;
                if (i === index) {
                    bottomTriangle = (currOrder === 'asc') ? 'selected' : 'unselected';
                    topTriangle = (currOrder === 'desc') ? 'selected' : 'unselected';
                } else {
                    topTriangle = 'unselected';
                    bottomTriangle = 'unselected';
                }
                this.tableHeaderEl.find('svg > g > path:eq(' + 2 * i + ')').removeClass('selected').removeClass('unselected').addClass(topTriangle);
                this.tableHeaderEl.find('svg > g > path:eq(' + (2 * i + 1) + ')').removeClass('selected').removeClass('unselected').addClass(bottomTriangle);
            }
        }
    };

    p.processStyleChange = function () {
        var renderer = this;
        this.styleChangeProcess = _.defer(function () {
            renderer.updateRowHeights();
        });
    };

    /**
     * This method listens for the inputHandler to be ready, and when it is
     * it binds the click event to the table
     */
    p._inputReadyHandler = function () {
        this.tableBodyEl.off('inputHandlerReady', _.bind(this._inputReadyHandler, this));
        this.addEventListeners();
    };

    /**
     * This method will handle the clicks in a cell, if the cell has the attribute input
     * set to true, it will call the input handler
     * @param {Event} e
     */
    p._cellClickHandler = function (e) {
        if (this.tableReady) {
            if ((e.target.getAttribute('input') === 'true') && (!$(e.target).hasClass('disabled'))) {
                this.inputHandler.requestCellInput(e.target);
            }
        }
    };

    p._headerClickHandler = function (e) {
        var indexOfChild;

        this.tableHeaderEl.children().each(function (index, elem) {
            if ($.contains(elem, e.target)) {
                indexOfChild = index;
                return false;
            } else if (elem === e.target) {
                indexOfChild = index;
                return false;
            }
        });
        if (this.settings.showSortingButton) {
            this.updateTableOrder(indexOfChild);
        }
        this.widget[this.options.headerClickCallbackFn](e, indexOfChild);
    };

    p.setRowState = function (index, state) {
        var rowEl = $(this.table.row(index).node()),
            pos = this.widget.model.getActualItem(index),
            itemConfig = brease.callWidget(this.settings.tableItemIds[pos], 'getItemConfig');

        rowEl.children().toggleClass('disabled', !state).attr('input', itemConfig.input);
        rowEl.prev().children().toggleClass('nextItemDisabled', !state);
        if ((state === true) && (itemConfig.input === true)) {
            rowEl.children().each(function (index, td) {
                if (itemConfig.inputConfig.validDataLength > index) {
                    $(td).attr('input', true);
                } else {
                    $(td).attr('input', false);
                }
            });
        }
        this.tableHeaderEl.children().eq(index).toggleClass('disabled', !state);
        this.tableHeaderEl.children().eq(index).prev().toggleClass('nextItemDisabled', !state);
    };

    p.setColumnState = function (index, state) {
        var columnEl = $(this.table.column(index).nodes()),
            pos = this.widget.model.getActualItem(index),
            itemConfig = brease.callWidget(this.settings.tableItemIds[pos], 'getItemConfig');

        columnEl.toggleClass('disabled', !state).attr('input', itemConfig.input);
        if (index > 0) {
            $(this.table.column(index - 1).nodes()).toggleClass('nextItemDisabled', !state);
        }
        if ((state === true) && (itemConfig.input === true)) {
            columnEl.each(function (index, td) {
                if (itemConfig.inputConfig.validDataLength > index) {
                    $(td).attr('input', true);
                } else {
                    $(td).attr('input', false);
                }
            });
        }
        this.tableHeaderEl.children().eq(index).toggleClass('disabled', !state);
        this.tableHeaderEl.children().eq(index).prev().toggleClass('nextItemDisabled', !state);
    };

    p.enable = function () {
        if (this.scrollHandler.scrollerBody && this.table) {
            this.scrollHandler.scrollerBody.enable();
        }
        this.updateTable();
    };

    p.disable = function () {
        if (this.scrollHandler.scrollerBody && this.table) {
            this.scrollHandler.scrollerBody.disable();
        }
        this.updateTable();
    };

    p.setVisible = function () {
        _resize(this.widget);
        this.refreshScroller();
    };

    p.setRendererBusy = function () {
        if (!brease.config.editMode) {
            this.busy = true;
        }
    };

    p.refreshScroller = function () {
        this.scrollHandler._refreshScroller();
    };

    p.setRendererReady = function () {
        this.busy = false;
        this.widget._hideBusyIndicator();
    };

    /**
     * Method solely for the purpose of the editor!
     */
    p._itemResizeHandler = function (e) {
        var totalHeaderSize = 0, itemToUpdate;
        if (this.settings.dataOrientation === Enum.Direction.vertical) {
            for (var i = 0; i < this.settings.tableItemIds.length; i += 1) {
                if (this.settings.tableItemIds[i] === e.detail.id) {
                    this.settings.itemColumnWidths[i] = e.detail.newSize;
                    itemToUpdate = i;
                }
                totalHeaderSize += parseInt(this.settings.itemColumnWidths[i]);
            }
            this.widget.el.find('.headerContainer').width(totalHeaderSize);

        } else {
            for (var j = 0; j < this.settings.tableItemIds.length; j += 1) {
                if (this.settings.tableItemIds[j] === e.detail.id) {
                    this.settings.itemRowHeights[j] = e.detail.newSize;
                    itemToUpdate = j;
                }
                totalHeaderSize += parseInt(this.settings.itemRowHeights[j]);
            }
            this.widget.el.find('.headerContainer').height(totalHeaderSize);
        }

        _updateFromEditHandler(this, itemToUpdate, e.detail.newSize, totalHeaderSize);
        this.scrollHandler._refreshEditorScroller(true);
    };

    p.setFilter = function () {
        var self = this;
        if ($.fn.dataTable.ext.search.length !== 0) {
            $.fn.dataTable.ext.search.pop();
        }

        //The function for filtering WILL ONLY BE CALLED IF THERE IS DATA IN THE TABLE!!!!
        $.fn.dataTable.ext.search.push(
            function (settings, data, dataIndex, row) {
                
                var accVal = (self.widget.settings.filter.length === 0), accAnd = true;
                for (var i = 0; i < self.widget.settings.filter.length; i += 1) {
                    var fil = self.widget.settings.filter[i], compVal, origVal,
                        conf = self.widget.settings.itemConfigs[fil.data];

                    //Check if we are looking at time
                    if (conf.type === 'date') {
                        compVal = self._fixTimestamp(fil.comp.split('Z')[0], conf.inputConfig.format);
                        //origVal = self._fixTimestamp(brease.callWidget(self.widget.settings.tableItemIds[fil.data], 'getValue')[dataIndex], conf.inputConfig.format);
                        origVal = self._fixTimestamp(brease.callWidget(self.widget.settings.tableItemIds[fil.data], 'getValue')[dataIndex].split('Z')[0], conf.inputConfig.format);
                    } else {
                        compVal = fil.comp;
                        //If we are going to get the orignal data we have to remember that it's not transformed for vertical data so we switch
                        //position for rows and columns...
                        // origVal = self.widget.model.getOriginalData()[fil.data][dataIndex];
                        var f = self.widget.model.findIndexOfActualItem(fil.data);
                        origVal = self.widget.model.getData()[dataIndex][f];
                    }

                    var val = self._getFilterStatement(origVal, fil.opVal, compVal);

                    //Split between whether we are in an 'OR' or 'AND' filter
                    if (fil.logVal === 1 || fil.logical === '') {
                        accVal = accVal || (accAnd && val);
                        accAnd = true;
                    } else if (fil.logVal === 0) {
                        accAnd = accAnd && val;
                    }

                }
                return accVal;
            });
    };

    p._getFilterStatement = function (origVal, op, compVal) {
        var retValRow;

        if (!isNaN(parseInt(origVal))) {
            origVal = parseInt(origVal);
        }

        if (!isNaN(parseInt(compVal))) {
            compVal = parseInt(compVal);
        }

        if (compVal === 'not supported') {
            return true;
        }

        if (origVal instanceof Date) {
            origVal = origVal.getTime();
            compVal = compVal.getTime();
        }

        switch (op) {
            case 0:
                //retValRow = (origVal !== compVal);
                // eslint-disable-next-line eqeqeq
                retValRow = (origVal != compVal);
                break;

            case 1:
                //retValRow = (origVal === compVal);
                // eslint-disable-next-line eqeqeq
                retValRow = (origVal == compVal);
                break;

            case 2:
                retValRow = (origVal < compVal);
                break;

            case 3:
                retValRow = (origVal <= compVal);
                break;

            case 4:
                retValRow = (origVal > compVal);
                break;

            case 5:
                retValRow = (origVal >= compVal);
                break;

            case 6:
                retValRow = (typeof (origVal) !== 'string') ? false : (origVal.indexOf(compVal) !== -1);
                break;

            case 7:
                retValRow = (typeof (origVal) !== 'string') ? false : (origVal.indexOf(compVal) === -1);
                break;

            default:
                retValRow = true;
        }
        return retValRow;
    };

    p._fixTimestamp = function (tim, f) {
        var d = new Date(tim);

        if (f.indexOf('f') !== -1) {
            // eslint-disable-next-line no-self-assign
            d = d;
        } else if (f.indexOf('s') !== -1) {
            d.setMilliseconds(0);
        } else if (f.indexOf('m') !== -1) {
            d.setMilliseconds(0);
            d.setSeconds(0);
        } else if (f.indexOf('H') !== -1 || f.indexOf('h') !== -1) {
            d.setMilliseconds(0);
            d.setSeconds(0);
            d.setMinutes(0);
        } else if (f.indexOf('d') !== -1) {
            d.setMilliseconds(0);
            d.setSeconds(0);
            d.setMinutes(0);
            d.setHours(0);
        } else if (f.indexOf('M') !== -1) {
            d.setMilliseconds(0);
            d.setSeconds(0);
            d.setMinutes(0);
            d.setHours(0);
            d.setDate(0);
        } else if (f.indexOf('y') !== -1) {
            d.setMilliseconds(0);
            d.setSeconds(0);
            d.setMinutes(0);
            d.setHours(0);
            d.setDate(0);
            d.setMonth(0);
        }
        return d;
    };

    /**
     * This method will get the perpendicular item, i.e. if table is in horizontal
     * mode the items are on the rows and cells are based on the columns and vice
     * versa if we are in vertical mode
     * @param {Integer} idx
     * @returns {Integer}
     */
    p.getPerpendicularItem = function (idx) {
        if (!this.table) return;
        if (this.settings.dataOrientation === Enum.Direction.vertical) {
            var d = this.table.row(idx).data();
            return d[d.length - 1];
        } else {
            return this.table.rows(this.table.rows().count() - 1).data().toArray()[0][idx];
        }
    };

    /**
     * A few methods needs to interact directly with the table indexing, but to 
     * store the correct position of an item it needs the correct value, this method
     * reconverts the pIndex (given by the method getPerpendicukarItem) to the index
     * found in the table.
     * @param {Integer} pidx
     * @returns {Integer}
     */
    p.convertPerpendicularItemToTableIndex = function (pidx) {
        if (!this.table) return;
        if (this.settings.dataOrientation === Enum.Direction.vertical) {
            return pidx; //this.table.columns(this.table.columns().count() - 1).data().toArray()[0].indexOf(pidx) - 1;
        } else {
            return this.table.rows(this.table.rows().count() - 1).data().toArray()[0].indexOf(pidx);
        }
    };

    p.removeEventListeners = function () {
        if (brease.config.editMode) {
            this.widget.elem.removeEventListener('ItemSizeChanged', this._bind('_itemResizeHandler'));
        }
        this.tableBodyEl.off(BreaseEvent.CLICK, _.bind(this._cellClickHandler, this));
    };

    p.addEventListeners = function () {
        this.tableBodyEl.on(BreaseEvent.CLICK, _.bind(this._cellClickHandler, this));
    };

    p.dispose = function () {
        _clearTable(this);
        this.removeEventListeners();
        window.clearTimeout(this.styleChangeProcess);
        this.tableReady = null;
        this.scrollHandler.dispose();
        this.inputHandler.dispose();
        SuperClass.prototype.dispose.apply(this, arguments);
    };
    
    p.suspend = function () {
        this.inputHandler.suspend();
        this.removeEventListeners();
    };

    p.wake = function () {
        this.inputHandler.wake();
        this.addEventListeners();
    };

    // Privates

    /**
     * @method _fitBackgroundImagesToRowHeight
     * This method will fit the image to the height of the row these are placed in
     * @param {Object} widget widget we operate on 
     * @param {UInteger} height optional, the height that should be applied to the image, if none is supplied it will use the rowHeight
     * @param {UInteger} index the row that should be operated upon. May differ in horizontal direction
     */
    function _fitBackgroundImagesToRowHeight(widget, height, index) {
        if (height === undefined || height === 0) {
            height = widget.settings.rowHeight;
        }
        var w, i = 0;
        //Set size to one pixel less than row height so appended row padding adds up to the correct size
        if (index) {
            //The first row is tr > th and thus we need to increase the index count to ignore the hidden header row
            w = widget.elem.querySelectorAll('tr')[index];
            if (!w) return;
            for (i = 0; i < w.children.length; i += 1) {
                if (w.children[i].children.length === 0) continue;
                w.children[i].children[0].style.maxHeight = (height - 1) + 'px';
            }
        } else {
            // widget.el.find('td > img').css('max-height', height - 1);
            w = widget.elem.querySelectorAll('tr > td > img');
            for (i = 0; i < w.length; i += 1) {
                w[i].style.maxHeight = (height - 1) + 'px';
            }
        }
    }

    function _createHeaderWrapper(renderer) {
        var headerWrapperEl = $('<div class="dataTables_scrollHead"></div>'),
            headerSize = renderer.settings.headerBarSize;

        if (!renderer.widget.settings.showHeader) {
            headerWrapperEl.css('display', 'none');
            headerSize = 0;
        }

        renderer.tableHeaderEl = $('<div class="tableHeader">').on(BreaseEvent.CLICK, renderer._bind('_headerClickHandler'));

        if (renderer.settings.dataOrientation === Enum.Direction.vertical) {
            headerWrapperEl.height(headerSize);
            headerWrapperEl.addClass('verticalOrientation');
        } else if (renderer.settings.dataOrientation === Enum.Direction.horizontal) {
            headerWrapperEl.width(headerSize);
            headerWrapperEl.addClass('horizontalOrientation');
        }

        headerWrapperEl.append(renderer.tableHeaderEl);
        var headerContainer = renderer.widget.el.find('.headerContainer');
        if (headerContainer.length > 0) {
            //This part is so that we keep the editorhandles in the same place at all times when inserting a new item
            headerWrapperEl.insertAfter(headerContainer);
        } else {
            renderer.widget.container.prepend(headerWrapperEl);
        }
    }

    function _generate(renderer) {
        var headerEl = [];
        var deferredList = [], i = 0;
        $.each(renderer.settings.tableItemIds, function (index) {
            var h = $('<div class="headerElement" style="box-sizing:border-box;"/>').append($('<span>').text(renderer.settings.headerTexts[index])), headerSize;
            var visible = renderer.settings.itemFinalVisibility[index] || renderer.settings.itemVisibility[index];
            if (!visible) {
                h.addClass('hidden');
            }
            if (renderer.settings.dataOrientation === Enum.Direction.vertical) {
                headerSize = (renderer.settings.itemColumnWidths[index] > 0) ? renderer.settings.itemColumnWidths[index] : renderer.settings.columnWidth;
                h.width(headerSize);
            } else if (renderer.settings.dataOrientation === Enum.Direction.horizontal) {
                headerSize = (renderer.settings.itemRowHeights[index] > 0) ? renderer.settings.itemRowHeights[index] : renderer.settings.columnWidth;
                h.height(headerSize);
            }
            headerEl.push(h);

            if (renderer.settings.showSortingButton) {
                var src = 'widgets/brease/Table/assets/sort_arrow.svg';
                UtilsImage.getInlineSvg(src).then(function (svgElement) {
                    var imgEl = $('<svg class="ordering img_vert" />');
                    imgEl.replaceWith(svgElement);
                    imgEl = svgElement;
                    imgEl.addClass('ordering');
                    if (renderer.settings.dataOrientation === Enum.Direction.vertical) {
                        imgEl.addClass('img_vert');
                    } else {
                        imgEl.addClass('img_horz');
                    }
                    headerEl[i].append(imgEl);
                    i += 1;
                });
            }
        });

        $.when(deferredList).done(function () {
            renderer.tableHeaderEl.append(headerEl);
        }).fail();
    }

    function _createBodyWrapper(renderer) {

        var bodyWrapperEl = $('<div class="dataTables_scrollBody"/>'),
            headerWrapperEl = renderer.widget.el.find('.dataTables_scrollHead').detach(),
            headerSize = (renderer.widget.settings.showHeader) ? renderer.settings.headerBarSize : 0;

        renderer.widget.container.find('.dataTable thead').remove();
        renderer.tableWrapper = renderer.widget.container.find('.dataTables_wrapper');
        renderer.tableBodyEl.addClass('tableCells');

        if (renderer.settings.dataOrientation === Enum.Direction.vertical) {
            bodyWrapperEl.css('height', 'calc(100%' + ' - ' + headerSize + 'px)');
            bodyWrapperEl.addClass('verticalOrientation');
            renderer.tableWrapper.addClass('verticalOrientation');
        } else if (renderer.settings.dataOrientation === Enum.Direction.horizontal) {
            bodyWrapperEl.css('width', 'calc(100%' + ' - ' + headerSize + 'px)');
            headerWrapperEl.width(renderer.settings.headerBarSize);
            bodyWrapperEl.addClass('horizontalOrientation');
            renderer.tableWrapper.addClass('horizontalOrientation');
        }

        renderer.tableBodyEl.wrap(bodyWrapperEl);
        renderer.tableWrapper.prepend(headerWrapperEl);
    }

    function _addTableNode(renderer) {
        renderer.tableBodyEl = $('<table>').attr('id', renderer.widget.elem.id + '_table');
        if (!brease.config.editMode) {
            if (renderer.inputHandler && renderer.inputHandler.inputsReady) {
                renderer.tableBodyEl.on(BreaseEvent.CLICK, _.bind(renderer._cellClickHandler, renderer));
            } else {
                renderer.tableBodyEl.on('inputHandlerReady', _.bind(renderer._inputReadyHandler, renderer));
            }
        }
        renderer.widget.container.append(renderer.tableBodyEl);
    }

    /**
     * Method that calculates all necessities for the table to be built
     * It will preprocess all data and set variables necessary before instantiating
     * the table.
     * This is a very slow process and should only be done if item functionality/visibility
     * or tableConfiguration has changed.
     * @param {Boolean} rebuild changes which callback function should be used.
     */
    p._buildTable = function (rebuild) {
        if (brease.config.preLoadingState) return;

        var displayData = this._preprocessBuildTable();
        if (!displayData || (displayData[0] && displayData[0].empty)) {
            return this.widget.resolveTable();
        }

        this.updateOrder();

        var options = {
            data: displayData,
            autoWidth: false,
            ordering: (this.settings.dataOrientation === Enum.Direction.vertical) ? this.settings.showSortingButton : false, //Only allow sorting if vertical table,
            order: this.settings.order, //set no sorting order to begin with.
            paging: false,
            info: false,
            dom: 't',
            language: { zeroRecords: '' },
            columns: this.columnDefinition,
            columnDefs: [
                { targets: '_all', createdCell: _.bind(_createdCellCallback, this), orderable: true, searchable: true }
            ],
            initComplete: (rebuild) ? _.bind(_rebuildCompleteCallback, this) : _.bind(_initCompleteCallback, this),
            drawCallback: _.bind(_drawCallback, this),
            createdRow: _.bind(_createdRowCallback, this)
        };
        var colDefs;
        if (this.settings.dataOrientation === Enum.Direction.vertical) {
            options.columnDefs.push({ targets: -1, searchable: false, visible: false, orderable: true });
            colDefs = this.getColumnClasses(this.columnDefinition.length);
        } else {
            colDefs = this.getHorzColumnClasses();
        }
        if (colDefs.length > 0) {
            options.columnDefs = options.columnDefs.concat(colDefs);
        }

        this.tableBodyEl.DataTable(options);
    };

    /**
     * This method preprocess all infomration necessary for the buildTable method
     * if the build is invalid somehow it will return an undefined value otherwise
     * the dataset that should be shown will be returned.
     * @returns {Object[]|undefined}
     */
    p._preprocessBuildTable = function () {
        if (this.widget.model.getIsDatasetEmpty()) {
            return;
        } else if (this.widget.model.getNumberOfRowsAvailable() > 0) {
            this.setFilter();
        }
        var dir = (this.settings.dataOrientation === Enum.Direction.vertical) ? 'specColumns' : 'specRows';
        this._defineItemsThatAreVisible(this.widget.settings.tableConfiguration, dir);
        this._defineItemsThatAreEnabled(this.widget.settings.tableConfiguration, dir);

        this.widget.model.sliceDataAccordingToTableConfig(this.widget.settings.tableConfiguration);
        //we must update the data sorting (horz) before we get a copy of it to feed into the datatables
        if (this.settings.dataOrientation === Enum.Direction.horizontal && this.settings.permOrder !== '') {
            var or =  this.widget.model.findIndexOfActualItem(this.settings.permOrder[0]);
            if (or > -1) this.widget.model.sortDataHorizontally(or, this.settings.permOrder[1]);
        }
        var displayData = this.widget.model.getData();

        _createColumnObj(this, displayData);

        return displayData;
    };

    function _createColumnObj(renderer, data) {
        renderer.columnDefinition = [];
        var t = 1;
        //Sequencer contains no data so we need to set the data from the item visibility
        if (renderer.widget.elem.classList.contains('breaseSequencerTable')) {
            renderer.settings.itemFinalVisibility.forEach(function (val) { if (val) t++; });
        } else {
            if (data.length > 0) {
                t = data[0].length;
            }
        }
        renderer.columnDefinition = _.fill(Array(t), null);
    }

    function _initCompleteCallback() {
        _setClasses(this);
        _createBodyWrapper(this);

        // this.updateItemVisibility(true);
        this.updateHeaderItems();

        this.updateColumnWidths(true);
        this.updateRowHeights(true);
        this.scrollHandler.initializeScroller(false, false);
        this.refreshScroller();
        // _setInitialEnableStates(this);
        _resize(this.widget);
        this.tableReady = true;
        this.widget[this.options.tableReadyCallbackFn]();

        if (this.settings.dataOrientation === 'vertical') {
            this.selectItem('row', this.settings.selectedRow, true);
        } else {
            this.selectItem('column', this.settings.selectedColumn, true);
        }
        this.setRendererReady();
    }

    function _rebuildCompleteCallback() {
        _setClasses(this);
        _createBodyWrapper(this);

        this.updateHeaderItems();

        this.updateColumnWidths(true);
        this.updateRowHeights(true);
        this.scrollHandler.initializeScroller(false, true);
        // _setInitialEnableStates(this);
        _resize(this.widget);
        this.tableReady = true;
        this.widget[this.options.tableReadyCallbackFn]();

        if (this.settings.dataOrientation === 'vertical') {
            this.selectItem('row', this.settings.selectedRow, true);
        } else {
            this.selectItem('column', this.settings.selectedColumn, true);
        }
        this.setRendererReady();
    }

    function _drawCallback() {
        this._updateColumnsOrRows();
        this.widget[this.options.drawCallbackFn]();
        this.refreshScroller();
        this.setRendererReady(); 
    }

    /**
     * this method is called by the DataTables when a cell is instantiated.
     * It's used by the widget to add cell specific information 
     * @param {*} cell 
     * @param {*} cellData 
     * @param {*} rowData 
     * @param {*} rowIndex 
     * @param {*} colIndex 
     */
    function _createdCellCallback(cell, cellData, rowData, rowIndex, colIndex) {

        //var compIndex, readIndex;
        var readIndex;
        if (this.settings.dataOrientation === Enum.Direction.vertical) {
            // compIndex = this.getPerpendicularItem(rowIndex);
            readIndex = this.widget.model.getActualItem(colIndex);
        } else {
            readIndex = this.widget.model.getActualItem(rowIndex);
            // compIndex = this.getPerpendicularItem(colIndex);
        }
        
        if (!this.settings.itemConfigs[readIndex]) return;

        //Check if cell is of type input type true or false
        if (this.settings.itemConfigs[readIndex].input) { // && (this.settings.itemConfigs[readIndex].inputConfig.validDataLength > compIndex)) {
            cell.setAttribute('input', true);
        } else {
            cell.setAttribute('input', false);
        }

        if ((this.settings.itemConfigs[readIndex].type === 'number') || (this.settings.itemConfigs[readIndex].type === 'nodeNumber')) {
            cell.setAttribute('type', 'number');
        } else if (this.settings.itemConfigs[readIndex].type === 'string') {
            cell.setAttribute('type', 'string');
        }
    }

    /**
     * This method is a callback function bound to the DataTable and called 
     * when a new row is created. For the widget this gives an oppertunity to
     * add disabled and selected class and adjust the row height of every
     * row.
     * @param {*} row 
     * @param {*} data 
     * @param {*} dataIndex 
     * @param {*} cells 
     */
    function _createdRowCallback(row, data, dataIndex, cells) {
        var rowHeight, sts = this.settings, pos = -1;
        if (sts.dataOrientation === Enum.Direction.vertical) {
            this._fixVerticalRowOnCallback(row, data, dataIndex);
            rowHeight = sts.rowHeight;
        } else {
            pos = this._fixHorzRowOnCallback(row, data, dataIndex);
            rowHeight = (sts.itemRowHeights[pos] > 0) ? sts.itemRowHeights[pos] : sts.rowHeight;
        }

        row.style.height = rowHeight + 'px';
    }

    /**
     * This function is merely a helper class for the vertical orientation
     * of the _createdRowCallback function above.
     * @param {Object} row 
     * @param {Object} data 
     * @param {Integer} dataIndex 
     * 
     */
    p._fixVerticalRowOnCallback = function (row, data, dataIndex) {
        var list = this.getTableConfigClassesRows(data[data.length - 1]), pos = -1;
        if (list.length > 0) {
            row.classList.add(list);
        }

        if (this.widget.isDisabled) {
            row.classList.add('disabled');
        }

        var rowIndicator = this.getRowClass(dataIndex);
        for (var i = 0; i < row.children.length; i += 1) {
            pos = this.widget.model.getActualItem(i);
            var listC = this.getTableItemEnableState(pos);
            if (list.length > 0) {
                row.children[i].classList.add(list);
            }
            if (listC.length > 0) {
                row.children[i].classList.add(listC);
            }
            if (rowIndicator) {
                row.children[i].classList.add(rowIndicator);
            }
        }

        if (this.settings.selection && dataIndex === this.previouslySelectedItemNbr) {
            row.classList.add('selected');
            for (i = 0; i < row.children.length; i += 1) {
                row.children[i].classList.add('selected');
            }
        }
    };

    /**
     * This function is merely a helper class for the horizontal orientation
     * of the _createdRowCallback function above.
     * @param {Object} row 
     * @param {Object} data 
     * @param {Integer} dataIndex 
     * @returns {Integer}
     * 
     */
    p._fixHorzRowOnCallback = function (row, data, dataIndex) {
        var pos = this.widget.model.getActualItem(dataIndex),
            list = [], dis, styles = '';

        if (this.widget.model.isLastItem(dataIndex)) {
            dis = 'hidden';
        } else {
            if (pos < 0) return;
            dis = this.getTableItemEnableState(pos);
            styles = this.getIndividualItemStyling(pos);
        }

        if (dis.length > 0) {
            list.push(dis);
        }

        if (styles.length > 0) {
            var style = styles.split(' ');
            list.push(style[1]);
            list.push(style[0]);
        }
        if (list.length > 0) {
            for (var i = 0; i < list.length; i += 1) {
                row.classList.add(list[i]);
                for (var k = 0; k < row.children.length; k += 1) {
                    row.children[k].classList.add(list[i]);
                }
            }
        }

        if (this.settings.selection && this.previouslySelectedItemNbr !== undefined && row.children[this.previouslySelectedItemNbr] !== undefined) {
            row.children[this.previouslySelectedItemNbr].classList.add('selected');
        }

        return pos;
    };

    /**
     * This function sets the classes ellipsis, wordWrap and multiLine
     * to the top element of the widget if these classes are sepcified.
     * @param {Object} renderer 
     */
    function _setClasses(renderer) {
        if (renderer.settings.ellipsis) {
            renderer.widget.elem.classList.add('ellipsis');
        }
        if (renderer.settings.wordWrap && renderer.settings.multiLine) {
            renderer.widget.elem.classList.add('wordWrap');
        } else if (renderer.settings.multiLine) {
            renderer.widget.elem.classList.add('mulitLine');
        }
    }

    // Delete Table
    function _clearTable(renderer) {
        if (renderer.table) {
            var headerWrapper = renderer.widget.container.find('.dataTables_scrollHead').detach();
            renderer.widget.container.append(headerWrapper);
            renderer.scrollHandler.removeScroller();
            renderer.table.destroy(true);
            renderer.table = undefined;
        }
        // eslint-disable-next-line no-unused-expressions
        renderer.tableBodyEl ? renderer.tableBodyEl.off().empty() : null;
    }

    function _updateFromEditHandler(renderer, index, size, totalSize) {
        var headerElements = renderer.tableHeaderEl.find('.headerElement');

        if (renderer.settings.dataOrientation === Enum.Direction.vertical) {
            var colElements = renderer.tableBodyEl.find('col');
            $(colElements[index]).width(size);
            $(headerElements[index]).width(size);
            renderer.tableHeaderEl.width(totalSize);
            renderer.tableBodyEl.width(totalSize);
        } else {
            var rowElements = renderer.tableBodyEl.find('tr');
            $(rowElements[index]).height(size);
            $(headerElements[index]).height(size);
            renderer.tableHeaderEl.height(totalSize);
            renderer.tableBodyEl.height(totalSize);
        }
    }

    function _resize(widget) {
        if (widget.settings.maxHeight > widget.settings.height) {
            var newHeight = Math.max(Math.min(widget.container.find('.dataTable').outerHeight() + widget.settings.headerBarSize, widget.settings.maxHeight), widget.settings.height);
            widget.el.height(newHeight);
        }
    }

    return Renderer;
});
