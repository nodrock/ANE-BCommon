package sk.bpositive.bcommon.firebase;

import com.google.firebase.iid.FirebaseInstanceId;

import sk.bpositive.bcommon.BCommonEvents;
import sk.bpositive.bcommon.BCommonExtension;

public class FirebaseInstanceIdService extends com.google.firebase.iid.FirebaseInstanceIdService {

    /**
     * Called if InstanceID token is updated. This may occur if the security of
     * the previous token had been compromised. This call is initiated by the
     * InstanceID provider.
     */
    // [START refresh_token]
    @Override
    public void onTokenRefresh() {

        String refreshedToken = FirebaseInstanceId.getInstance().getToken();
        if(BCommonExtension.context != null) {
            BCommonExtension.context.dispatchEvent(BCommonEvents.FCM_TOKEN, refreshedToken);
        }
    }
    // [END refresh_token]
}
