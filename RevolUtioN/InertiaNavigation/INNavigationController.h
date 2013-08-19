//
//  CRViewController.h
//  DeviceInfoTest
//
//  Created by Bjorn on 13-7-15.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <CoreMotion/CoreMotion.h>
#import "INTimeWindow.h"
#import "INKalmanFilter.h"
#import "INStepCounting.h"

@interface INNavigationController : UIViewController<CLLocationManagerDelegate, MKMapViewDelegate>{
    BOOL wasFound;
}

- (IBAction)startAction:(id)sender;
- (IBAction)stopAction:(id)sender;
- (IBAction)hideKeyboard:(id)sender;
- (IBAction)bgTap:(id)sender;

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (strong, nonatomic) CMMotionManager *motionManager;
@property (strong, nonatomic) MKMapView *mapView;

@property (retain, nonatomic) NSMutableArray *routePoints;
@property (retain, nonatomic) MKPolyline *routeLine;
@property (retain, nonatomic) MKPolylineView *routeLineView;

@property (strong, nonatomic) CLLocation *initialLocation;
@property (strong, nonatomic) CLLocation *formerLocation;
@property (nonatomic) BOOL isStarted;
@property (assign) NSTimer *repeatingTimer;
@property (strong, nonatomic) INTimeWindow *timeWindow;
@property (strong, nonatomic) INDeviceStatus *formerStatus;
@property (nonatomic) NSInteger formerTimeTag;
@property (nonatomic) NSInteger aDir;
@property (strong, nonatomic) INKalmanFilter *kalmanFilter;
@property (nonatomic) CLLocationCoordinate2D coordinateOffset;
@property (strong, nonatomic) INStepCounting *stepCounting;

@end
