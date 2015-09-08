package sk.bpositive.bcommon.functions;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREObject;
import sk.bpositive.bcommon.BCommonExtension;

public class SetNativeLogEnabledFunction extends BaseFunction
{
	@Override
	public FREObject call(FREContext context, FREObject[] args)
	{
		super.call(context, args);

		Boolean nativeLogEnabled = getBooleanFromFREObject(args[0]);

		BCommonExtension.nativeLogEnabled = nativeLogEnabled;
		
		return null;
	}

}
