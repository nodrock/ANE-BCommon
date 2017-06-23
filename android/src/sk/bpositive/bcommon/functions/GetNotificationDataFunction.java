package sk.bpositive.bcommon.functions;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import sk.bpositive.bcommon.firebase.NotificationData;
import sk.bpositive.bcommon.firebase.NotificationActivity;
import sk.bpositive.bcommon.utils.FREConversionUtil;

/**
 * Created by nodrock on 05/11/15.
 */
public class GetNotificationDataFunction implements FREFunction {
    @Override
    public FREObject call(FREContext freContext, FREObject[] freObjects) {

        NotificationData notificationData = NotificationActivity.lastNotification;

        return notificationData == null ? null : FREConversionUtil.fromString(notificationData.toString());
    }
}
