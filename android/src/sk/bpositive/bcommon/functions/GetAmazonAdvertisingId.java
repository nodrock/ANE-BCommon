package sk.bpositive.bcommon.functions;

import android.content.ContentResolver;
import android.content.Context;
import android.provider.Settings;
import android.provider.Settings.Secure;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

import org.json.JSONException;
import org.json.JSONObject;

import sk.bpositive.bcommon.BCommonEvents;
import sk.bpositive.bcommon.BCommonExtension;
import sk.bpositive.bcommon.utils.FREConversionUtil;

public class GetAmazonAdvertisingId extends BaseFunction {
    @Override
    public FREObject call(FREContext context, FREObject[] args) {

        super.call(context, args);

        String advertisingID = "";
        boolean limitAdTracking = false;
        String jsonResult;

        try {
            Context ctx = context.getActivity().getApplicationContext();
            ContentResolver contentResolver = ctx.getContentResolver();

            // get user's tracking preference
            limitAdTracking = Secure.getInt(contentResolver, "limit_ad_tracking") != 0;

            // get advertising
            advertisingID = Secure.getString(contentResolver, "advertising_id");


            jsonResult = createResultJson(advertisingID, !limitAdTracking);

        } catch (Settings.SettingNotFoundException ex) {
            ex.printStackTrace();
            jsonResult = createErrorJson("Missing ad tracking id!");
        }

        BCommonExtension.context.dispatchEvent(BCommonEvents.AD_IDENTIFIER, jsonResult);

        return FREConversionUtil.fromString(jsonResult);
    }

    private static String createResultJson(String id, boolean trackingEnabled) {
        try {
            JSONObject object = new JSONObject();
            object.put("type", "AmazonAdID");
            object.put("id", id);
            object.put("trackingEnabled", trackingEnabled);
            return object.toString();
        } catch (Throwable t) {
            t.printStackTrace();
            return null;
        }
    }

    private static String createErrorJson(String error)
    {
        try {
            JSONObject object = new JSONObject();
            object.put("type", "AmazonAdID");
            object.put("error", error);
            return object.toString();
        } catch (Throwable t) {
            t.printStackTrace();
            return null;
        }
    }
}
