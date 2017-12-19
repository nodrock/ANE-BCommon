package sk.bpositive.bcommon.functions;

import android.app.Activity;
import android.app.Application;
import android.content.Context;
import android.os.Bundle;
import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.google.firebase.analytics.FirebaseAnalytics;

import sk.bpositive.bcommon.BCommonExtension;

public class InitFirebase extends BaseFunction {

    private FirebaseAnalytics mFirebaseAnalytics;

    private Boolean callbacksRegistered = false;

    @Override
    public FREObject call(FREContext context, FREObject[] args) {

        super.call(context, args);

        // we don't need to store it here but maybe someday we will need something
        mFirebaseAnalytics = FirebaseAnalytics.getInstance(context.getActivity().getApplicationContext());

        BCommonExtension.isAppActive = true;

        if(!callbacksRegistered) {
            BCommonExtension.log("Register activity lifecycle callbacks.");
            callbacksRegistered = true;
            context.getActivity().getApplication().registerActivityLifecycleCallbacks(
                    new Application.ActivityLifecycleCallbacks() {
                        @Override
                        public void onActivityCreated(Activity activity, Bundle savedInstanceState) {
                        }

                        @Override
                        public void onActivityStarted(Activity activity) {
                            BCommonExtension.isAppActive = true;
                            BCommonExtension.debug("onActivityStarted() isAppActive = true");
                        }

                        @Override
                        public void onActivityResumed(Activity activity) {
                        }

                        @Override
                        public void onActivityPaused(Activity activity) {
                        }

                        @Override
                        public void onActivityStopped(Activity activity) {
                            BCommonExtension.isAppActive = false;
                            BCommonExtension.debug("onActivityStopped() isAppActive = false");
                        }

                        @Override
                        public void onActivitySaveInstanceState(Activity activity, Bundle outState) {
                        }

                        @Override
                        public void onActivityDestroyed(Activity activity) {
                        }
                    });
        }

        return null;
    }

}
