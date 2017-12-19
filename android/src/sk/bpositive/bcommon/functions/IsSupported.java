package sk.bpositive.bcommon.functions;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREObject;

import sk.bpositive.bcommon.utils.FREConversionUtil;

public class IsSupported extends BaseFunction {

    @Override
    public FREObject call(FREContext context, FREObject[] args) {

        super.call(context, args);

        return FREConversionUtil.fromBoolean(true);
    }

}
