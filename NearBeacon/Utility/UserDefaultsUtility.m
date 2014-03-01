//
//  UserDefaultManager.m
//  ExploreMemo
//
//  Created by Tak on 12/11/11.
//  Copyright (c) 2012年 Tak. All rights reserved.
//

#import "UserDefaultsUtility.h"

@interface UserDefaultsUtility()

@end

@implementation UserDefaultsUtility

+(void)initializeUserDefault{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:@"jp.co.yumemi" forKey:DEFAULTS_BEACON_ADVERTISING_IDENTIFIER];
    [dic setValue:@"887B3993-B1AD-48F8-968D-B27705B8CEE7" forKey:DEFAULTS_BEACON_UUID];
    [dic setValue:[NSNumber numberWithInteger:0] forKey:@"default_store_unlock_ad"];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults registerDefaults:dic];
}

+(id)getUserDefaultsForKey:(NSString *)key{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+(void)setUsetDefaultsObjects:(id)objects forKey:(NSString *)key{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:objects forKey:key];
    [userDefaults synchronize];
}

@end
