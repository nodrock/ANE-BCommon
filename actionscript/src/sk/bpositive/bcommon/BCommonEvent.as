/**
 * Created by nodrock on 24/09/15.
 */
package sk.bpositive.bcommon {
import flash.events.Event;

public class BCommonEvent extends Event{

    public static const MEMORY_WARNING:String = "BCommonEvent.MEMORY_WARNING";
    public static const FCM_TOKEN:String = "BCommonEvent.FCM_TOKEN";

    /**
     * Event with advertising identifier data.
     *
     * Json format of data:
     * <code>
     *  {
     *      "type": "IDFA",
     *      "error": "error message",   [may not be present if there is no error]
     *      "id": "xxx",                [may be null if there is error]
     *      "trackingEnabled": true
     *  }
     * </code>
     *
     * Currently these types are supported: IDFA, AAID, AmazonAdID
     */
    public static const AD_IDENTIFIER:String = "BCommonEvent.AD_IDENTIFIER";

    public var data:String;

    public function BCommonEvent(type:String, data:String = null, bubbles:Boolean = false, cancelable:Boolean = false)
    {
        super(type, bubbles, cancelable);

        this.data = data;
    }
}
}
