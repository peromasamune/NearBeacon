//
//  PMLogUtility.h
//  NearBeacon
//
//  Created by Peromasamune on 2014/03/03.
//  Copyright (c) 2014年 井上 卓. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PMLogUtility : NSObject

+(void)appendLog:(NSString *)log forKey:(NSString *)key;
+(void)writeLog:(NSString *)log forKey:(NSString *)key;
+(NSString *)logForKey:(NSString *)key;

@end
