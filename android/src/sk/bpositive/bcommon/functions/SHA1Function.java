package sk.bpositive.bcommon.functions;

import com.adobe.fre.*;

import java.math.BigInteger;
import java.nio.ByteBuffer;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class SHA1Function implements FREFunction {

    @Override
    public FREObject call(FREContext freContext, FREObject[] freObjects) {

        try {
            FREByteArray byteArray = (FREByteArray) freObjects[0];

            byteArray.acquire();

            MessageDigest md = MessageDigest.getInstance("SHA-1");

            ByteBuffer byteBuffer = byteArray.getBytes();
            md.update(byteBuffer);

            byte[] digest = md.digest();
            BigInteger number = new BigInteger(1, digest);
            String digestString = number.toString(16);

            byteArray.release();

            return FREObject.newObject(digestString);

        } catch (FREInvalidObjectException e) {
            e.printStackTrace();
        } catch (FREWrongThreadException e) {
            e.printStackTrace();
        } catch (NullPointerException e) {
            e.printStackTrace();
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }

        return null;
    }

}
