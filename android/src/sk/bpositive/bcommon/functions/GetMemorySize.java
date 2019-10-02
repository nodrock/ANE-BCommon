package sk.bpositive.bcommon.functions;

import android.app.Activity;
import android.app.ActivityManager;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREObject;

import sk.bpositive.bcommon.utils.FREConversionUtil;

public class GetMemorySize extends BaseFunction {

    @Override
    public FREObject call(FREContext context, FREObject[] args) {

        super.call(context, args);

        ActivityManager activityManager = (ActivityManager) context.getActivity().getSystemService(Activity.ACTIVITY_SERVICE);
        if (activityManager != null) {
            ActivityManager.MemoryInfo memInfo = new ActivityManager.MemoryInfo();
            activityManager.getMemoryInfo(memInfo);

            FREConversionUtil.fromNumber(memInfo.availMem);
        }

        return null;
    }

}
