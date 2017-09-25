package sk.bpositive.bcommon.functions;

import android.os.Build;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.google.firebase.iid.FirebaseInstanceId;
import org.json.JSONException;
import org.json.JSONObject;
import sk.bpositive.bcommon.BCommonExtension;
import sk.bpositive.bcommon.utils.FREConversionUtil;

public class GetDeviceInfoToken implements FREFunction {

    @Override
    public FREObject call(FREContext freContext, FREObject[] freObjects) {

        String deviceInfo = null;

        try {
            JSONObject json = new JSONObject();
            json.put("bootloader", Build.BOOTLOADER);
            json.put("manufacturer", Build.MANUFACTURER);
            json.put("model", Build.MODEL);
            json.put("brand", Build.BRAND);
            json.put("hardware", Build.HARDWARE);
            json.put("board", Build.BOARD);
            json.put("device", Build.DEVICE);
            json.put("product", Build.PRODUCT);
            json.put("display", Build.DISPLAY);
            json.put("id", Build.ID);
            json.put("fingerprint", Build.FINGERPRINT);

            json.put("codename", Build.VERSION.CODENAME);
            json.put("incremental", Build.VERSION.INCREMENTAL);
            json.put("release", Build.VERSION.RELEASE);
            json.put("sdk_int", Build.VERSION.SDK_INT);
            deviceInfo = json.toString();

        } catch(JSONException ex) {
            ex.printStackTrace();
        }

        BCommonExtension.log("DEVICE_INFO: " + deviceInfo);

        return FREConversionUtil.fromString(deviceInfo);
    }

}
