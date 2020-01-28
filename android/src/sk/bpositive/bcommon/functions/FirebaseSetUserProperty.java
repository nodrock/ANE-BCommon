package sk.bpositive.bcommon.functions;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREObject;
import com.google.firebase.analytics.FirebaseAnalytics;

import sk.bpositive.bcommon.utils.FREConversionUtil;

public class FirebaseSetUserProperty extends BaseFunction {

    @Override
    public FREObject call(FREContext context, FREObject[] args) {

        super.call(context, args);

        // we don't need to store it here but maybe someday we will need something
        FirebaseAnalytics mFirebaseAnalytics = FirebaseAnalytics.getInstance(context.getActivity().getApplicationContext());

        String name = FREConversionUtil.toString(args[0]);
        String value = FREConversionUtil.toString(args[1]);
        if (name != null) {
            mFirebaseAnalytics.setUserProperty(name, value);
        }

        return null;
    }

}
