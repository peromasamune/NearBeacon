//
//  LogDetailViewController.m
//  NearBeacon
//
//  Created by Peromasamune on 2014/03/03.
//  Copyright (c) 2014年 井上 卓. All rights reserved.
//

#import "LogDetailViewController.h"

@interface LogDetailViewController ()

@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) UILabel *textLabel;

@end

@implementation LogDetailViewController

- (id)initWithLogKey:(NSString *)logKey{
    self = [super init];
    if (self) {
        _logKey = logKey;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.title = @"Log";
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollView];
    
    self.textLabel = [[UILabel alloc] init];
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.textLabel.font = [UIFont systemFontOfSize:10];
    self.textLabel.numberOfLines = 0;
    [self.scrollView addSubview:self.textLabel];
    
    UIBarButtonItem *deleteButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteLogButtonDidPush:)];
    self.navigationItem.rightBarButtonItem = deleteButton;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self setLogText];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRangeBeaconsNotification:) name:self.logKey object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- Private Method --

-(void)setLogText{
    if (self.textLabel && self.scrollView) {
        NSString *logText = [PMLogUtility logForKey:self.logKey];
        
        BOOL isBottom = (self.scrollView.contentOffset.y >= self.textLabel.frame.size.height - self.scrollView.frame.size.height);
        
        self.textLabel.text = logText;
        [self.textLabel sizeToFit];
        
        CGFloat offsetY = 0;
        CGFloat navHeight = self.navigationController.navigationBar.frame.size.height + 20;
        
        if (self.scrollView.contentSize.height + navHeight < self.scrollView.frame.size.height) {
            offsetY += navHeight;
        }
        
        self.textLabel.frame = CGRectMake(0, offsetY, self.scrollView.frame.size.width, self.textLabel.frame.size.height);
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.textLabel.frame.size.height);
        
        if (isBottom) {
            CGFloat offset = self.textLabel.frame.size.height - self.scrollView.frame.size.height;
            if (offset < 0) {
                offset = 0;
            }
            self.scrollView.contentOffset = CGPointMake(0, offset);
        }
    }
};

#pragma mark -- Button Actions --

-(void)deleteLogButtonDidPush:(id)sender{
    [PMLogUtility writeLog:@"" forKey:self.logKey];
}

#pragma mark -- NSNotificationCenter --

-(void)didRangeBeaconsNotification:(NSNotification *)notification{
    [self setLogText];
}

#pragma mark -- UITextViewDelegate --
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    return YES;
}

@end
