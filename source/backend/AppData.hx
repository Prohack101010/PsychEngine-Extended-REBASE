package backend;

#if android
import android.os.AppDetails;

class AppData
{
    public static function getAppVersionName():String {
        return AppDetails.getAppVersionName();
    }

    public static function getAppPackageName():String {
        return AppDetails.getAppPackageName();
    }

    public static function getAppName():String {
        return AppDetails.getAppName();
    }
}
#end