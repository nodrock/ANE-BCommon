//
//  BCommonAPIFunctions.h
//  BCommon
//
//  Created by Ján Horváth on 24/09/15.
//
//

#import "FlashRuntimeExtensions.h"

#define PREFIX(fnprefix,fn) fnprefix##_##fn
#define BCOMMON(fn) PREFIX(BCommon,fn)
#define DEFINE_ANE_FUNCTION(fn) FREObject BCOMMON(fn)(FREContext context, void* functionData, uint32_t argc, FREObject argv[])

// C interface
DEFINE_ANE_FUNCTION(isSupported);

// Debug
DEFINE_ANE_FUNCTION(nativeLog);
DEFINE_ANE_FUNCTION(setNativeLogEnabled);
DEFINE_ANE_FUNCTION(getLanguageCode);
DEFINE_ANE_FUNCTION(getAdId);
DEFINE_ANE_FUNCTION(getIDFV);
DEFINE_ANE_FUNCTION(getIDFA);
DEFINE_ANE_FUNCTION(getIDFATrackingEnabled);

DEFINE_ANE_FUNCTION(canOpenSettings);
DEFINE_ANE_FUNCTION(openSettings);
DEFINE_ANE_FUNCTION(isRemoteNotificationsEnabled);

DEFINE_ANE_FUNCTION(showSplashView);
DEFINE_ANE_FUNCTION(hideSplashView);

DEFINE_ANE_FUNCTION(crc32);
DEFINE_ANE_FUNCTION(updateCrc32);
DEFINE_ANE_FUNCTION(adler32);
DEFINE_ANE_FUNCTION(sha1);
DEFINE_ANE_FUNCTION(md5);

DEFINE_ANE_FUNCTION(unzipFile);

DEFINE_ANE_FUNCTION(initFirebase);
DEFINE_ANE_FUNCTION(registerForRemoteNotifications);
DEFINE_ANE_FUNCTION(getFCMToken);
