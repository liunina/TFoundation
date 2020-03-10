//
//  TPreferences.m
//  TFoundation
//
//  Created by liu nian on 2020/3/10.
//

#import "TPreferences.h"
#import "TCache.h"

NSString *const PREFERENCE_INSTALL_DATE = @"pref-install-date";
NSString *const PREFERENCE_APP_VERSION = @"pref-app-version";
NSString *const PREFERENCE_APP_SHOULD_GUIDE = @"pref-app-should-guide";
NSString *const PREFERENCE_APP_VERSION_UPDATE_SHOW = @"pref-app-version-update-show";
NSString *const PREFERENCE_APP_PUSH_SHOW_ALERT_DATE = @"pref-app-push-show-alert-date";
NSString *const PREFERENCE_APP_PUSH_DEVICETOKEN = @"pref-app-push-devicetoken";
NSString *const PREFERENCE_PUSH_NOTIFICTION = @"pref-push-notification";

NSString *const PREFERENCE_APP_LANGUAGE = @"pref-app-language";
NSString *const PREFERENCE_APP_EFFECTIVETIME = @"pfef-app-effectiveTime";
NSString *const PREFERENCE_APP_DID_RECEIVE_MESSAGE = @"pref-app-didReceiveMessage";

NSString *const kApplicationStoreKey = @"com.t11.application.preferences";

@interface TPreferences ()
@property (nonatomic, strong) TCache *applicationDataStore;
@end
@implementation TPreferences

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    return self;
}

+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (BOOL)applicationDidFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    if ([self getInstallDate] == 0) {
        
        if ([self getAppVersion] == nil) {
            [self setInstallDate];
            [self setAppVersion:appVersion];
            
            //根据机型语言配置
            NSString *preferredLanguageCode = [NSLocale preferredLanguages][0];
            if ([preferredLanguageCode rangeOfString:@"zh-Hans"].location != NSNotFound) {
                
                
            }else if ([preferredLanguageCode rangeOfString:@"zh-Hant"].location != NSNotFound ||
                      [preferredLanguageCode rangeOfString:@"zh-TW"].location != NSNotFound ||
                      [preferredLanguageCode rangeOfString:@"zh-HK"].location != NSNotFound) {
              
            }
        }else {
            [self setInstallDate];
            if (![appVersion isEqualToString:[self getAppVersion]] ) {
                [self setAppVersion:appVersion];
            }
        }
    } else {
        if (![appVersion isEqualToString:[self getAppVersion]] ) {
            [self setAppVersion:appVersion];
        }
    }
    return YES;
}

#pragma mark - 常用的配置实例

- (NSTimeInterval)getInstallDate {
    return [self.applicationDataStore timeIntervalForKey:PREFERENCE_INSTALL_DATE];
}

- (void)setInstallDate {
    [self.applicationDataStore setTimeInterval:[[NSDate new] timeIntervalSince1970]
                                        forKey:PREFERENCE_INSTALL_DATE];
}

- (BOOL)hasShouldGuidd {
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *ver = [self.applicationDataStore stringForKey:PREFERENCE_APP_SHOULD_GUIDE];
    if (ver == nil || ![ver isEqualToString:appVersion]) {
        return YES;
    }
    return NO;
}

- (void)setHasGuide {
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [self.applicationDataStore setString:appVersion forKey:PREFERENCE_APP_SHOULD_GUIDE];
}

- (void)setAppVersion:(NSString *)version {
    [self.applicationDataStore setString:version forKey:PREFERENCE_APP_VERSION];
}

- (NSString *)getAppVersion {
    return [self.applicationDataStore stringForKey:PREFERENCE_APP_VERSION];
}

- (BOOL)hasShowAppVersionUpdate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [NSDate date];
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    if ([dateString isEqualToString:[self getShowAppUpdateDate]]) {
        return YES;
    }
    return NO;
}
- (NSString *)getShowAppUpdateDate {
    return [self.applicationDataStore stringForKey:PREFERENCE_APP_VERSION_UPDATE_SHOW];
}

- (void)setShowAppUpdateDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [NSDate date];
    NSString *dateString = [dateFormatter stringFromDate:date];
    [self.applicationDataStore setString:dateString forKey:PREFERENCE_APP_VERSION_UPDATE_SHOW];
}

- (BOOL)hasShowAppPushAlert {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [NSDate date];
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    if ([dateString isEqualToString:[self getShowAppPushAlertDate]]) {
        return YES;
    }
    return NO;
}
- (NSString *)getShowAppPushAlertDate {
    return [self.applicationDataStore stringForKey:PREFERENCE_APP_PUSH_SHOW_ALERT_DATE];
}

- (void)setShowPushAlertDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [NSDate date];
    NSString *dateString = [dateFormatter stringFromDate:date];
    [self.applicationDataStore setString:dateString forKey:PREFERENCE_APP_PUSH_SHOW_ALERT_DATE];
}

- (void)setAppPushDeviceToken:(NSString *)deviceToken {
    [self.applicationDataStore setString:deviceToken forKey:PREFERENCE_APP_PUSH_DEVICETOKEN];
}

- (NSString *)getAppPushDeviceToken {
    return [self.applicationDataStore stringForKey:PREFERENCE_APP_PUSH_DEVICETOKEN];
}

- (void)setAppDidReceiveMessage:(BOOL)state {
    [self.applicationDataStore setBool:state forKey:PREFERENCE_APP_DID_RECEIVE_MESSAGE];
}
- (BOOL)getAppDidReceiveMessage {
    return [self.applicationDataStore boolForKey:PREFERENCE_APP_DID_RECEIVE_MESSAGE];
}

- (void)setAppEffectiveTime:(NSDate *)time{
    [self.applicationDataStore storeObject:time forKey:PREFERENCE_APP_EFFECTIVETIME];
}
- (NSDate *)getAppEffectiveTime{
    return (NSDate *)[self.applicationDataStore cachedObjectForKey:PREFERENCE_APP_EFFECTIVETIME];
}

#pragma mark getter
- (TCache *)applicationDataStore {
    if(!_applicationDataStore) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        _applicationDataStore = [[TCache alloc] initWithName:kApplicationStoreKey
                                                      dirPath:documentsDirectory];
    }
    return _applicationDataStore;
}
@end
