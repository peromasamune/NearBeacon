//
//  BeaconStatusCell.h
//  NearBeacon
//
//  Created by Peromasamune on 2014/03/02.
//  Copyright (c) 2014年 井上 卓. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BeaconStatusCell : UITableViewCell

@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *majorLabel;
@property (nonatomic) UILabel *minorLabel;
@property (nonatomic) UILabel *accuracyLabel;
@property (nonatomic) UILabel *rssiLabel;

@end
