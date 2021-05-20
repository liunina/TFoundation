//
//  TAudioPlayer.h
//  TFoundation
//
//  Created by liu nian on 2020/3/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TAudioPlayer : NSObject
+ (void)playSoundWithFileName:(NSString *)aFileName
				   bundleName:(nullable NSString *)aBundleName
					   ofType:(nullable NSString *)ext
					 andAlert:(BOOL)alert;
@end

NS_ASSUME_NONNULL_END
