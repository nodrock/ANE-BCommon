package sk.bpositive.bcommon.functions;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
//import org.zeroturnaround.zip.ZipUtil;
import sk.bpositive.bcommon.utils.FREConversionUtil;

import java.io.File;

public class UnzipFileFunction implements FREFunction {

    @Override
    public FREObject call(FREContext freContext, FREObject[] freObjects) {

//        try {
//
//            String file = FREConversionUtil.toString(freObjects[0]);
//            String destination = FREConversionUtil.toString(freObjects[1]);
//
//            File zipFile = new File(file);
//            File destinationFolder = new File(destination);
//
//            ZipUtil.unpack(zipFile, destinationFolder);
//
//            Boolean success = zipFile.exists() && destinationFolder.exists();
//
//            return FREConversionUtil.fromBoolean(success);
//
//        } catch (NullPointerException e) {
//            e.printStackTrace();
//        }

        return null;
    }

}
