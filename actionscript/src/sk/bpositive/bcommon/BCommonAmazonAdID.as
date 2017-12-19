/**
 * Created by nodrock on 28/09/15.
 */
package sk.bpositive.bcommon {
public class BCommonAmazonAdID {

    public var id:String;
    public var limitAdTracking:Boolean;

    public function BCommonAmazonAdID()
    {
    }

    public static function createFromJSON(json:String):BCommonAmazonAdID
    {
        var jsonObject:Object = JSON.parse(json);
        if(jsonObject.hasOwnProperty("error")){
            return null;
        }
        var id:BCommonAmazonAdID = new BCommonAmazonAdID();
        id.id = jsonObject["id"] as String;
        id.limitAdTracking = jsonObject["limitAdTracking"] as Boolean;
        return id;
    }
}
}
