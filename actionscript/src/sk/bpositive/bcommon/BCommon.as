package sk.bpositive.bcommon {

import flash.events.EventDispatcher;
import flash.events.StatusEvent;
import flash.external.ExtensionContext;
import flash.system.Capabilities;

public class BCommon extends EventDispatcher {

    public static const VERSION:String = "1.0.1";

    private var _initialized:Boolean;

    // --------------------------------------------------------------------------------------//
    //																						 //
    // 									   PUBLIC API										 //
    // 																						 //
    // --------------------------------------------------------------------------------------//

    /** BCommon is supported on iOS and Android devices. */
    public static function get isSupported():Boolean
    {
        return isIOS() || isAndroid();
    }

    private static function isIOS():Boolean
    {
        return Capabilities.version.indexOf("IOS") != -1;
    }

    private static function isAndroid():Boolean
    {
        return Capabilities.version.indexOf("AND") != -1;
    }

    public function BCommon()
    {
        if(!isSupported){
            throw new Error("This extension is supported only on iOS and Android!");
        }
        if (!_instance) {
            _context = ExtensionContext.createExtensionContext(EXTENSION_ID, null);
            if (!_context) {
                log("ERROR - Extension context is null. Please check if extension.xml is setup correctly.");
                return;
            }

            _instance = this;
        }
        else {
            throw Error("This is a singleton, use getInstance(), do not call the constructor directly.");
        }
    }

    public static function getInstance():BCommon
    {
        if(!isSupported){
            trace("This extension is supported only on iOS and Android!");
            return null;
        }
        return _instance ? _instance : new BCommon();
    }

    public function init():void
    {
        if (isSupported && _context != null) {

            if(!_initialized){
                _context.addEventListener(StatusEvent.STATUS, onStatus);

                _context.call("setNativeLogEnabled", BCommon.nativeLogEnabled);
                log("ANE BCommon version: " + VERSION);

                _initialized = true;
            } else {
                log("Already initialized!");
            }
        } else {

            log("Can't initialize extension! Unsupported platform or context couldn't be created!")
        }
    }

    public function getIDFV():String
    {
        if (_initialized) {

            if(isIOS()){

                return _context.call("getIDFV") as String;
            }else{

                log("This method is supported only on iOS!");
                return null;
            }
        } else {

            log("You must call init() before any other method!");
            return null;
        }
    }

    public function getIDFA():BCommonIDFA
    {
        if (_initialized) {

            if(isIOS()){

                var id:String = _context.call("getIDFA") as String;
                var trackingEnabled:Boolean = _context.call("getIDFATrackingEnabled") as Boolean;
                return BCommonIDFA.createFrom(id, trackingEnabled);
            }else{

                log("This method is supported only on iOS!");
                return null;
            }
        } else {

            log("You must call init() before any other method!");
            return null;
        }
    }

    public function getAAID():void
    {
        if (_initialized) {

            if(isAndroid()){

                _context.call("getAAID");
            }else{

                log("This method is supported only on Android!");
            }
        } else {

            log("You must call init() before any other method!");
        }
    }

    public function setFlagKeepScreenOn(value:Boolean):void
    {
        if(_initialized) {

            if (isAndroid()) {

                _context.call("flagKeepScreenOn", value);
            }else{

                log("This method is supported only on Android!");
            }
        } else {

            log("You must call init() before any other method!");
        }
    }

    // --------------------------------------------------------------------------------------//
    //																						 //
    // 									 	PRIVATE API										 //
    // 																						 //
    // --------------------------------------------------------------------------------------//

    private static const EXTENSION_ID:String = "sk.bpositive.BCommon";

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

    private var _context:ExtensionContext;
    private var _requestCallbacks:Object = {};

    private function getNewCallbackName(callback:Function):String
    {
        // Generate callback name based on current time
        var date:Date = new Date();
        var callbackName:String = date.time.toString();

        // Clean up old callback if the name already exists
        if (_requestCallbacks.hasOwnProperty(callbackName)) {
            delete _requestCallbacks[callbackName]
        }

        // Save new callback under this name
        _requestCallbacks[callbackName] = callback;

        return callbackName;
    }

    private function onStatus(event:StatusEvent):void
    {
        var dataArr:Array;
        var callbackName:String;
        var callback:Function;
        var data:Object;

        if (event.code == "LOGGING") // Simple log message
        {
            // NOTE: logs from native should go only to as3 log
            as3Log(event.level, "NATIVE");
        }
        else if(event.code == "NOTIFICATION")
        {
            try {
                data = JSON.parse(event.level);

                if(data.hasOwnProperty("type")){

                    var type:String = data["type"];
                    if(type == "MEMORY_WARNING"){

                        log("NOTIFICATION: MEMORY_WARNING");
                        if(hasEventListener(BCommonEvent.MEMORY_WARNING)){

                            dispatchEvent(new BCommonEvent(BCommonEvent.MEMORY_WARNING, false, false));
                        }
                    }
                }
            }
            catch (e:Error) {
                log("ERROR - INVALID NOTIFICATION RECEIVED! raw:" + event.level + " error:" + e);
            }
        }
        else if(event.code.indexOf("AAID") != 0)
        {
            dataArr = event.code.split("_");
            var aaidEvent:BCommonAAIDEvent;
            if(dataArr[1] == "COMPLETED"){

                if(hasEventListener(BCommonAAIDEvent.AAID_COMPLETED)){

                    aaidEvent = new BCommonAAIDEvent(BCommonAAIDEvent.AAID_COMPLETED, false, false);
                    aaidEvent.aaid = BCommonAAID.createFromJSON(event.level);
                    dispatchEvent(aaidEvent);
                }
            }else if(dataArr[1] == "FAILED"){

                if(hasEventListener(BCommonAAIDEvent.AAID_FAILED)){

                    aaidEvent = new BCommonAAIDEvent(BCommonAAIDEvent.AAID_FAILED, false, false);
                    // TODO: error
                    dispatchEvent(aaidEvent);
                }
            }
        }
        else // Default case: we check for a registered callback associated with the event code
        {
            if (_requestCallbacks.hasOwnProperty(event.code)) {
                callback = _requestCallbacks[event.code];

                if (callback != null) {
                    try {
                        data = JSON.parse(event.level);
                    }
                    catch (e:Error) {
                        log("ERROR - " + e);
                    }

                    callback(data);

                    delete _requestCallbacks[event.code];
                }
            }
        }
    }

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
        if (BCommon.nativeLogEnabled) {
            nativeLog(message);
        }
    }

    private function as3Log(message:String, prefix:String):void
    {
        trace("[BCommon][" + prefix + "] " + message);
    }

    private function nativeLog(message:String):void
    {
        if (_context != null) {

            _context.call('nativeLog', message);
        }
    }
}
}
