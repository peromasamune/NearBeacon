//
//  LocalNotificationManager.m
//  NearBeacon
//
//  Created by 井上 卓 on 2013/10/07.
//  Copyright (c) 2013年 井上 卓. All rights reserved.
//

#import "LocalNotificationManager.h"

@interface LocalNotificationManager()
+(UILocalNotification *)searchLocalNotificationFromMessage:(NSString *)message fireDate:(NSDate *)date;
@end

@implementation LocalNotificationManager

#pragma mark - Provate Method
+(UILocalNotification *)searchLocalNotificationFromMessage:(NSString *)message fireDate:(NSDate *)date{
    NSLog(@"model message:%@ date:%@",message,date);
    NSArray *notifiArray = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *notification in notifiArray){
        NSLog(@"notification message:%@ date:%@",notification.alertBody,notification.fireDate);
        if ([notification.alertBody isEqualToString:message] && [notification.fireDate compare:date] == NSOrderedSame) {
            return notification;
        }
    }
    return nil;
}

#pragma mark - Class Method
+(void)setLocalNotificationFileNow:(NSString *)message block:(SetLocalNotificationBlock)block{
    [LocalNotificationManager setLocalNotificationWithMessage:message fireDate:nil isNowFile:YES block:block];
}

+(void)setLocalNotificationWithMessage:(NSString *)message fireDate:(NSDate *)date isNowFile:(BOOL)isNow block:(SetLocalNotificationBlock)block{
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    if (localNotification == nil) {
        if (block) block(NO);
        return;
    }
    
    //過去の時間は登録しない
    if (isNow == NO) {
        if ([[date dateByAddingTimeInterval:0] compare:[NSNumber numberWithInteger:[[NSDate date] timeIntervalSinceNow]]] == NSOrderedAscending) {
            block(NO);
            return;
        }
    }
    
    localNotification.fireDate = date;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.alertBody = message;
    localNotification.alertAction = NSLocalizedString(@"Show", @"");
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    
    if (isNow) {
        [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
    }else{
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
    
    NSLog(@"Set LocalNotification %@ : %@",date,message);
    
    if (block) block(YES);
}

+(void)deleteLocalNotificationWithMessage:(NSString *)message fireDate:(NSDate *)date{
    UILocalNotification *notification = [LocalNotificationManager searchLocalNotificationFromMessage:message fireDate:date];
    if (notification == nil) {
        NSLog(@"Target LocalNotification not found");
        return;
    }
    [[UIApplication sharedApplication] cancelLocalNotification:notification];
    NSLog(@"Delete LocalNotification");
}

+(NSArray *)allLocalNotificationList{
    return [[UIApplication sharedApplication] scheduledLocalNotifications];
}


@end
