/**
 * Created by nodrock on 21/04/2017.
 */
package sk.bpositive.bcommon.common {
import flash.events.EventDispatcher;
import flash.events.StatusEvent;
import flash.utils.getDefinitionByName;

public class ExtensionWrapper extends EventDispatcher{

	private var _extensionContext:EventDispatcher;

	public function ExtensionWrapper(extensionId:String)
	{
		try{
			var clazz:Class = getDefinitionByName("flash.external.ExtensionContext") as Class;
			_extensionContext = clazz["createExtensionContext"](extensionId, null);
			if(_extensionContext != null){
				// check if extension really exists - default platform creates empty context (e.g. MacOS-x86-64)
				var callFunction:Function = _extensionContext["call"];
				if(callFunction.call(_extensionContext, "isSupported")){
					_extensionContext.addEventListener(StatusEvent.STATUS, onStatus);
				}
			}
		}catch(e:Error){
			_extensionContext = null;
			trace("ExtensionContext was not created!", e)
		}
	}

	public function get isSupported():Boolean
	{
		return _extensionContext != null;
	}

	private function onStatus(event:StatusEvent):void
	{
		dispatchEvent(event);
	}

	public function call(functionName:String, ...args):Object
	{
		trace("call", functionName, args, "context:",_extensionContext)
		if(_extensionContext == null){
			trace("Context is not initialized or wrong platform! Can't call function: " + functionName);
			return null;
		}
		return _extensionContext["call"].apply(_extensionContext, [functionName].concat(args));
	}

	public function dispose():void
	{
		if(_extensionContext == null){
			return;
		}
		_extensionContext["dispose"]();
		_extensionContext = null;
	}
}
}
