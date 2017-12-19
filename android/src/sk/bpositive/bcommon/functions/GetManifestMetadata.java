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

public class GetManifestMetadata extends BaseFunction {
    
    @Override
    public FREObject call(FREContext context, FREObject[] args) {

        super.call(context, args);

        String metaName = FREConversionUtil.toString(args[0]);

        try {
            Context ctx = context.getActivity().getApplicationContext();
            ApplicationInfo applicationInfo = ctx.getPackageManager().getApplicationInfo(ctx.getPackageName(), PackageManager.GET_META_DATA);
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
