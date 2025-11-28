define([
    'system/widgets/KeyBoard/libs/external/dictionaries',
    'brease/core/Types'
], function (dictionary, Types) {

    'use strict';
    
    /**
     * @class widgets.brease.KeyBoard.ConverterZhCHS
     * #Description
     * Converts phonetic input to chinese characters
     * @extends Object
     */
    var ConverterZhCHS = function () { },
        p = ConverterZhCHS.prototype,
        candidateList = [],
        pattern;
    /**
    * @method init
    * @return {Promise}
    */
    p.init = function () {
        return dictionary.load('zh-cn');
    };
    /**
     * @method getCandidates
     * get suggestions for a specific value
     * @param {String} value
     */
    p.getCandidates = function (value) {
        candidateList = [];
        if (value.length > 0) {
            // requirement candidate list should only contain elements matching the pinyin value exactly
            pattern = new RegExp('^' + value + '$', 'i');
            this.lookup(value).map(_addCandidateToList, this);
        }
        return candidateList;
    };
    /**
     * @method lookup
     * lookup a word in the dictionary
     * @param {String} value
     */
    p.lookup = function (value) {
        return _searchDictionary(value).filter(this.testEntry, value).sort(function (a, b) {
            var fa = Types.parseValue(a.freq, 'Integer', { default: dictionary.MAX_FREQUENCY, min: dictionary.MIN_FREQUENCY, max: dictionary.MAX_FREQUENCY }),
                fb = Types.parseValue(b.freq, 'Integer', { default: dictionary.MAX_FREQUENCY, min: dictionary.MIN_FREQUENCY, max: dictionary.MAX_FREQUENCY });
            return fa - fb;
        }).map(this.extractData);
    };
    /**
     * @method testEntry
     * test a single entry in the dictionary if it should be displayed in
     * @param {Object} entry
     * @param {String} entry.can candidate
     * @param {String} entry.com composed value
     */
    p.testEntry = function (entry) {
        if (entry) {
            // requirement candidate list should only contain elements matching the pinyin (composed) value exactly
            return pattern.test(entry.com) === true;
        }

    };
    /**
     * @method extractData
     * extract data from the dictionary entry to be displayed
     * in the candidate list
     * @param {Object} entry
     * @param {String} entry.can candidate
     * @param {String} entry.com composed value
     */
    p.extractData = function (entry) {
        return entry.can;
    };

    function _searchDictionary() {
        return dictionary.get('zh-cn');
    }
    function _addCandidateToList(Char) {
        // prevent duplicates
        if (!candidateList.includes(Char)) {
            candidateList.push(Char);
        }
    }

    return new ConverterZhCHS();
});
