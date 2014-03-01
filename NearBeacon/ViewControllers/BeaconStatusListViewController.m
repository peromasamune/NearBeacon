//
//  BeaconStatusListViewController.m
//  NearBeacon
//
//  Created by Peromasamune on 2014/03/02.
//  Copyright (c) 2014年 井上 卓. All rights reserved.
//

#import "BeaconStatusListViewController.h"

#import "BeaconStatusCell.h"
#import "SwitchCell.h"

@interface BeaconStatusListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSMutableDictionary *dataDictionary;

@end

@implementation BeaconStatusListViewController

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
    
    self.dataDictionary = [NSMutableDictionary dictionary];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- UITableView DataSource --

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }
    if (section == 1) {
        return 1;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 44.f;
    }
    if (indexPath.section == 1) {
        return 120.f;
    }
    return 0.f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *SwitchCellIdentifier = @"SwitchCell";
    static NSString *BeaconDetailCellIdentifier = @"BeaconDetailCell";
    
    if (indexPath.section == 0) {
        SwitchCell *switchCell = (SwitchCell *)[tableView dequeueReusableCellWithIdentifier:SwitchCellIdentifier];
        if (!switchCell) {
            switchCell = [[SwitchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SwitchCellIdentifier];
        }
        
        switchCell.textLabel.textColor = [UIColor darkGrayColor];
        switchCell.textLabel.font = [UIFont boldSystemFontOfSize:15];
        
        switch (indexPath.row) {
            case 0:
                switchCell.textLabel.text = @"Monitoring Beacon";
                break;
            case 1:
                switchCell.textLabel.text = @"Advertising Beacon";
                break;
            default:
                break;
        }
        
        return switchCell;
    }
    
    if (indexPath.section == 1) {
        BeaconStatusCell *cell = (BeaconStatusCell *)[tableView dequeueReusableCellWithIdentifier:BeaconDetailCellIdentifier];
        if (!cell) {
            cell = [[BeaconStatusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BeaconDetailCellIdentifier];
        }
        
        cell.titleLabel.text = [NSString stringWithFormat:@"title : %@",@"No title"];
        cell.majorLabel.text = [NSString stringWithFormat:@"major : %@",@"1"];
        cell.minorLabel.text = [NSString stringWithFormat:@"minor : %@",@"2"];
        cell.accuracyLabel.text = [NSString stringWithFormat:@"accuracy : %@",@"1.00000"];
        cell.rssiLabel.text = [NSString stringWithFormat:@"rssi : %@",@"1.00000"];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
    }
    
    return [UITableViewCell new];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark -- UITableView Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
