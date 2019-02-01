package sk.bpositive.bcommon.functions;

import android.app.NotificationManager;
import android.content.Context;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREObject;
import com.google.firebase.iid.FirebaseInstanceId;

import sk.bpositive.bcommon.BCommonExtension;
import sk.bpositive.bcommon.utils.FREConversionUtil;

public class CancelAllNotificationsFunction extends BaseFunction {

    @Override
    public FREObject call(FREContext context, FREObject[] args) {

        super.call(context, args);

        NotificationManager notificationManager =
                (NotificationManager) context.getActivity().getApplicationContext().getSystemService(Context.NOTIFICATION_SERVICE);

        if (notificationManager == null)
        {
            return FREConversionUtil.fromBoolean(false);
        }

        notificationManager.cancelAll();

        return FREConversionUtil.fromBoolean(true);
    }

}
