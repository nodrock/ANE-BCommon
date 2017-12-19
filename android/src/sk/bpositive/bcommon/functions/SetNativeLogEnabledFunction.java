package sk.bpositive.bcommon.functions;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREObject;
import sk.bpositive.bcommon.BCommonExtension;
import sk.bpositive.bcommon.utils.FREConversionUtil;

public class SetNativeLogEnabledFunction extends BaseFunction
{
	@Override
	public FREObject call(FREContext context, FREObject[] args)
	{
		super.call(context, args);

		Boolean nativeLogEnabled = FREConversionUtil.toBoolean(args[0]);
		Boolean debugLogEnabled = FREConversionUtil.toBoolean(args[0]);

		BCommonExtension.nativeLogEnabled = nativeLogEnabled;
		BCommonExtension.debugLogEnabled = debugLogEnabled;
		
		return null;
	}

}
