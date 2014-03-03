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
#import "PMBeaconLocationManager.h"
#import "LogDetailViewController.h"

@interface BeaconStatusListViewController () <UITableViewDataSource, UITableViewDelegate,PMBeaconLocationmanagerDelegate>

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
    self.title = @"iBeacon";
    
    self.dataDictionary = [NSMutableDictionary dictionary];
    
    [PMBeaconLocationManager sharedManager].delegate = self;
    
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

#pragma mark -- Private Method --

-(NSString *)beacomIdentifierNameFromBeacon:(CLBeacon *)beacon{
    NSString *identifier = @"";
    
    identifier = [NSString stringWithFormat:@"%@-%@-%@",beacon.major, beacon.minor, [beacon.proximityUUID UUIDString]];
    
    return identifier;
}

-(void)appendLogMessageWithBeacon:(CLBeacon *)beacon forKey:(NSString *)key{
    
    if (!beacon || !key || [key length] == 0) {
        return;
    }
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"US"]];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    
    //Log追記
    NSString *logMessage = [NSString stringWithFormat:@"%@ major:%@, minor:%@, accuracy:%f, rssi:%ld",
                            dateString, beacon.major, beacon.minor, beacon.accuracy, (long)beacon.rssi];
    [PMLogUtility appendLog:logMessage forKey:key];
}

#pragma mark -- UI Actions --

-(void)switchValueDidChange:(id)sender{
    UISwitch *sw = (UISwitch *)sender;
    
    if (sw.tag == 0) {
        //monitoring
        if (sw.on) {
            [[PMBeaconLocationManager sharedManager] startMonitoring];
        }else{
            [[PMBeaconLocationManager sharedManager] stopMonitoring];
        }
    }
    
    if (sw.tag == 2) {
        //advertising
        if (sw.on) {
            [[PMBeaconLocationManager sharedManager] startAdvertising];
        }else{
            [[PMBeaconLocationManager sharedManager] stopAdvertising];
        }
    }
    
    [self.tableView reloadData];
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
        return [[self.dataDictionary allKeys] count];
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

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"Behavior Status";
    }
    if (section == 1) {
        return @"Beacon Status";
    }
    return @"";
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
        switchCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        switchCell.sw.tag = indexPath.row;
        [switchCell.sw addTarget:self action:@selector(switchValueDidChange:) forControlEvents:UIControlEventValueChanged];
        
        if (indexPath.row == 0) {
            //monitoring
            switchCell.textLabel.text = @"Monitoring Beacon";
            switchCell.sw.on = [PMBeaconLocationManager sharedManager].isMonitoring;
        }
        
        if (indexPath.row == 1) {
            //advertising
            switchCell.textLabel.text = @"Advertising Beacon";
            switchCell.sw.on = [PMBeaconLocationManager sharedManager].isAdvertising;
        }
        
        return switchCell;
    }
    
    if (indexPath.section == 1) {
        BeaconStatusCell *cell = (BeaconStatusCell *)[tableView dequeueReusableCellWithIdentifier:BeaconDetailCellIdentifier];
        if (!cell) {
            cell = [[BeaconStatusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BeaconDetailCellIdentifier];
        }
        
        NSArray *array = [self.dataDictionary allValues];
        if ([array count] <= indexPath.row) {
            return [UITableViewCell new];
        }
        
        CLBeacon *beacon = [array objectAtIndex:indexPath.row];
        
        cell.titleLabel.text = [NSString stringWithFormat:@"title : %@",@"No title"];
        cell.majorLabel.text = [NSString stringWithFormat:@"major : %@",beacon.major];
        cell.minorLabel.text = [NSString stringWithFormat:@"minor : %@",beacon.minor];
        cell.accuracyLabel.text = [NSString stringWithFormat:@"accuracy : %f",beacon.accuracy];
        cell.rssiLabel.text = [NSString stringWithFormat:@"rssi : %ld",(long)beacon.rssi];
        
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
    
    if (indexPath.section != 1) {
        return;
    }
    
    NSArray *array = [self.dataDictionary allValues];
    if ([array count] <= indexPath.row) {
        return;
    }
    
    CLBeacon *beacon = [array objectAtIndex:indexPath.row];
    NSString *identifier = [self beacomIdentifierNameFromBeacon:beacon];
    
    LogDetailViewController *viewController = [[LogDetailViewController alloc] initWithLogKey:identifier];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark -- PMBeaconLocationManagerDelegate

-(void)PMBeaconLocationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region{
    
}

-(void)PMBeaconLocationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region{
    
    for (CLBeacon *beacon in beacons){
        NSString *identifier = [self beacomIdentifierNameFromBeacon:beacon];
        if ([identifier length] == 0 || !identifier) continue;
        
        [self.dataDictionary setObject:beacon forKey:identifier];
        
        //Log
        [self appendLogMessageWithBeacon:beacon forKey:identifier];
        
        //Notification
        [[NSNotificationCenter defaultCenter] postNotificationName:identifier object:nil];
    }
    
    [self.tableView reloadData];
}

@end
