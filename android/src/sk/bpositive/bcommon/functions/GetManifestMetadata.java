package sk.bpositive.bcommon.functions;

import android.content.Context;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.os.Bundle;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.adobe.fre.FREWrongThreadException;

import sk.bpositive.bcommon.utils.FREConversionUtil;

public class GetManifestMetadata implements FREFunction {
    
    @Override
    public FREObject call(FREContext freContext, FREObject[] freObjects) {

        String metaName = FREConversionUtil.toString(freObjects[0]);

        try {
            Context context = freContext.getActivity().getApplicationContext();
            ApplicationInfo applicationInfo = context.getPackageManager().getApplicationInfo(context.getPackageName(), PackageManager.GET_META_DATA);
            Bundle bundle = applicationInfo.metaData;
            return FREObject.newObject(bundle.getString(metaName));
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        } catch (FREWrongThreadException e) {
            e.printStackTrace();
        }

        return null;
    }

}
