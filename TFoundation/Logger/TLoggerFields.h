//
//  TLoggerFields.h
//  TFoundation
//
//  Created by liu nian on 2020/3/30.
//

#import <Foundation/Foundation.h>
#import "TLoggerFileFormatter.h"

NS_ASSUME_NONNULL_BEGIN

@interface TLoggerFields : NSObject <TLoggerFieldsDelegate>
@property (strong, nonatomic) NSString *appversion;
@property (strong, nonatomic) NSString *userid;
@property (strong, nonatomic) NSString *sessionid;
@end

NS_ASSUME_NONNULL_END
