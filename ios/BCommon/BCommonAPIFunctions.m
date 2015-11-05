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
#import "FREConversionUtil.h"
#import "BCommon.h"

DEFINE_ANE_FUNCTION(nativeLog)
{
    NSString *message = [FREConversionUtil toString:argv[0]];
    
    // NOTE: logs from as3 should go only to native log
    [BCommon nativeLog:message withPrefix:@"AS3"];
    
    return nil;
}


DEFINE_ANE_FUNCTION(setNativeLogEnabled)
{
    BOOL nativeLogEnabled = [FREConversionUtil toBoolean:argv[0]];
    
    [[BCommon sharedInstance] setNativeLogEnabled:nativeLogEnabled];
    
    return nil;
}

DEFINE_ANE_FUNCTION(getIDFV)
{
    NSString* idString = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        
    [BCommon log:@"identifierForVendor: %@", idString];

    return [FREConversionUtil fromString:idString];
}

DEFINE_ANE_FUNCTION(getLanguageCode)
{
    NSLocale* locale = [[NSLocale alloc] initWithLocaleIdentifier:[[NSLocale preferredLanguages] firstObject]];
    NSString* languageCode = [locale objectForKey:NSLocaleLanguageCode];
        
    [BCommon log:@"getLanguageCode: %@", languageCode];

    return [FREConversionUtil fromString:languageCode];
}

DEFINE_ANE_FUNCTION(getIDFA)
{
    NSString* idString = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        
    [BCommon log:@"advertisingIdentifier: %@", idString];
 
    return [FREConversionUtil fromString:idString];
}

DEFINE_ANE_FUNCTION(getIDFATrackingEnabled)
{
    BOOL advertisingTrackingEnabled = [[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled];
    
    [BCommon log:@"advertisingTrackingEnabled: %@", (advertisingTrackingEnabled ? @"YES" : @"NO")];
    
    return [FREConversionUtil fromBoolean:advertisingTrackingEnabled];
}