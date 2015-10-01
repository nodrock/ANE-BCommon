package sk.bpositive.bcommon {

import flash.events.EventDispatcher;
import flash.system.Capabilities;

public class BCommon extends EventDispatcher {

    public static const VERSION:String = "1.0.2";

    // --------------------------------------------------------------------------------------//
    //																						 //
    // 									   PUBLIC API										 //
    // 																						 //
    // --------------------------------------------------------------------------------------//

    /** BCommon is supported on iOS and Android devices. */
    public static function get isSupported():Boolean
    {
        return false;
    }

    public static function isIOS():Boolean
    {
        return Capabilities.version.indexOf("IOS") != -1;
    }

    public static function isAndroid():Boolean
    {
        return Capabilities.version.indexOf("AND") != -1;
    }

    public function BCommon()
    {
        if (!_instance) {

            _instance = this;
        }
    }

    public static function getInstance():BCommon
    {
        return _instance ? _instance : new BCommon();
    }

    public function init():void
    {
    }

    public function getIDFV():String
    {
        return null;
    }

    public function getAndroidId():String
    {
        return null;
    }

    public function getIDFA():BCommonIDFA
    {
        return null;
    }

    public function getAAID():void
    {
        var event:BCommonAAIDEvent = new BCommonAAIDEvent(BCommonAAIDEvent.AAID_FAILED, false, false);
        dispatchEvent(event);
    }

    public function setFlagKeepScreenOn(value:Boolean):void
    {
    }

    // --------------------------------------------------------------------------------------//
    //																						 //
    // 									 	PRIVATE API										 //
    // 																						 //
    // --------------------------------------------------------------------------------------//


    private static var _instance:BCommon;
    /**
     * If <code>true</code>, logs will be displayed at the ActionScript level.
     */
    public static var logEnabled:Boolean = false;
    /**
     * If <code>true</code>, logs will be displayed at the native level.
     * You must change this before first call of getInstance() to actually see logs in native.
     */
    public static var nativeLogEnabled:Boolean = false;

    /**
     * Do not use this method outside this class. It may be removed anytime!
     *
     * @param message
     */
    public function log(message:String):void
    {
        if (BCommon.logEnabled) {
            as3Log(message, "AS3");
        }
    }

    private function as3Log(message:String, prefix:String):void
    {
        trace("[BCommon][DEFAULT][" + prefix + "] " + message);
    }
}
}
