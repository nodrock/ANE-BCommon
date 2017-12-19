package sk.bpositive.bcommon.functions;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREObject;
import com.google.firebase.iid.FirebaseInstanceId;

import sk.bpositive.bcommon.BCommonExtension;
import sk.bpositive.bcommon.utils.FREConversionUtil;

public class GetFCMToken extends BaseFunction {

    @Override
    public FREObject call(FREContext context, FREObject[] args) {

        super.call(context, args);

        String token = FirebaseInstanceId.getInstance().getToken();
        BCommonExtension.log("FCM_TOKEN: " + token);

        return FREConversionUtil.fromString(token);
    }

}
