//
//  LogDetailViewController.h
//  NearBeacon
//
//  Created by Peromasamune on 2014/03/03.
//  Copyright (c) 2014年 井上 卓. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogDetailViewController : UIViewController

-(id)initWithLogKey:(NSString *)logKey;

@property (nonatomic) NSString *logKey;

@end
