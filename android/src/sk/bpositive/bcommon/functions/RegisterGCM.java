package sk.bpositive.bcommon.functions;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.GoogleApiAvailability;
import sk.bpositive.bcommon.BCommonExtension;
import sk.bpositive.bcommon.gcm.NotificationActivity;
import sk.bpositive.bcommon.gcm.RegistrationIntentService;
import sk.bpositive.bcommon.utils.FREConversionUtil;

public class RegisterGCM implements FREFunction {

//    private static final int PLAY_SERVICES_RESOLUTION_REQUEST = 9000;

    @Override
    public FREObject call(FREContext freContext, FREObject[] freObjects) {

        String senderId = FREConversionUtil.toString(freObjects[0]);

        Activity activity = freContext.getActivity();
        if (checkPlayServices(activity)) {
            // Start IntentService to register this application with GCM.
            Intent intent = new Intent(activity, RegistrationIntentService.class);
            intent.putExtra(RegistrationIntentService.TAG + ".senderId", senderId);
            activity.startService(intent);
        }else{

            BCommonExtension.context.dispatchStatusEventAsync("GCM_ERROR", "{\"error\":\"google_play_services\"}");
        }

        return null;
    }

    /**
     * Check the device to make sure it has the Google Play Services APK. If
     * it doesn't, display a dialog that allows users to download the APK from
     * the Google Play Store or enable it in the device's system settings.
     */
    private boolean checkPlayServices(Activity activity) {
        GoogleApiAvailability apiAvailability = GoogleApiAvailability.getInstance();
        int resultCode = apiAvailability.isGooglePlayServicesAvailable(activity);
        if (resultCode != ConnectionResult.SUCCESS) {
//            if (apiAvailability.isUserResolvableError(resultCode)) {
//                apiAvailability.getErrorDialog(activity, resultCode, PLAY_SERVICES_RESOLUTION_REQUEST)
//                        .show();
//            } else {
//                //Log.i(TAG, "This device is not supported.");
//                activity.finish();
//            }
            return false;
        }
        return true;
    }

}
