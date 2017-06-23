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
    NSDictionary *functions = @{
                                @"isSupported":                     [NSValue valueWithPointer:&BCOMMON(isSupported)],
                                
                                @"getLanguageCode":                 [NSValue valueWithPointer:&BCOMMON(getLanguageCode)],
                                @"getIDFV":                         [NSValue valueWithPointer:&BCOMMON(getIDFV)],
                                @"getIDFA":                         [NSValue valueWithPointer:&BCOMMON(getIDFA)],
                                @"getIDFATrackingEnabled":          [NSValue valueWithPointer:&BCOMMON(getIDFATrackingEnabled)],
                                @"canOpenSettings":                 [NSValue valueWithPointer:&BCOMMON(canOpenSettings)],
                                @"openSettings":                    [NSValue valueWithPointer:&BCOMMON(openSettings)],
                                @"isRemoteNotificationsEnabled":    [NSValue valueWithPointer:&BCOMMON(isRemoteNotificationsEnabled)],
                                
                                @"showSplashView":                  [NSValue valueWithPointer:&BCOMMON(showSplashView)],
                                @"hideSplashView":                  [NSValue valueWithPointer:&BCOMMON(hideSplashView)],
                                
                                @"crc32":                           [NSValue valueWithPointer:&BCOMMON(crc32)],
                                @"adler32":                         [NSValue valueWithPointer:&BCOMMON(adler32)],
                                @"sha1":                            [NSValue valueWithPointer:&BCOMMON(sha1)],
                                @"md5":                             [NSValue valueWithPointer:&BCOMMON(md5)],
                                
                                @"initFirebase":                    [NSValue valueWithPointer:&BCOMMON(initFirebase)],
                                @"registerForRemoteNotifications":  [NSValue valueWithPointer:&BCOMMON(registerForRemoteNotifications)],
                                @"getFCMToken":                     [NSValue valueWithPointer:&BCOMMON(getFCMToken)],
                                
                                //@"unzipFile":                       [NSValue valueWithPointer:&BCOMMON(unzipFile)],
                                
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


