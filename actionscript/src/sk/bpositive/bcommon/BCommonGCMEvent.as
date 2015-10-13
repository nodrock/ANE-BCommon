/**
 * Created by nodrock on 09/10/15.
 */
package sk.bpositive.bcommon {
import flash.events.Event;

public class BCommonGCMEvent extends Event {

    public static const TOKEN:String = "BCommonGCMEvent.TOKEN";
    public static const ERROR:String = "BCommonGCMEvent.ERROR";

    public var token:String;
    public var error:BCommonErrorObject;

    public function BCommonGCMEvent(type:String, bubbles:Boolean, cancelable:Boolean)
    {
        super(type, bubbles, cancelable);
    }
}
}
