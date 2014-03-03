//
//  PMLogUtility.m
//  NearBeacon
//
//  Created by Peromasamune on 2014/03/03.
//  Copyright (c) 2014年 井上 卓. All rights reserved.
//

#import "PMLogUtility.h"

@implementation PMLogUtility

#define FILE_DIRECTORY @"Log"

#pragma mark -- Class Method --

+(void)appendLog:(NSString *)log forKey:(NSString *)key{
    
    if (!log || [log length] == 0) {
        NSLog(@"%s : Log length is 0",__func__);
        return;
    }
    
    if (!key || [key length] == 0) {
        NSLog(@"%s : Key not found",__func__);
        return;
    }
    
    [PMLogUtility createDirectory];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *filePath = [PMLogUtility filePathForDirectory:FILE_DIRECTORY name:key];
    log = [log stringByAppendingString:@"\n"];
    
    if (![fileManager fileExistsAtPath:filePath]) {
        NSError *error = nil;
        [log writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
        if (error) {
            NSLog(@"%s : %@",__func__,[error localizedDescription]);
            NSLog(@"path : %@ \n log : %@",filePath,log);
        }
    }else{
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:filePath];
        [fileHandle seekToEndOfFile];
        NSData *textData = [log dataUsingEncoding:NSUTF8StringEncoding];
        [fileHandle writeData:textData];
        [fileHandle closeFile];
    }
}

+(void)writeLog:(NSString *)log forKey:(NSString *)key{
    
    if (!key || [key length] == 0) {
        NSLog(@"%s : Key not found",__func__);
        return;
    }
    
    NSString *filePath = [PMLogUtility filePathForDirectory:FILE_DIRECTORY name:key];
    
    NSError *error = nil;
    [log writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"%s : %@",__func__,[error localizedDescription]);
    }
}

+(NSString *)logForKey:(NSString *)key{
    
    if (!key || [key length] == 0) {
        NSLog(@"%s : Key not found",__func__);
        return @"";
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *filePath = [PMLogUtility filePathForDirectory:FILE_DIRECTORY name:key];
    
    if (![fileManager fileExistsAtPath:filePath]) {
        NSLog(@"%s : File not found",__func__);
        return @"";
    }
    
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    NSString *fileString = [[NSString alloc] initWithData:fileData encoding:NSUTF8StringEncoding];
    
    return fileString;
}

#pragma mark -- Private Method --

+(NSString *)filePathForDirectory:(NSString *)dir name:(NSString *)name{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [paths objectAtIndex:0];
    
    if (dir || [dir length] > 0) {
        documentDir = [documentDir stringByAppendingPathComponent:dir];
    }
    
    return [documentDir stringByAppendingPathComponent:name];
}

+(void)createDirectory{
    NSFileManager *fileManager= [NSFileManager defaultManager];
    BOOL isDir=YES;
    NSError *error = nil;
    
    NSString *filePath = [self filePathForDirectory:FILE_DIRECTORY name:@""];
    
    if(![fileManager fileExistsAtPath:filePath isDirectory:&isDir]){
        if(![fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:&error]){
            NSLog(@"%s error : %@",__func__,[error localizedDescription]);
        }
    }
}

@end
