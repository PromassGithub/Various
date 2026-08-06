/* eslint-disable no-new-wrappers,no-new-object */
define(['brease/core/Utils'], function (Utils) {

    'use strict';

    describe('jasmine', function () {
        
        describe('#matcher-toBeTrue', function () {
            
            // toBeTrue passes for actual===true
            it('toBeTrue', function () {
                expect(true).toBeTrue();
                var v = 7;
                expect(v === 7).toBeTrue();
                expect(Utils.isString('a')).toBeTrue();
                expect(!!{}).toBeTrue(); //casting {} to bool
            });
            it('not.toBeTrue', function () {
                expect(1).not.toBeTrue();
                expect(new Boolean(true)).not.toBeTrue();
                expect(undefined).not.toBeTrue();
                expect(null).not.toBeTrue();
                expect(false).not.toBeTrue();
                expect(0).not.toBeTrue();
                expect({}).not.toBeTrue();
                expect(!{}).not.toBeTrue();
                expect('').not.toBeTrue();
                expect('a').not.toBeTrue();
            });
        });

        describe('#matcher-toBeTruthy', function () {
            // toBeTruthy passes for !!actual===true
            it('toBeTruthy', function () {
                expect(true).toBeTruthy();
                expect(new Boolean(true)).toBeTruthy();
                expect(1).toBeTruthy(); // number <> 0
                expect({}).toBeTruthy(); // any object !=null and !=undefined
                expect(new Object(null)).toBeTruthy();
                expect(new Date()).toBeTruthy();
                expect('a').toBeTruthy(); // string, not empty 
            });
            it('not.toBeTruthy', function () {
                expect(undefined).not.toBeTruthy();
                expect(null).not.toBeTruthy();
                expect(false).not.toBeTruthy();
                expect(0).not.toBeTruthy();
                expect('').not.toBeTruthy();
            });
        });

        describe('some special matchers', function () {
            it('0 not equal -0', function () {
                expect(-0).not.toEqual(0);
            });

            it('null not equal undefined', function () {
                expect(null).not.toEqual(undefined);
            });
        });

        describe('object comparison', function () {
            it('object comparison', function () {
                expect({ a: 1, b: 2 }).not.toEqual({ a: 1, b: 2, c: undefined });
                expect({ a: 1, b: 2 }).toEqual({ a: 1, b: 2 });
                expect({ a: 1, b: 2 }).not.toBe({ a: 1, b: 2 });
            });

            it('toEqual for objects considers the constructor', function () {

                var BaseClass = function () {},
                    obj1 = {},
                    obj2 = new BaseClass();

                obj1.a = obj2.a = 1;
                obj1.b = obj2.b = 2;

                expect(obj1).not.toEqual(obj2);
            });
        });

    });
});
