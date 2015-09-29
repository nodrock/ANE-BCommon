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
}

void BCommonFinalizer(void *extData)
{
    return;
}

void BCommonContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx,
                               uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet)
{
    NSDictionary *functions = @{
                                @"getIDFV":                         [NSValue valueWithPointer:&getIDFV],
                                @"getIDFA":                         [NSValue valueWithPointer:&getIDFA],
                                @"getIDFATrackingEnabled":          [NSValue valueWithPointer:&getIDFATrackingEnabled],
                                
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
    
    [[BCommon sharedInstance] setContext:ctx];
    
    [[NSNotificationCenter defaultCenter] addObserver:[BCommon sharedInstance] selector:@selector(didReceiveMemoryWarning:) name:UIApplicationDidReceiveMemoryWarningNotification object:[UIApplication sharedApplication]];
}

void BCommonContextFinalizer(FREContext ctx)
{
    [[NSNotificationCenter defaultCenter]removeObserver:[BCommon sharedInstance] name:UIApplicationDidReceiveMemoryWarningNotification object:[UIApplication sharedApplication]];
}

