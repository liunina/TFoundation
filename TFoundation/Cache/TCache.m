//
//  TCache.m
//  TFoundation
//
//  Created by liu nian on 2020/3/10.
//

#import "TCache.h"
#import <DFCache/DFCache.h>

@interface TCache ()
@property (nonatomic, strong) NSString *cacheName;
@property (nonatomic, strong) NSString *dirPath;
@property (nonatomic, assign) BOOL memoryCache;
@property (nonatomic, strong) DFCache *cacheDF;
@end
@implementation TCache

- (instancetype)init {
    self = [self initWithName:@"com.t11.cache"];
    if (self) {
    }
    return self;
}

- (instancetype)initWithName:(NSString *)name {
    self = [self initWithName:name dirPath:[DFDiskCache cachesDirectoryPath]];
    return self;
}

- (instancetype)initWithName:(NSString *)name dirPath:(NSString *)dirPath {
    self = [self initWithName:name dirPath:dirPath memoryCache:YES];
    if (self) {
    }
    return self;
}

- (instancetype)initWithName:(NSString *)name dirPath:(NSString *)dirPath memoryCache:(BOOL)memoryCache {
    self = [super init];
    if (self) {
        self.cacheName = name;
        self.dirPath = dirPath;
        self.memoryCache = memoryCache;
    }
    return self;
}

- (void)storeObject:(id)object forKey:(NSString *)key {
    [self.cacheDF storeObject:object forKey:key];
}

- (void)removeObjectForKey:(NSString *)key {
    [self.cacheDF removeObjectForKey:key];
    [self.cacheDF removeMetadataForKey:key];
}

- (void)addMetadata:(NSDictionary *)metadata forKey:(NSString *)key {
    [self.cacheDF setMetadataValues:metadata forKey:key];
}

- (void)removeMetadataForKey:(NSString *)key {
    [self.cacheDF removeMetadataForKey:key];
}
- (void)removeAllObjects {
    [self.cacheDF removeAllObjects];
}

- (id)cachedObjectForKey:(NSString *)key {
    return [self.cacheDF cachedObjectForKey:key];
}
- (void)fetchCachedObjectForKey:(NSString *)key  completion:(void (^)(id))completion {
    [self.cacheDF cachedObjectForKey:key completion:completion];
}

- (NSDictionary *)metadataForKey:(NSString *)key {
    return [self.cacheDF metadataForKey:key];
}

- (unsigned long long)contentsSize{
    return [self.cacheDF.diskCache contentsSize];
}

- (NSTimeInterval)timeIntervalForKey: (NSString*)key {
    return [[self.cacheDF cachedObjectForKey:key] doubleValue];
}

- (void)setTimeInterval: (NSTimeInterval)value forKey: (NSString*)key {
    [self.cacheDF storeObject:@(value) forKey:key];
}

- (BOOL)boolForKey:(NSString*)key {
    return [[self.cacheDF cachedObjectForKey:key] boolValue];
}

- (void)setBool:(BOOL)value forKey:(NSString*)key {
    [self.cacheDF storeObject:@(value) forKey:key];
}

- (NSInteger)integerForKey:(NSString*)key {
    return [[self.cacheDF cachedObjectForKey:key] integerValue];
}

- (void)setInteger:(NSInteger)value forKey: (NSString*)key {
    [self.cacheDF storeObject:@(value) forKey:key];
}


- (float)floatForKey:(NSString*)key {
    return [[self.cacheDF cachedObjectForKey:key] floatValue];
}

- (void)setFloat:(float)value forKey:(NSString*)key {
    [self.cacheDF storeObject:@(value) forKey:key];
}

- (NSString*)stringForKey:(NSString*)key {
    return [self.cacheDF cachedObjectForKey:key];
}

- (void)setString:(NSString*)value forKey:(NSString*)key {
    [self.cacheDF storeObject:value forKey:key];
}

- (void)setArray:(NSArray*)value forKey:(NSString *)key {
    [self.cacheDF storeObject:value forKey:key];
}

- (NSArray*)arrayForKey:(NSString*)key {
    return [self.cacheDF cachedObjectForKey:key];
}

- (void)setDictionary:(NSDictionary*)value forKey:(NSString *)key {
    [self.cacheDF storeObject:value forKey:key];
}

- (NSDictionary*)dictionaryForKey:(NSString*)key {
    return [self.cacheDF cachedObjectForKey:key];
}

#pragma mark - getter
- (DFCache *)cacheDF {
    if (!_cacheDF) {
        NSString *directoryPath = [self.dirPath stringByAppendingPathComponent:self.cacheName];
        DFDiskCache *diskCache = [[DFDiskCache alloc] initWithPath:directoryPath error:nil];
//        diskCache.capacity = 1024 * 1024 * 500; // 500 Mb
        diskCache.capacity = DFDiskCacheCapacityUnlimited;
        NSCache *memoryCache = nil;
        if (self.memoryCache) {
            memoryCache = [NSCache new];
            memoryCache.name = self.cacheName;
        }
        
        DFCache *cache = [[DFCache alloc] initWithDiskCache:diskCache memoryCache:memoryCache];
        _cacheDF = cache;
    }
    return _cacheDF;
}
@end
