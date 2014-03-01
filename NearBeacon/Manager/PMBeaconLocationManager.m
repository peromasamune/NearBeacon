//
//  PMBeaconLocationManager.m
//  NearBeacon
//
//  Created by 井上 卓 on 2013/10/07.
//  Copyright (c) 2013年 井上 卓. All rights reserved.
//

#import "PMBeaconLocationManager.h"
#import "LocalNotificationManager.h"
#import "SVProgressHUD.h"

@interface PMBeaconLocationManager()

-(void)initialize;

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) CBPeripheralManager *peripheralManager;
@property (nonatomic, retain) NSUUID *proximityUUID;
@end

@implementation PMBeaconLocationManager

@synthesize isMonitoring = isMonitoring_;
@synthesize isAdvertising = isAdvertising_;

@synthesize locationManager = locationManager_;
@synthesize peripheralManager = peripheralManager_;
@synthesize proximityUUID = proximityUUID_;

#pragma mark -- Initializer --

-(id)init{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void)dealloc{
    [self stopMonitoring];
    self.locationManager.delegate = nil;
    
    [self stopAdvertising];
    self.peripheralManager.delegate = nil;
    
    self.delegate = nil;
}

-(void)initialize{
    if (!self.locationManager) {
        //LocationManagerの初期化
        self.locationManager = [CLLocationManager new];
        self.locationManager.delegate = self;
    }
    
    if (!self.peripheralManager) {
        //PeriferalManagerの初期化
        self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
    }
    
    if (!self.proximityUUID) {
        //生成したUUIDからNSUUIDを作成
        self.proximityUUID = [[NSUUID alloc] initWithUUIDString:[UserDefaultsUtility getUserDefaultsForKey:DEFAULTS_BEACON_UUID]];
    }
    
    if (self.locationManager.monitoredRegions.count > 0) {
        self.isMonitoring = YES;
    }
    
    // TODO : its couldn't check Advertising status in Application killed.
    if (self.peripheralManager.isAdvertising) {
        self.isAdvertising = YES;
    }
}

#pragma mark -- Shared Manager --

+(PMBeaconLocationManager *)sharedManager{
    static PMBeaconLocationManager *manager = nil;
    if (!manager) {
        manager = [[PMBeaconLocationManager alloc] init];
    }
    return manager;
}

#pragma mark -- Class Method --
#pragma mark Monitoring Methods

//Beaconの監視用メソッド群

-(BOOL)startMonitoring{
    
    NSLog(@"%s",__func__);

    if (self.isMonitoring == YES) {
        return YES;
    }
    
    if (![CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]]) {
        //CLBeaconRegionが開始できない
        [SVProgressHUD showErrorWithStatus:@"Failed start monitoring"];
        return NO;
    }
    
    //CLBeaconRegionを生成し、Beaconによる領域観測を開始
    CLBeaconRegion *beacon = [[CLBeaconRegion alloc] initWithProximityUUID:self.proximityUUID
                                                                identifier:[UserDefaultsUtility getUserDefaultsForKey:DEFAULTS_BEACON_ADVERTISING_IDENTIFIER]];
    beacon.notifyEntryStateOnDisplay = YES;
    [self.locationManager startMonitoringForRegion:beacon];
    
    self.isMonitoring = YES;
    
    [SVProgressHUD showSuccessWithStatus:@"Start monitoring"];
    
    return YES;
}

-(BOOL)stopMonitoring{
    
    NSLog(@"%s",__func__);
    
    if (self.isMonitoring == NO) {
        return YES;
    }
    
    if (![CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]]) {
        //CLBeaconRegionが開始できない
        [SVProgressHUD showErrorWithStatus:@"Failed stop monitoring"];
        return NO;
    }
    
    //登録されているBeaconを全て削除する
    for (id regions in self.locationManager.monitoredRegions){
        if ([regions isMemberOfClass:[CLBeaconRegion class]]) {
            [self.locationManager stopRangingBeaconsInRegion:(CLBeaconRegion *) regions];
        }
        if ([regions isKindOfClass:[CLRegion class]]) {
            [self.locationManager stopMonitoringForRegion:(CLRegion *) regions];
        }
    }
    
    self.isMonitoring = NO;
    
    [SVProgressHUD showSuccessWithStatus:@"Stop Monitoring"];
    
    return YES;
}

#pragma mark Advertising Methods

//Beaconのアドバータイジング(配信)用のメソッド群

-(BOOL)startAdvertising{
    
    NSLog(@"%s",__func__);
    
    if (self.isAdvertising == YES) {
        return YES;
    }
    
    if (self.peripheralManager.state != CBPeripheralManagerStatePoweredOn) {
        [SVProgressHUD showErrorWithStatus:@"Failed start advertising"];
        return NO;
    }
    
    //アドバータイジング開始処理
    CLBeaconRegion *beconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:self.proximityUUID
                                                                          major:1
                                                                          minor:2
                                                                     identifier:[UserDefaultsUtility getUserDefaultsForKey:DEFAULTS_BEACON_ADVERTISING_IDENTIFIER]];
    NSDictionary *dic = [beconRegion peripheralDataWithMeasuredPower:nil];
    
    [self.peripheralManager startAdvertising:dic];
    
    self.isAdvertising = YES;
    [SVProgressHUD showSuccessWithStatus:@"Start advertising"];
    
    return YES;
}

-(BOOL)stopAdvertising{
    
    NSLog(@"%s",__func__);
    
    if (self.isAdvertising == NO) {
        return YES;
    }
    
    [self.peripheralManager stopAdvertising];
    self.isAdvertising = NO;
    [SVProgressHUD showSuccessWithStatus:@"Stop advertising"];
    
    return YES;
}

#pragma mark -- CLLocationManagerDelegate --

-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region{
    //領域内に侵入した際にコールされる
    
    NSLog(@"%s",__func__);
    
    [LocalNotificationManager setLocalNotificationFileNow:[NSString stringWithFormat:@"didEnterRegion : %@",region.identifier] block:^(BOOL succeeded) {
        
    }];
    
    //Beaconの距離測定を開始する
    if ([region isMemberOfClass:[CLBeaconRegion class]] && [CLLocationManager isRangingAvailable]) {
        [self.locationManager startRangingBeaconsInRegion:(CLBeaconRegion *) region];
    }
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region{
    //領域内から退出した際にコールされる
    
    NSLog(@"%s",__func__);
    
    [LocalNotificationManager setLocalNotificationFileNow:[NSString stringWithFormat:@"didExitRegion : %@",region.identifier] block:^(BOOL succeeded) {
        
    }];
    
    //Beaconの距離測定を終了する
    if ([region isMemberOfClass:[CLBeaconRegion class]] && [CLLocationManager isRangingAvailable]) {
        [self.locationManager stopRangingBeaconsInRegion:(CLBeaconRegion *) region];
    }
}

//Beaconの距離の測定を開始すると定期的にイベントが呼ばれる
-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region{
    
    NSLog(@"%s",__func__);
    
    for (CLBeacon *beacon in beacons){
        
        NSString *rangeMessage = @"";
        
        // Beaconの距離でメッセージを変える
        switch (beacon.proximity) {
            case CLProximityImmediate:
                rangeMessage = @"Range Immediate";
                break;
            case CLProximityNear:
                rangeMessage = @"Range Near";
                break;
            case CLProximityFar:
                rangeMessage = @"Range Far";
                break;
            default:
                rangeMessage = @"Range Unknown";
                break;
        }
        
        rangeMessage = [NSString stringWithFormat:@"major:%@, minor:%@, accuracy:%f, rssi:%d",
                        beacon.major, beacon.minor, beacon.accuracy, beacon.rssi];
        
        [LocalNotificationManager setLocalNotificationFileNow:[NSString stringWithFormat:@"didRangeBeacons : %@",rangeMessage] block:^(BOOL succeeded) {
            
        }];
    }
    
    [self.delegate PMBeaconLocationManager:manager didRangeBeacons:beacons inRegion:region];
}

//通知エリアを跨ぐ際にコールされるメソッド
-(void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region{
    NSLog(@"%s",__func__);
    
    /*
     * Keep monitoring in background
     * Source : http://stackoverflow.com/questions/19141779/ranging-beacons-only-works-when-app-running/19152814#19152814
     */
    
    if (state == CLRegionStateInside) {
        [manager startRangingBeaconsInRegion:(CLBeaconRegion *) region];
    }else{
        [manager stopRangingBeaconsInRegion:(CLBeaconRegion *) region];
    }
    
    [self.delegate PMBeaconLocationManager:manager didDetermineState:state forRegion:region];
}

#pragma mark -- CBPeripheralManagerDelegate --

-(void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error{
    NSLog(@"%s",__func__);
    
    [LocalNotificationManager setLocalNotificationFileNow:[NSString stringWithFormat:@"DidStartAdvertising : %@",[peripheral description]] block:^(BOOL succeeded) {
        
    }];
}

-(void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral{
    NSLog(@"%s",__func__);
    
    [LocalNotificationManager setLocalNotificationFileNow:[NSString stringWithFormat:@"DidUpdateState : %@",[peripheral description]] block:^(BOOL succeeded) {
        
    }];
}

@end
