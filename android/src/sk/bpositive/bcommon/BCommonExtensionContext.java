package sk.bpositive.bcommon;

import java.util.HashMap;
import java.util.Map;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import sk.bpositive.bcommon.functions.*;

public class BCommonExtensionContext extends FREContext
{
	@Override
	public void dispose()
	{
		BCommonExtension.context = null;
	}

	@Override
	public Map<String, FREFunction> getFunctions()
	{
		Map<String, FREFunction> functions = new HashMap<String, FREFunction>();

		functions.put("isSupported", new IsSupported());

		functions.put("initFirebase", new InitFirebase());
		functions.put("getFCMToken", new GetFCMToken());
		functions.put("getNotificationData", new GetNotificationDataFunction());

		functions.put("getLanguageCode", new GetLanguageCodeFunction());
		functions.put("flagKeepScreenOn", new FlagKeepScreenOn());
		functions.put("getFlagKeepScreenOn", new GetFlagKeepScreenOn());
		functions.put("getAAID", new GetAAIDFunction());
		functions.put("getAndroidId", new GetAndroidId());
		functions.put("crc32", new CRC32Function());
		functions.put("sha1", new SHA1Function());
		functions.put("unzipFile", new UnzipFileFunction());
		functions.put("getInstallerPackageName", new GetInstallerPackageName());
		functions.put("immersiveMode", new ImmersiveModeFunction());
		functions.put("deviceInfo", new GetDeviceInfoToken());
		functions.put("getResourceString", new GetResourceString());
		functions.put("getManifestMetadata", new GetManifestMetadata());
		functions.put("getAmazonAdID", new GetAmazonAdvertisingId());
		functions.put("getAdId", new GetAdvertisingId());

		functions.put("cancelAllNotifications", new CancelAllNotificationsFunction());

		// Debug
		functions.put("nativeLog", new NativeLogFunction());
		functions.put("setNativeLogEnabled", new SetNativeLogEnabledFunction());

		return functions;	
	}

	public void dispatchEvent(String type, String data)
	{
		BCommonExtension.log("Dispatch event! type: " + type + " data: " + data);
		dispatchStatusEventAsync(type, data);
	}
}
