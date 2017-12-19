package sk.bpositive.bcommon.functions;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import sk.bpositive.bcommon.BCommonExtension;
import sk.bpositive.bcommon.utils.FREConversionUtil;

/**
 * Created by nodrock on 12/06/15.
 */
public class NativeLogFunction implements FREFunction {
    public FREObject call(FREContext context, FREObject[] args)
    {
        String message = FREConversionUtil.toString(args[0]);

        // NOTE: logs from as3 should go only to native log
        BCommonExtension.nativeLog(message, "AS3");

        return null;
    }
}
