//
//  MainViewController.m
//  NearBeacon
//
//  Created by 井上 卓 on 2013/10/07.
//  Copyright (c) 2013年 井上 卓. All rights reserved.
//

#import "MainViewController.h"
#import "PMBeaconLocationManager.h"

@interface MainViewController ()

-(void)createView;

@property (nonatomic, retain) UITableView *tableView;
@end

@implementation MainViewController

@synthesize tableView = tableView_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self createView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CreateView
-(void)createView{
    
    self.title = @"Main Menu";
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120.f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    PMBeaconLocationManager *manager = [PMBeaconLocationManager sharedManager];
    
    if (indexPath.section == 0) {
        cell.textLabel.text = @"Monitoring Beacon";
        if (manager.isMonitoring) {
            cell.detailTextLabel.text = @"Running";
            cell.detailTextLabel.textColor = [UIColor blueColor];
        }else{
            cell.detailTextLabel.text = @"Stop";
            cell.detailTextLabel.textColor = [UIColor redColor];
        }
    }
    
    if (indexPath.section == 1) {
        cell.textLabel.text = @"Advertising Beacon";
        if (manager.isAdvertising) {
            cell.detailTextLabel.text = @"Running";
            cell.detailTextLabel.textColor = [UIColor blueColor];
        }else{
            cell.detailTextLabel.text = @"Stop";
            cell.detailTextLabel.textColor = [UIColor redColor];
        }
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PMBeaconLocationManager *manager = [PMBeaconLocationManager sharedManager];
    
    if (indexPath.section == 0) {
        if (manager.isMonitoring) {
            [manager stopMonitoring];
        }else{
            [manager startMonitoring];
        }
    }
    
    if (indexPath.section == 1) {
        if (manager.isAdvertising) {
            [manager stopAdvertising];
        }else{
            [manager startAdvertising];
        }
    }
    
    [tableView reloadData];
}

@end
