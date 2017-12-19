package sk.bpositive.bcommon.functions;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

import sk.bpositive.bcommon.BCommonExtension;
import sk.bpositive.bcommon.BCommonExtensionContext;

public class BaseFunction implements FREFunction
{
	@Override
	public FREObject call(FREContext context, FREObject[] args)
	{
		BCommonExtension.context = (BCommonExtensionContext)context;
		BCommonExtension.log(this.getClass().getName() + " call");
		return null;
	}
}
