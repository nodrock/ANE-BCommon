package sk.bpositive.bcommon {

import flash.errors.IllegalOperationError;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;
import flash.events.StatusEvent;
import flash.system.Capabilities;
import flash.utils.ByteArray;

import sk.bpositive.bcommon.common.CRC32;
import sk.bpositive.bcommon.common.ExtensionWrapper;

public class BCommon extends EventDispatcher {

    private static const INVOKE_REASON_NOTIFICATION:String = "notification";
    public static const NOTIFICATION_ACTION_START:String = "start";
    private static const IOS_NOTIFICATION_MESSAGE_ID:String = "gcm.message_id";
    private static const IOS_NOTIFICATION_REF:String = "ref";
    
    public static const VERSION:String = "1.5.2";
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

    public function setLogEnabled(as3Log:Boolean, nativeLog:Boolean, debugLog:Boolean = false):void
    {
        m_logEnabled = as3Log;
        m_nativeLogEnabled = nativeLog;
        m_extensionContext.call(NativeMethods.SET_NATIVE_LOG_ENABLED, nativeLog, debugLog);
    }

    /**
     * Returns two-letter language code according to ISO 639-1.
     */
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

    /**
     * Gets advertising id.
     * IDFA on iOS
     * AAID on Android
     * AmazonAdID on Amazon
     * Result it returned by BCommonEvent.AD_IDENTIFIER.
     */
    public function getAdId():void
    {
        m_extensionContext.call(NativeMethods.GET_AD_ID);
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

    /**
     * Returns Amazon Advertising ID in same format as AAID in BCommonEvent.
     *
     * Json format of data:
     * <code>
     *  {
     *      "type": "AmazonAdID",
     *      "error": "error message",   [not be present if there is NO error]
     *      "id": "xxx",                [not be present if there is error]
     *      "trackingEnabled": true     [not be present if there is error]
     *  }
     * </code>
     *
     * @return
     */
    public function getAmazonAdID():String
    {
        if (isAndroid()){

            var json:String = m_extensionContext.call(NativeMethods.GET_AMAZON_AD_ID);
            return json;
        }
        return null;
    }

    public function getAAID():void
    {
        if (isAndroid()) {

            m_extensionContext.call(NativeMethods.GET_AAID);
        }
    }

    /**
     * Returns manifest data from meta-data tag.
     *
     * <meta-data
     *   android:name="com.pixelfederation.meta.CUSTOM_METADATA"
     *   android:value="Some metadata" />
     *
     * @param name
     */
    public function getManifestMetadata(name:String):void
    {
        if (isAndroid()) {

            m_extensionContext.call(NativeMethods.GET_MANIFEST_METADATA, name);
        }
    }

    /**
     * Cancel all notifications.
     */
    public function cancelAllNotifications():void
    {
        if (isAndroid()) {

            m_extensionContext.call(NativeMethods.CANCEL_ALL_NOTIFICATIONS);
        }
    }

    /**
     * Returns resource string.
     *
     * @param id
     */
    public function getResourceString(id:String):void
    {
        if (isAndroid()) {

            m_extensionContext.call(NativeMethods.GET_RESOURCE_STRING, id);
        }
    }

    public function setFlagKeepScreenOn(value:Boolean):void
    {
        if (isAndroid()) {

            m_extensionContext.call(NativeMethods.FLAG_KEEP_SCREEN_ON, value);
        }
    }

    public function canOpenSettings():Boolean
    {
        if (isIOS()) {

            return m_extensionContext.call(NativeMethods.CAN_OPEN_SETTINGS) as Boolean;
        }
        return false;
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

            return m_extensionContext.call(NativeMethods.IS_REMOTE_NOTIFICATION_ENABLED) as Boolean;
        }

        return false;
    }

    public function getInstallerPackageName():String
    {
        if (isAndroid()) {

            return m_extensionContext.call(NativeMethods.GET_INSTALLER_PACKAGE_NAME) as String;
        }

        return null;
    }

    public function immersiveMode(isSticky:Boolean = true):Boolean
    {
        if (isAndroid()) {

            return m_extensionContext.call(NativeMethods.IMMERSIVE_MODE, isSticky) as Boolean;
        }

        return null;
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
     * Inits firebase. Must be called for proper functionality.
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

    /**
     * Gets data about notification which started this app in json format.
     *
     * JSON format:
     * <code>
     *  {
     *      "messageId": "0:1514369100381481%c8c9da34c8c9da34",
     *      "ref": null,
     *      "action": "start",
     *      "actionTime": "1514369750421"
     *  }
     * </code>
     *
     * @return Last notification data
     */
    public function getNotificationDataJson():String
    {
        var data:NotificationData = getNotificationData();
        return data == null ? null : JSON.stringify(data);
    }

    /**
     * Computes crc32 of data byte array.
     * @param data
     * @return
     */
    public function crc32(data:ByteArray):uint
    {
        if(m_extensionContext.isSupported){
            return m_extensionContext.native_call(NativeMethods.CRC32, data);
        } else {
            // flash implementation
            return CRC32.crc32(data);
        }
    }

    /**
     * EXPERIMENTAL Do not use.
     * @param crc
     * @param data
     * @param offset
     * @param length
     * @return
     */
    public function xcrc32(crc:uint, data:ByteArray, offset:uint = 0, length:uint = 0):uint
    {
        length = length == 0 ? data.length : length;
        if (offset + length <= data.length) {
            if (m_extensionContext.isSupported) {
                return m_extensionContext.native_call(NativeMethods.UPDATE_CRC32, crc, data, offset, length);
            } else {
                return CRC32.updateCrc32(crc, data, offset, length);
            }
        } else {
            throw new ArgumentError("Wrong offset or length!");
        }
    }

    /**
     * Computes sha1 of byte array.
     * @param data
     * @return
     */
    public function sha1(data:ByteArray):uint
    {
        if(m_extensionContext.isSupported){
            return m_extensionContext.native_call(NativeMethods.SHA1, data);
        } else {
            // flash implementation
            throw new IllegalOperationError("SHA1 is not supported on flash yet!")
        }
    }

    /**
     * Returns device information for Android.
     * Contains: bootloader, manufacturer, model, brand, hardware, board, device, product, display, id, fingerprint
     * from Build and codename, incremental, release and sdk_int from Build.VERSION.
     * @return JSON string
     */
    public function getDeviceInfoJson():String
    {
        if (isAndroid()) {
            return m_extensionContext.call(NativeMethods.DEVICE_INFO);
        }

        return null;
    }

    public function call(functionName:String, ... args):*
    {
        return m_extensionContext.call.apply(m_extensionContext, [functionName].concat(args));
    }

    // --------------------------------------------------------------------------------------//
    //																						 //
    // 									 	PRIVATE API										 //
    // 																						 //
    // --------------------------------------------------------------------------------------//

    private function onStatus(event:StatusEvent):void {

        if (event.code == "LOGGING") // Simple log message
        {
            // NOTE: logs from native should go only to as3 log
            as3Log(event.level, "NATIVE");
        }
        else {

            as3Log("Event name: " + event.code + ", data:" + event.level, "AS3");
            dispatchEvent(new BCommonEvent(event.code, event.level));
        }

        // backward compatibility only if we have listeners for that
        if (hasEventListener(BCommonAAIDEvent.AAID_COMPLETED) || hasEventListener(BCommonAAIDEvent.AAID_FAILED)){

            if (event.code == BCommonEvent.AD_IDENTIFIER) {

                log("Generating backward compatibility AAID events");

                var aaidEvent:BCommonAAIDEvent;

                if (event.level == null || event.level == "") {
                    aaidEvent = new BCommonAAIDEvent(BCommonAAIDEvent.AAID_FAILED, false, false);
                    aaidEvent.error = BCommonErrorObject.create("Empty JSON.", "Empty JSON.");
                } else {
                    var aaidData:Object = JSON.parse(event.level);
                    if (aaidData.hasOwnProperty("error")) {
                        aaidEvent = new BCommonAAIDEvent(BCommonAAIDEvent.AAID_FAILED, false, false);
                        aaidEvent.error = BCommonErrorObject.create(aaidData["error"], aaidData["error"]);
                    } else {
                        aaidEvent = new BCommonAAIDEvent(BCommonAAIDEvent.AAID_COMPLETED, false, false);
                        aaidEvent.aaid = BCommonAAID.createFromJSON(event.level);
                    }
                }

                dispatchEvent(aaidEvent);
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

            m_extensionContext.native_call('nativeLog', message);
        }
    }
}
}
