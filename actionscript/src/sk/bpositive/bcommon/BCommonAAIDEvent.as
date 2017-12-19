/**
 * Created by nodrock on 28/09/15.
 */
package sk.bpositive.bcommon {
import flash.events.Event;

/**
 * @deprecated
 */
public class BCommonAAIDEvent extends Event{

    public var aaid:BCommonAAID;
    public var error:BCommonErrorObject;

    public static const AAID_COMPLETED:String = "BCommonEvent.AAID_COMPLETED";
    public static const AAID_FAILED:String = "BCommonEvent.AAID_FAILED";

    public function BCommonAAIDEvent(type:String, bubbles:Boolean, cancelable:Boolean)
    {
        super(type, bubbles, cancelable);
    }
}
}
