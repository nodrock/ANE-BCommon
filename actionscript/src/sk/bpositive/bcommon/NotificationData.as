/**
 * Created by nodrock on 06/06/2017.
 */
package sk.bpositive.bcommon {
public class NotificationData {

    public var messageId:String;
    public var ref:String;
    public var action:String;
    public var actionTime:String;

    public static function initByJson(json:String):NotificationData
    {
        try {
            var obj:Object = JSON.parse(json);
            var notificationData:NotificationData = new NotificationData();
            notificationData.messageId = obj["messageId"];
            notificationData.ref = obj["ref"];
            notificationData.action = obj["action"];
            notificationData.actionTime = obj["actionTime"];
            return notificationData;
        } catch (e:Error) {
            trace("NotificationData creation failed! notificationData:", json)
        }
        return null;
    }

    public function toString():String
    {
        return "NotificationData{messageId=" + String(messageId) + ",ref=" + String(ref) + ",action=" + String(action) + ",actionTime=" + String(actionTime) + "}";
    }

    public function NotificationData()
    {
    }
}
}
