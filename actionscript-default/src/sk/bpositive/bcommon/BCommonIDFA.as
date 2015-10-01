/**
 * Created by nodrock on 28/09/15.
 */
package sk.bpositive.bcommon {
public class BCommonIDFA {

    private var _advertisingIdentifier:String;
    private var _advertisingTrackingEnabled:Boolean;

    public function BCommonIDFA()
    {
    }

    public static function createFrom(id:String, trackingEnabled:Boolean):BCommonIDFA
    {
        var idfa:BCommonIDFA = new BCommonIDFA();
        idfa._advertisingIdentifier = id;
        idfa._advertisingTrackingEnabled = trackingEnabled;
        return idfa;
    }

    public function getAdvertisingIdentifier():String
    {
        return _advertisingIdentifier;
    }

    public function isAdvertisingTrackingEnabled():Boolean
    {
        return _advertisingTrackingEnabled;
    }
}
}
