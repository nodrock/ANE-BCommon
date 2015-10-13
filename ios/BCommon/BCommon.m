#import "BCommon.h"

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

// every time we have to send back information to the air application, invoque this method wich will dispatch an Event in air
- (void)dispatchEvent:(NSString *)event withMessage:(NSString *)message
{
    if(self.context != nil){
        NSString *eventName = event ? event : @"LOGGING";
        NSString *messageText = message ? message : @"";
        FREDispatchStatusEventAsync(self.context, (const uint8_t *)[eventName UTF8String], (const uint8_t *)[messageText UTF8String]);
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
    [[BCommon sharedInstance] dispatchEvent:@"LOGGING" withMessage:message];
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
    [self dispatchEvent:@"NOTIFICATION" withMessage:@"{\"type\":\"MEMORY_WARNING\"}"];
}

@end

