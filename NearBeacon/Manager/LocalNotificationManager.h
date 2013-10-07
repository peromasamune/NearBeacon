//
//  LocalNotificationManager.h
//  NearBeacon
//
//  Created by 井上 卓 on 2013/10/07.
//  Copyright (c) 2013年 井上 卓. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SetLocalNotificationBlock)(BOOL succeeded);

@interface LocalNotificationManager : NSObject

//ローカル通知のセット
+(void)setLocalNotificationFileNow:(NSString *)message block:(SetLocalNotificationBlock)block;

+(void)setLocalNotificationWithMessage:(NSString *)message fireDate:(NSDate *)date isNowFile:(BOOL)isNow block:(SetLocalNotificationBlock)block;

//ローカル通知の削除
+(void)deleteLocalNotificationWithMessage:(NSString *)message fireDate:(NSDate *)date;

//ローカル通知を一覧表示
+(NSArray *)allLocalNotificationList;

@end
