package sk.bpositive.bcommon.gcm;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import sk.bpositive.bcommon.BCommonExtension;

public class NotificationActivity extends Activity {

    private static final String TAG = "NotificationActivity";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        BCommonExtension.log("NotificationActivity started!");

        // TODO: process notification data
        Bundle bundle = getIntent().getExtras();
        if(bundle != null) {
            for (String key : bundle.keySet()) {
                Object value = bundle.get(key);
                Log.i(TAG, String.format("%s %s (%s)", key,
                        value == null ? "null" : value.toString(), value == null ? "null" : value.getClass().getName()));
            }
        }

        try {
            Intent intent = new Intent(this, Class.forName(getPackageName() + ".AppEntry"));
            startActivity(intent);
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }

        finish();
    }
}
