/**
 * Created by nodrock on 28/09/15.
 */
package sk.bpositive.bcommon {
/**
 * @deprecated
 */
public class BCommonAAID {

    private var _id:String;
    private var _limitAdTrackingEnabled:Boolean;

    public function BCommonAAID()
    {
    }

    public static function createFromJSON(json:String):BCommonAAID
    {
        var aaid:BCommonAAID = new BCommonAAID();
        var jsonObject:Object = JSON.parse(json);
        aaid._id = jsonObject["id"] as String;
        aaid._limitAdTrackingEnabled = !(jsonObject["trackingEnabled"] as Boolean);
        return aaid;
    }

    public function getId():String
    {
        return _id;
    }

    public function isLimitAdTrackingEnabled():Boolean
    {
        return _limitAdTrackingEnabled;
    }
}
}
