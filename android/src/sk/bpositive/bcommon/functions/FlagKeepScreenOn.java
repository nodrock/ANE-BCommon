package sk.bpositive.bcommon.functions;

import android.view.WindowManager;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import sk.bpositive.bcommon.utils.FREConversionUtil;

public class FlagKeepScreenOn implements FREFunction {

    private FREContext _context;

    @Override
    public FREObject call(FREContext context, FREObject[] args) {

        _context = context;

        Boolean activate = FREConversionUtil.toBoolean(args[0]);

        if (activate) {
            _context.getActivity().getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
        } else {
            _context.getActivity().getWindow().clearFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
        }

        return null;
    }
}
