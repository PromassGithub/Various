/*global module,process*/
(function () {
    'use strict';

    var write = process.stdout.write.bind(process.stdout);

    function log(str) {
        write(str + '\n', 'utf8');
    }

    module.exports = {

        init: function init() {

            this.startTime = Date.now();
            log('[' + this.startTime + ']start');

            this.originalExit = process.exit;
            process.exit = this.exit.bind(this);
        },

        exit: function exit(exitCode) {

            this.endTime = Date.now();
            log('[' + this.endTime + ']exit, code=' + exitCode + '\ntime:' + (this.endTime - this.startTime) + 'ms');

            process.exit = this.originalExit;
            this.originalExit(exitCode);
        }

    };

})();
