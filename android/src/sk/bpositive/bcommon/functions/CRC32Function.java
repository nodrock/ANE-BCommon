package sk.bpositive.bcommon.functions;

import com.adobe.fre.*;

import java.util.zip.CRC32;

public class CRC32Function implements FREFunction {

    @Override
    public FREObject call(FREContext freContext, FREObject[] freObjects) {

        try {

            FREByteArray byteArray = (FREByteArray) freObjects[0];

            byteArray.acquire();

            CRC32 crc32 = new CRC32();
            crc32.update(byteArray.getBytes().array());
            long crc = crc32.getValue();

            byteArray.release();

            return FREObject.newObject(crc);

        } catch (FREInvalidObjectException e) {
            e.printStackTrace();
        } catch (FREWrongThreadException e) {
            e.printStackTrace();
        } catch (NullPointerException e) {
            e.printStackTrace();
        }

        return null;
    }

}
