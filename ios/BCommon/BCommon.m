//////////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2012 Freshplanet (http://freshplanet.com | opensource@freshplanet.com)
//  
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//  
//    http://www.apache.org/licenses/LICENSE-2.0
//  
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//  
//////////////////////////////////////////////////////////////////////////////////////
//

#import "BCommon.h"
#import "FREConversionUtil.h"

FREContext AirFBCtx = nil;

@implementation AirFacebook {
    
    NSMutableDictionary *shareActivities;
}

static AirFacebook *sharedInstance = nil;

+ (AirFacebook *)sharedInstance
{
    if (sharedInstance == nil)
    {
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedInstance];
}

- (id)copy
{
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        shareActivities = [NSMutableDictionary dictionary];
    }
    return self;
}

// every time we have to send back information to the air application, invoque this method wich will dispatch an Event in air
+ (void)dispatchEvent:(NSString *)event withMessage:(NSString *)message
{
    if(AirFBCtx != nil){
        NSString *eventName = event ? event : @"LOGGING";
        NSString *messageText = message ? message : @"";
        FREDispatchStatusEventAsync(AirFBCtx, (const uint8_t *)[eventName UTF8String], (const uint8_t *)[messageText UTF8String]);
    }
}

+ (void)log:(NSString *)format, ...
{
    @try
    {
        va_list args;
        va_start(args, format);
        NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
        [AirFacebook as3Log:message];
        [AirFacebook nativeLog:message withPrefix:@"NATIVE"];
    }
    @catch (NSException *exception)
    {
        NSLog(@"[AirFacebook] Couldn't log message. Exception: %@", exception);
    }
}

+ (void)as3Log:(NSString *)message
{
    [AirFacebook dispatchEvent:@"LOGGING" withMessage:message];
}

+ (void)nativeLog:(NSString *)message withPrefix:(NSString *)prefix
{
    if ([[AirFacebook sharedInstance] isNativeLogEnabled]) {
        NSLog(@"[AirFacebook][%@] %@", prefix, message);
    }
}

+ (NSString*) jsonStringFromObject:(id)obj andPrettyPrint:(BOOL) prettyPrint
{
    if(obj == nil){
        NSLog(@"jsonStringFromObject:andPrettyPrint: first argument was nil!");
        return @"[]";
    }
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj
                                                       options:(NSJSONWritingOptions) (prettyPrint ? NSJSONWritingPrettyPrinted : 0)
                                                         error:&error];
    
    if (!jsonData) {
        NSLog(@"jsonStringFromObject:andPrettyPrint: error: %@", error.localizedDescription);
        return @"[]";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

@end

#pragma mark - C interface

DEFINE_ANE_FUNCTION(nativeLog)
{
    NSString *message = FPANE_FREObjectToNSString(argv[0]);
    
    // NOTE: logs from as3 should go only to native log
    [AirFacebook nativeLog:message withPrefix:@"AS3"];
    
    return nil;
}


DEFINE_ANE_FUNCTION(setNativeLogEnabled)
{
    BOOL nativeLogEnabled = FPANE_FREObjectToBOOL(argv[0]);
    
    [[AirFacebook sharedInstance] setNativeLogEnabled:nativeLogEnabled];
    
    return nil;
}

//DEFINE_ANE_FUNCTION(logEvent)
//{
//    NSString *eventName = [FREConversionUtil toString:[FREConversionUtil getProperty:@"eventName" fromObject:argv[0]]];
//    NSNumber *valueToSum = [FREConversionUtil toNumber:[FREConversionUtil getProperty:@"valueToSum" fromObject:argv[0]]];
//    NSDictionary *parameters = FPANE_FREObjectsToNSDictionary([FREConversionUtil getProperty:@"paramsKeys" fromObject:argv[0]],
//                                                              [FREConversionUtil getProperty:@"paramsTypes" fromObject:argv[0]],
//                                                              [FREConversionUtil getProperty:@"paramsValues" fromObject:argv[0]]);
//    
//
//    return nil;
//}

void BCommonContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx,
                        uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet) 
{
    
//    [[NSNotificationCenter defaultCenter] addObserver:[AirFacebook sharedInstance] selector:@selector(didFinishLaunching:) name:UIApplicationDidFinishLaunchingNotification object:nil];
    
    // Register the links btwn AS3 and ObjC. (dont forget to modify the nbFuntionsToLink integer if you are adding/removing functions)
    NSDictionary *functions = @{
//        @"logEvent":                        [NSValue valueWithPointer:&logEvent],
        
        // Debug
        @"nativeLog":                       [NSValue valueWithPointer:&nativeLog],
        @"setNativeLogEnabled":             [NSValue valueWithPointer:&setNativeLogEnabled],
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
    
    AirFBCtx = ctx;
}

void BCommonContextFinalizer(FREContext ctx) { }

void BCommonInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet)
{
	*extDataToSet = NULL;
	*ctxInitializerToSet = &BCommonContextInitializer;
	*ctxFinalizerToSet = &BCommonContextFinalizer;
}

void BCommonFinalizer(void *extData) { }
