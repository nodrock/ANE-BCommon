//
//  BCommonAPIFunctions.h
//  BCommon
//
//  Created by Ján Horváth on 24/09/15.
//
//

#import "FlashRuntimeExtensions.h"

#define PREFIX(fnprefix,fn) fnprefix##_##fn
#define BCOMMON(fn) PREFIX(BCommon,fn)
#define DEFINE_ANE_FUNCTION(fn) FREObject BCOMMON(fn)(FREContext context, void* functionData, uint32_t argc, FREObject argv[])

// C interface

// Debug
DEFINE_ANE_FUNCTION(nativeLog);
DEFINE_ANE_FUNCTION(setNativeLogEnabled);
DEFINE_ANE_FUNCTION(getLanguageCode);
DEFINE_ANE_FUNCTION(getIDFV);
DEFINE_ANE_FUNCTION(getIDFA);
DEFINE_ANE_FUNCTION(getIDFATrackingEnabled);