package sk.bpositive.bcommon.firebase;

import android.app.Notification;

import org.json.JSONObject;

/**
 * Created by jhorvath on 14/12/2017.
 */

public class NotificationPayload {
    public String notificationId;
    public String title;
    public String body;
    public String smallIcon;
    public String largeIcon;
    public String bigPicture;
    public String smallIconAccentColor;
    public String sound;
    public String vibrate;
    public String group;
    public int lockScreenVisibility;
    public boolean forceShow;
    public BackgroundImage backgroundImage;

    public NotificationPayload() {
    }

    public NotificationPayload(JSONObject jsonObject) {
        this.notificationId = jsonObject.optString("notificationId", null);
        this.title = jsonObject.optString("title", null);
        this.body = jsonObject.optString("body");
        this.smallIcon = jsonObject.optString("smallIcon", null);
        this.largeIcon = jsonObject.optString("largeIcon", null);
        this.bigPicture = jsonObject.optString("bigPicture", null);
        this.smallIconAccentColor = jsonObject.optString("smallIconAccentColor", null);
        this.sound = jsonObject.optString("sound", null);
        this.vibrate = jsonObject.optString("vibrate", null);
        this.group = jsonObject.optString("group", null);
        this.lockScreenVisibility = jsonObject.optInt("lockScreenVisibility", Notification.VISIBILITY_PUBLIC);
        this.forceShow = jsonObject.optBoolean("forceShow", false);
        String backgroundImageString = jsonObject.optString("backgroundImage", null);
        if (backgroundImageString != null) {
            try {
                JSONObject backgroundImageJson = new JSONObject(backgroundImageString);
                this.backgroundImage = new BackgroundImage(backgroundImageJson);
            } catch (Throwable t) {}
        }
    }

    public class BackgroundImage {
        public String customView;
        public String image;
        public String imageAlign;
        public String titleColor;
        public String bodyColor;

        public BackgroundImage() {
        }

        public BackgroundImage(JSONObject jsonObject) {
            this.customView = jsonObject.optString("customView", null);
            this.image = jsonObject.optString("image", null);
            this.imageAlign = jsonObject.optString("imageAlign", null);
            this.titleColor = jsonObject.optString("titleColor", null);
            this.bodyColor = jsonObject.optString("bodyColor", null);
        }
    }
}
