package sk.bpositive.bcommon.functions;

import android.provider.Settings.Secure;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREObject;

import sk.bpositive.bcommon.utils.FREConversionUtil;

public class GetAndroidId extends BaseFunction {
    @Override
    public FREObject call(FREContext context, FREObject[] args) {

        super.call(context, args);

        String androidId = Secure.getString(context.getActivity().getContentResolver(), Secure.ANDROID_ID);

        return FREConversionUtil.fromString(androidId);
    }
}
