//
//  BCommonAPI.h
//  BCommon
//
//  Created by Ján Horváth on 24/09/15.
//
//

#import "FlashRuntimeExtensions.h"
#import "NotificationController.h"

NotificationController *g_notificationController;

void BCommonInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet);
void BCommonFinalizer(void *extData);

void BCommonContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx,
                               uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet);
void BCommonContextFinalizer(FREContext ctx);

