package sk.bpositive.bcommon {

import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;
import flash.events.StatusEvent;
import flash.system.Capabilities;

import sk.bpositive.bcommon.common.ExtensionWrapper;

public class BCommon extends EventDispatcher {

    private static const INVOKE_REASON_NOTIFICATION:String = "notification";
    public static const NOTIFICATION_ACTION_START:String = "start";
    private static const IOS_NOTIFICATION_MESSAGE_ID:String = "gcm.message_id";
    private static const IOS_NOTIFICATION_REF:String = "ref";
    
    public static const VERSION:String = "1.1.0";
    public static const EXTENSION_ID:String = "sk.bpositive.BCommon";
    private var m_extensionContext:ExtensionWrapper;

    private var m_logEnabled:Boolean = false;
    private var m_nativeLogEnabled:Boolean = false;

    private var m_iosNotificationData:NotificationData;

    public static function isIOS():Boolean
    {
        return Capabilities.version.indexOf("IOS") != -1;
    }

    public static function isAndroid():Boolean
    {
        return Capabilities.version.indexOf("AND") != -1;
    }

    private static var _instance:BCommon;

    public static function getInstance():BCommon
    {
        if (_instance == null) {
            _instance = new BCommon();
        }
        return _instance;
    }

    public function BCommon(target:IEventDispatcher = null)
    {
        super(target);

        m_extensionContext = new ExtensionWrapper(EXTENSION_ID);
        m_extensionContext.addEventListener(StatusEvent.STATUS, onStatus);
    }

    /**
     * Determines if the BCommon is supported on a platform
     */
    public function get isSupported():Boolean
    {
        return m_extensionContext.isSupported;
    }

    public function setLogEnabled(as3Log:Boolean, nativeLog:Boolean):void
    {
        m_logEnabled = as3Log;
        m_nativeLogEnabled = nativeLog;
        m_extensionContext.call(NativeMethods.SET_NATIVE_LOG_ENABLED, nativeLog);
    }

    public function getLanguageCode():String
    {
        return m_extensionContext.call(NativeMethods.GET_LANGUAGE_CODE) as String;
    }

    public function getIDFV():String
    {
        if (isIOS()) {

            return m_extensionContext.call(NativeMethods.GET_IDFV) as String;
        } else {
            return null;
        }
    }

    public function getAndroidId():String
    {
        if (isAndroid()) {

            return m_extensionContext.call(NativeMethods.GET_ANDROID_ID) as String;
        } else {
            return null;
        }
    }

    public function getIDFA():BCommonIDFA
    {
        if (isIOS()) {

            var id:String = m_extensionContext.call(NativeMethods.GET_IDFA) as String;
            var trackingEnabled:Boolean = m_extensionContext.call(NativeMethods.GET_IDFA_TRACKING_ENABLED) as Boolean;
            return BCommonIDFA.createFrom(id, trackingEnabled);
        } else {
            return null;
        }
    }

    public function getAAID():void
    {
        if (isAndroid()) {

            m_extensionContext.call(NativeMethods.GET_AAID);
        }
    }

    public function setFlagKeepScreenOn(value:Boolean):void
    {
        if (isAndroid()) {

            m_extensionContext.call(NativeMethods.FLAG_KEEP_SCREEN_ON, value);
        }
    }

    /**
     * @deprecated Use only with old GCM.
     * @param senderId
     */
    public function registerGCM(senderId:String):void
    {
        if (isAndroid()) {

            m_extensionContext.call(NativeMethods.REGISTER_GCM, senderId);
        }
    }

    public function canOpenSettings():Boolean
    {
        if (isIOS()) {

            var canOpenSettings:Boolean = m_extensionContext.call(NativeMethods.CAN_OPEN_SETTINGS) as Boolean;
            return canOpenSettings;
        } else {
            return null;
        }
    }

    public function openSettings():void
    {
        if (isIOS()) {

            m_extensionContext.call(NativeMethods.OPEN_SETTINGS);
        }
    }

    public function isRemoteNotificationsEnabled():Boolean
    {
        if (isIOS()) {

            var remoteNotificationsEnabled:Boolean = m_extensionContext.call(NativeMethods.IS_REMOTE_NOTIFICATION_ENABLED) as Boolean;
            return remoteNotificationsEnabled;
        } else {
            return false;
        }
    }

    public function getInstallerPackageName():String
    {
        if (isAndroid()) {

            return m_extensionContext.call(NativeMethods.GET_INSTALLER_PACKAGE_NAME) as String;
        } else {
            return null;
        }
    }

    public function immersiveMode(isSticky:Boolean = true):Boolean
    {
        if (isAndroid()) {

            return m_extensionContext.call(NativeMethods.IMMERSIVE_MODE, isSticky) as Boolean;
        } else {
            return null;
        }
    }

    /**
     * Process invoke events data.
     * Note: This method must be called from InvokeEvent.INVOKE event handler on iOS for
     * notification to work properly.
     *
     * <code>
     *     ...
     *
     *     NativeApplication.application.addEventListener(InvokeEvent.INVOKE, onInvoke);
     *
     *     ...
     *
     *     private function onInvoke(event:InvokeEvent):void
     *     {
     *          BCommon.getInstance().processInvokeEvent(event.reason, event.arguments);
     *     }
     * </code>
     *
     * @param reason InvokeEvent.INVOKE reason param
     * @param arguments InvokeEvent.INVOKE arguments param
     */
    public function processInvokeEvent(reason:String, arguments:Array):void
    {
        log("processInvokeEvent reason: " + reason + ", args: " + JSON.stringify(arguments));
        if (reason == INVOKE_REASON_NOTIFICATION && arguments.length > 0) {
            var data:Object = arguments[0];
            var notifData:NotificationData = new NotificationData();
            notifData.action = NOTIFICATION_ACTION_START;
            notifData.messageId = data.hasOwnProperty(IOS_NOTIFICATION_MESSAGE_ID) ?
                    data[IOS_NOTIFICATION_MESSAGE_ID] : null;
            notifData.ref = data.hasOwnProperty(IOS_NOTIFICATION_REF) ?
                    data[IOS_NOTIFICATION_REF] : null;
            notifData.actionTime = String((new Date()).time);
            m_iosNotificationData = notifData;
        }
    }

    /**
     * Inits firebase. 
     * Note: Must be called on iOS.
     */
    public function initFirebase():void
    {
        m_extensionContext.call(NativeMethods.INIT_FIREBASE);
    }

    /**
     * Gets FCM token if it has been already generated. Otherwise returns null.
     * Note: Always remember to listen to BCommonEvent.FCM_TOKEN for token refreshes.
     * @return FCM token
     */
    public function getFCMToken():String
    {
        return m_extensionContext.call(NativeMethods.GET_FCM_TOKEN) as String;
    }

    /**
     * Registers handlers for remote notifications.
     * Note: Must be called on iOS.
     */
    public function registerForRemoteNotifications():void
    {
        if(isIOS()){
            m_extensionContext.call(NativeMethods.REGISTER_FOR_REMOTE_NOTIFICATION);
        }
    }

    /**
     * Gets data about notification which started this app.
     * @return Last notification data
     */
    public function getNotificationData():NotificationData
    {
        if(isAndroid()){
            var jsonData:String = m_extensionContext.call(NativeMethods.GET_NOTIFICATION_DATA) as String;
            return NotificationData.initByJson(jsonData);
        } else {
            return m_iosNotificationData;
        }
    }

    public function call(functionName:String, ... args):Object
    {
        return m_extensionContext.call.apply(m_extensionContext, [functionName].concat(args));
    }

    // --------------------------------------------------------------------------------------//
    //																						 //
    // 									 	PRIVATE API										 //
    // 																						 //
    // --------------------------------------------------------------------------------------//

    private function onStatus(event:StatusEvent):void
    {
        trace(event.code, event.level);

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
        else if(event.code.indexOf("AAID") != -1)
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
                    aaidEvent.error = BCommonErrorObject.createFromJSON(event.level);
                    dispatchEvent(aaidEvent);
                }
            }
        }
        else if(event.code.indexOf("GCM") != -1)
        {
            dataArr = event.code.split("_");
            var gcmEvent:BCommonGCMEvent;
            if(dataArr[1] == "TOKEN"){

                if(hasEventListener(BCommonGCMEvent.TOKEN)){

                    gcmEvent = new BCommonGCMEvent(BCommonGCMEvent.TOKEN, false, false);
                    gcmEvent.token = event.level;
                    dispatchEvent(gcmEvent);
                }
            }else if(dataArr[1] == "ERROR"){

                if(hasEventListener(BCommonGCMEvent.ERROR)){

                    gcmEvent = new BCommonGCMEvent(BCommonGCMEvent.ERROR, false, false);
                    gcmEvent.error = BCommonErrorObject.createFromJSON(event.level);
                    dispatchEvent(gcmEvent);
                }
            }
        }
        else if(event.code == "FCM_TOKEN")
        {
            dispatchEvent(new BCommonEvent(BCommonEvent.FCM_TOKEN));
        }
    }

    /**
     * Do not use this method outside this class. It may be removed anytime!
     *
     * @param message
     */
    public function log(message:String):void
    {
        if (m_logEnabled) {
            as3Log(message, "AS3");
        }
        if (m_nativeLogEnabled) {
            nativeLog(message);
        }
    }

    private function as3Log(message:String, prefix:String):void
    {
        trace("[BCommon][" + prefix + "] " + message);
    }

    private function nativeLog(message:String):void
    {
        if (isSupported) {

            m_extensionContext.call('nativeLog', message);
        }
    }
}
}
