package sk.bpositive.bcommon.functions;

import android.os.Build;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREObject;

public class GetAdvertisingId extends BaseFunction {
    @Override
    public FREObject call(FREContext context, FREObject[] args) {

        super.call(context, args);

        if ("Amazon".equals(Build.MANUFACTURER)){
            new GetAmazonAdvertisingId().call(context, args);
        } else {
            new GetAAIDFunction().call(context, args);
        }

        return null;
    }
}
