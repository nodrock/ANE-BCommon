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

package sk.bpositive.bcommon.gcm;

import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.content.res.Resources;
import android.media.RingtoneManager;
import android.net.Uri;
import android.os.Bundle;
import android.support.v4.app.NotificationCompat;
import android.util.Log;

import com.google.android.gms.gcm.GcmListenerService;
import sk.bpositive.bcommon.BCommonExtension;

public class BCommonGcmListenerService extends GcmListenerService {

    private static final String TAG = "BCommonGcmListenerServ";

    /**
     * Called when message is received.
     *
     * @param from SenderID of the sender.
     * @param data Data bundle containing message data as key/value pairs.
     *             For Set of keys use data.keySet().
     */
    // [START receive_message]
    @Override
    public void onMessageReceived(String from, Bundle data) {
        Log.i(TAG, "From: " + from);

//        if (from.startsWith("/topics/")) {
//            // message received from some topic.
//        } else {
//            // normal downstream message.
//        }

        String type = data.getString("type");
        if("notification".equals(type)){

            BCommonExtension.log("Sending notification!");
            sendNotification(data);
        }
    }
    // [END receive_message]

    /**
     * Create and show a simple notification containing the received GCM message.
     *
     * @param data GCM message received.
     */
    private void sendNotification(Bundle data) {

        Intent intent;

        try {
            intent = new Intent(this, Class.forName(getPackageName() + ".AppEntry"));
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            return;
        }

        String contentTitle = data.getString("content_title");
        String contentText = data.getString("content_text");
        String smallIcon = data.getString("small_icon");

        Resources resources = getResources();
        int smallIconId = resources.getIdentifier(smallIcon, "drawable", getPackageName());
        if(smallIconId == 0){
            BCommonExtension.log("Wrong icon resource id!");
        }

        int ringtone_type = data.getInt("ringtone_type", 0);

        PendingIntent pendingIntent = PendingIntent.getActivity(this, 0 /* Request code */, intent,
                PendingIntent.FLAG_ONE_SHOT);

        NotificationCompat.Builder notificationBuilder = new NotificationCompat.Builder(this)
                .setSmallIcon(smallIconId)
                .setContentTitle(contentTitle)
                .setContentText(contentText)
                .setAutoCancel(true)
                .setContentIntent(pendingIntent);

        // add ringtone
        if(ringtone_type != 0){
            Uri defaultSoundUri = RingtoneManager.getDefaultUri(ringtone_type);

            if(defaultSoundUri != null){

                notificationBuilder.setSound(defaultSoundUri);
            }
        }

        NotificationManager notificationManager =
                (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);

        notificationManager.notify(0 /* ID of notification */, notificationBuilder.build());
    }
}
