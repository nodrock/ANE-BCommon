package sk.bpositive.bcommon.functions;

import com.adobe.fre.FREByteArray;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREInvalidObjectException;
import com.adobe.fre.FREObject;
import com.adobe.fre.FREWrongThreadException;

import java.nio.ByteBuffer;
import java.util.zip.CRC32;

public class CRC32Function extends BaseFunction {

    private static final int BUFFER_SIZE = 4096;

    @Override
    public FREObject call(FREContext context, FREObject[] args) {

        super.call(context, args);

        try {
            FREByteArray byteArray = (FREByteArray) args[0];

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
