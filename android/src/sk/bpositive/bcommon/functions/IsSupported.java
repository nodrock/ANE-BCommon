package sk.bpositive.bcommon.functions;

import com.adobe.fre.*;
import sk.bpositive.bcommon.utils.FREConversionUtil;

import java.util.zip.CRC32;

public class IsSupported implements FREFunction {

    @Override
    public FREObject call(FREContext freContext, FREObject[] freObjects) {

        return FREConversionUtil.fromBoolean(true);
    }

}
