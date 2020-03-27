//
//  TKeychainItemWrapper.h
//  TFoundation
//
//  Created by liu nian on 2020/3/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*
    The KeychainItemWrapper class is an abstraction layer for the iPhone Keychain communication. It is merely a
    simple wrapper to provide a distinct barrier between all the idiosyncracies involved with the Keychain
    CF/NS container objects.
*/
@interface TKeychainItemWrapper : NSObject {
    NSMutableDictionary *keychainItemData;		// The actual keychain item data backing store.
    NSMutableDictionary *genericPasswordQuery;	// A placeholder for the generic keychain item query used to locate the item.
}

@property (nonatomic, retain, nullable) NSMutableDictionary *keychainItemData;
@property (nonatomic, retain, nullable) NSMutableDictionary *genericPasswordQuery;

// Designated initializer.
- (id)initWithIdentifier: (NSString *)identifier accessGroup:(NSString *) accessGroup;
- (void)setObject:(id)inObject forKey:(id)key;
- (id)objectForKey:(id)key;

// Initializes and resets the default generic keychain item data.
- (void)resetKeychainItem;

@end

NS_ASSUME_NONNULL_END
