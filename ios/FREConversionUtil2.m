//
//  FREConversionUtil.m
//  AirFacebook
//
//  Created by Ján Horváth on 30/06/15.
//
//

#import "FREConversionUtil2.h"

@implementation FREConversionUtil2

typedef NS_ENUM(NSUInteger, ConversionType)
{
    ConversionTypeString = 0,
    ConversionTypeInt,
    ConversionTypeBool,
    ConversionTypeLong,
    ConversionTypeDouble,
    
    ConversionTypeStringArray,
    ConversionTypeIntArray,
    ConversionTypeBoolArray,
    ConversionTypeLongArray,
    ConversionTypeDoubleArray,
    
    ConversionTypeObject,
    ConversionTypeObjectArray
};

+ (FREObject)fromString:(NSString *)value {
    FREObject object;
    
    FREResult result = FRENewObjectFromUTF8((uint32_t) [value length], (uint8_t *) [value UTF8String], &object);
    
    if (result != FRE_OK) {
    
        return nil;
    }
    
    return object;
}

+ (FREObject)fromNumber:(NSNumber *)value {
    FREObject object;
    
    FREResult result = FRENewObjectFromDouble([value doubleValue], &object);
    
    if (result != FRE_OK) {
        
        return nil;
    }
    
    return object;
}

+ (FREObject)fromInt:(NSInteger)value {
    FREObject object;
    
    FREResult result = FRENewObjectFromInt32((int32_t) value, &object);
    
    if (result != FRE_OK) {
        
        return nil;
    }
    
    return object;
}

+ (FREObject)fromUInt:(NSUInteger)value {
    FREObject object;
    
    FREResult result = FRENewObjectFromInt32((uint32_t) value, &object);
    
    if (result != FRE_OK) {
       
        return nil;
    }
    
    return object;
}

+ (FREObject)fromBoolean:(BOOL)value {
    FREObject object;
    
    FREResult result = FRENewObjectFromBool((uint32_t) value, &object);
    
    if (result != FRE_OK) {
    
        return nil;
    }
    
    return object;
}

+ (NSString *)toString:(FREObject)object {
    uint32_t length;
    const uint8_t *value;
    
    FREResult result = FREGetObjectAsUTF8(object, &length, &value);
    
    if (result != FRE_OK) {
        
        return nil;
    }
    
    return [NSString stringWithUTF8String:(char *) value];
}

+ (NSNumber *)toNumber:(FREObject)object {
    double value = 0;
    
    FREResult result = FREGetObjectAsDouble(object, &value);
    
    if (result != FRE_OK) {
        
        return [NSNumber numberWithDouble:value];
    }
    
    return [NSNumber numberWithDouble:value];
}

+ (NSInteger)toInt:(FREObject)object {
    int32_t value = 0;
    
    FREResult result = FREGetObjectAsInt32(object, &value);
    
    if (result != FRE_OK) {
        
        return value;
    }
    
    return value;
}

+ (NSUInteger)toUInt:(FREObject)object {
    uint32_t value = 0;
    
    FREResult result = FREGetObjectAsUint32(object, &value);
    
    if (result != FRE_OK) {
        
        return value;
    }
    
    return value;
}

+ (BOOL)toBoolean:(FREObject)object {
    uint32_t value = 0;
    
    FREResult result = FREGetObjectAsBool(object, &value);
    
    if (result != FRE_OK) {
        
        return (value) ? YES : NO;
    }
    
    return (value) ? YES : NO;
}

+ (NSNumber *)toLong:(FREObject)object {
    double value = 0;
    
    FREResult result = FREGetObjectAsDouble(object, &value);
    
    if (result != FRE_OK) {
        
        return [NSNumber numberWithLongLong:value];
    }
    
    return [NSNumber numberWithLongLong:value];
}

+ (NSArray *)toStringArray:(FREObject)object {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    @try {
        NSUInteger length = [FREConversionUtil2 getArrayLength:object];
        for(NSUInteger i = 0; i<length; i++){
            [array addObject:[FREConversionUtil2 toString:[FREConversionUtil2 getArrayItemAt:i on:object]]];
        }
    }
    @catch (NSException *exception) {
        
        return nil;
    }
    
    return [array copy];
}

+ (NSArray *)toIntArray:(FREObject)object {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    @try {
        NSUInteger length = [FREConversionUtil2 getArrayLength:object];
        for(NSUInteger i = 0; i<length; i++){
            [array addObject:@([FREConversionUtil2 toInt:[FREConversionUtil2 getArrayItemAt:i on:object]])]; // same as [NSNumber numberWithLong:value]
        }
    }
    @catch (NSException *exception) {
        
        return nil;
    }
    
    return [array copy];
}

+ (NSArray *)toBoolArray:(FREObject)object {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    @try {
        NSUInteger length = [FREConversionUtil2 getArrayLength:object];
        for(NSUInteger i = 0; i<length; i++){
            [array addObject:@([FREConversionUtil2 toBoolean:[FREConversionUtil2 getArrayItemAt:i on:object]])]; // same as [NSNumber numberWithBool:value]
        }
    }
    @catch (NSException *exception) {
        
        return nil;
    }
    
    return [array copy];
}

+ (NSArray *)toLongArray:(FREObject)object {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    @try {
        NSUInteger length = [FREConversionUtil2 getArrayLength:object];
        for(NSUInteger i = 0; i<length; i++){
            [array addObject:[FREConversionUtil2 toLong:[FREConversionUtil2 getArrayItemAt:i on:object]]];
        }
    }
    @catch (NSException *exception) {
        
        return nil;
    }
    
    return [array copy];
}

+ (NSArray *)toDoubleArray:(FREObject)object {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    @try {
        NSUInteger length = [FREConversionUtil2 getArrayLength:object];
        for(NSUInteger i = 0; i<length; i++){
            [array addObject:[FREConversionUtil2 toNumber:[FREConversionUtil2 getArrayItemAt:i on:object]]];
        }
    }
    @catch (NSException *exception) {
        
        return nil;
    }
    
    return [array copy];
}

+ (NSArray *)toDictionaryArray:(FREObject)object {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    @try {
        NSUInteger length = [FREConversionUtil2 getArrayLength:object];
        for(NSUInteger i = 0; i<length; i++){
            [array addObject:[FREConversionUtil2 toDictionary:[FREConversionUtil2 getArrayItemAt:i on:object]]];
        }
    }
    @catch (NSException *exception) {
        
        return nil;
    }
    
    return [array copy];
}


+ (NSDictionary *)toStringDictionary:(FREObject)object {
    
    FREObject keys = [FREConversionUtil2 getProperty:@"keys" fromObject:object];
    FREObject values = [FREConversionUtil2 getProperty:@"values" fromObject:object];
        
    return [FREConversionUtil2 toStringDictionaryFromKeys:keys andValues:values];
}

+ (NSDictionary *)toStringDictionaryFromKeys:(FREObject)keys andValues:(FREObject)values {
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    @try {
        NSUInteger keysLength = [FREConversionUtil2 getArrayLength:keys];
        NSUInteger valuesLength = [FREConversionUtil2 getArrayLength:values];
        if(keysLength != valuesLength){
            
            return nil;
        }
        
        for(NSUInteger i = 0; i<keysLength; i++){
            
            NSString *key = [FREConversionUtil2 toString:[FREConversionUtil2 getArrayItemAt:i on:keys]];
            NSString *value = [FREConversionUtil2 toString:[FREConversionUtil2 getArrayItemAt:i on:values]];
            [dictionary setObject:value forKey:key];
        }
    }
    @catch (NSException *exception) {
        
        return nil;
    }
    
    return [dictionary copy];
}

+ (NSDictionary *)toDictionary:(FREObject)object {

    if (object == NULL)
    {
        return nil;
    }

    FREObject keys = [FREConversionUtil2 getProperty:@"keys" fromObject:object];
    FREObject types = [FREConversionUtil2 getProperty:@"types" fromObject:object];
    FREObject values = [FREConversionUtil2 getProperty:@"values" fromObject:object];
    
    return [FREConversionUtil2 toDictionaryFromKeys:keys types:types andValues:values];
}

+ (NSDictionary *)toDictionaryFromKeys:(FREObject)keys types:(FREObject)types andValues:(FREObject)values {
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    @try {
        NSUInteger keysLength = [FREConversionUtil2 getArrayLength:keys];
        NSUInteger typesLength = [FREConversionUtil2 getArrayLength:types];
        NSUInteger valuesLength = [FREConversionUtil2 getArrayLength:values];
        if(keysLength != valuesLength || keysLength != typesLength){
            
            return nil;
        }
        
        for(NSUInteger i = 0; i<keysLength; i++){
            
            NSString *key = [FREConversionUtil2 toString:[FREConversionUtil2 getArrayItemAt:i on:keys]];
            ConversionType type = [FREConversionUtil2 toUInt:[FREConversionUtil2 getArrayItemAt:i on:types]];
            FREObject rawValue = [FREConversionUtil2 getArrayItemAt:i on:values];
            
            switch (type) {
                case ConversionTypeString:
                {
                    NSString *value = [FREConversionUtil2 toString:rawValue];
                    [dictionary setObject:value forKey:key];
                    break;
                }
                case ConversionTypeInt:
                {
                    NSInteger value = [FREConversionUtil2 toInt:rawValue];
                    [dictionary setObject:@(value) forKey:key]; // same as [NSNumber numberWithLong:value]
                    break;
                }
                case ConversionTypeBool:
                {
                    BOOL value = [FREConversionUtil2 toBoolean:rawValue];
                    [dictionary setObject:@(value) forKey:key]; // same as [NSNumber numberWithBool:value]
                    break;
                }
                case ConversionTypeLong:
                {
                    NSNumber *value = [FREConversionUtil2 toLong:rawValue];
                    [dictionary setObject:value forKey:key];
                    break;
                }
                case ConversionTypeDouble:
                {
                    NSNumber *value = [FREConversionUtil2 toNumber:rawValue];
                    [dictionary setObject:value forKey:key];
                    break;
                }
                case ConversionTypeStringArray:
                {
                    NSArray *value = [FREConversionUtil2 toStringArray:rawValue];
                    [dictionary setObject:value forKey:key];
                    break;
                }
                case ConversionTypeIntArray:
                {
                    NSArray *value = [FREConversionUtil2 toIntArray:rawValue];
                    [dictionary setObject:value forKey:key];
                    break;
                }
                case ConversionTypeBoolArray:
                {
                    NSArray *value = [FREConversionUtil2 toBoolArray:rawValue];
                    [dictionary setObject:value forKey:key];
                    break;
                }
                case ConversionTypeLongArray:
                {
                    NSArray *value = [FREConversionUtil2 toLongArray:rawValue];
                    [dictionary setObject:value forKey:key];
                    break;
                }
                case ConversionTypeDoubleArray:
                {
                    NSArray *value = [FREConversionUtil2 toDoubleArray:rawValue];
                    [dictionary setObject:value forKey:key];
                    break;
                }
                case ConversionTypeObject:
                {
                    NSDictionary *value = [FREConversionUtil2 toDictionary:rawValue];
                    [dictionary setObject:value forKey:key];
                    break;
                }
                case ConversionTypeObjectArray:
                {
                    NSArray *value = [FREConversionUtil2 toDictionaryArray:rawValue];
                    [dictionary setObject:value forKey:key];
                    break;
                }
                default:
                    continue;
            }
        }
    }
    @catch (NSException *exception) {
        
        return nil;
    }
    
    return [dictionary copy];
}

+ (FREObject)getProperty:(NSString *)name fromObject:(FREObject)object {
    FREObject value;
    FREResult result = FREGetObjectProperty(object, (uint8_t *) [name UTF8String], &value, NULL);
    
    if (result != FRE_OK) {
        NSException *exception;
        
        switch (result) {
            case FRE_ACTIONSCRIPT_ERROR:
                exception = [NSException exceptionWithName:@"ActionscriptError" reason:@"An ActionScript error occurred. The runtime sets the thrownException parameter to represent the ActionScript Error class or subclass object." userInfo:NULL];
                break;
            case FRE_ILLEGAL_STATE:
                exception = [NSException exceptionWithName:@"IllegalState" reason:@"The extension context has acquired an ActionScript BitmapData or ByteArray object. The context cannot call this method until it releases the BitmapData or ByteArray object." userInfo:NULL];
                break;
            case FRE_INVALID_ARGUMENT:
                exception = [NSException exceptionWithName:@"InvalidArgument" reason:@"The propertyName or propertyValue parameter is NULL." userInfo:NULL];
                break;
            case FRE_INVALID_OBJECT:
                exception = [NSException exceptionWithName:@"InvalidObject" reason:@"The FREObject parameter is invalid." userInfo:NULL];
                break;
            case FRE_NO_SUCH_NAME:
                exception = [NSException exceptionWithName:@"NoSuchName" reason:@"The propertyName parameter does not match a property of the ActionScript class object that the object parameter represents. Another, less likely, reason for this return value exists. Specifically, consider the unusual case when an ActionScript class has two properties with the same name but the names are in different ActionScript namespaces." userInfo:NULL];
                break;
            case FRE_TYPE_MISMATCH:
                exception = [NSException exceptionWithName:@"TypeMismatch" reason:@"The FREObject parameter does not represent an ActionScript class object." userInfo:NULL];
                break;
            case FRE_WRONG_THREAD:
                exception = [NSException exceptionWithName:@"WrongThread" reason:@"The method was called from a thread other than the one on which the runtime has an outstanding call to a native extension function." userInfo:NULL];
                break;
            default:
                exception = NULL;
        }
        
        if (exception != NULL) @throw exception;
    }
    
    return value;
}

+ (NSUInteger)getArrayLength:(FREObject *)array {
    uint32_t length;
    FREResult result = FREGetArrayLength(array, &length);
    
    if (result != FRE_OK) {
        NSException *exception;
        
        switch (result) {
            case FRE_ILLEGAL_STATE:
                exception = [NSException exceptionWithName:@"IllegalState" reason:@"The extension context has acquired an ActionScript BitmapData or ByteArray object. The context cannot call this method until it releases the BitmapData or ByteArray object." userInfo:NULL];
                break;
            case FRE_INVALID_ARGUMENT:
                exception = [NSException exceptionWithName:@"InvalidArgument" reason:@"The propertyName or propertyValue parameter is NULL." userInfo:NULL];
                break;
            case FRE_INVALID_OBJECT:
                exception = [NSException exceptionWithName:@"InvalidObject" reason:@"The FREObject parameter is invalid." userInfo:NULL];
                break;
            case FRE_TYPE_MISMATCH:
                exception = [NSException exceptionWithName:@"TypeMismatch" reason:@"The FREObject parameter does not represent an ActionScript class object." userInfo:NULL];
                break;
            case FRE_WRONG_THREAD:
                exception = [NSException exceptionWithName:@"WrongThread" reason:@"The method was called from a thread other than the one on which the runtime has an outstanding call to a native extension function." userInfo:NULL];
                break;
            default:
                exception = NULL;
        }
        
        if (exception != NULL) @throw exception;
    }
    
    return [[NSNumber numberWithInteger:length] unsignedIntegerValue];
}

+ (FREObject *)getArrayItemAt:(NSUInteger)index on:(FREObject)array {
    FREObject value;
    FREResult result = FREGetArrayElementAt(array, (uint32_t) index, &value);
    
    if (result != FRE_OK) {
        NSException *exception;
        
        switch (result) {
            case FRE_ILLEGAL_STATE:
                exception = [NSException exceptionWithName:@"IllegalState" reason:@"The extension context has acquired an ActionScript BitmapData or ByteArray object. The context cannot call this method until it releases the BitmapData or ByteArray object." userInfo:NULL];
                break;
            case FRE_INVALID_ARGUMENT:
                exception = [NSException exceptionWithName:@"InvalidArgument" reason:@"The propertyName or propertyValue parameter is NULL." userInfo:NULL];
                break;
            case FRE_INVALID_OBJECT:
                exception = [NSException exceptionWithName:@"InvalidObject" reason:@"The FREObject parameter is invalid." userInfo:NULL];
                break;
            case FRE_TYPE_MISMATCH:
                exception = [NSException exceptionWithName:@"TypeMismatch" reason:@"The FREObject parameter does not represent an ActionScript class object." userInfo:NULL];
                break;
            case FRE_WRONG_THREAD:
                exception = [NSException exceptionWithName:@"WrongThread" reason:@"The method was called from a thread other than the one on which the runtime has an outstanding call to a native extension function." userInfo:NULL];
                break;
            default:
                exception = NULL;
        }
        
        if (exception != NULL) @throw exception;
    }
    
    return value;
}

+ (NSString *) toHexString:(const uint8_t*) bytes length:(uint32_t) length
{
    NSUInteger bytesCount = length;
    if (bytesCount) {
        const char *hexChars = "0123456789ABCDEF";
        const unsigned char *dataBuffer = bytes;
        char *chars = malloc(sizeof(char) * (bytesCount * 2 + 1));
        char *s = chars;
        for (unsigned i = 0; i < bytesCount; ++i) {
            *s++ = hexChars[((*dataBuffer & 0xF0) >> 4)];
            *s++ = hexChars[(*dataBuffer & 0x0F)];
            dataBuffer++;
        }
        *s = '\0';
        NSString *hexString = [NSString stringWithUTF8String:chars];
        free(chars);
        return hexString;
    }
    return @"";
}

// NSData to hex
//- (NSString *) hexString
//{
//    NSUInteger bytesCount = self.length;
//    if (bytesCount) {
//        const char *hexChars = "0123456789ABCDEF";
//        const unsigned char *dataBuffer = self.bytes;
//        char *chars = malloc(sizeof(char) * (bytesCount * 2 + 1));
//        char *s = chars;
//        for (unsigned i = 0; i < bytesCount; ++i) {
//            *s++ = hexChars[((*dataBuffer & 0xF0) >> 4)];
//            *s++ = hexChars[(*dataBuffer & 0x0F)];
//            dataBuffer++;
//        }
//        *s = '\0';
//        NSString *hexString = [NSString stringWithUTF8String:chars];
//        free(chars);
//        return hexString;
//    }
//    return @"";
//}

@end
