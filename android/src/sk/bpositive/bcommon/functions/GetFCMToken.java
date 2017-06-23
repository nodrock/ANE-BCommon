package sk.bpositive.bcommon.functions;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.google.firebase.iid.FirebaseInstanceId;
import sk.bpositive.bcommon.BCommonExtension;
import sk.bpositive.bcommon.utils.FREConversionUtil;

public class GetFCMToken implements FREFunction {

    @Override
    public FREObject call(FREContext freContext, FREObject[] freObjects) {

        String token = FirebaseInstanceId.getInstance().getToken();
        BCommonExtension.log("FCM_TOKEN: " + token);

        return FREConversionUtil.fromString(token);
    }

}
