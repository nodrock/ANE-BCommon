package sk.bpositive.bcommon.gcm;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import sk.bpositive.bcommon.BCommonExtension;

public class NotificationActivity extends Activity {

    private static final String TAG = "NotificationActivity";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        BCommonExtension.log("NotificationActivity started!");

        try {
            Intent intent = new Intent(this, Class.forName(getPackageName() + ".AppEntry"));
            startActivity(intent);
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }

        finish();
    }
}
