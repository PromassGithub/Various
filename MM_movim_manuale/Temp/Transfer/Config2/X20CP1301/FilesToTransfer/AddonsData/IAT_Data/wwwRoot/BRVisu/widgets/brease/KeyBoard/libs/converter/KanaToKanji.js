define([
    'widgets/brease/KeyBoard/libs/external/wanakana', 
    'widgets/brease/KeyBoard/libs/external/dictionaries/KanjiDic'
], function (wanakana, dictionary) {

    'use strict';
    
    /**
     * @class widgets.brease.KeyBoard.KanaToKanji
     * #Description
     * Converts kana input to kanji
     * @extends Class
     */
    var KanaToKanji = function () {
            this.pathDict = 'widgets/brease/KeyBoard/libs/external/dictionaries/KanjiDic';
        },
        p = KanaToKanji.prototype;

    /**
     * @method getCandidates
     * get suggestions for a specific value
     * @param {String} value
     */
    p.getCandidates = function (value) {
        this.candidateList = [];
        switch (_getValueType(value)) {
            case 0:// romaji 
                this.lookup(value).map(_addCandidateToList, this);
                break;
            case 1: //katakana or hiragana
                this.lookup(wanakana.toRomaji(value)).map(_addCandidateToList, this);
                break;
            default:

        }
        return this.candidateList;
    };
    /**
     * @method lookup
     * lookup a word in the dictionary
     * @param {String} value
     */
    p.lookup = function (value) {
        return _searchDictionary(value).filter(this.testEntry, value).map(this.extractData);
    };
    /**
     * @method testEntry
     * test a single entry in the dictionary if it should be displayed in
     * the candidate list
     * @param {Object} data
     */
    p.testEntry = function (data) {
        if (data) {
            return (_isOnyomi(this, data.onyomi) || _isKunyomi(this, data.kunyomi));
        }

    };
    /**
     * @method extractData
     * extract data from the dictionary entry to be displayed
     * in the candidate list
     * @param {Object} entry
     */
    p.extractData = function (entry) {
        return entry.kanji;
    };

    //p.getAlternatives = function (value) {
    //    arrStartValues = '',
    //    arrEndValues = '',
    //    self = this;
    //console.debug("lookup:", value);
    //value.split("").forEach(function (actValue, idx, arrValues) {
    //    arrStartValues = arrValues.slice(0, idx);
    //    arrEndValues = arrValues.slice(idx, arrValues.length);
    //    var startResults = [],
    //        endResults = [], finalResults = [];
    //    //console.debug('search', arrStartValues, arrEndValues);
    //    startResults = toSearchValue(arrStartValues, this);
    //    endResults = toSearchValue(arrEndValues, this);
    //    if (startResults.length > 0 && endResults.length > 0) {
    //        for (var i = 0; i < startResults.length; i++) {
    //            for (var j = 0; j < endResults.length; j++) {
    //                finalResults.push(startResults[i] + endResults[j]);
    //            }
    //        }
    //    } else if (startResults.length > 0 && endResults.length === 0) {
    //        finalResults = startResults.length > 0 ? startResults : [];
    //    }else {
    //        finalResults = endResults.length > 0 ? endResults : [];
    //    }
    //    console.debug('searchResults:',startResults,endResults, finalResults);
    //},this);
    //};
    function _isOnyomi(input, arrOnyomi) {
        if (arrOnyomi) {
            return arrOnyomi.some(_compareIdeographicChar, input);
        } else { return false; }
    }
    function _isKunyomi(input, arrKunyomi) {
        if (arrKunyomi) {
            return arrKunyomi.some(_compareIdeographicChar, input);
        } else { return false; }
    }
    function _compareIdeographicChar(phoneticChar) {
        var phoneticValue = wanakana.toRomaji(phoneticChar);
        if ((phoneticValue.search(this) === 0) && (phoneticValue.length <= this.length + 2)) {
            return true;
        } else {
            return false;
        }

    }
    function _searchDictionary() {
        return dictionary.dump;
    }
    function _addCandidateToList(Char) { this.candidateList.push(Char); }
    function _getValueType(value) {
        if (wanakana.isRomaji(value)) {
            return 0;
        } else if (wanakana.isKatakana(value) || wanakana.isHiragana(value)) {
            return 1;
        } else {
            return undefined;
        }
    }
    return new KanaToKanji();
});
