package sk.bpositive.bcommon.firebase;

import android.app.Notification;

import org.json.JSONObject;

import java.util.Map;

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
    public String ref;

    public String backgroundImage;
    public String backgroundImageAlign;
    public String customView;
    public String titleColor;
    public String bodyColor;

    public NotificationPayload() {
    }

    public NotificationPayload(Map<String, String> data) {
        this.notificationId = data.get("notificationId");
        this.title = data.get("title");
        this.body = data.get("body");
        this.smallIcon = data.get("smallIcon");
        this.largeIcon = data.get("largeIcon");
        this.bigPicture = data.get("bigPicture");
        this.smallIconAccentColor = data.get("smallIconAccentColor");
        this.sound = data.get("sound");
        this.vibrate = data.get("vibrate");
        this.group = data.get("group");
        this.lockScreenVisibility = data.get("lockScreenVisibility") == null ? Notification.VISIBILITY_PUBLIC : Integer.parseInt(data.get("lockScreenVisibility"));
        this.forceShow = data.get("forceShow") == null ? false : Boolean.getBoolean(data.get("forceShow"));
        this.ref = data.get("ref");

        // flat structure for custom view
        this.backgroundImage = data.get("backgroundImage");
        this.backgroundImageAlign = data.get("backgroundImageAlign");
        this.customView = data.get("customView");
        this.titleColor = data.get("titleColor");
        this.bodyColor = data.get("bodyColor");
    }
}
