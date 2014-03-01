//
//  PMBeaconLocationManager.h
//  NearBeacon
//
//  Created by 井上 卓 on 2013/10/07.
//  Copyright (c) 2013年 井上 卓. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@protocol PMBeaconLocationmanagerDelegate;
@interface PMBeaconLocationManager : NSObject <CLLocationManagerDelegate, CBPeripheralManagerDelegate>

+(PMBeaconLocationManager *)sharedManager;

-(BOOL)startMonitoring;
-(BOOL)stopMonitoring;

-(BOOL)startAdvertising;
-(BOOL)stopAdvertising;

@property (nonatomic) BOOL isMonitoring;
@property (nonatomic) BOOL isAdvertising;
@property (nonatomic, weak) id<PMBeaconLocationmanagerDelegate> delegate;

@end

@protocol PMBeaconLocationmanagerDelegate <NSObject>
@optional
-(void)PMBeaconLocationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region;
-(void)PMBeaconLocationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region;
@end
