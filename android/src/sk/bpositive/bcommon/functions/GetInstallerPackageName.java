package sk.bpositive.bcommon.functions;

import android.content.Context;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREObject;

import sk.bpositive.bcommon.utils.FREConversionUtil;

/**
 * Gets PackageManager.getInstallerPackageName()
 */
public class GetInstallerPackageName extends BaseFunction {
    @Override
    public FREObject call(FREContext context, FREObject[] args) {

        super.call(context, args);

        try {
            Context ctx = context.getActivity().getApplicationContext();
            String packageName = ctx.getPackageName();
            String installerPackageName = ctx.getPackageManager().getInstallerPackageName(packageName);

            return FREConversionUtil.fromString(installerPackageName);
        }catch(Exception e){
            return null;
        }
    }
}
