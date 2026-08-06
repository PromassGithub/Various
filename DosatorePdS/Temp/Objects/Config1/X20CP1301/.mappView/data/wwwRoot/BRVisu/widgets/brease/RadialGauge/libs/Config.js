define(function () {

    'use strict';

    /**
    * @class widgets.brease.RadialGauge.Config
    * @extends core.javascript.Object
    * @override widgets.brease.RadialGauge
    */

    /**
     * @cfg {brease.config.MeasurementSystemFormat} format={'metric':{ 'decimalPlaces' : 1, 'minimumIntegerDigits' : 1 }, 'imperial' :{ 'decimalPlaces' : 1, 'minimumIntegerDigits' : 1 }, 'imperial-us' :{ 'decimalPlaces' : 1, 'minimumIntegerDigits' : 1 }}
     * @iatStudioExposed
     * @bindable
     * @iatCategory Appearance
     * NumberFormat for every measurement system.
     */

    /**
     * @cfg {Number} minValue=0
     * @iatStudioExposed
     * @iatCategory Behavior
     * Minimum value for gauge pointer to display.  
     */

    /**
     * @cfg {Number} maxValue=100
     * @iatStudioExposed
     * @iatCategory Behavior
     * Maximum value for gauge pointer to display.  
     */

    /**
     * @cfg {UInteger} majorTicks=5
     * @iatStudioExposed
     * @iatCategory Appearance
     * Number of major Ticks.
     */

    /**
     * @cfg {UInteger} minorTicks=1
     * @iatStudioExposed
     * @iatCategory Appearance
     * Number of minor Ticks.
     */

    /**
     * @cfg {UNumber} startAngle=225
     * @iatStudioExposed
     * @iatCategory Appearance
     * Start angle of the whole scale in degree.
     */

    /**
     * @cfg {brease.datatype.Node} node=''
     * @bindable
     * @iatStudioExposed
     * @iatCategory Data
     * Display value.
     */

    /**
     * @cfg {Number} value=0
     * @bindable
     * @iatStudioExposed
     * @nodeRefId node
     * @iatCategory Data
     * Display value.
     */

    /**
     * @cfg {brease.datatype.Node} scaleArea0Node=''
     * @bindable
     * @iatStudioExposed
     * @iatCategory Data
     * Start of first scale area. A scale area is shown as a background color behind the minor 
     * and major ticks. Include unit and limits.
     */

    /**
     * @cfg {Number} scaleArea0=0
     * @bindable
     * @iatStudioExposed
     * @nodeRefId scaleArea0Node
     * @iatCategory Data
     * Start of first scale area. A scale area is shown as a background color behind the minor 
     * and major ticks. Defined in percent of the whole scale.
     */

    /**
     * @cfg {brease.datatype.Node} scaleArea1Node=''
     * @bindable
     * @iatStudioExposed
     * @iatCategory Data
     * End of first scale area. A scale area is shown as a background color behind the minor and 
     * major ticks. This value is also used as start of the second scale area. Defined in percent of 
     * the whole scale.
     */

    /**
     * @cfg {Number} scaleArea1=20 
     * @bindable
     * @iatStudioExposed
     * @nodeRefId scaleArea1Node
     * @iatCategory Data
     * End of first scale area. A scale area is shown as a background color behind the minor and 
     * major ticks. This value is also used as start of the second scale area. Defined in percent of 
     * the whole scale.
     */

    /**
     * @cfg {brease.datatype.Node} scaleArea2Node=''
     * @bindable
     * @iatStudioExposed
     * @iatCategory Data
     * End of second scale area. A scale area is shown as a background color behind the minor 
     * and major ticks. This value is also used as start of the third scale area. Defined in percent 
     * of the whole scale.
     */
    
    /**
     * @cfg {Number} scaleArea2=40 
     * @bindable
     * @iatStudioExposed
     * @nodeRefId scaleArea2Node
     * @iatCategory Data
     * End of second scale area. A scale area is shown as a background color behind the minor 
     * and major ticks. This value is also used as start of the third scale area. Defined in percent 
     * of the whole scale.
     */

    /**
     * @cfg {brease.datatype.Node} scaleArea3Node=''
     * @bindable
     * @iatStudioExposed
     * @iatCategory Data
     * End of third scale area. A scale area is shown as a background color behind the minor and 
     * major ticks. This value is also used as start of the fourth scale area. Defined in percent of 
     * the whole scale. 
     */

    /**
     * @cfg {Number} scaleArea3=60
     * @bindable
     * @iatStudioExposed
     * @nodeRefId scaleArea3Node
     * @iatCategory Data
     * End of third scale area. A scale area is shown as a background color behind the minor and 
     * major ticks. This value is also used as start of the fourth scale area. Defined in percent of 
     * the whole scale.   
     */

    /**
     * @cfg {brease.datatype.Node} scaleArea4Node=''
     * @bindable
     * @iatStudioExposed
     * @iatCategory Data
     * End of fourth scale area. A scale area is shown as a background color behind the minor 
     * and major ticks. This value is also used as start of the fifth scale area. Defined in percent 
     * of the whole scale. 
     */

    /**
     * @cfg {Number} scaleArea4=80
     * @bindable
     * @iatStudioExposed
     * @nodeRefId scaleArea4Node
     * @iatCategory Data
     * End of fourth scale area. A scale area is shown as a background color behind the minor 
     * and major ticks. This value is also used as start of the fifth scale area. Defined in percent 
     * of the whole scale.  
     */

    /**
     * @cfg {brease.datatype.Node} scaleArea5Node=''
     * @bindable
     * @iatStudioExposed
     * @iatCategory Data
     * End of fifth scale area. A scale area is shown as a background color behind the minor and 
     * major ticks. Defined in percent of the whole scale.  
     */

    /**
     * @cfg {Number} scaleArea5=100
     * @bindable
     * @iatStudioExposed
     * @nodeRefId scaleArea5Node
     * @iatCategory Data
     * End of fifth scale area. A scale area is shown as a background color behind the minor and 
     * major ticks. Defined in percent of the whole scale.   
     */

    /**
     * @cfg {String} text=''
     * @localizable
     * @iatStudioExposed
     * @iatCategory Appearance
     * Text displayed next to the unit. There is a fixed maximum size and if the text exceeds the 
     * limit it will simply be cut off. 
     */

    /**
     * @cfg {Boolean} showUnit=false
     * @iatStudioExposed
     * @iatCategory Behavior
     * Determines if the unit is displayed.  
     */

    /**
     * @cfg {brease.config.MeasurementSystemUnit} unit=''
     * @iatStudioExposed
     * @bindable
     * @iatCategory Appearance
     * Unit code for every measurement system.  
     */

    /**
     * @cfg {Boolean} scaleAreaInPercent=true
     * @iatStudioExposed
     * @iatCategory Behavior
     * If true, the values set in the scale areas are interpreted in percent (from 0 to 100%).
     * If false, the values are not intepreted as precent, so they can be set in the range between minValue and maxValue.
     */

    /**
     * @cfg {UNumber} range=270
     * @iatStudioExposed
     * @iatCategory Behavior
     * Sets the range of the Needle 
     */
    
    /**
     * @cfg {UInteger} transitionTime=500
     * @iatStudioExposed
     * @iatCategory Behavior
     * Sets the animation Duration of the Needle
     */

    return {
        value: 0,
        format: { default: { decimalPlaces: 1, minimumIntegerDigits: 1 } },
        showUnit: false,
        minValue: 0,
        maxValue: 100,
        majorTicks: 5,
        minorTicks: 1,
        startAngle: 225,
        scaleArea0: 0,
        scaleArea1: 20,
        scaleArea2: 40,
        scaleArea3: 60,
        scaleArea4: 80,
        scaleArea5: 100,
        height: 200,
        width: 200,
        scaleAreaInPercent: true,
        range: 270,
        transitionTime: 500
    };

});
