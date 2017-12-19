#import "BCommon.h"
#import "BCommonEvents.h"

@implementation BCommon {
    
    NSMutableDictionary *shareActivities;
}

static BCommon *sharedInstance = nil;

+ (BCommon *)sharedInstance
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

- (void)dispatchEvent:(NSString *)event
{
    [self dispatchEvent:event withData:nil];
}

- (void)dispatchEvent:(NSString *)event withData:(NSString *)data
{
    if(self.context != nil){
        NSLog(@"Dispatch event! type: %@ data: %@", event, data);

        NSString *eventName = event ? event : @"LOGGING";
        NSString *eventData = data ? data : @"";
        FREDispatchStatusEventAsync(self.context, (const uint8_t *)[eventName UTF8String], (const uint8_t *)[eventData UTF8String]);
    }
}

- (void)log:(NSString *)message
{
    if(self.context != nil && message != nil){

        FREDispatchStatusEventAsync(self.context, (const uint8_t *)[@"LOGGING" UTF8String], (const uint8_t *)[message UTF8String]);
    }
}

+ (void)log:(NSString *)format, ...
{
    @try
    {
        va_list args;
        va_start(args, format);
        NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
        [BCommon as3Log:message];
        [BCommon nativeLog:message withPrefix:@"NATIVE"];
    }
    @catch (NSException *exception)
    {
        NSLog(@"[BCommon] Couldn't log message. Exception: %@", exception);
    }
}

+ (void)as3Log:(NSString *)message
{
    [[BCommon sharedInstance] log:message];
}

+ (void)nativeLog:(NSString *)message withPrefix:(NSString *)prefix
{
    if ([[BCommon sharedInstance] isNativeLogEnabled]) {
        NSLog(@"[BCommon][%@] %@", prefix, message);
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

- (void)didReceiveMemoryWarning:(NSNotification *)notification
{
    [self dispatchEvent:BCOMMON_EVENT_MEMORY_WARNING];
}

@end

