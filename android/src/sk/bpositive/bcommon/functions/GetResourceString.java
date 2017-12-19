package sk.bpositive.bcommon.functions;

import android.content.Context;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.adobe.fre.FREWrongThreadException;

import sk.bpositive.bcommon.utils.FREConversionUtil;

public class GetResourceString extends BaseFunction {

    @Override
    public FREObject call(FREContext context, FREObject[] args) {

        super.call(context, args);

        String resource = FREConversionUtil.toString(args[0]);

        Context ctx = context.getActivity().getApplicationContext();
        int resourceId = ctx.getResources().getIdentifier(resource, "string", ctx.getPackageName());

        if(resourceId != 0){
            String value = ctx.getResources().getString(resourceId);
            try {
                return FREObject.newObject(value);
            } catch (FREWrongThreadException e) {
                e.printStackTrace();
            }
        }

        return null;
    }

}
