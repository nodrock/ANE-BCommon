package sk.bpositive.bcommon.functions;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREObject;

import sk.bpositive.bcommon.firebase.NotificationActivity;
import sk.bpositive.bcommon.firebase.NotificationData;
import sk.bpositive.bcommon.utils.FREConversionUtil;

/**
 * Created by nodrock on 05/11/15.
 */
public class GetNotificationDataFunction extends BaseFunction {
    @Override
    public FREObject call(FREContext context, FREObject[] args) {

        super.call(context, args);

        NotificationData notificationData = NotificationActivity.lastNotification;

        return notificationData == null ? null : FREConversionUtil.fromString(notificationData.toString());
    }
}
