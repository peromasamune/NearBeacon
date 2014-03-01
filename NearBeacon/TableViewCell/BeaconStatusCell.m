//
//  BeaconStatusCell.m
//  NearBeacon
//
//  Created by Peromasamune on 2014/03/02.
//  Copyright (c) 2014年 井上 卓. All rights reserved.
//

#import "BeaconStatusCell.h"

@interface BeaconStatusCell()
-(void)createView;
@end

@implementation BeaconStatusCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self createView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark -- Private Method --

-(void)createView{
    
    CGFloat offset = 10.f;
    
    CGRect contentViewRect = self.contentView.frame;
    contentViewRect.origin.x = offset;
    contentViewRect.origin.y = offset;
    contentViewRect.size.width -= offset;
    
    UIView *contentOffsetView = [UIView new];
    contentOffsetView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:contentOffsetView];
    
    CGFloat labelOffset = 0.f;
    self.titleLabel = [self cellLabelWithFrame:CGRectMake(0, 0, contentOffsetView.frame.size.width, 20)];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [contentOffsetView addSubview:self.titleLabel];
    labelOffset += 20;
    
    self.majorLabel = [self cellLabelWithFrame:CGRectMake(0, labelOffset, contentOffsetView.frame.size.width, 20)];
    [contentOffsetView addSubview:self.majorLabel];
    labelOffset += 20;
    
    self.minorLabel = [self cellLabelWithFrame:CGRectMake(0, labelOffset, contentOffsetView.frame.size.width, 20)];
    [contentOffsetView addSubview:self.minorLabel];
    labelOffset += 20;
    
    self.accuracyLabel = [self cellLabelWithFrame:CGRectMake(0, labelOffset, contentOffsetView.frame.size.width, 20)];
    [contentOffsetView addSubview:self.accuracyLabel];
    labelOffset += 20;
    
    self.rssiLabel = [self cellLabelWithFrame:CGRectMake(0, labelOffset, contentOffsetView.frame.size.width, 20)];
    [contentOffsetView addSubview:self.rssiLabel];
    labelOffset += 20;
    
    contentViewRect.size.height = labelOffset;
    contentOffsetView.frame = contentViewRect;
}

-(UILabel *)cellLabelWithFrame:(CGRect)frame{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor darkGrayColor];
    label.font = [UIFont systemFontOfSize:13];
    return label;
}

@end
