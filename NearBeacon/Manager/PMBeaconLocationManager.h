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

@interface PMBeaconLocationManager : NSObject <CLLocationManagerDelegate, CBPeripheralManagerDelegate>

+(PMBeaconLocationManager *)sharedManager;

-(void)startMonitoring;
-(void)stopMonitoring;

-(void)startAdvertising;
-(void)stopAdvertising;

@property (nonatomic) BOOL isMonitoring;
@property (nonatomic) BOOL isAdvertising;

@end
