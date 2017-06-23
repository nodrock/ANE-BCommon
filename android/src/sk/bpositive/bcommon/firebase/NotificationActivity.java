package sk.bpositive.bcommon.firebase;

import android.app.Activity;
import android.app.NotificationManager;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;

public class NotificationActivity extends Activity {

    private static final String TAG = "NotificationActivity";
    static final String START_ACTION = "sk.bpositive.bcommon.NotificationActivity.START";
    static final String DELETE_ACTION = "sk.bpositive.bcommon.NotificationActivity.DELETE";
    static final String EXTRA_REF = "sk.bpositive.bcommon.NotificationActivity.EXTRA_REF";
    static final String EXTRA_MESSAGE_ID = "sk.bpositive.bcommon.NotificationActivity.EXTRA_MESSAGE_ID";
    static final String EXTRA_NOTIFICATION_ID = "sk.bpositive.bcommon.NotificationActivity.NOTIFICATION_ID";
    // used if notification payload is sent
    static final String NOTIFICATION_ACTION = "NOTIFICATION_ACTION"; // used in click_action
    static final String NOTIFICATION_EXTRA_MESSAGE_ID = "google.message_id";
    static final String NOTIFICATION_EXTRA_REF = "ref";


    public static NotificationData lastNotification = null;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        /*if (getIntent().getExtras() != null) {
            for (String key : getIntent().getExtras().keySet()) {
                String value = getIntent().getExtras().getString(key);
                Log.d(TAG, "Key: " + key + " Value: " + value);
            }
        }*/

        String action = getIntent().getAction();
        String messageId;
        String ref;
        if (action.endsWith(NOTIFICATION_ACTION)) {
            messageId = getIntent().getStringExtra(NOTIFICATION_EXTRA_MESSAGE_ID);
            ref = getIntent().getStringExtra(NOTIFICATION_EXTRA_REF);
        } else {
            messageId = getIntent().getStringExtra(EXTRA_MESSAGE_ID);
            ref = getIntent().getStringExtra(EXTRA_REF);
        }
        Long actionTime = System.currentTimeMillis();

        lastNotification = new NotificationData(messageId, ref, action, actionTime);

        Log.i(TAG, "NotificationActivity started!");
        Log.i(TAG, "action:" + action);
        Log.i(TAG, "messageId:" + messageId);
        Log.i(TAG, "ref:" + ref);

        if (DELETE_ACTION.equals(action)) {

        } else if (START_ACTION.equals(action)){

            startApp();
        } else {

            if (getIntent().hasExtra(EXTRA_NOTIFICATION_ID)) {
                int notificationId = getIntent().getIntExtra(EXTRA_NOTIFICATION_ID, 0);

                Log.i(TAG, "notificationId:" + notificationId);

                NotificationManager notificationManager =
                        (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);

                notificationManager.cancel(notificationId);
            }

            startApp();
        }

        finish();
    }

    private void startApp()
    {
        Log.i(TAG, "startApp");
        try {
            Intent intent = new Intent(this, Class.forName(getPackageName() + ".AppEntry"));
            startActivity(intent);
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }
}