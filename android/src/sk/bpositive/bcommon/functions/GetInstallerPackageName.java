package sk.bpositive.bcommon.functions;

import android.content.Context;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import sk.bpositive.bcommon.utils.FREConversionUtil;

/**
 * Gets PackageManager.getInstallerPackageName()
 */
public class GetInstallerPackageName implements FREFunction {
    @Override
    public FREObject call(FREContext ctx, FREObject[] args) {

        try {
            Context context = ctx.getActivity().getApplicationContext();
            String packageName = context.getPackageName();
            String installerPackageName = context.getPackageManager().getInstallerPackageName(packageName);

            return FREConversionUtil.fromString(installerPackageName);
        }catch(Exception e){
            return null;
        }
    }
}
