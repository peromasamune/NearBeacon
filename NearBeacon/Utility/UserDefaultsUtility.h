//
//  UserDefaultManager.h
//  ExploreMemo
//
//  Created by Tak on 12/11/11.
//  Copyright (c) 2012年 Tak. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DEFAULTS_BEACON_ADVERTISING_IDENTIFIER @"defaults_beacon_advertising_identifier"
#define DEFAULTS_BEACON_UUID @"defaults_beacon_uuid"

@interface UserDefaultsUtility : NSObject{
    
}

+(void)initializeUserDefault;

+(id)getUserDefaultsForKey:(NSString *)key;
+(void)setUsetDefaultsObjects:(id)objects forKey:(NSString *)key;

@end
