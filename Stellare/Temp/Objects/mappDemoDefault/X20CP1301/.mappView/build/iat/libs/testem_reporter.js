/*global module,process,__dirname*/
(function () {
    'use strict';

    /* custom reporter for xunit
    */
    var path = require('path'),
        fs = require('fs'),
        grunt = require('grunt'),
        reporterUtils = require(path.resolve(__dirname, 'utils_reporter'));

    function xmlName(name) {
        name = name.replace(/&/g, '&amp;');
        name = name.replace(/\n/g, '\\n');
        name = name.replace(/"/g, '&quot;');
        return name;
    }

    function createReport(objReport) {
        var xml = '<?xml version="1.0" encoding="UTF-8"?><testsuites>';
        for (var suiteName in objReport) {
            var suite = objReport[suiteName];
            xml += '<testsuite name="' + xmlName(suiteName) + '" errors="0" tests="' + suite.tests + '" failures="' + suite.failures + '" timestamp="' + suite.timestamp + '">';
            suite.testcases.forEach(function (testcase) {
                xml += '<testcase classname="' + xmlName(testcase.classname) + '" name="' + xmlName(testcase.name) + '" time="' + ((testcase.time !== undefined) ? testcase.time : '0') + '">';
                if (testcase.error) {
                    xml += '<failure><![CDATA[' + testcase.error.message + ']]></failure>';
                }
                xml += '</testcase>';
            });
            xml += '</testsuite>';
        }
        return xml + '</testsuites>';
    }

    function Reporter(reportDir, resultPath, coveragePath) {
        
        var resultFile = resultPath.substring(resultPath.lastIndexOf('/') + 1);
        this.resultDir = path.resolve(reportDir, resultPath.substring(0, resultPath.lastIndexOf('/')));
        this.jasmineDir = path.resolve(reportDir, resultPath.substring(0, resultPath.indexOf('/')));
        this.resultFile = path.resolve(this.resultDir, resultFile);

        var coverageFile = coveragePath.substring(coveragePath.lastIndexOf('/') + 1);
        this.coverageDir = path.resolve(reportDir, coveragePath.substring(0, coveragePath.indexOf(coverageFile)));
        this.coverageFile = path.resolve(reportDir, coveragePath);

        this.out = process.stdout;

        //this.out.write('resultDir:' + this.resultDir + '\n');
        //this.out.write('jasmineDir:' + this.jasmineDir + '\n');
        //this.out.write('resultFile:' + this.resultFile + '\n');
        //this.out.write('coverageDir:' + this.coverageDir + '\n');
        //this.out.write('coverageFile:' + this.coverageFile + '\n');

        this.total = 0;
        this.passed = 0;
        this.objReport = {};
        this.metadata = {};
        this.failures = [];
    }

    Reporter.prototype = {
        report: function report(prefix, data) {
            if (data !== undefined) {
                if (!this.start) {
                    this.start = Date.now();
                }
                this.total += 1;
                var status = data.passed ? 'ok' : 'failed';
                var strOut = ((data.name && typeof data.name.trim === 'function') ? data.name.trim().replace(/\|/g, '') : '') + '\n';
                strOut = strOut.replace(/ +/g, ' ');
                if (data.passed) {
                    this.passed += 1;
                } else {
                    this.failures.push(strOut + ((data.error) ? data.error.message : 'fail without error') + '\n'); 
                }
                this.out.write(prefix + ' | ' + status + ' | ' + strOut);
                reporterUtils.testcase(this.objReport, data.name, data.passed, data.error);
            }
        },
        finish: function finish() {

            if (!fs.existsSync(this.jasmineDir)) {
                fs.mkdirSync(this.jasmineDir);
            }
            if (!fs.existsSync(this.resultDir)) {
                fs.mkdirSync(this.resultDir);
            }
            fs.writeFileSync(this.resultFile + '.xml', createReport(this.objReport));
            if (this.metadata.jsonReport) {
                fs.writeFileSync(this.resultFile + '.json', JSON.stringify(this.objReport));
            }
            if (this.metadata.userAgent) {
                this.out.write('userAgent:' + this.metadata.userAgent + '\n');
                this.out.write('window:' + this.metadata.innerWidth + 'x' + this.metadata.innerHeight + '\n');
                this.out.write('url:' + this.metadata.url + '\n');
            }
            this.out.write(this.passed + ' of ' + this.total + ' tests passed\n');
            this.out.write('finished in ' + ((Date.now() - this.start) / 1000) + 's\n');
            if (this.passed < this.total) {
                if (grunt.config.get('isWidgetFactory') === false) {
                    grunt.fail.warn('failures:' + (this.total - this.passed) + '\n' + this.failures.join(''));
                } else {
                    this.out.write('failures:' + (this.total - this.passed) + '\n' + this.failures.join('')); 
                } 
            }
        },
        reportMetadata: function reportMetadata(tag, metadata) {
            if (tag === 'mappView') {
                this.metadata = metadata;
            }
            if (tag === 'log') {
                this.out.write('log:' + metadata);
            }
            if (tag === 'coverage') {
                this.out.write('coverage received\n');
                if (!fs.existsSync(this.coverageDir)) {
                    fs.mkdirSync(this.coverageDir);
                }
                fs.writeFile(this.coverageFile, metadata, (err) => {
                    if (err) throw err;
                });
            }
        }
    };
  
    module.exports = Reporter;
})();
