package sk.bpositive.bcommon {
public class BCommonErrorObject {

    private var _error:String;
    private var _message:String;

    public function BCommonErrorObject()
    {
    }

    public static function createFromJSON(json:String):BCommonErrorObject
    {
        var errorObject:BCommonErrorObject = new BCommonErrorObject();
        var jsonObject:Object = JSON.parse(json);
        errorObject._error = jsonObject["error"] as String;
        errorObject._message = jsonObject["message"] as String;
        return errorObject;
    }

    public static function create(error:String, message:String):BCommonErrorObject
    {
        var errorObject:BCommonErrorObject = new BCommonErrorObject();
        errorObject._error = error;
        errorObject._message = message;
        return errorObject;
    }

    public function toString():String
    {
        return "BCommonErrorObject{error=" + _error + ",message=" + _message + "}";
    }
}
}
