//
//  TKeychain.m
//  TFoundation
//
//  Created by liu nian on 2020/3/27.
//

#import "TKeychain.h"
#import "TKeychainItemWrapper.h"
#import "TFoundationInternal.h"
#import "TFoundation+Options.h"

//trader里头的DeviceCodeNotEncrypt
NSString *const T_KEYCHAIN_DEVICECODE = @"T_KEYCHAIN_DEVICECODE";
NSString *const T_KEYCHAIN_DEVICETOKEN = @"T_KEYCHAIN_DEVICETOKEN";
NSString *const T_KeyChainUserToken = @"t.keychain.passport.token";

@interface TKeychain ()
@property (nonatomic, strong) TKeychainItemWrapper *otsItem;
@property (nonatomic, strong) NSArray *commonClasses;
@end

@implementation TKeychain

+ (instancetype)sharedInstance {
	static id sharedInstance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[self alloc] init];
	});
	return sharedInstance;
}

- (id)init {
    if (self = [super init]) {
        self.commonClasses = @[[NSNumber class],
                               [NSString class],
                               [NSMutableString class],
                               [NSData class],
                               [NSMutableData class],
                               [NSDate class],
                               [NSValue class]];
        
        [self setup];
    }
    return self;
}

- (void)setup {
	NSString *identity = [TFoundation keyChainIdentity];
	NSString *group = [TFoundation keychainGroup];
	if (!identity ) {
//		TFLogError(@"keyChainIdentity must be true");
	}
	NSAssert(identity, @"keyChainIdentity must be true");
	
    TKeychainItemWrapper *wrapper = [[TKeychainItemWrapper alloc] initWithIdentifier:identity accessGroup:group];
	self.otsItem = wrapper;
}

+ (void)setKeychainValue:(id<NSCopying, NSObject>)value forType:(NSString *)type {
    TKeychain *keychain = [TKeychain sharedInstance];
    
    __block BOOL find = NO;
    [keychain.commonClasses enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Class class = obj;
        if ([value isKindOfClass:class]) {
            find = YES;
            *stop = YES;
        }
        
    }];
    
    if (!find && value) {
//        TFLogError(@"error set keychain type [%@], value [%@]",type ,value);
        return ;
    }
    
    if (!type || !keychain.otsItem) {
        return ;
    }
    
    id data = [keychain.otsItem objectForKey:(__bridge id)kSecValueData];
    NSMutableDictionary *dict = nil;
    if (data && [data isKindOfClass:[NSMutableData class]]) {
        dict = [keychain decodeDictWithData:data];
    }
    
    if (!dict) {
        dict = [NSMutableDictionary dictionary];
    }
    
    dict[type] = value;
    data = [keychain encodeDict:dict];
	NSString *identity = [TFoundation keyChainIdentity];
	NSAssert(identity, @"keyChainIdentity must be true");
    if (data && [data isKindOfClass:[NSMutableData class]]) {
        [keychain.otsItem setObject:identity forKey:(__bridge id)(kSecAttrAccount)];
        [keychain.otsItem setObject:data forKey:(__bridge id)kSecValueData];
    }
}

+ (id)getKeychainValueForType:(NSString *)type {
    TKeychain *keychain = [TKeychain sharedInstance];
    if (!type || !keychain.otsItem) {
        return nil;
    }
    
    id data = [keychain.otsItem objectForKey:(__bridge id)kSecValueData];
    NSMutableDictionary *dict = nil;
    if (data && [data isKindOfClass:[NSMutableData class]]) {
        dict = [keychain decodeDictWithData:data];
    }
    
    return dict[type];
}

+ (void)reset {
    TKeychain *keychain = [TKeychain sharedInstance];
    if (!keychain.otsItem) {
        return ;
    }
    
    id data = [keychain encodeDict:[NSMutableDictionary dictionary]];
    
    if (data && [data isKindOfClass:[NSMutableData class]]) {
		NSString *identity = [TFoundation keyChainIdentity];
		NSAssert(identity, @"keyChainIdentity must be true");
        [keychain.otsItem setObject:identity forKey:(__bridge id)(kSecAttrAccount)];
        [keychain.otsItem setObject:data forKey:(__bridge id)kSecValueData];
    }
}

- (NSMutableData *)encodeDict:(NSMutableDictionary *)dict {
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:dict forKey:T_KEYCHAIN_DICT_ENCODE_KEY_VALUE];
    [archiver finishEncoding];
    return data;
}

- (NSMutableDictionary *)decodeDictWithData:(NSMutableData *)data {
    NSMutableDictionary *dict = nil;
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    if ([unarchiver containsValueForKey:T_KEYCHAIN_DICT_ENCODE_KEY_VALUE]) {
        @try {
            dict = [unarchiver decodeObjectForKey:T_KEYCHAIN_DICT_ENCODE_KEY_VALUE];
        }
        @catch (NSException *exception) {
//            TFLogError(@"keychain 解析错误");
            [TKeychain reset];
        }
    }
    [unarchiver finishDecoding];
    
    return dict;
}

@end
