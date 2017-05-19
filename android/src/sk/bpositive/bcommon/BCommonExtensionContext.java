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

		functions.put("getLanguageCode", new GetLanguageCodeFunction());
		functions.put("flagKeepScreenOn", new FlagKeepScreenOn());
		functions.put("getFlagKeepScreenOn", new GetFlagKeepScreenOn());
		functions.put("getAAID", new GetAAIDFunction());
		functions.put("getAndroidId", new GetAndroidId());
		functions.put("registerGCM", new RegisterGCM());
		functions.put("crc32", new CRC32Function());
		functions.put("sha1", new SHA1Function());
		functions.put("unzipFile", new UnzipFileFunction());
		functions.put("getInstallerPackageName", new GetInstallerPackageName());
		functions.put("immersiveMode", new ImmersiveModeFunction());

		// Debug
		functions.put("nativeLog", new NativeLogFunction());
		functions.put("setNativeLogEnabled", new SetNativeLogEnabledFunction());

		return functions;	
	}
}
