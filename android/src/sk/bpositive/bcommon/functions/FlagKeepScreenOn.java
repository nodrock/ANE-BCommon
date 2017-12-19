package sk.bpositive.bcommon.functions;

import android.view.WindowManager;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREObject;

import sk.bpositive.bcommon.utils.FREConversionUtil;

public class FlagKeepScreenOn extends BaseFunction {

    @Override
    public FREObject call(FREContext context, FREObject[] args) {

        super.call(context, args);

        Boolean activate = FREConversionUtil.toBoolean(args[0]);

        if (activate) {
            context.getActivity().getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
        } else {
            context.getActivity().getWindow().clearFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
        }

        return null;
    }
}
