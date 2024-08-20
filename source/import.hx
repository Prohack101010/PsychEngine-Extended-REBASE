import Paths;
import mobile.SUtil;
import mobile.SwipeUtil;
import mobile.TouchUtil;
import Difficulty;
#if MODS_ALLOWED import Mods; #end

using StringTools;

#if flxanimate
import flxanimate.*;
#end

//Android
#if android
import android.content.Context as AndroidContext;
import android.widget.Toast as AndroidToast;
import android.os.Environment as AndroidEnvironment;
import android.Permissions as AndroidPermissions;
import android.Settings as AndroidSettings;
import android.Tools as AndroidTools;
import android.os.BatteryManager as AndroidBatteryManager;
#end