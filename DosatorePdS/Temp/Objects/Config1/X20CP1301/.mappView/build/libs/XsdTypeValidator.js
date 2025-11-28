(function () {

    'use strict';

    let path = require('path');
    let grunt = require('grunt');
    let basePath = path.resolve(__dirname, '../');
    let typesCheckSchemaPath = path.resolve(basePath, 'schemes/TypesCheck.xsd');
    let XMLLint = require(path.resolve(basePath, 'iat/XMLLint'));

    class Validator {
        constructor() {
            this.collected = [];
        }

        /**
         * 
         * @param {String} type XSD type (i.e ImagePath)
         * @param {String|Number} value Value to validate
         * @param {Object} context Variables provided when validate fails
         */
        push(type, value, context) {
            this.collected.push({ type, value, context });
        }

        /**
         * Validate all pushed values at once.
         * @returns true if ok, context object of value which fails, object with msg property if line number can not be parsed
         */
        validate() {
            let xml = `<?xml version="1.0"?><t:TCS xmlns:t="http://www.br-automation.com/iat2021/typeDefinition/v1">`;
            for (let i = 0; i < this.collected.length; ++i) {
                let typeCheck = `<TypeCheck value_${this.collected[i].type}="${this.collected[i].value}" />\n`;
                xml += typeCheck;
            }
            if (this.collected.length > 0) {
                xml += '</t:TCS>';
                let result = XMLLint.check(grunt, typesCheckSchemaPath, xml, { fail: false, debug: false, out: false }, basePath);
                if (result.status !== 0) {
                    let lineNumber = result.msg.toString().slice(0, 10).split(':')[1];
                    if (!lineNumber) {
                        this.collected.length = 0;
                        return { msg: result.msg.toString() };
                    }
                    let context = this.collected[lineNumber - 1].context;
                    this.collected.length = 0;
                    return context;
                }
            }
            return true;
        }
    }

    module.exports = {
        Validator: Validator
    };
})();
