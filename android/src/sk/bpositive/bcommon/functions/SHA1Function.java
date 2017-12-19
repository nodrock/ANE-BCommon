package sk.bpositive.bcommon.functions;

import com.adobe.fre.FREByteArray;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREInvalidObjectException;
import com.adobe.fre.FREObject;
import com.adobe.fre.FREWrongThreadException;

import java.math.BigInteger;
import java.nio.ByteBuffer;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class SHA1Function extends BaseFunction {

    @Override
    public FREObject call(FREContext context, FREObject[] args) {

        super.call(context, args);

        try {
            FREByteArray byteArray = (FREByteArray) args[0];

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
