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
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.Build;
import android.support.v4.app.NotificationCompat;
import android.view.View;
import android.widget.RemoteViews;

import com.google.firebase.messaging.RemoteMessage;

import org.json.JSONException;
import org.json.JSONObject;

import sk.bpositive.bcommon.BCommonExtension;
import sk.bpositive.bcommon.R;

public class FirebaseMessagingService extends com.google.firebase.messaging.FirebaseMessagingService {

    private final int NOTIFICATION_ID = 1;

    // [START receive_message]
    @Override
    public void onMessageReceived(RemoteMessage message) {

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

        if (message.getData() != null && message.getData().size() > 0) {

            String ref = message.getData().get("ref");

            String notificationData = message.getData().get("notification_data");
            NotificationPayload payload = parseNotificationData(notificationData);

            // ignore processing if payload is not there
            if (payload == null){
                return;
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
            intent.putExtra(NotificationActivity.EXTRA_REF, ref);
            PendingIntent pendingIntent = PendingIntent.getActivity(this, 0 /* Request code */, intent,
                    PendingIntent.FLAG_ONE_SHOT);

            // delete intent
            Intent deleteIntent = new Intent(this, NotificationActivity.class);
            deleteIntent.setAction(NotificationActivity.DELETE_ACTION);
            deleteIntent.putExtra(NotificationActivity.EXTRA_MESSAGE_ID, messageId);
            deleteIntent.putExtra(NotificationActivity.EXTRA_REF, ref);
            PendingIntent deletePendingIntent = PendingIntent.getActivity(this, 0 /* Request code */, deleteIntent,
                    PendingIntent.FLAG_ONE_SHOT);

            NotificationCompat.Builder notificationBuilder = new NotificationCompat.Builder(getApplicationContext())
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

            if(!"".equals(payload.sound)) {
                Uri soundUri = Utils.getSoundUri(context, payload.sound);
                if (soundUri != null) {
                    notificationBuilder.setSound(soundUri);
                } else {
                    notificationDefaults |= Notification.DEFAULT_SOUND;
                }
            }

            if(!"".equals(payload.vibrate)) {
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

            if (payload.group != null) {
                notificationManager.notify(payload.group, NOTIFICATION_ID, notificationBuilder.build());
            } else {
                notificationManager.notify(NOTIFICATION_ID, notificationBuilder.build());
            }
        }
    }
    // [END receive_message]

    private NotificationPayload parseNotificationData(String jsonData)
    {
        if (jsonData == null){
            return null;
        }
        try {
            JSONObject json = new JSONObject(jsonData);
            return new NotificationPayload(json);

        } catch (JSONException e) {
            e.printStackTrace();
            return null;
        }
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
            bg_image = Utils.getBitmap(context, notificationPayload.backgroundImage.image);
        }
        if (bg_image != null)
        {
            int viewId = R.layout.pixel_bgimage_notif_layout;
            if(notificationPayload.backgroundImage.customView != null) {
                viewId = context.getResources().getIdentifier(notificationPayload.backgroundImage.customView, "layout", context.getPackageName());
            }

            RemoteViews customView = new RemoteViews(context.getPackageName(), viewId);
            customView.setTextViewText(R.id.pixel_bgimage_notif_title, Utils.getTitle(context, notificationPayload.title));
            customView.setTextViewText(R.id.pixel_bgimage_notif_body, notificationPayload.body);
            setTextColor(customView, R.id.pixel_bgimage_notif_title, notificationPayload.backgroundImage.titleColor);
            setTextColor(customView, R.id.pixel_bgimage_notif_body, notificationPayload.backgroundImage.bodyColor);

            Bitmap largeIcon = Utils.getLargeIcon(context, notificationPayload.largeIcon);
            if (largeIcon != null) {
                customView.setImageViewBitmap(R.id.pixel_bgimage_large_icon, largeIcon);
            }

            String alignSetting = null;
            if (notificationPayload.backgroundImage.imageAlign != null)
            {
                alignSetting = notificationPayload.backgroundImage.imageAlign;
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
