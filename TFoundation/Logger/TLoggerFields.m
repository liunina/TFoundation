//
//  TLoggerFields.m
//  TFoundation
//
//  Created by liu nian on 2020/3/30.
//

#import "TLoggerFields.h"

@interface TLoggerFields () {
	dispatch_queue_t _queue;
}
@property (nonatomic, strong) NSDictionary *fieldsDictionary;
@end
@implementation TLoggerFields

- (id)init {
    if((self = [super init])) {
        _queue = dispatch_queue_create("se.baresi.tlogger.loggerfields.queue", NULL);
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
        [dict setObject:[[NSLocale preferredLanguages] objectAtIndex:0] forKey:@"lang"];
        id bundleDisplayName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
        if (bundleDisplayName != nil) {
            [dict setObject:bundleDisplayName forKey:@"appname"];
        } else {
            NSString *bundleName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
            if(bundleName != nil) {
                [dict setObject:bundleName forKey:@"appname"];
            }
        }
        NSString *bundleVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        if(bundleVersion != nil) {
            [dict setObject:bundleVersion forKey:@"appversion"];
        }
        [dict setObject:[UIDevice currentDevice].name forKey:@"devicename"];
        [dict setObject:[UIDevice currentDevice].model forKey:@"devicemodel"];
        [dict setObject:[UIDevice currentDevice].systemVersion forKey:@"osversion"];
        [dict setObject:[self generateRandomStringWithSize:10] forKey:@"sessionid"];
        _fieldsDictionary = [NSDictionary dictionaryWithDictionary:dict];
    }
    return self;
}

#pragma mark TLoggerFieldsDelegate
- (NSDictionary *)loggerFieldsToIncludeInEveryLogStatement {
    // The dict may be altered by one of the setters, so lets use a queue for thread safety
    __block NSDictionary *dict;
    dispatch_sync(_queue, ^{
        dict = [_fieldsDictionary copy];
    });
    return dict;
}

#pragma mark Property setters

- (void)setAppversion:(NSString *)appversion {
	__weak typeof(self) ws = self;
    dispatch_barrier_async(_queue, ^{
		NSMutableDictionary *dict = [ws.fieldsDictionary mutableCopy];
        if (appversion != nil) {
            [dict setObject:appversion forKey:@"appversion"];
        } else {
            [dict removeObjectForKey:@"appversion"];
        }
		ws.fieldsDictionary = [NSDictionary dictionaryWithDictionary:dict];
    });
}

- (void)setSessionid:(NSString *)sessionid {
    __weak typeof(self) ws = self;
	dispatch_barrier_async(_queue, ^{
		NSMutableDictionary *dict = [ws.fieldsDictionary mutableCopy];
        if (sessionid != nil) {
            [dict setObject:sessionid forKey:@"sessionid"];
        } else {
            [dict removeObjectForKey:@"sessionid"];
        }
		ws.fieldsDictionary = [NSDictionary dictionaryWithDictionary:dict];
    });
}

- (void)setUserid:(NSString *)userid {
	__weak typeof(self) ws = self;
    dispatch_barrier_async(_queue, ^{
		NSMutableDictionary *dict = [ws.fieldsDictionary mutableCopy];
        if (userid != nil) {
             [dict setObject:userid forKey:@"userid"];
        } else {
            [dict removeObjectForKey:@"userid"];
        }
		ws.fieldsDictionary = [NSDictionary dictionaryWithDictionary:dict];
    });
}

#pragma mark Private methods
- (NSString*)generateRandomStringWithSize:(int)num {
    NSMutableString* string = [NSMutableString stringWithCapacity:num];
    for (int i = 0; i < num; i++) {
        [string appendFormat:@"%C", (unichar)('a' + arc4random_uniform(25))];
    }
    return string;
}

@end
