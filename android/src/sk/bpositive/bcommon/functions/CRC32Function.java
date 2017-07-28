package sk.bpositive.bcommon.functions;

import com.adobe.fre.*;
import sk.bpositive.bcommon.BCommonExtension;

import java.nio.ByteBuffer;
import java.util.zip.CRC32;

public class CRC32Function implements FREFunction {

    private static final int BUFFER_SIZE = 4096;

    @Override
    public FREObject call(FREContext freContext, FREObject[] freObjects) {

        try {
            FREByteArray byteArray = (FREByteArray) freObjects[0];

            byteArray.acquire();

            byte buffer[] = new byte[BUFFER_SIZE];
            CRC32 crc32 = new CRC32();

            ByteBuffer byteBuffer = byteArray.getBytes();
            int remainingBytes = byteBuffer.remaining();
            while (remainingBytes > 0) {
                int len = remainingBytes > BUFFER_SIZE ? BUFFER_SIZE : remainingBytes;
                byteBuffer.get(buffer, 0, len);
                crc32.update(buffer, 0, len);
                remainingBytes = byteBuffer.remaining();
            }
            long crc = crc32.getValue();

            byteArray.release();

            return FREObject.newObject(crc);

        } catch (FREInvalidObjectException e) {
            e.printStackTrace();
        } catch (FREWrongThreadException e) {
            e.printStackTrace();
        } catch (NullPointerException e) {
            e.printStackTrace();
        } catch (IllegalStateException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

}
