package sk.bpositive.bcommon.functions;

import android.os.Build;
import android.view.View;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import sk.bpositive.bcommon.utils.FREConversionUtil;

/**
 * Created by nodrock on 19/10/16.
 */
public class ImmersiveModeFunction implements FREFunction {
    @Override
    public FREObject call(FREContext context, FREObject[] args) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.KITKAT)
        {
            return FREConversionUtil.fromBoolean(false);
        }
        else{

            try {
                Boolean isSticky = FREConversionUtil.toBoolean(args[0]);

                int immersive = isSticky
                        ? View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY
                        : View.SYSTEM_UI_FLAG_IMMERSIVE;

                final int uiOptions =
                        View.SYSTEM_UI_FLAG_LAYOUT_STABLE
                                | View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
                                | View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
                                | View.SYSTEM_UI_FLAG_HIDE_NAVIGATION
                                | View.SYSTEM_UI_FLAG_FULLSCREEN
                                | immersive;

                context.getActivity().getWindow().getDecorView().setSystemUiVisibility(uiOptions);

                return FREConversionUtil.fromBoolean(true);

            }catch (Exception e){

                return FREConversionUtil.fromBoolean(false);
            }
        }
    }
}
