package sk.bpositive.bcommon.firebase;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;

import sk.bpositive.bcommon.BCommonExtension;

public class NotificationActivity extends Activity {

    static final String START_ACTION = "sk.bpositive.bcommon.NotificationActivity.START";
    static final String DELETE_ACTION = "sk.bpositive.bcommon.NotificationActivity.DELETE";
    static final String EXTRA_REF = "sk.bpositive.bcommon.NotificationActivity.EXTRA_REF";
    static final String EXTRA_MESSAGE_ID = "sk.bpositive.bcommon.NotificationActivity.EXTRA_MESSAGE_ID";
    // used if notification payload is sent
    static final String NOTIFICATION_ACTION = "NOTIFICATION_ACTION"; // used in click_action
    static final String NOTIFICATION_EXTRA_MESSAGE_ID = "google.message_id";
    static final String NOTIFICATION_EXTRA_REF = "ref";

    static final String START_ACTION_DATA = "start";
    static final String DELETE_ACTION_DATA = "delete";

    public static NotificationData lastNotification = null;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        BCommonExtension.log("NotificationActivity started!");

        if (BCommonExtension.debugLogEnabled) {
            if (getIntent().getExtras() != null) {
                for (String key : getIntent().getExtras().keySet()) {
                    try {
                        String value = getIntent().getExtras().getString(key);
                        BCommonExtension.debug("Key: " + key + " Value: " + value);
                    } catch (Throwable t) {
                        BCommonExtension.debug("Key: " + key, t);
                    }
                }
            }
        }

        String action = getIntent().getAction();
        BCommonExtension.log("Action: " + action);
        String messageId;
        String ref;
        // native start from notification payload
        if (action.endsWith(NOTIFICATION_ACTION)) {
            messageId = getIntent().getStringExtra(NOTIFICATION_EXTRA_MESSAGE_ID);
            ref = getIntent().getStringExtra(NOTIFICATION_EXTRA_REF);
        } else {
            messageId = getIntent().getStringExtra(EXTRA_MESSAGE_ID);
            ref = getIntent().getStringExtra(EXTRA_REF);
        }
        Long actionTime = System.currentTimeMillis();

        // set data action from action
        String dataAction = START_ACTION_DATA;
        if (DELETE_ACTION.equals(action)) {
            dataAction = DELETE_ACTION_DATA;
        }

        lastNotification = new NotificationData(messageId, ref, dataAction, actionTime);

        BCommonExtension.log("Stored NotificationData: " + lastNotification);

        if (DELETE_ACTION.equals(action)) {

            finish();
            return;
        }

        startApp();
        finish();
    }

    private void startApp()
    {
        BCommonExtension.log("NotificationActivity.startApp()");
        try {
            Intent intent = new Intent(this, Class.forName(getPackageName() + ".AppEntry"));
            startActivity(intent);
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }
}