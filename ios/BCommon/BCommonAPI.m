//
//  BCommonAPI.m
//  BCommon
//
//  Created by Ján Horváth on 24/09/15.
//
//

#import <Foundation/Foundation.h>
#import "BCommonAPI.h"
#import "BCommonAPIFunctions.h"
#import "BCommon.h"

//#import <UIKit/UIApplication.h>
//
//#import <objc/runtime.h>
//#import <objc/message.h>
//
//typedef void (^ RestorationHandler)(NSArray*);
//
//// Reports app open from a Universal Link for iOS 9
//static IMP __bcommon_original_continueUserActivity_Imp;
//BOOL continueUserActivity(id self, SEL _cmd, UIApplication* application, NSUserActivity* userActivity, RestorationHandler restorationHandler) {
//    NSLog(@"BCommon.continueUserActivity");
//    NSLog(@"x: %@", self);
//    NSLog(@"x: %@", userActivity.activityType);
//    NSLog(@"x: %@", userActivity.title);
//    NSLog(@"x: %@", userActivity.requiredUserInfoKeys);
//    NSLog(@"x: %@", userActivity.userInfo);
//    NSLog(@"x: %@", userActivity.referrerURL);
////    [[AppsFlyerTracker sharedTracker] continueUserActivity:userActivity restorationHandler:restorationHandler];
//    return ((BOOL(*)(id,SEL,UIApplication*,NSUserActivity*, RestorationHandler))__bcommon_original_continueUserActivity_Imp)(self, _cmd, application, userActivity, restorationHandler);
//}
//// Reports app open from deeplink for iOS 8 or below (DEPRECATED)
//static IMP __bcommon_original_openURLDeprecated_Imp;
//BOOL openURLDeprecated(id self, SEL _cmd, UIApplication* application, NSURL* url, NSString* sourceApplication, id annotation) {
//    NSLog(@"BCommon.openURLDeprecated");
//    NSLog(@"BCommon.openURLDeprecated: %@ %@ %@ %@", self, sourceApplication, url, annotation);
////    [[AppsFlyerTracker sharedTracker] handleOpenURL:url sourceApplication:sourceApplication withAnnotation:annotation];
//    return ((BOOL(*)(id, SEL, UIApplication*, NSURL*, NSString*, id))__bcommon_original_openURLDeprecated_Imp)(self, _cmd, application, url, sourceApplication, annotation);
//}
//// Reports app open from deeplink for iOS 10
//static IMP __bcommon_original_openURL_Imp;
//BOOL openURL(id self, SEL _cmd, UIApplication* application, NSURL* url, NSDictionary * options) {
//    NSLog(@"BCommon.openURL");
//    NSLog(@"BCommon.openURL: %@ %@ %@", self, url, options);
////    [[AppsFlyerTracker sharedTracker] handleOpenUrl:url options:options];
//    return ((BOOL(*)(id, SEL, UIApplication*, NSURL*, NSDictionary*))__bcommon_original_openURL_Imp)(self, _cmd, application, url, options);
//}
//
//static IMP __bcommon_original_didReceiveRemoteNotification_Imp;
//BOOL didReceiveRemoteNotificationHandler(id self, SEL _cmd, UIApplication* application, NSDictionary* userInfo) {
//    NSLog(@"BCommon.didReceiveRemoteNotification");
//    NSLog(@"BCommon.didReceiveRemoteNotification: %@", self);
////    [[AppsFlyerTracker sharedTracker] handlePushNotification:userInfo];
//    return ((BOOL(*)(id, SEL, UIApplication*, NSDictionary*))__bcommon_original_didReceiveRemoteNotification_Imp)(self, _cmd, application, userInfo);
//}

void BCommonInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet)
{
    *extDataToSet = NULL;
    *ctxInitializerToSet = &BCommonContextInitializer;
    *ctxFinalizerToSet = &BCommonContextFinalizer;
    
    if(g_notificationController == nil) {
        g_notificationController = [[NotificationController alloc] init];
    }
}

void BCommonFinalizer(void *extData)
{
    g_notificationController = nil;
}

void BCommonContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx,
                               uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet)
{
//    UIApplication *application = UIApplication.sharedApplication;
//
//    id delegate = application.delegate;
//
//    Class objectClass = object_getClass(delegate);
//
//    SEL originalContinueUserActivitySelector = @selector(application:continueUserActivity:restorationHandler:);
//    SEL originalOpenURLDeprecatedSelector = @selector(application:openURL:sourceApplication:annotation:);
//    SEL originalOpenURLSelector = @selector(application:openURL:options:);
//    SEL originalDidReceiveRemoteNotificationSelector = @selector(application:didReceiveRemoteNotification:);
//
//    Method originalContinueUserActivityMethod = class_getInstanceMethod(objectClass, originalContinueUserActivitySelector);
//    Method originalOpenURLDeprecatedMethod = class_getInstanceMethod(objectClass, originalOpenURLDeprecatedSelector);
//    Method originalOpenURLMethod = class_getInstanceMethod(objectClass, originalOpenURLSelector);
//    Method originalDidReceiveRemoteNotificationMethod = class_getInstanceMethod(objectClass, originalDidReceiveRemoteNotificationSelector);
//
//    __bcommon_original_continueUserActivity_Imp = method_setImplementation(originalContinueUserActivityMethod, (IMP)continueUserActivity);
//    __bcommon_original_openURLDeprecated_Imp = method_setImplementation(originalOpenURLDeprecatedMethod, (IMP)openURLDeprecated);
//    __bcommon_original_openURL_Imp = method_setImplementation(originalOpenURLMethod, (IMP)openURL);
//    __bcommon_original_didReceiveRemoteNotification_Imp = method_setImplementation(originalDidReceiveRemoteNotificationMethod, (IMP)didReceiveRemoteNotificationHandler);

    NSDictionary *functions = @{
                                @"isSupported":                     [NSValue valueWithPointer:&BCOMMON(isSupported)],
                                
                                @"getLanguageCode":                 [NSValue valueWithPointer:&BCOMMON(getLanguageCode)],
                                @"getAdId":                         [NSValue valueWithPointer:&BCOMMON(getAdId)],
                                @"getIDFV":                         [NSValue valueWithPointer:&BCOMMON(getIDFV)],
                                @"getIDFA":                         [NSValue valueWithPointer:&BCOMMON(getIDFA)],
                                @"getIDFATrackingEnabled":          [NSValue valueWithPointer:&BCOMMON(getIDFATrackingEnabled)],
                                @"canOpenSettings":                 [NSValue valueWithPointer:&BCOMMON(canOpenSettings)],
                                @"openSettings":                    [NSValue valueWithPointer:&BCOMMON(openSettings)],
                                @"isRemoteNotificationsEnabled":    [NSValue valueWithPointer:&BCOMMON(isRemoteNotificationsEnabled)],
                                @"getMemorySize":                   [NSValue valueWithPointer:&BCOMMON(getMemorySize)],

                                @"showSplashView":                  [NSValue valueWithPointer:&BCOMMON(showSplashView)],
                                @"hideSplashView":                  [NSValue valueWithPointer:&BCOMMON(hideSplashView)],
                                
                                @"crc32":                           [NSValue valueWithPointer:&BCOMMON(crc32)],
                                @"updateCrc32":                     [NSValue valueWithPointer:&BCOMMON(updateCrc32)],
                                @"adler32":                         [NSValue valueWithPointer:&BCOMMON(adler32)],
                                @"sha1":                            [NSValue valueWithPointer:&BCOMMON(sha1)],
                                @"md5":                             [NSValue valueWithPointer:&BCOMMON(md5)],
                                
                                @"initFirebase":                    [NSValue valueWithPointer:&BCOMMON(initFirebase)],
                                @"registerForRemoteNotifications":  [NSValue valueWithPointer:&BCOMMON(registerForRemoteNotifications)],
                                @"getFCMToken":                     [NSValue valueWithPointer:&BCOMMON(getFCMToken)],
                                
                                //@"unzipFile":                       [NSValue valueWithPointer:&BCOMMON(unzipFile)],

                                @"firebaseLogEvent":                [NSValue valueWithPointer:&BCOMMON(firebaseLogEvent)],
                                @"firebaseResetAnalyticsData":      [NSValue valueWithPointer:&BCOMMON(firebaseResetAnalyticsData)],
                                @"firebaseSetCurrentScreen":        [NSValue valueWithPointer:&BCOMMON(firebaseSetCurrentScreen)],
                                @"firebaseSetUserId":               [NSValue valueWithPointer:&BCOMMON(firebaseSetUserId)],
                                @"firebaseSetUserProperty":         [NSValue valueWithPointer:&BCOMMON(firebaseSetUserProperty)],

                                // Debug
                                @"nativeLog":                       [NSValue valueWithPointer:&BCOMMON(nativeLog)],
                                @"setNativeLogEnabled":             [NSValue valueWithPointer:&BCOMMON(setNativeLogEnabled)],
                                };
    
    *numFunctionsToTest = (uint32_t)[functions count];
    
    FRENamedFunction *func = (FRENamedFunction *)malloc(sizeof(FRENamedFunction) * [functions count]);
    
    uint32_t i = 0;
    for (NSString* functionName in functions){
        NSValue *value = functions[functionName];
        
        func[i].name = (const uint8_t *)[functionName UTF8String];
        func[i].functionData = NULL;
        func[i].function = [value pointerValue];
        i++;
    }
    
    *functionsToSet = func;
    
    [[BCommon sharedInstance] setContext:ctx];
    
    [[NSNotificationCenter defaultCenter] addObserver:[BCommon sharedInstance] selector:@selector(didReceiveMemoryWarning:) name:UIApplicationDidReceiveMemoryWarningNotification object:[UIApplication sharedApplication]];
}

void BCommonContextFinalizer(FREContext ctx)
{
    [[NSNotificationCenter defaultCenter]removeObserver:[BCommon sharedInstance] name:UIApplicationDidReceiveMemoryWarningNotification object:[UIApplication sharedApplication]];
}
