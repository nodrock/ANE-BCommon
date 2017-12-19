package sk.bpositive.bcommon.functions;

import android.content.ContentResolver;
import android.provider.Settings;
import android.provider.Settings.Secure;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

import org.json.JSONException;
import org.json.JSONObject;

import sk.bpositive.bcommon.utils.FREConversionUtil;

public class GetAmazonAdvertisingId implements FREFunction {
    @Override
    public FREObject call(FREContext context, FREObject[] freObjects) {

        String advertisingID = "";
        boolean limitAdTracking = false;
        String jsonResult;

        try {
            ContentResolver contentResolver = context.getActivity().getContentResolver();

            // get user's tracking preference
            limitAdTracking = Secure.getInt(contentResolver, "limit_ad_tracking") != 0;

            // get advertising
            advertisingID = Secure.getString(contentResolver, "advertising_id");


            JSONObject object = new JSONObject();
            object.put("id", advertisingID);
            object.put("limitAdTracking", limitAdTracking);
            jsonResult = object.toString();

        } catch (Settings.SettingNotFoundException ex) {
            ex.printStackTrace();
            jsonResult = "{\"error\":\"json_parse_error\", \"message\":\"Missing ad tracking id!\"}";
        } catch (JSONException e) {
            e.printStackTrace();
            jsonResult = "{\"error\":\"json_parse_error\", \"message\":\"Result parsing error!\"}";
        }

        return FREConversionUtil.fromString(jsonResult);
    }
}
