//
//  BCommonAPIFunctions.m
//  BCommon
//
//  Created by Ján Horváth on 24/09/15.
//
//

#import <Foundation/Foundation.h>
#import <AdSupport/AdSupport.h>
#import "BCommonAPIFunctions.h"
#import "FREConversionUtil2.h"
#import "BCommon.h"

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
    BOOL fCanOpenSettings = (&UIApplicationOpenSettingsURLString != NULL);
    
    [BCommon log:@"canOpenSettings: %@", (fCanOpenSettings ? @"YES" : @"NO")];
    
    return [FREConversionUtil2 fromBoolean:fCanOpenSettings];
}

DEFINE_ANE_FUNCTION(openSettings)
{
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

    BOOL remoteNotificationsEnabled;

    // For IOS >= 8 use isRegisteredForRemoteNotifications
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        UIUserNotificationType notificationType = [[application currentUserNotificationSettings] types];
        remoteNotificationsEnabled = [application isRegisteredForRemoteNotifications] && (notificationType & UIUserNotificationTypeAlert);
    }
    // For IOS <= 7 use enabledRemoteNotificationTypes
    else
    {
        UIRemoteNotificationType types = [application enabledRemoteNotificationTypes];
        remoteNotificationsEnabled = types & UIRemoteNotificationTypeAlert;
    }
    
    return [FREConversionUtil2 fromBoolean:remoteNotificationsEnabled];
}