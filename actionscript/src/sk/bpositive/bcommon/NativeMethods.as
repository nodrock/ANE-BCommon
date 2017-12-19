/**
 * Created by nodrock on 19/05/2017.
 */
package sk.bpositive.bcommon {
public class NativeMethods {
    public function NativeMethods()
    {
    }

    public static const SET_NATIVE_LOG_ENABLED:String = "setNativeLogEnabled";
    public static const GET_LANGUAGE_CODE:String = "getLanguageCode";

    public static const GET_IDFV:String = "getIDFV";
    public static const GET_IDFA:String = "getIDFA";
    public static const GET_IDFA_TRACKING_ENABLED:String = "getIDFATrackingEnabled";
    public static const IS_REMOTE_NOTIFICATION_ENABLED:String = "isRemoteNotificationsEnabled";
    public static const CAN_OPEN_SETTINGS:String = "canOpenSettings";
    public static const OPEN_SETTINGS:String = "openSettings";

    public static const GET_ANDROID_ID:String = "getAndroidId";
    public static const GET_AAID:String = "getAAID";
    public static const GET_AMAZON_AD_ID:String = "getAmazonAdID";
    public static const FLAG_KEEP_SCREEN_ON:String = "flagKeepScreenOn";
    public static const REGISTER_GCM:String = "registerGCM";
    public static const GET_INSTALLER_PACKAGE_NAME:String = "getInstallerPackageName";
    public static const IMMERSIVE_MODE:String = "immersiveMode";
    public static const GET_MANIFEST_METADATA:String = "getManifestMetadata";
    public static const GET_RESOURCE_STRING:String = "getResourceString";

    public static const INIT_FIREBASE:String = "initFirebase";
    public static const GET_FCM_TOKEN:String = "getFCMToken";
    public static const REGISTER_FOR_REMOTE_NOTIFICATION:String = "registerForRemoteNotifications";
    public static const GET_NOTIFICATION_DATA:String = "getNotificationData";

    public static const CRC32:String = "crc32";
    public static const SHA1:String = "sha1";
    public static const UPDATE_CRC32:String = "updateCrc32";
    public static const DEVICE_INFO:String = "deviceInfo";
}
}
