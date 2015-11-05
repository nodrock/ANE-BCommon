package sk.bpositive.bcommon.functions;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import sk.bpositive.bcommon.utils.FREConversionUtil;

import java.util.Locale;

/**
 * Created by nodrock on 05/11/15.
 */
public class GetLanguageCodeFunction implements FREFunction {
    @Override
    public FREObject call(FREContext freContext, FREObject[] freObjects) {

        String languageCode = Locale.getDefault().getLanguage();

        return FREConversionUtil.fromString(languageCode);
    }
}
