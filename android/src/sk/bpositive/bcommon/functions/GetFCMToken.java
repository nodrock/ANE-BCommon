package sk.bpositive.bcommon.functions;

import android.support.annotation.NonNull;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREObject;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.iid.FirebaseInstanceId;

import com.google.firebase.iid.InstanceIdResult;
import com.google.firebase.messaging.FirebaseMessaging;
import sk.bpositive.bcommon.BCommonEvents;
import sk.bpositive.bcommon.BCommonExtension;

public class GetFCMToken extends BaseFunction {

    @Override
    public FREObject call(FREContext context, FREObject[] args) {

        super.call(context, args);

        if (BCommonExtension.context != null && BCommonExtension.context.token != null)
        {
            BCommonExtension.log("FCM_TOKEN has token: " + BCommonExtension.context.token);
            BCommonExtension.context.dispatchEvent(BCommonEvents.FCM_TOKEN, BCommonExtension.context.token);
            return null;
        }

        try {
            FirebaseInstanceId.getInstance().getInstanceId().addOnCompleteListener(new OnCompleteListener<InstanceIdResult>() {
                @Override
                public void onComplete(@NonNull Task<InstanceIdResult> task) {
                    if (!task.isSuccessful()) {
                        BCommonExtension.log("FCM_TOKEN exception: " + task.getException());
                        return;
                    }

                    if (task.getResult() == null) {
                        BCommonExtension.log("FCM_TOKEN should never happend!");
                        return;
                    }

                    String token = task.getResult().getToken();
                    BCommonExtension.log("FCM_TOKEN: " + token);
                    if (BCommonExtension.context != null) {
                        BCommonExtension.context.token = token;
                        BCommonExtension.context.dispatchEvent(BCommonEvents.FCM_TOKEN, token);
                    }
                }
            });
        }catch (Exception e)
        {
            BCommonExtension.log("FCM_TOKEN call exception: " + e.toString());
        }

        return null;
    }

}
