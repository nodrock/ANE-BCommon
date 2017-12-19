package sk.bpositive.bcommon.functions;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREObject;

import java.util.Locale;

import sk.bpositive.bcommon.utils.FREConversionUtil;

/**
 * Created by nodrock on 05/11/15.
 */
public class GetLanguageCodeFunction extends BaseFunction {
    @Override
    public FREObject call(FREContext context, FREObject[] args) {

        super.call(context, args);

        String languageCode = Locale.getDefault().getLanguage();

        return FREConversionUtil.fromString(languageCode);
    }
}
