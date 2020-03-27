//
//  TKeychainItemWrapper.m
//  TFoundation
//
//  Created by liu nian on 2020/3/27.
//

#import "TKeychainItemWrapper.h"
#import <Security/Security.h>

/*

These are the default constants and their respective types,
available for the kSecClassGenericPassword Keychain Item class:

kSecAttrAccessGroup			-		CFStringRef
kSecAttrCreationDate		-		CFDateRef
kSecAttrModificationDate    -		CFDateRef
kSecAttrDescription			-		CFStringRef
kSecAttrComment				-		CFStringRef
kSecAttrCreator				-		CFNumberRef
kSecAttrType                -		CFNumberRef
kSecAttrLabel				-		CFStringRef
kSecAttrIsInvisible			-		CFBooleanRef
kSecAttrIsNegative			-		CFBooleanRef
kSecAttrAccount				-		CFStringRef
kSecAttrService				-		CFStringRef
kSecAttrGeneric				-		CFDataRef
 
See the header file Security/SecItem.h for more details.

*/

@interface TKeychainItemWrapper (PrivateMethods)
/*
The decision behind the following two methods (secItemFormatToDictionary and dictionaryToSecItemFormat) was
to encapsulate the transition between what the detail view controller was expecting (NSString *) and what the
Keychain API expects as a validly constructed container class.
*/
- (NSMutableDictionary *)secItemFormatToDictionary:(NSDictionary *)dictionaryToConvert;
- (NSMutableDictionary *)dictionaryToSecItemFormat:(NSDictionary *)dictionaryToConvert;

// Updates the item in the keychain, or adds it if it doesn't exist.
- (void)writeToKeychain;

@end

@implementation TKeychainItemWrapper

@synthesize keychainItemData, genericPasswordQuery;

- (id)initWithIdentifier: (NSString *)identifier accessGroup:(NSString *) accessGroup;
{
    if (self = [super init])
    {
        // Begin Keychain search setup. The genericPasswordQuery leverages the special user
        // defined attribute kSecAttrGeneric to distinguish itself between other generic Keychain
        // items which may be included by the same application.
        genericPasswordQuery = [[NSMutableDictionary alloc] init];
        
		[genericPasswordQuery setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
        [genericPasswordQuery setObject:identifier forKey:(id)kSecAttrGeneric];
		
		// The keychain access group attribute determines if this item can be shared
		// amongst multiple apps whose code signing entitlements contain the same keychain access group.
		if (accessGroup != nil)
		{
#if TARGET_IPHONE_SIMULATOR
			// Ignore the access group if running on the iPhone simulator.
			//
			// Apps that are built for the simulator aren't signed, so there's no keychain access group
			// for the simulator to check. This means that all apps can see all keychain items when run
			// on the simulator.
			//
			// If a SecItem contains an access group attribute, SecItemAdd and SecItemUpdate on the
			// simulator will return -25243 (errSecNoAccessForItem).
#else
			[genericPasswordQuery setObject:accessGroup forKey:(id)kSecAttrAccessGroup];
#endif
		}
		
		// Use the proper search constants, return only the attributes of the first match.
        [genericPasswordQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
        [genericPasswordQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnAttributes];
        
        NSDictionary *tempQuery = [NSDictionary dictionaryWithDictionary:genericPasswordQuery];
        NSDictionary *outDictionary = nil;
        CFTypeRef outDictionaryRef;
        if (SecItemCopyMatching((CFDictionaryRef)tempQuery, &outDictionaryRef) != noErr) {
			
			outDictionary = (__bridge_transfer NSDictionary*)outDictionaryRef;
            // Stick these default values into keychain item if nothing found.
            [self resetKeychainItem];
			
			// Add the generic attribute and the keychain access group.
			[keychainItemData setObject:identifier forKey:(id)kSecAttrGeneric];
			if (accessGroup != nil)
			{
#if TARGET_IPHONE_SIMULATOR
				// Ignore the access group if running on the iPhone simulator.
				//
				// Apps that are built for the simulator aren't signed, so there's no keychain access group
				// for the simulator to check. This means that all apps can see all keychain items when run
				// on the simulator.
				//
				// If a SecItem contains an access group attribute, SecItemAdd and SecItemUpdate on the
				// simulator will return -25243 (errSecNoAccessForItem).
#else
				[keychainItemData setObject:accessGroup forKey:(id)kSecAttrAccessGroup];
#endif
			}
		} else {
            // load the saved data from Keychain.
            self.keychainItemData = [self secItemFormatToDictionary:outDictionary];
        }
    }
    
	return self;
}

- (void)dealloc{
    keychainItemData = nil;
	genericPasswordQuery = nil;
}

- (void)setObject:(id)inObject forKey:(id)key {
    if (inObject == nil) return;
    id currentObject = [keychainItemData objectForKey:key];
    if (![currentObject isEqual:inObject])
    {
        [keychainItemData setObject:inObject forKey:key];
        [self writeToKeychain];
    }
}

- (id)objectForKey:(id)key {
    return [keychainItemData objectForKey:key];
}

- (void)resetKeychainItem {
	OSStatus junk = noErr;
    if (!keychainItemData) {
        if (self.keychainItemData) {
            self.keychainItemData = nil;
        }
        self.keychainItemData = [[NSMutableDictionary alloc] init];
    } else if (keychainItemData) {
        NSMutableDictionary *tempDictionary = [self dictionaryToSecItemFormat:keychainItemData];
		junk = SecItemDelete((CFDictionaryRef)tempDictionary);
//        NSAssert( junk == noErr || junk == errSecItemNotFound, @"Problem deleting current dictionary." );
    }
    
    // Default attributes for keychain item.
    [keychainItemData setObject:@"" forKey:(id)kSecAttrAccount];
    [keychainItemData setObject:@"" forKey:(id)kSecAttrLabel];
    [keychainItemData setObject:@"" forKey:(id)kSecAttrDescription];
    
	// Default data for keychain item.
    [keychainItemData setObject:@"" forKey:(id)kSecValueData];
}

- (NSMutableDictionary *)dictionaryToSecItemFormat:(NSDictionary *)dictionaryToConvert {
    // The assumption is that this method will be called with a properly populated dictionary
    // containing all the right key/value pairs for a SecItem.
    
    // Create a dictionary to return populated with the attributes and data.
    NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionaryToConvert];
    
    // Add the Generic Password keychain item class attribute.
    [returnDictionary setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
    
    // Convert the NSString to NSData to meet the requirements for the value type kSecValueData.
	// This is where to store sensitive data that should be encrypted.
    if ([[dictionaryToConvert objectForKey:(id)kSecValueData] isKindOfClass:[NSString class]]) {
        NSString *passwordString = [dictionaryToConvert objectForKey:(id)kSecValueData];
        [returnDictionary setObject:[passwordString dataUsingEncoding:NSUTF8StringEncoding] forKey:(id)kSecValueData];
    }
    else {
        [returnDictionary setObject:[dictionaryToConvert objectForKey:(id)kSecValueData] forKey:(id)kSecValueData];
    }
    
    return returnDictionary;
}

- (NSMutableDictionary *)secItemFormatToDictionary:(NSDictionary *)dictionaryToConvert
{
    // The assumption is that this method will be called with a properly populated dictionary
    // containing all the right key/value pairs for the UI element.
    
    // Create a dictionary to return populated with the attributes and data.
    NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionaryToConvert];
    
    // Add the proper search key and class attribute.
    [returnDictionary setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [returnDictionary setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
    
    // Acquire the password data from the attributes.
	CFTypeRef passwordDataRef;
    if (SecItemCopyMatching((CFDictionaryRef)returnDictionary, &passwordDataRef) == noErr) {
		NSData *passwordData = (__bridge_transfer NSData*)passwordDataRef;
        // Remove the search, class, and identifier key/value, we don't need them anymore.
        [returnDictionary removeObjectForKey:(id)kSecReturnData];
        
        // Add the password to the dictionary, converting from NSData to NSString.
        NSString *password = [[NSString alloc] initWithBytes:[passwordData bytes] length:[passwordData length]
                                                     encoding:NSUTF8StringEncoding];
        if (password) {
            [returnDictionary setObject:password forKey:(id)kSecValueData];
        }else {
            [returnDictionary setObject:passwordData forKey:(id)kSecValueData];
        }
    }else {
        // Don't do anything if nothing is found.
//        NSAssert(NO, @"Serious error, no matching item found in the keychain.\n");
    }
	return returnDictionary;
}

- (void)writeToKeychain {
    NSMutableDictionary *updateItem = NULL;
	OSStatus result;
    
	CFTypeRef attributesDataRef;
	
    if (SecItemCopyMatching((CFDictionaryRef)genericPasswordQuery, &attributesDataRef) == noErr) {
        
		NSDictionary *attributes = (__bridge_transfer NSDictionary*)attributesDataRef;
		// First we need the attributes from the Keychain.
        updateItem = [NSMutableDictionary dictionaryWithDictionary:attributes];
        // Second we need to add the appropriate search key/values.
        [updateItem setObject:[genericPasswordQuery objectForKey:(id)kSecClass] forKey:(id)kSecClass];
        
        // Lastly, we need to set up the updated attribute list being careful to remove the class.
        NSMutableDictionary *tempCheck = [self dictionaryToSecItemFormat:keychainItemData];
        [tempCheck removeObjectForKey:(id)kSecClass];
		
#if TARGET_IPHONE_SIMULATOR
		// Remove the access group if running on the iPhone simulator.
		//
		// Apps that are built for the simulator aren't signed, so there's no keychain access group
		// for the simulator to check. This means that all apps can see all keychain items when run
		// on the simulator.
		//
		// If a SecItem contains an access group attribute, SecItemAdd and SecItemUpdate on the
		// simulator will return -25243 (errSecNoAccessForItem).
		//
		// The access group attribute will be included in items returned by SecItemCopyMatching,
		// which is why we need to remove it before updating the item.
		[tempCheck removeObjectForKey:(id)kSecAttrAccessGroup];
#endif
        
        // An implicit assumption is that you can only update a single item at a time.
		
        result = SecItemUpdate((CFDictionaryRef)updateItem, (CFDictionaryRef)tempCheck);
//		NSAssert( result == noErr, @"Couldn't update the Keychain Item." );
    }else {
        // No previous item found; add the new one.
        result = SecItemAdd((CFDictionaryRef)[self dictionaryToSecItemFormat:keychainItemData], NULL);
//		NSAssert( result == noErr, @"Couldn't add the Keychain Item." );
    }
}

@end
