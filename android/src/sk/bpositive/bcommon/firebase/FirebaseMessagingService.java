/**
 * Copyright 2015 Google Inc. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package sk.bpositive.bcommon.firebase;

import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.content.res.Resources;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.support.v4.app.NotificationCompat;
import android.util.Log;
import com.google.firebase.messaging.RemoteMessage;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import sk.bpositive.bcommon.BCommonExtension;

import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class FirebaseMessagingService extends com.google.firebase.messaging.FirebaseMessagingService {

    private final int NOTIFICATION_ID = 1;

    private static final String TAG = "FMessagingService";

    private static final Pattern RESOURCE_PATTERN = Pattern.compile("\\@(.*)/(.*)");
    private static final String DO_NOT_OPEN = "do_not_open";

    // [START receive_message]
    @Override
    public void onMessageReceived(RemoteMessage message) {
        String messageId = message.getMessageId();
        Log.i(TAG, "Id: " + message.getMessageId());
        Log.i(TAG, "Type: " + message.getMessageType());
        Log.i(TAG, "From: " + message.getFrom());
        Log.i(TAG, "To: " + message.getTo());
        Log.i(TAG, "Collapse key: " + message.getCollapseKey());
        Log.i(TAG, "Sent time: " + message.getSentTime());
        Log.i(TAG, "TTL: " + message.getTtl());
        Log.i(TAG, "Data: " + message.getData());
        Log.i(TAG, "Notification: " + message.getNotification());

        String title = message.getData().get("title");
        String body = message.getData().get("body");
        String icon = message.getData().get("icon");
        String color = message.getData().get("color");
        String clickAction = message.getData().get("click_action");
        boolean autoCancel = message.getData().get("auto_cancel") == null || "true".equals(message.getData().get("auto_cancel"));

        String largeIconUrl = message.getData().get("large_icon_url");
        String bigImageUrl = message.getData().get("big_image_url");

        String bigContentTitle = message.getData().get("big_content_title");
        String summaryText = message.getData().get("summary_text");

        String when = message.getData().get("when");
        String showWhen = message.getData().get("show_when");
        String usesChronometer = message.getData().get("uses_chronometer");

        String ref = message.getData().get("ref");

        Bitmap largeIconBitmap = getBitmapfromUrl(largeIconUrl);
        Bitmap bigImageBitmap = getBitmapfromUrl(bigImageUrl);

        // process icon
        int smallIconId = getIconResource(getApplicationContext().getResources(), icon);
        if(smallIconId == 0){
            BCommonExtension.log("Wrong icon resource id!");
        }

        // process click_action
        PendingIntent pendingIntent = null;
        if(clickAction == null) {
            Intent intent = new Intent(this, NotificationActivity.class);
            intent.setAction(NotificationActivity.START_ACTION);
            intent.putExtra(NotificationActivity.EXTRA_MESSAGE_ID, messageId);
            intent.putExtra(NotificationActivity.EXTRA_REF, ref);
            pendingIntent = PendingIntent.getActivity(this, 0 /* Request code */, intent,
                    PendingIntent.FLAG_ONE_SHOT);
        } else if (DO_NOT_OPEN.equals(clickAction)) {
            pendingIntent = null;
        }

        NotificationCompat.Builder notificationBuilder = new NotificationCompat.Builder(getApplicationContext())
                .setSmallIcon(smallIconId)
                .setContentTitle(title)
                .setContentText(body)
                .setAutoCancel(autoCancel);

        if (when != null) {
            notificationBuilder.setWhen(Long.parseLong(when));
        }
        if (showWhen != null) {
            notificationBuilder.setShowWhen("true".equals(showWhen));
        }
        if (usesChronometer != null) {
            notificationBuilder.setUsesChronometer("true".equals(usesChronometer));
        }

        if (bigImageBitmap != null) {
            NotificationCompat.BigPictureStyle bigPictureStyle = new NotificationCompat.BigPictureStyle()
                    .bigPicture(bigImageBitmap);

            if (bigContentTitle != null) {
                bigPictureStyle.setBigContentTitle(bigContentTitle);
            }

            if (summaryText != null) {
                bigPictureStyle.setSummaryText(summaryText);
            } else {
                // We put body here otherwise there is empty line if you have opened you image. (on Android 6)
                bigPictureStyle.setSummaryText(body);
            }

            notificationBuilder.setStyle(bigPictureStyle);
        }

        if (largeIconBitmap != null) {
            notificationBuilder.setLargeIcon(getBitmapfromUrl(largeIconUrl));
        }

        if (color != null) {
            try {
                notificationBuilder.setColor(Color.parseColor(color));
            } catch (IllegalArgumentException ex){
                BCommonExtension.log("Wrong color string -> ignoring! color: " + color);
            }
        }

        if (pendingIntent != null) {
            notificationBuilder.setContentIntent(pendingIntent);
        }

        Intent deleteIntent = new Intent(this, NotificationActivity.class);
        deleteIntent.setAction(NotificationActivity.DELETE_ACTION);
        deleteIntent.putExtra(NotificationActivity.EXTRA_MESSAGE_ID, messageId);
        deleteIntent.putExtra(NotificationActivity.EXTRA_REF, ref);
        PendingIntent deletePendingIntent = PendingIntent.getActivity(this, 0 /* Request code */, deleteIntent,
                PendingIntent.FLAG_ONE_SHOT);
        notificationBuilder.setDeleteIntent(deletePendingIntent);

        parseActions(message, notificationBuilder);

        NotificationManager notificationManager =
                (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);

        notificationManager.notify(NOTIFICATION_ID, notificationBuilder.build());
    }
    // [END receive_message]

    private void parseActions(RemoteMessage message, NotificationCompat.Builder notificationBuilder)
    {
        String messageId = message.getMessageId();
        String ref = message.getData().get("ref");
        String actions = message.getData().get("actions");
        Log.i(TAG, "Actions: " + actions);

        if (actions != null) {
            try {
                JSONArray actionsArr = new JSONArray(actions);
                for (int actionIndex = 0; actionIndex<actionsArr.length(); ++actionIndex) {
                    JSONObject actionJson = actionsArr.getJSONObject(actionIndex);
                    String title = actionJson.getString("title");
                    String icon = actionJson.getString("icon");
                    String action = actionJson.getString("action");

                    int iconId = getIconResource(getApplicationContext().getResources(), icon);
                    if (iconId == 0) {
                        BCommonExtension.log("No icon for action! icon:" + icon);
                        continue;
                    }

                    Intent intent = new Intent(this, NotificationActivity.class);
                    intent.setAction(action);
                    intent.putExtra(NotificationActivity.EXTRA_NOTIFICATION_ID, NOTIFICATION_ID); // TODO: proper notification id
                    intent.putExtra(NotificationActivity.EXTRA_MESSAGE_ID, messageId);
                    intent.putExtra(NotificationActivity.EXTRA_REF, ref);
                    PendingIntent pendingIntent = PendingIntent.getActivity(this, 0 /* Request code */, intent,
                            PendingIntent.FLAG_ONE_SHOT);
                    notificationBuilder.addAction(iconId, title, pendingIntent);
                }

            } catch (JSONException e) {
                e.printStackTrace();
            }
        }
    }

    private int getIconResource(Resources resources, String resourceName)
    {
        Matcher matcher = RESOURCE_PATTERN.matcher(resourceName);
        if(matcher.find()){
            return resources.getIdentifier(matcher.group(2), matcher.group(1), getPackageName());
        }

        return 0;
    }

    /*
    *To get a Bitmap image from the URL received
    * */
    private Bitmap getBitmapfromUrl(String imageUrl) {
        try {
            URL url = new URL(imageUrl);
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            connection.setDoInput(true);
            connection.connect();
            InputStream input = connection.getInputStream();
            Bitmap bitmap = BitmapFactory.decodeStream(input);
            return bitmap;

        } catch (Exception e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
            return null;

        }
    }
}
