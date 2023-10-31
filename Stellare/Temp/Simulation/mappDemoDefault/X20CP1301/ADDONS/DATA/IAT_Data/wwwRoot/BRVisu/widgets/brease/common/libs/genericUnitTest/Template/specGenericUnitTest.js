/*global m*/
define([
    'widgets/brease/common/libs/genericUnitTest/mSpecUnitTestGeneric',
    'widgets/brease/common/libs/genericUnitTest/Template/cSpecGenericUnitTest',
    'widgets/brease/common/libs/Test/Jasmine-moduleTest'
], function (
    mSpecUnitTestGeneric, cSpecGenericUnitTest
) {
    'use strict';

    //generic Unit Test
    m.describe(cSpecGenericUnitTest.run, 'UnitTest for: >>Template.js<<', mSpecUnitTestGeneric.suite, [cSpecGenericUnitTest]);

});
