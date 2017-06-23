/**
 * Created by nodrock on 24/09/15.
 */
package sk.bpositive.bcommon {
import flash.events.Event;

public class BCommonEvent extends Event{

    public static const MEMORY_WARNING:String = "BCommonEvent.MEMORY_WARNING";
    public static const FCM_TOKEN:String = "BCommonEvent.FCM_TOKEN";

    public function BCommonEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
    {
        super(type, bubbles, cancelable);
    }
}
}
