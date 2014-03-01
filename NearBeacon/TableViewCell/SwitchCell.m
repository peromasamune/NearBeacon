//
//  SwitchCell.m
//  LightingButtons
//
//  Created by 井上 卓 on 12/08/27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SwitchCell.h"

@implementation SwitchCell

@synthesize sw = sw_;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        //self.sw = [[[UISwitch alloc] initWithFrame:CGRectMake(211, 8, 79, 27)] autorelease];
        self.sw = [[[UISwitch alloc] initWithFrame:CGRectMake(self.contentView.frame.size.width-79-10, 8, 79, 27)] autorelease];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

-(void)layoutSubviews{
    [super layoutSubviews];
    if (is_major_version_7()) {
        self.imageView.frame = CGRectMake(self.imageView.frame.origin.x, 5, 34, 34);
    }else{
        self.imageView.frame = CGRectMake(5, 5, 34, 34);

    }
}

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    //NSLog(@"Called Switchcell drawRect");
    self.sw.frame = CGRectMake(self.contentView.frame.size.width-self.sw.frame.size.width-10, 8, self.sw.frame.size.width, 27);
    [self.contentView addSubview:self.sw];
}

-(void)dealloc{
    self.sw = nil;
    [super dealloc];
}

@end
