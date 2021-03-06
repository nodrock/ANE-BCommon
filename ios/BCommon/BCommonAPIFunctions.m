//
//  BCommonAPIFunctions.m
//  BCommon
//
//  Created by Ján Horváth on 24/09/15.
//
//

#import <Foundation/Foundation.h>
#import <AdSupport/AdSupport.h>
//#import <ZipArchive/ZipArchive.h>
#import "BCommonAPIFunctions.h"
#import "FREConversionUtil2.h"
#import "BCommon.h"

#import "BCommonAPI.h"
#import "NotificationController.h"

#import <zlib.h>
#import <CommonCrypto/CommonDigest.h>
#import "Firebase.h"
#import "BCommonEvents.h"

DEFINE_ANE_FUNCTION(isSupported)
{
    return [FREConversionUtil2 fromBoolean:YES];
}

DEFINE_ANE_FUNCTION(nativeLog)
{
    NSString *message = [FREConversionUtil2 toString:argv[0]];
    
    // NOTE: logs from as3 should go only to native log
    [BCommon nativeLog:message withPrefix:@"AS3"];
    
    return nil;
}


DEFINE_ANE_FUNCTION(setNativeLogEnabled)
{
    BOOL nativeLogEnabled = [FREConversionUtil2 toBoolean:argv[0]];
    
    [[BCommon sharedInstance] setNativeLogEnabled:nativeLogEnabled];
    
    return nil;
}

DEFINE_ANE_FUNCTION(crc32)
{
    FREByteArray byteArray;
    FREAcquireByteArray(argv[0], &byteArray);
    
    uint32_t crc = (uint32_t) crc32(0L, byteArray.bytes, byteArray.length);
    
    FREReleaseByteArray(argv[0]);
    
    return [FREConversionUtil2 fromUInt:crc];
}

DEFINE_ANE_FUNCTION(updateCrc32)
{
    FREByteArray byteArray;
    uint32_t crc = (uint32_t)[FREConversionUtil2 toUInt:argv[0]];
    FREAcquireByteArray(argv[1], &byteArray);
    uint32_t offset = (uint32_t)[FREConversionUtil2 toUInt:argv[2]];
    uint32_t length = (uint32_t)[FREConversionUtil2 toUInt:argv[3]];
    
    if (offset + length <= byteArray.length){
        crc = (uint32_t) crc32(crc, byteArray.bytes + offset, length);
    }
    
    FREReleaseByteArray(argv[1]);
    
    return [FREConversionUtil2 fromUInt:crc];
}

DEFINE_ANE_FUNCTION(adler32)
{
    FREByteArray byteArray;
    FREAcquireByteArray(argv[0], &byteArray);
    
    uint32_t adler = (uint32_t) adler32(0L, byteArray.bytes, byteArray.length);
    
    FREReleaseByteArray(argv[0]);
    
    return [FREConversionUtil2 fromUInt:adler];
}

DEFINE_ANE_FUNCTION(sha1)
{
    FREByteArray byteArray;
    FREAcquireByteArray(argv[0], &byteArray);
    
    unsigned char digest_sha1[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(byteArray.bytes, byteArray.length, digest_sha1);
    
    FREReleaseByteArray(argv[0]);
    
    return [FREConversionUtil2 fromString:[FREConversionUtil2 toHexString:digest_sha1 length:CC_SHA1_DIGEST_LENGTH]];
}


DEFINE_ANE_FUNCTION(md5)
{
    FREByteArray byteArray;
    FREAcquireByteArray(argv[0], &byteArray);
    
    unsigned char digest_md5[CC_MD5_DIGEST_LENGTH];
    CC_MD5(byteArray.bytes, byteArray.length, digest_md5);
    
    FREReleaseByteArray(argv[0]);

    return [FREConversionUtil2 fromString:[FREConversionUtil2 toHexString:digest_md5 length:CC_MD5_DIGEST_LENGTH]];
}

DEFINE_ANE_FUNCTION(getIDFV)
{
    NSString* idString = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    [BCommon log:@"identifierForVendor: %@", idString];
    
    return [FREConversionUtil2 fromString:idString];
}

DEFINE_ANE_FUNCTION(getLanguageCode)
{
    NSLocale* locale = [[NSLocale alloc] initWithLocaleIdentifier:[[NSLocale preferredLanguages] firstObject]];
    NSString* languageCode = [locale objectForKey:NSLocaleLanguageCode];
        
    [BCommon log:@"getLanguageCode: %@", languageCode];

    return [FREConversionUtil2 fromString:languageCode];
}

DEFINE_ANE_FUNCTION(getAdId)
{
    NSString* idString = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    BOOL advertisingTrackingEnabled = [[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled];

    NSString* json = [BCommon jsonStringFromObject:
            @{
                    @"type": @"IDFA",
                    @"id": idString,
                    @"trackingEnabled": (advertisingTrackingEnabled ? @YES : @NO)
            } andPrettyPrint:true];

    [[BCommon sharedInstance] dispatchEvent:BCOMMON_EVENT_AD_IDENTIFIER withData:json];

    return [FREConversionUtil2 fromString:json];
}

DEFINE_ANE_FUNCTION(getIDFA)
{
    NSString* idString = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        
    [BCommon log:@"advertisingIdentifier: %@", idString];
 
    return [FREConversionUtil2 fromString:idString];
}

DEFINE_ANE_FUNCTION(getIDFATrackingEnabled)
{
    BOOL advertisingTrackingEnabled = [[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled];
    
    [BCommon log:@"advertisingTrackingEnabled: %@", (advertisingTrackingEnabled ? @"YES" : @"NO")];
    
    return [FREConversionUtil2 fromBoolean:advertisingTrackingEnabled];
}

DEFINE_ANE_FUNCTION(canOpenSettings)
{
    // IOS >= 8 this should be true
    BOOL fCanOpenSettings = (&UIApplicationOpenSettingsURLString != NULL);
    
    [BCommon log:@"canOpenSettings: %@", (fCanOpenSettings ? @"YES" : @"NO")];
    
    return [FREConversionUtil2 fromBoolean:fCanOpenSettings];
}

DEFINE_ANE_FUNCTION(openSettings)
{
    // IOS >= 8 this should be true
    BOOL fCanOpenSettings = (&UIApplicationOpenSettingsURLString != NULL);
    
    [BCommon log:@"openSettings: %@", (fCanOpenSettings ? @"YES" : @"NO")];

    if (fCanOpenSettings) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:url];
    }
    
    return nil;
}

DEFINE_ANE_FUNCTION(isRemoteNotificationsEnabled)
{
    UIApplication *application = [UIApplication sharedApplication];

    BOOL remoteNotificationsEnabled = [application isRegisteredForRemoteNotifications];
    
    return [FREConversionUtil2 fromBoolean:remoteNotificationsEnabled];
}

DEFINE_ANE_FUNCTION(unzipFile)
{
//    NSString *file = [FREConversionUtil2 toString:argv[0]];
//    NSString *destination = [FREConversionUtil2 toString:argv[1]];
    
//    BOOL success = [SSZipArchive unzipFileAtPath:file toDestination:destination];
    
//    return [FREConversionUtil2 fromBoolean:success];
    return nil;
}

UIImageView *splashView;

DEFINE_ANE_FUNCTION(showSplashView)
{
    UIApplication *application = [UIApplication sharedApplication];
    UIView *keyWindow = [application keyWindow];
    
    splashView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default.png"]];
    
    [BCommon log:@"showSplashView: %@", splashView];
    
    [keyWindow addSubview:splashView];

    return nil;
}

DEFINE_ANE_FUNCTION(hideSplashView)
{
    [splashView removeFromSuperview];
    
    return nil;
}

DEFINE_ANE_FUNCTION(initFirebase)
{
    if ([FIRApp defaultApp] == nil) {
        [FIRApp configure];
    }
    
    return nil;
}

DEFINE_ANE_FUNCTION(firebaseLogEvent)
{
    NSString *eventName = [FREConversionUtil2 toString:argv[0]];
    NSDictionary *eventParams = [FREConversionUtil2 toDictionary:argv[1]];

    [BCommon log:@"firebaseLogEvent: %@", eventName];

    [FIRAnalytics logEventWithName:eventName parameters:eventParams];

    return nil;
}

DEFINE_ANE_FUNCTION(firebaseResetAnalyticsData)
{
    // TODO: no method for this in Objective C
    [BCommon log:@"firebaseResetAnalyticsData -> no method in Objective-C for this!"];

    return nil;
}

DEFINE_ANE_FUNCTION(firebaseSetCurrentScreen)
{
    NSString *screenName = [FREConversionUtil2 toString:argv[0]];

    [BCommon log:@"firebaseSetCurrentScreen: %@", screenName];

    [FIRAnalytics setScreenName:screenName screenClass:nil];

    return nil;
}

DEFINE_ANE_FUNCTION(firebaseSetUserId)
{
    NSString *userId = [FREConversionUtil2 toString:argv[0]];

    [BCommon log:@"firebaseSetUserId: %@", userId];

    [FIRAnalytics setUserID:userId];

    return nil;
}

DEFINE_ANE_FUNCTION(firebaseSetUserProperty)
{
    NSString *name = [FREConversionUtil2 toString:argv[0]];
    NSString *value = [FREConversionUtil2 toString:argv[1]];

    [BCommon log:@"firebaseSetUserProperty: %@: %@", name, value];

    [FIRAnalytics setUserPropertyString:value forName:name];

    return nil;
}


DEFINE_ANE_FUNCTION(registerForRemoteNotifications)
{
    [BCommon log:@"ANE registerForRemoteNotifications"];
    [g_notificationController registerForRemoteNotifications];
    
    return nil;
}

DEFINE_ANE_FUNCTION(getFCMToken)
{
    [BCommon log:@"ANE getFCMToken"];
    NSString *fcmToken = g_notificationController.FCMToken;
    [BCommon log:@"FCM_TOKEN: %@", fcmToken];
    [[BCommon sharedInstance] dispatchEvent:BCOMMON_EVENT_FCM_TOKEN withData:fcmToken];
    
    return nil;
}

DEFINE_ANE_FUNCTION(getMemorySize)
{
    [BCommon log:@"ANE getMemorySize"];

    return [FREConversionUtil2 fromNumber:@([NSProcessInfo processInfo].physicalMemory)];
}
