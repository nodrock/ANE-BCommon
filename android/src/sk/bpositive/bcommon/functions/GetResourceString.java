package sk.bpositive.bcommon.functions;

import android.content.Context;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.adobe.fre.FREWrongThreadException;

import sk.bpositive.bcommon.utils.FREConversionUtil;

public class GetResourceString implements FREFunction {

    @Override
    public FREObject call(FREContext freContext, FREObject[] freObjects) {

        String resource = FREConversionUtil.toString(freObjects[0]);

        Context context = freContext.getActivity().getApplicationContext();
        int resourceId = context.getResources().getIdentifier(resource, "string", context.getPackageName());

        if(resourceId != 0){
            String value = context.getResources().getString(resourceId);
            try {
                return FREObject.newObject(value);
            } catch (FREWrongThreadException e) {
                e.printStackTrace();
            }
        }

        return null;
    }

}
