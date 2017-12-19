package sk.bpositive.bcommon.functions;

import android.view.WindowManager;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREObject;

import sk.bpositive.bcommon.utils.FREConversionUtil;

public class GetFlagKeepScreenOn extends BaseFunction {

    @Override
    public FREObject call(FREContext context, FREObject[] args) {

        super.call(context, args);

        Boolean flagKeepScreenOn = (context.getActivity().getWindow().getAttributes().flags & WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON) != 0;

        return FREConversionUtil.fromBoolean(flagKeepScreenOn);
    }
}
