package sk.bpositive.bcommon.functions;

import android.provider.Settings.Secure;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import sk.bpositive.bcommon.utils.FREConversionUtil;

public class GetAndroidId implements FREFunction {
    @Override
    public FREObject call(FREContext context, FREObject[] freObjects) {

        String androidId = Secure.getString(context.getActivity().getContentResolver(), Secure.ANDROID_ID);

        return FREConversionUtil.fromString(androidId);
    }
}
