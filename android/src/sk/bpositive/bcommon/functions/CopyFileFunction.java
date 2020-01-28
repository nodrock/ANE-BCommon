package sk.bpositive.bcommon.functions;

import android.util.Log;

import java.io.InputStream;
import java.io.OutputStream;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.FileOutputStream;
import java.io.File;

import android.app.Activity;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREObject;

import sk.bpositive.bcommon.BCommonExtension;
import sk.bpositive.bcommon.utils.FREConversionUtil;

public class CopyFileFunction extends BaseFunction {

    @Override
    public FREObject call(FREContext context, FREObject[] args) {

        super.call(context, args);
        try {
            String sourceUri = FREConversionUtil.toString(args[0]);

            BCommonExtension.log("Copy file: " + sourceUri);

            Activity activity = context.getActivity();
            File files = activity.getFilesDir(); 
            File root = files.getParentFile();

            File source = new File(root.getPath() + sourceUri);
            File destin = new File(files.getPath() + "/" + source.getName());

            BCommonExtension.log(" - copy source:[" + source + "] destination:[" + destin + "]");

            copy(source, destin);
    
        } catch(Exception e) {
            e.printStackTrace();

            return FREConversionUtil.fromBoolean(false);
        }

        return FREConversionUtil.fromBoolean(true);
    }

    public static void copy(File src, File dst) throws IOException {

        InputStream in = new FileInputStream(src);
        try {
            OutputStream out = new FileOutputStream(dst);
            try {
                // Transfer bytes from in to out
                byte[] buf = new byte[1024];
                int len;
                while ((len = in.read(buf)) > 0) {
                    out.write(buf, 0, len);
                }
            } finally {
                out.close();
            }
        } finally {
            in.close();
        }
    }

    private static void directoryList(File directory) {

        BCommonExtension.log("directoryList: " + directory.getName() + " : " + directory.getAbsolutePath() + " : " + directory.exists());
        
        if (directory.isDirectory()) {

            File[] files = directory.listFiles();
            if (files == null) {
                return;
            }

            Log.e("Files", "files:" + files.length);
            for (int i = 0; i < files.length; i++)
            {
                File file = files[i];
                boolean isDir = file.isDirectory();
                if (isDir) {
                    BCommonExtension.log("dir: [ " + file.getAbsolutePath() + " ]");
    
                    if(file.listFiles() != null) directoryList(file);
    
                } else {
                    BCommonExtension.log(" - " + file.getName());
                }
            }
        }
    }
}
