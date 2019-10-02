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

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.net.Uri;
import android.os.Build;
import android.support.v4.app.NotificationCompat;
import android.support.v4.text.TextUtilsCompat;
import android.text.TextUtils;
import android.view.View;
import android.widget.RemoteViews;

import com.google.firebase.messaging.RemoteMessage;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.Map;

import sk.bpositive.bcommon.BCommonEvents;
import sk.bpositive.bcommon.BCommonExtension;
import sk.bpositive.bcommon.R;

public class FirebaseMessagingService extends com.google.firebase.messaging.FirebaseMessagingService {

    @Override
    public void onNewToken(String token) {
        super.onNewToken(token);
        BCommonExtension.log("FCM_TOKEN changed: " + token);

        if(BCommonExtension.context != null) {
            BCommonExtension.context.token = token;
            BCommonExtension.context.dispatchEvent(BCommonEvents.FCM_TOKEN, token);
        }
    }

    // [START receive_message]
    @Override
    public void onMessageReceived(RemoteMessage message) {
        final String NOTIFICATION_CHANNEL_ID = "default";

        Context context = getApplicationContext();

        String messageId = message.getMessageId();
        BCommonExtension.log("FirebaseMessagingService.onMessageReceived()");
        BCommonExtension.log("Id: " + message.getMessageId());
        BCommonExtension.log("Type: " + message.getMessageType());
        BCommonExtension.log("From: " + message.getFrom());
        BCommonExtension.log("To: " + message.getTo());
        BCommonExtension.log("Collapse key: " + message.getCollapseKey());
        BCommonExtension.log("Sent time: " + message.getSentTime());
        BCommonExtension.log("TTL: " + message.getTtl());
        BCommonExtension.log("Data: " + message.getData());
        BCommonExtension.log("Notification: " + message.getNotification());

        if (message.getData() == null || message.getData().size() == 0)
        {
            // no data
            return;
        }

        NotificationPayload payload = new NotificationPayload(message.getData());

        // ignore processing if payload.body is not there (this is the only required param)
        if (payload.body == null){
            return;
        }

        int notificationId = 0;
        if (payload.notificationId != null){
            try {
                notificationId = Integer.parseInt(payload.notificationId);
            } catch (Exception ex) {
                BCommonExtension.log("Wrong notificationId -> using default 0.");
            }
        }

        // don't show notification if app is active and notification is not forced
        if (BCommonExtension.isAppActive && !payload.forceShow){
            BCommonExtension.log("Notification ignored because app is in foreground!");
            return;
        }

        // content intent
        Intent intent = new Intent(this, NotificationActivity.class);
        intent.setAction(NotificationActivity.START_ACTION);
        intent.putExtra(NotificationActivity.EXTRA_MESSAGE_ID, messageId);
        intent.putExtra(NotificationActivity.EXTRA_REF, payload.ref);
        PendingIntent pendingIntent = PendingIntent.getActivity(this, 0 /* Request code */, intent,
                PendingIntent.FLAG_ONE_SHOT);

        // delete intent
        Intent deleteIntent = new Intent(this, NotificationActivity.class);
        deleteIntent.setAction(NotificationActivity.DELETE_ACTION);
        deleteIntent.putExtra(NotificationActivity.EXTRA_MESSAGE_ID, messageId);
        deleteIntent.putExtra(NotificationActivity.EXTRA_REF, payload.ref);
        PendingIntent deletePendingIntent = PendingIntent.getActivity(this, 0 /* Request code */, deleteIntent,
                PendingIntent.FLAG_ONE_SHOT);

        NotificationCompat.Builder notificationBuilder = new NotificationCompat.Builder(getApplicationContext(), NOTIFICATION_CHANNEL_ID)
                .setSmallIcon(Utils.getSmallIconId(context, payload.smallIcon))
                .setContentTitle(Utils.getTitle(context, payload.title))
                .setContentText(payload.body)
                .setTicker(payload.body)
                .setAutoCancel(true)
                .setContentIntent(pendingIntent)
                .setDeleteIntent(deletePendingIntent)
                .setStyle(new NotificationCompat.BigTextStyle().bigText(payload.body));

        int notificationDefaults = 0;

        Integer accentColor = Utils.safeGetColorFromHex(payload.smallIconAccentColor);
        if(accentColor != null)
        {
            notificationBuilder.setColor(accentColor);
        }

        try {
            notificationBuilder.setVisibility(payload.lockScreenVisibility);
        } catch (Throwable t) {
            BCommonExtension.debug("Cannot set lockScreenVisibility.", t);
        }

        Bitmap largeIcon = Utils.getLargeIcon(context, payload.largeIcon);
        if (largeIcon != null) {
            notificationBuilder.setLargeIcon(largeIcon);
        }

        Bitmap bigPictureIcon = Utils.getBitmap(context, payload.bigPicture);
        if (bigPictureIcon != null) {
           notificationBuilder.setStyle(new NotificationCompat.BigPictureStyle().bigPicture(bigPictureIcon).setSummaryText(payload.body));
        }

        if(!TextUtils.isEmpty(payload.sound)) {
            Uri soundUri = Utils.getSoundUri(context, payload.sound);
            if (soundUri != null) {
                notificationBuilder.setSound(soundUri);
            } else {
                notificationDefaults |= Notification.DEFAULT_SOUND;
            }
        }

        if(!TextUtils.isEmpty(payload.vibrate)) {
            notificationDefaults |= Notification.DEFAULT_VIBRATE;
        }

        if(payload.backgroundImage != null)
        {
            BCommonExtension.debug("Creating background image!");
            try {
                addBackgroundImage(payload, notificationBuilder, getApplicationContext());
            } catch (Throwable t) {
                BCommonExtension.debug("Failed!", t);
            }
        }

        notificationBuilder.setDefaults(notificationDefaults);

        NotificationManager notificationManager =
                (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);

        if (notificationManager == null)
        {
            BCommonExtension.log("Can't get NotificationManager!");
            return;
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            if (notificationManager.getNotificationChannel(NOTIFICATION_CHANNEL_ID) == null) {
                BCommonExtension.log("Creating default channel!");
                NotificationChannel notificationChannel = new NotificationChannel(NOTIFICATION_CHANNEL_ID, "default", NotificationManager.IMPORTANCE_DEFAULT);

                // Configure the notification channel.
//            notificationChannel.setDescription("Channel description");
//            notificationChannel.enableLights(true);
//            notificationChannel.setLightColor(Color.RED);
//            notificationChannel.setVibrationPattern(new long[]{0, 1000, 500, 1000});
//            notificationChannel.enableVibration(true);
                notificationManager.createNotificationChannel(notificationChannel);
            }
        }

        if (payload.group != null) {
            notificationManager.notify(payload.group, notificationId, notificationBuilder.build());
        } else {
            BCommonExtension.log("Showing notification! id=" + notificationId);
            notificationManager.notify(notificationId, notificationBuilder.build());
        }
    }
    // [END receive_message]

    private NotificationPayload parseNotificationData(Map<String, String> data)
    {
        return new NotificationPayload(data);
    }

    private static void addBackgroundImage(NotificationPayload notificationPayload, NotificationCompat.Builder notifBuilder, Context context)
            throws Throwable
    {
        if (Build.VERSION.SDK_INT < 16) {
            return;
        }
        Bitmap bg_image = null;
        if (notificationPayload.backgroundImage != null)
        {
            bg_image = Utils.getBitmap(context, notificationPayload.backgroundImage);
        }
        if (bg_image != null)
        {
            int viewId = R.layout.pixel_bgimage_notif_layout;
            if(notificationPayload.customView != null) {
                viewId = context.getResources().getIdentifier(notificationPayload.customView, "layout", context.getPackageName());
            }

            RemoteViews customView = new RemoteViews(context.getPackageName(), viewId);
            customView.setTextViewText(R.id.pixel_bgimage_notif_title, Utils.getTitle(context, notificationPayload.title));
            customView.setTextViewText(R.id.pixel_bgimage_notif_body, notificationPayload.body);
            setTextColor(customView, R.id.pixel_bgimage_notif_title, notificationPayload.titleColor);
            setTextColor(customView, R.id.pixel_bgimage_notif_body, notificationPayload.bodyColor);

            Bitmap largeIcon = Utils.getLargeIcon(context, notificationPayload.largeIcon);
            if (largeIcon != null) {
                customView.setImageViewBitmap(R.id.pixel_bgimage_large_icon, largeIcon);
            }

            String alignSetting = null;
            if (notificationPayload.backgroundImageAlign != null)
            {
                alignSetting = notificationPayload.backgroundImageAlign;
            }

            if ("right".equals(alignSetting))
            {
                customView.setViewPadding(R.id.pixel_bgimage_notif_bgimage_align_layout, -5000, 0, 0, 0);
                customView.setImageViewBitmap(R.id.pixel_bgimage_notif_bgimage_right_aligned, bg_image);
                customView.setViewVisibility(R.id.pixel_bgimage_notif_bgimage_right_aligned, View.VISIBLE); // visible
                customView.setViewVisibility(R.id.pixel_bgimage_notif_bgimage, View.GONE); // gone
            }
            else
            {
                customView.setImageViewBitmap(R.id.pixel_bgimage_notif_bgimage, bg_image);
            }

            notifBuilder.setContent(customView);

            notifBuilder.setStyle(null);
        }
    }

    private static void setTextColor(RemoteViews customView, int viewId, String colorString)
    {
        Integer color = Utils.safeGetColorFromHex(colorString);
        if (color != null)
        {
            customView.setTextColor(viewId, color);
        }
    }
}
