package sk.bpositive.bcommon.functions;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREObject;
import sk.bpositive.bcommon.BCommonExtension;

/**
 * Created by nodrock on 12/06/15.
 */
public class NativeLogFunction extends BaseFunction {
    public FREObject call(FREContext context, FREObject[] args)
    {
        super.call(context, args);

        String message = getStringFromFREObject(args[0]);

        // NOTE: logs from as3 should go only to native log
        BCommonExtension.nativeLog(message, "AS3");

        return null;
    }
}
