package sk.bpositive.bcommon.firebase;

import android.content.ContentResolver;
import android.content.Context;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.content.res.Resources;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;

import org.json.JSONObject;

import java.math.BigInteger;
import java.net.URL;
import java.util.Arrays;
import java.util.List;

import sk.bpositive.bcommon.BCommonExtension;

/**
 * Created by jhorvath on 14/12/2017.
 */

public class Utils {

    public static Integer safeGetColorFromHex(String colorString)
    {
        if(colorString == null){
            return null;
        }
        try
        {
            return new BigInteger(colorString, 16).intValue();
        }
        catch (Throwable t) {
            BCommonExtension.debug("Cannot parse color string: " + colorString, t);
        }
        return null;
    }

    public static CharSequence getTitle(Context context, String title)
    {
        if (title != null) {
            return title;
        }
        return context.getPackageManager().getApplicationLabel(context.getApplicationInfo());
    }

    private static boolean isValidResourceName(String name)
    {
        return (name != null) && (!name.matches("^[0-9]"));
    }

    public static Bitmap getLargeIcon(Context context, String largeIcon)
    {
        Bitmap bitmap = getBitmap(context, largeIcon);
        if (bitmap == null) {
            return null;
        }
        return resizeBitmapForLargeIconArea(context.getResources(), bitmap);
    }

    private static Bitmap resizeBitmapForLargeIconArea(Resources resources, Bitmap bitmap)
    {
        if (bitmap == null) {
            return null;
        }
        try
        {
            int systemLargeIconHeight = (int)resources.getDimension(android.R.dimen.notification_large_icon_height);
            int systemLargeIconWidth = (int)resources.getDimension(android.R.dimen.notification_large_icon_width);
            int bitmapHeight = bitmap.getHeight();
            int bitmapWidth = bitmap.getWidth();
            if ((bitmapWidth > systemLargeIconWidth) || (bitmapHeight > systemLargeIconHeight))
            {
                int newWidth = systemLargeIconWidth;int newHeight = systemLargeIconHeight;
                if (bitmapHeight > bitmapWidth)
                {
                    float ratio = bitmapWidth / bitmapHeight;
                    newWidth = (int)(newHeight * ratio);
                }
                else if (bitmapWidth > bitmapHeight)
                {
                    float ratio = bitmapHeight / bitmapWidth;
                    newHeight = (int)(newWidth * ratio);
                }
                return Bitmap.createScaledBitmap(bitmap, newWidth, newHeight, true);
            }
        }
        catch (Throwable localThrowable) {}
        return bitmap;
    }

    public static Bitmap getBitmapFromAssetsOrResourceName(Context context, String bitmapStr)
    {
        try
        {
            Bitmap bitmap = null;
            try
            {
                bitmap = BitmapFactory.decodeStream(context.getAssets().open(bitmapStr));
            }
            catch (Throwable localThrowable) {}
            if (bitmap != null) {
                return bitmap;
            }
            List<String> image_extensions = Arrays.asList(".png", ".webp", ".jpg", ".gif", ".bmp");
            for (String extension : image_extensions)
            {
                try
                {
                    bitmap = BitmapFactory.decodeStream(context.getAssets().open(bitmapStr + extension));
                }
                catch (Throwable localThrowable1) {}
                if (bitmap != null) {
                    return bitmap;
                }
            }
            int bitmapId = getResourceIcon(context, bitmapStr);
            if (bitmapId != 0) {
                return BitmapFactory.decodeResource(context.getResources(), bitmapId);
            }
        }
        catch (Throwable localThrowable2) {}
        return null;
    }

    private static Bitmap getBitmapFromURL(String location)
    {
        try
        {
            return BitmapFactory.decodeStream(new URL(location).openConnection().getInputStream());
        }
        catch (Throwable t)
        {
            BCommonExtension.debug("Could not download image!", t);
        }
        return null;
    }

    public static Bitmap getBitmap(Context context, String name)
    {
        if (name == null) {
            return null;
        }
        String trimmedName = name.trim();
        if ((trimmedName.startsWith("http://")) || (trimmedName.startsWith("https://"))) {
            return getBitmapFromURL(trimmedName);
        }
        return getBitmapFromAssetsOrResourceName(context, name);
    }

    private static int getResourceIcon(Context context, String iconName)
    {
        if (iconName == null) {
            return 0;
        }
        String trimmedIconName = iconName.trim();
        if (!isValidResourceName(trimmedIconName)) {
            return 0;
        }
        int notificationIcon = getDrawableId(context, trimmedIconName);
        if (notificationIcon != 0) {
            return notificationIcon;
        }
        try
        {
            return android.R.drawable.class.getField(iconName).getInt(null);
        }
        catch (Throwable localThrowable) {}
        return 0;
    }

    public static int getSmallIconId(Context context, String smallIconId)
    {
        int notificationIcon = getResourceIcon(context, smallIconId);
        if (notificationIcon != 0) {
            return notificationIcon;
        }
        return android.R.drawable.ic_popup_reminder;
    }

    private static int getDrawableId(Context context, String name)
    {
        BCommonExtension.debug("getDrawableId " + name);
        return context.getResources().getIdentifier(name, "drawable", context.getPackageName());
    }

    public static Uri getSoundUri(Context context, String sound) {

        if (sound == null){
            return null;
        }

        Resources resources = context.getResources();
        String packageName = context.getPackageName();
        int soundId;

        if (isValidResourceName(sound)) {
            soundId = resources.getIdentifier(sound, "raw", packageName);
            if (soundId != 0)
                return Uri.parse(ContentResolver.SCHEME_ANDROID_RESOURCE + "://" + packageName + "/" + soundId);
        }

        return null;
    }


}
