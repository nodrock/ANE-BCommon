package sk.bpositive.bcommon.firebase;

import com.google.firebase.iid.FirebaseInstanceId;
import sk.bpositive.bcommon.BCommonExtension;

public class FirebaseInstanceIdService extends com.google.firebase.iid.FirebaseInstanceIdService {

    private static final String TAG = "FirebaseInstanceIdService";

    /**
     * Called if InstanceID token is updated. This may occur if the security of
     * the previous token had been compromised. This call is initiated by the
     * InstanceID provider.
     */
    // [START refresh_token]
    @Override
    public void onTokenRefresh() {

        String refreshedToken = FirebaseInstanceId.getInstance().getToken();
        BCommonExtension.log("FCM_TOKEN: " + refreshedToken);
        if(BCommonExtension.context != null) {
            BCommonExtension.context.dispatchStatusEventAsync("FCM_TOKEN", refreshedToken);
        }
    }
    // [END refresh_token]
}
