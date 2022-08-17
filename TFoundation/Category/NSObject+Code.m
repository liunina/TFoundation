//
//  NSObject+Code.m
//  TFoundation
//
//  Created by liu nian on 2020/3/27.
//

#import "NSObject+Code.h"
#import "NSString+safe.h"
#import "NSMutableString+safe.h"
#import "NSArray+safe.h"
#import "NSMutableArray+safe.h"
#import "NSDictionary+safe.h"
#import "NSMutableDictionary+safe.h"
#import <JSONModel/JSONModel.h>

@interface NSObject () <NSCoding>
@end

@implementation NSObject (Runtime)

/// 获取对象的所有属性,包括父类的。可以一直遍历到JSONModel层。如果不是继承JSONMOdel,最上层为NSObject
- (NSArray *)getProperties {
    NSMutableArray *props = [NSMutableArray array];
    unsigned int outCount, i;
	Class targetClass = [self class];
	while (targetClass != [JSONModel class] && targetClass != [NSObject class]) {
		objc_property_t *properties = class_copyPropertyList(targetClass, &outCount);
		for (i = 0; i < outCount; i++) {
			objc_property_t property = properties[i];
			const char *char_f = property_getName(property);
			NSString *propertyName = [NSString stringWithUTF8String:char_f];
			[props addObject:propertyName];
		}
		free(properties);
		targetClass = [targetClass superclass];
	}
	return props;
}

/* 获取对象的所有方法 */
- (void)printMothList {
    unsigned int mothCout_f = 0;
    Method *mothList_f = class_copyMethodList([self class], &mothCout_f);
    for(int i = 0; i < mothCout_f; i++) {
        Method temp_f = mothList_f[i];
//        IMP imp_f = method_getImplementation(temp_f);
        SEL name_f = method_getName(temp_f);
        const char* name_s = sel_getName(name_f);
        int arguments = method_getNumberOfArguments(temp_f);
        const char* encoding = method_getTypeEncoding(temp_f);
//        TFLogError(@"方法名：%@,参数个数：%d,编码方式：%@",[NSString stringWithUTF8String:name_s], arguments, [NSString stringWithUTF8String:encoding]);
    }
    
    free(mothList_f);
}

@end

@implementation NSObject (coder)

- (id)otsDecodeWithCoder:(NSCoder *)aDecoder {
    [[self getProperties] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self setValue:[aDecoder decodeObjectForKey:obj] forKey:obj];
    }];
    return self;
}

- (void)otsEncodeWithCoder:(NSCoder *)aCoder {
    [[self getProperties] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [aCoder encodeObject:[self valueForKey:obj] forKey:obj];
    }];
}

@end

@implementation NSObject (JsonToVO)

/**
 *  获取类名   voName是dictionary中标记实体类的类名的
 */
+ (NSString *)classNameWithDictionary:(NSDictionary*)dic {
    if (!dic) {
        return nil;
    }
    //return [dic objectForKey:@"voName"];
    NSString *voName = nil;
    
    //根据dictinary中的key（datatype）获取到该dictionary对应的实体类名的描述
    NSString *dataTyepStr = [dic objectForKey:@"@datatype"];
    
    //判断类名描述存在则说明该dictionary是一个自定义的实体VO对象，否则就是一个dictionary类型类名返回nil不用映射
    if (dataTyepStr) {
        NSRange range = [dataTyepStr safeRangeOfString:@"." options:NSBackwardsSearch];
        if (range.location != NSNotFound) {
            voName = [dataTyepStr safeSubstringFromIndex:range.location + 1];
        }
    }
    return voName;
}

/**
 *  获取参数class类的所有属性
 */
- (NSMutableArray *)getPropertyList:(Class)class {
	if ([NSStringFromClass(class) isEqualToString:NSStringFromClass([NSObject class])]
		|| [NSStringFromClass(class) isEqualToString:NSStringFromClass([JSONModel class])]) {
		return nil;
    }
    u_int count;
    objc_property_t *properties = class_copyPropertyList(class, &count);
    NSMutableArray *propertyArray = [NSMutableArray arrayWithCapacity:count];

    for (int i = 0; i < count ; i++) {
        const char *propertyName = property_getName(properties[i]);
        const char *propertyType = property_getAttributes(properties[i]);
        NSMutableDictionary *propertyDic = [NSMutableDictionary dictionaryWithCapacity:0];
        [propertyDic safeSetObject:[NSString stringWithUTF8String: propertyName] forKey:@"propertyName"];
        [propertyDic safeSetObject:[NSString stringWithUTF8String: propertyType] forKey:@"propertyType"];
        [propertyArray safeAddObject:propertyDic];
    }
    free(properties);
	NSArray * superArray = [self getPropertyList:[class superclass]];
	if (superArray != nil) {
		[propertyArray addObjectsFromArray:superArray];
	}
    return propertyArray;
}

/**
 *  获取当前实体类的所有属性
 */
- (NSArray *)getPropertyList {
	//tips：原先的方法没法处理超过两层继承的类
	 return [self getPropertyList:[self class]];
}

- (NSArray *)getAssociatedPropertyList {
    return [self getAssociatedPropertyList:self.class];
}

- (NSArray *)getAssociatedPropertyList:(Class)class {
    if ([ NSStringFromClass(class) isEqualToString:NSStringFromClass([NSObject class])]) {
		return nil;
    }
    
    NSMutableArray *propertyArray = [NSMutableArray arrayWithCapacity:self.associatedObjectNames.count];
    
    for (NSString *propertyName in self.associatedObjectNames) {
        NSMutableDictionary *propertyDic = [NSMutableDictionary dictionaryWithCapacity:1];
        propertyDic[@"propertyName"] = propertyName;
        [propertyArray safeAddObject:propertyDic];
    }
    
    NSArray * superArray = [self getAssociatedPropertyList:[class superclass]];
	if (superArray != nil) {
		[propertyArray addObjectsFromArray:superArray];
	}
    
    return propertyArray;
}
/**
 *  解析数组里面的对象
 */
+ (NSMutableArray *)setListWithArray:(NSMutableArray *)array {
    if (!array) {
        return nil;
    }
    
    if (![array isKindOfClass:[NSMutableArray class]]) {
        return nil;
    }
    
    NSMutableArray *list = [[NSMutableArray alloc] initWithCapacity:[array count]];
    if ([array count] > 0) {
        for (id obj in array) {
            //如果是字典类型就转成VO
            if ([obj isKindOfClass:[NSDictionary class]]) {
                NSString *className = [NSObject classNameWithDictionary:obj];
                //判断类名存在则说明该dictionary是一个自定义的实体VO对象，否则就是一个dictionary类型不用映射直接添加到数组
                if (className) {
                    id subObj = [[NSClassFromString(className) alloc] initWithMyDictionary:obj];
                    if (subObj) {
                        [list safeAddObject:subObj];
                    }
                    continue;
                }
            }
            //如果是数组类型
            if ([obj isKindOfClass:[NSArray class]]) {
                NSMutableArray *subList = [self setListWithArray:obj];
                if (subList == nil) {
                    [list safeAddObject:[NSMutableArray arrayWithCapacity:0]];
                } else {
                    [list safeAddObject:subList];
                }
                
                continue;
            }

            if ([obj isKindOfClass:[NSNull class]]) {
				continue;
			}

            [list safeAddObject:obj];
        }
    }
    return list;
}

/**
 *  功能:将一个NSDictionary类型的数据里面的key值和VO的属性名一一对应赋value值
 */
- (void)setPropertysWithDictionary:(NSDictionary *)dict {
    NSArray *propertys = [self  getPropertyList];
    int i;
    for (i=0; i<propertys.count; i++) {
        NSMutableDictionary *propertyDic = [propertys safeObjectAtIndex:i];
        NSString *propertyName = [propertyDic objectForKey:@"propertyName"];
        NSString *propertyType = [propertyDic objectForKey:@"propertyType"];
        id value = nil;
        if ([propertyName isEqualToString:@"nid"]) {
            value = [dict objectForKey:@"id"];
        }
        else {
            value = [dict objectForKey:propertyName];
        }

        if (!value || [value isKindOfClass:[NSNull class]]) {
            continue;
        }
        
        //如果是字典类型的要继续转为对应的VO实体对象
        if ([value isKindOfClass:[NSDictionary class]]) {
            NSString* className = [NSObject classNameWithDictionary:value];
            //判断类名存在则说明该dictionary是一个自定义的实体VO对象，否则就是一个dictionary类型不用映射直接赋值
            if (className) {
                id subObj = [[NSClassFromString(className) alloc] initWithMyDictionary:value];
                if (subObj) {
                    [self setValue:subObj forKey:propertyName];
                }
                continue;
            }
        }
		
        
        //如果是数组
        if ([value isKindOfClass:[NSArray class]]) {
            NSMutableArray *list = [NSObject setListWithArray:value];
            [self setValue:list forKey:propertyName];
            continue;
        }
        
        if ([propertyType safeRangeOfString:@"NSDate"].location != NSNotFound) {//NSNumber转成NSDate
            if ([value isKindOfClass:[NSNumber class]]) {
                NSDate *dateValue = [NSDate dateWithTimeIntervalSince1970:((NSNumber*)value).doubleValue / 1000];
                [self setValue:dateValue forKey:propertyName];
            } else if ([value isKindOfClass:[NSString class]]) {
                NSDate *dateValue = nil;
                NSString *formatStr = @"yyyy-MM-dd HH:mm:ss";
                NSString *dateStr = (NSString *)value;
                NSUInteger length = [formatStr length];
                if (dateStr.length >= length) {
                    if ([dateStr safeRangeOfString:@"UTC"].location!=NSNotFound || [dateStr safeRangeOfString:@"GMT"].location!=NSNotFound) {
                        NSString *subStr = [dateStr safeSubstringWithRange:NSMakeRange(0, length)];
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
                        [dateFormatter setDateFormat:formatStr];
                        dateValue = [dateFormatter dateFromString:subStr];
                    } else {
                        NSString *subStr = [dateStr safeSubstringWithRange:NSMakeRange(0, length)];
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
                        [dateFormatter setDateFormat:formatStr];
                        dateValue = [dateFormatter dateFromString:subStr];
                    }
                }
                if (dateValue == nil) {
                    dateValue = [NSDate date];
                }
                [self setValue:dateValue forKey:propertyName];
            }
        } else {
            [self setValue:value forKey:propertyName];
        }
    }
}

/**
 *  功能:通过一个NSDictionary类型的数据构造一个VO类对象
 */
- (id)initWithMyDictionary:(NSDictionary *)dictionaryValue
{
    if (![dictionaryValue isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    self = [self init];
    if (self) {
        [self setPropertysWithDictionary:dictionaryValue];
    }
    
    return self;
}

/**
 *  判断一个value是否是能够转为json格式的基本数据类型
 */
- (BOOL)isValidTypeWithValue:(id)value {
    //可以转为json格式的数据类型
    NSArray *validType = [NSArray arrayWithObjects:@"NSString", @"NSNumber", @"NSArray", @"NSDictionary",@"NSNull",nil];
    
    __block BOOL isValidType = NO;
    
    //判断是否是能够转为json格式的基本数据类型
//    [validType enumerateObjectsUsingBlock:^(id obj,NSUInteger idx,BOOL *stop){
//        if ([value isKindOfClass:NSClassFromString(obj)]) {
//            isValidType = YES;
//            stop = YES;
//        }
//    }];
    
    for (NSString *classStr in validType) {
        if ([value isKindOfClass:NSClassFromString(classStr)]) {
            isValidType = YES;
            break;
        }
    }
    return isValidType;
}

/**
 *  将一个VO类对象转为NSMutabileDictionary类型
 */
- (NSMutableDictionary *)convertDictionary {
    if (!self) {
        return nil;
    }
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    NSArray *propertyList = [self getPropertyList];
    int i;
    for (i=0; i<propertyList.count; i++) {
        NSMutableDictionary *propertyDic = [propertyList safeObjectAtIndex:i];
        NSString *propertyName = [propertyDic objectForKey:@"propertyName"];

        if ((!propertyName)||([propertyName hasSuffix:@"OTSignore"])) {
            continue;
        }

        id value = [self valueForKey:propertyName];
        if (!value) {
            continue;
        }
    
        //如果不是转json的基本类型有可能是嵌套类对象
        if (![self isValidTypeWithValue:value]) {
            NSDictionary *dic = [value convertDictionary];
            if (dic) {
                [dictionary safeSetObject:dic forKey:propertyName];
            }
            continue;
        }
        
        //如果是数组
        if ([value isKindOfClass:[NSArray class]]) {
            NSMutableArray *list = [[NSMutableArray alloc] init];
            
            //判断数组中的对象如果不是转为json的基本类型那就是自定义的实体类对象
            [value enumerateObjectsUsingBlock:^(id obj,NSUInteger idx,BOOL *stop){
                
                if (![self isValidTypeWithValue:obj]) {
                    NSDictionary *dic = [obj convertDictionary];
                    if (dic) {
                        [dictionary safeSetObject:dic forKey:propertyName];
                        [list safeAddObject:dic];
                    }
                }
                else {
                    [list safeAddObject:obj];
                }
            }];
            
            [dictionary setValue:list forKey:propertyName];
            continue;
        }
        
        //如果是日期，NSDate转成NSNumber
        if ([value isKindOfClass:[NSDate class]]) {
            NSNumber *dateNum = [NSNumber numberWithDouble:((NSDate*)value).timeIntervalSince1970 * 1000];
            [dictionary setValue:dateNum forKey:propertyName];
            continue;
        }
		//转json的基本类型直接添加
		if ([propertyName isEqualToString:@"nid"]) {
		  [dictionary setValue:value forKey:@"id"];
		}else if ([propertyName isEqualToString:@"modifiedPassword"]) {
			[dictionary setValue:value forKey:@"newPassword"];
		}else {
			[dictionary setValue:value forKey:propertyName];
		}
    }

#ifdef ENABLE_ASSOCIATED_PROPERTY_JSON
    NSArray *associatedPropertyList = [self getAssociatedPropertyList];
    for (NSDictionary *propertyDic in associatedPropertyList) {
        NSString *propertyName = propertyDic[@"propertyName"];
        
        if (!propertyName) {
            continue;
        }
        
        id value = [self objc_getAssociatedObject:propertyName];
        if (!value) {
            continue;
        }
        
        //如果不是转json的基本类型有可能是嵌套类对象
        if (![self isValidTypeWithValue:value]) {
            NSDictionary *dic = [value convertDictionary];
            if (dic) {
                [dictionary safeSetObject:dic forKey:propertyName];
            }
            continue;
        }
        
        //如果是数组
        if ([value isKindOfClass:[NSArray class]]) {
            NSMutableArray *list = [[NSMutableArray alloc] init];
            
            //判断数组中的对象如果不是转为json的基本类型那就是自定义的实体类对象
            [value enumerateObjectsUsingBlock:^(id obj,NSUInteger idx,BOOL *stop){
                
                if (![self isValidTypeWithValue:obj]) {
                    NSDictionary *dic = [obj convertDictionary];
                    if (dic) {
                        [dictionary safeSetObject:dic forKey:propertyName];
                        [list safeAddObject:dic];
                    }
                }
                else {
                    [list safeAddObject:obj];
                }
            }];
            
            [dictionary setValue:list forKey:propertyName];
            continue;
        }
        
        //如果是日期，NSDate转成NSNumber
        if ([value isKindOfClass:[NSDate class]]) {
            NSNumber *dateNum = __DOUBLE(((NSDate*)value).timeIntervalSince1970 * 1000);
            [dictionary setValue:dateNum forKey:propertyName];
            continue;
        }
        
        //转json的基本类型直接添加
        if ([propertyName isEqualToString:@"nid"]) {
            [dictionary setValue:value forKey:@"id"];
        }
        else if ([propertyName isEqualToString:@"modifiedPassword"]) {
            [dictionary setValue:value forKey:@"newPassword"];
        }else {
            [dictionary setValue:value forKey:propertyName];
        }
    }
#endif
    return dictionary;
}

/**
 *  将vo对象转为json格式的字符串
 *  对象中的属性类型只能是：NSString NSNumber NSArray NSDictionary NSNull 或者是本地VO实体对象
 */
- (NSString *)toJsonStr {
    if (!self) {
        return nil;
    }
    
    NSData *jsonData = nil;
    NSError *jsonError = nil;
    @try {
         if ([self isKindOfClass:[NSDictionary class]] || [self isKindOfClass:[NSArray class]]) {
             jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&jsonError];
         } else {
             NSDictionary *dict = [self convertDictionary];
             jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&jsonError];
         }
    }
    @catch (NSException *exception) {
//        TFLogError(@"to JSON string exception: %@", exception.description);
        return nil;
    }
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

+ (NSDictionary *)dictFromString:(NSString *)aString {
    if (aString == nil) {
        return nil;
    }
    
    NSData *theData = [aString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSError *error = nil;
    
    NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:theData options:kNilOptions error:&error];
    
    if (error) {
//        TFLogError(@"error convert json string to dict,%@,%@", aString, error);
        return nil;
    }
    else {
        return resultDict;
    }
}

+ (NSArray *)arrayFromString:(NSString *)aString {
    if (aString == nil) {
        return nil;
    }
    
    NSData *theData = [aString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSError *error = nil;
    
    NSArray *resultArray = [NSJSONSerialization JSONObjectWithData:theData options:kNilOptions error:&error];
    
    if (error) {
//        TFLogError(@"error convert json string to array,%@,%@", aString, error);
        return nil;
    } else {
        return resultArray;
    }
}

@end

@implementation NSObject (Category)

static char associatedObjectNamesKey;

- (void)setAssociatedObjectNames:(NSMutableArray *)associatedObjectNames {
    objc_setAssociatedObject(self, &associatedObjectNamesKey, associatedObjectNames,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray *)associatedObjectNames {
    NSMutableArray *array = objc_getAssociatedObject(self, &associatedObjectNamesKey);
    if (!array) {
        array = [NSMutableArray array];
        [self setAssociatedObjectNames:array];
    }
    return array;
}

- (void)objc_setAssociatedObject:(NSString *)propertyName value:(id)value policy:(objc_AssociationPolicy)policy {
    objc_setAssociatedObject(self, (__bridge objc_objectptr_t)propertyName, value, policy);
    [self.associatedObjectNames addObject:propertyName];
}

- (id)objc_getAssociatedObject:(NSString *)propertyName {
    return objc_getAssociatedObject(self, (__bridge objc_objectptr_t)propertyName);
}

- (void)objc_removeAssociatedObjects {
    [self.associatedObjectNames removeAllObjects];
    objc_removeAssociatedObjects(self);
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
//    TFLogWarn(@"setValue %@ forUndefinedKey %@",value,key);
}

- (void)setNilValueForKey:(NSString *)key {
//    TFLogWarn(@"setNilValue forKey %@",key);
}

@end

@implementation NSObject (PerformBlock)

- (NSException *)tryCatch:(void (^)(void))block {
	NSException *result = nil;
	
	@try {
		block();
	}@catch (NSException *e) {
		result = e;
	}
	return result;
}

- (NSException *)tryCatch:(void (^)(void))block finally:(void(^)(void))aFinisheBlock {
	NSException *result = nil;
	
	@try {
		block();
	}
	@catch (NSException *e) {
		result = e;
	}
    @finally {
        aFinisheBlock();
    }
	return result;
}

- (void)performInMainThreadBlock:(void(^)(void))aInMainBlock {
    dispatch_async(dispatch_get_main_queue(), ^{
        aInMainBlock();
    });
}

- (void)performInThreadBlock:(void(^)(void))aInThreadBlock {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        aInThreadBlock();
    });
}

- (void)performInMainThreadBlock:(void(^)(void))aInMainBlock afterSecond:(NSTimeInterval)delay {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t) (delay * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        aInMainBlock();
    });
}

- (void)performInThreadBlock:(void(^)(void))aInThreadBlock afterSecond:(NSTimeInterval)delay {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t) (delay * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        aInThreadBlock();
    });
}

@end
