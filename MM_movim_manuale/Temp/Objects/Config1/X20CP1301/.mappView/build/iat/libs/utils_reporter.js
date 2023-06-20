/*global module*/
(function () {

    'use strict';

    var Utils = {
        arName: function arName(name) {
            if (typeof name.split === 'function') {
                var splitName = name.split(' | ');
                var arName = splitName.map(function (item) {
                    var str = item.trim();
                    if (str.indexOf('/') === 0) {
                        str = str.substring(1);
                    }
                    str = str.trim();
                    return str;
                });
                return arName; 
            } else {
                return [''];
            }
        },
        testcase: function testcase(objReport, name, passed, error) {
            var arName = Utils.arName(name),
                caseName = arName.pop(),
                suiteName = arName.join(' / ');
    
            if (caseName.lastIndexOf('.') === caseName.length - 1) {
                caseName = caseName.substring(0, caseName.length - 1);
            }
            if (!objReport[suiteName]) {
                objReport[suiteName] = {
                    timestamp: Date.now(),
                    errors: 0,
                    tests: 0,
                    failures: 0,
                    testcases: []
                };
            }
            var suite = objReport[suiteName];
            var testcase = {
                classname: suiteName,
                name: caseName
            };
            if (passed !== true) {
                testcase.error = {
                    message: (error !== undefined) ? error.message : '',
                    stack: (error !== undefined) ? error.stack : ''
                };
            }
            suite.testcases.push(testcase);
            suite.tests += 1;
            suite.failures += (passed === true) ? 0 : 1;
        }
    };

    module.exports = Utils;

})();
