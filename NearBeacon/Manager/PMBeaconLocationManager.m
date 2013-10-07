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

#define BECON_IDENTIFIER @"jp.co.yumemi"

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
        self.proximityUUID = [[NSUUID alloc] initWithUUIDString:@"887B3993-B1AD-48F8-968D-B27705B8CEE7"];
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

-(void)startMonitoring{

    if (self.isMonitoring == YES) {
        return;
    }
    
    if (![CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]]) {
        //CLBeaconRegionが開始できない
        [SVProgressHUD showErrorWithStatus:@"Failed start monitoring"];
        return;
    }
    
    //CLBeaconRegionを生成し、Beaconによる領域観測を開始
    CLBeaconRegion *beacon = [[CLBeaconRegion alloc] initWithProximityUUID:self.proximityUUID identifier:BECON_IDENTIFIER];
    [self.locationManager startMonitoringForRegion:beacon];
    
    self.isMonitoring = YES;
    
    [SVProgressHUD showSuccessWithStatus:@"Start monitoring"];
}

-(void)stopMonitoring{
    
    if (self.isMonitoring == NO) {
        return;
    }
    
    if (![CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]]) {
        //CLBeaconRegionが開始できない
        [SVProgressHUD showErrorWithStatus:@"Failed stop monitoring"];
        return;
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
}

#pragma mark Advertising Methods

//Beaconのアドバータイジング(配信)用のメソッド群

-(void)startAdvertising{
    
    if (self.isAdvertising == YES) {
        return;
    }
    
    if (self.peripheralManager.state != CBPeripheralManagerStatePoweredOn) {
        [SVProgressHUD showErrorWithStatus:@"Failed start advertising"];
        return;
    }
    
    //アドバータイジング開始処理
    CLBeaconRegion *beconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:self.proximityUUID
                                                                          major:1
                                                                          minor:2
                                                                     identifier:BECON_IDENTIFIER];
    NSDictionary *dic = [beconRegion peripheralDataWithMeasuredPower:nil];
    
    [self.peripheralManager startAdvertising:dic];
    
    self.isAdvertising = YES;
    [SVProgressHUD showSuccessWithStatus:@"Start advertising"];
}

-(void)stopAdvertising{
    
    if (self.isAdvertising == NO) {
        return;
    }
    
    [self.peripheralManager removeAllServices];
    self.isAdvertising = NO;
    [SVProgressHUD showSuccessWithStatus:@"Stop advertising"];
}

#pragma mark -- CLLocationManagerDelegate --

-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region{
    //領域内に侵入した際にコールされる
    
    [LocalNotificationManager setLocalNotificationFileNow:[NSString stringWithFormat:@"didEnterRegion : %@",region.identifier] block:^(BOOL succeeded) {
        
    }];
    
    //Beaconの距離測定を開始する
    if ([region isMemberOfClass:[CLBeaconRegion class]] && [CLLocationManager isRangingAvailable]) {
        [self.locationManager startRangingBeaconsInRegion:(CLBeaconRegion *) region];
    }
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region{
    //領域内から退出した際にコールされる
    
    [LocalNotificationManager setLocalNotificationFileNow:[NSString stringWithFormat:@"didExitRegion : %@",region.identifier] block:^(BOOL succeeded) {
        
    }];
    
    //Beaconの距離測定を終了する
    if ([region isMemberOfClass:[CLBeaconRegion class]] && [CLLocationManager isRangingAvailable]) {
        [self.locationManager stopRangingBeaconsInRegion:(CLBeaconRegion *) region];
    }
}

//Beaconの距離の測定を開始すると定期的にイベントが呼ばれる
-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region{
    
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
}

-(void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error{
    [LocalNotificationManager setLocalNotificationFileNow:[NSString stringWithFormat:@"DidStartAdvertising : %@",[peripheral description]] block:^(BOOL succeeded) {
        
    }];
}

-(void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral{
    [LocalNotificationManager setLocalNotificationFileNow:[NSString stringWithFormat:@"DidUpdateState : %@",[peripheral description]] block:^(BOOL succeeded) {
        
    }];
}

@end
