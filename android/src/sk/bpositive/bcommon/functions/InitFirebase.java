package sk.bpositive.bcommon.functions;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.google.firebase.analytics.FirebaseAnalytics;

public class InitFirebase implements FREFunction {

    private FirebaseAnalytics mFirebaseAnalytics;

    @Override
    public FREObject call(FREContext freContext, FREObject[] freObjects) {

        // we don't need to store it here but maybe someday we will need something
        mFirebaseAnalytics = FirebaseAnalytics.getInstance(freContext.getActivity().getApplicationContext());

        return null;
    }

}
