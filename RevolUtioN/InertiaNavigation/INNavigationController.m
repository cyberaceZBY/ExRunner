//
//  CRViewController.m
//  DeviceInfoTest
//
//  Created by Bjorn on 13-7-15.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "INNavigationController.h"
#import "INDeviceStatus.h"

static const NSTimeInterval deviceMotionMin = 0.01;

typedef enum {
    kDeviceMotionGraphTypeAttitude = 0,
    kDeviceMotionGraphTypeRotationRate,
    kDeviceMotionGraphTypeGravity,
    kDeviceMotionGraphTypeUserAcceleration
} DeviceMotionGraphType;

@interface INNavigationController ()

@property (strong, nonatomic) IBOutlet UILabel *graphLabel;

@property (strong, nonatomic) NSArray *graphTitles;

@property (nonatomic) double mag_x;
@property (nonatomic) double mag_y;
@property (nonatomic) double mag_z;

@property (nonatomic) vec_3 oldVn;
@property (nonatomic) CLLocationCoordinate2D oldLocation;
@property (nonatomic) vec_3 distance;
@property (nonatomic) double move;
@property (nonatomic) NSInteger timeCounter;
@end

@implementation INNavigationController
@synthesize locationManager, motionManager;
@synthesize mapView;
@synthesize routeLine, routeLineView, routePoints;
@synthesize initialLocation, isStarted, repeatingTimer, oldVn, oldLocation, formerLocation, distance, timeCounter, coordinateOffset;
@synthesize timeWindow, formerStatus, formerTimeTag;
@synthesize kalmanFilter, aDir;
@synthesize stepCounting;

-(id)initWithMapView:(MKMapView*)mv{
    self = [super init];
    self.mapView = mv;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [mapView setUserTrackingMode:MKUserTrackingModeFollow];
	motionManager = [[CMMotionManager alloc] init];
    locationManager = [[CLLocationManager alloc]init];
    routePoints = [[NSMutableArray alloc]init];
    wasFound = NO;
    isStarted = NO;
    formerTimeTag = 0;
    aDir = 0;
    coordinateOffset.latitude = 0;
    coordinateOffset.longitude = 0;
    [self LogDeviceStatus];
    self.graphTitles = @[@"deviceMotion.attitude", @"deviceMotion.rotationRate", @"deviceMotion.gravity", @"deviceMotion.userAcceleration"];
    [self showGraphAtIndex:0];
}

-(void)LogDeviceStatus{
    // 加速度器的检测
    if ([motionManager isAccelerometerAvailable]){
        NSLog(@"Accelerometer is available.");
    } else{
        NSLog(@"Accelerometer is not available.");
    }
    if ([motionManager isAccelerometerActive]){
        NSLog(@"Accelerometer is active.");
    } else {
        NSLog(@"Accelerometer is not active.");
    }
    
    // 陀螺仪的检测
    if([motionManager isGyroAvailable]){
        NSLog(@"Gryro is available.");
    } else {
        NSLog(@"Gyro is not available.");
    }
    if ([motionManager isGyroActive]){
        NSLog(@"Gryo is active.");
        
    } else {
        NSLog(@"Gryo is not active.");
    }
    
    // deviceMotion的检测
    if([motionManager isDeviceMotionAvailable]){
        NSLog(@"DeviceMotion is available.");
    } else {
        NSLog(@"DeviceMotion is not available.");
    }
    if ([motionManager isDeviceMotionActive]){
        NSLog(@"DeviceMotion is active.");
        
    } else {
        NSLog(@"DeviceMotion is not active.");
    }

}

- (IBAction)segmentedControlChanged:(UISegmentedControl *)sender
{
    NSUInteger selectedIndex = sender.selectedSegmentIndex;
    [self showGraphAtIndex:selectedIndex];
}


- (void)showGraphAtIndex:(NSUInteger)selectedIndex
{
//    [self.graphViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        BOOL hidden = (idx != selectedIndex);
//        UIView *graphView = obj;
//        graphView.hidden = hidden;
//    }];
    
    self.graphLabel.text = [self.graphTitles objectAtIndex:selectedIndex];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self startDeviceLocation];
    isStarted = NO;
//    distance = 0.0;
    
//    [self startUpdatesWithSliderValue:(int)(self.updateIntervalSlider.value * 100)];

}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self stopUpdates];
}

- (void)stopUpdates
{
    if ([motionManager isDeviceMotionActive] == YES) {
        [motionManager stopDeviceMotionUpdates];
    }   
    [locationManager stopUpdatingLocation];
    [locationManager stopUpdatingHeading];
}

- (void)viewDidUnload {
    [self setMapView:nil];
    [super viewDidUnload];
}

- (IBAction)startAction:(id)sender {
    if ([motionManager isDeviceMotionAvailable] ==  YES){
        isStarted = YES;
        [self initNavi];
        [self startDeviceMotion];
        [self startTimer];
        [self initOffsetWithMapViewCoordinate:[mapView userLocation].coordinate];
    }
    else
        NSLog(@"DeviceMotion is not Available");
}

-(void)initOffsetWithMapViewCoordinate:(CLLocationCoordinate2D)userLocation{
    CLLocationCoordinate2D clLocation = [locationManager location].coordinate;
    coordinateOffset.latitude = userLocation.latitude - clLocation.latitude;
    coordinateOffset.longitude = userLocation.longitude - clLocation.longitude;
    oldLocation.latitude = oldLocation.latitude + coordinateOffset.latitude;
    oldLocation.longitude = oldLocation.longitude + coordinateOffset.longitude;
}

- (CLLocationCoordinate2D)getNewLocation{
    CLLocation *originLocation = [locationManager location];
    CLLocationCoordinate2D realLocation;
    realLocation.latitude = originLocation.coordinate.latitude + coordinateOffset.latitude;
    realLocation.longitude = originLocation.coordinate.longitude + coordinateOffset.longitude;
    return realLocation;
}

- (void)initNavi{
    oldVn.v1 = 0;
    oldVn.v2 = 0;
    oldVn.v3 = 0;
    timeCounter = 0;
    formerStatus = nil;
    self.move = 0.0;
    timeWindow = [[INTimeWindow alloc] init];
    [mapView removeOverlays:[mapView overlays]];
//    [routePoints addObject:initialLocation];
    formerLocation = nil;
    //init kalman filter
    kalmanFilter = [[INKalmanFilter alloc]initWithCoordinate:[locationManager location].coordinate];
    stepCounting = [[INStepCounting alloc]init];
//    [self drawLineWithLocationArray:routePoints];
//    [self center_map];
}

- (void)startTimer{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:delta_T * 1 target:self selector:@selector(inertiaNavi) userInfo:nil repeats:YES];
    self.repeatingTimer = timer;
}

- (void)startDeviceMotion
{    
//	motionManager = [[CMMotionManager alloc] init];
	// Tell CoreMotion to show the compass calibration HUD when required to provide true north-referenced attitude
	motionManager.showsDeviceMovementDisplay = YES;
    
	motionManager.deviceMotionUpdateInterval = delta_T;
    motionManager.accelerometerUpdateInterval = delta_T;
	
	// New in iOS 5.0: Attitude that is referenced to true north
    if (motionManager.isMagnetometerAvailable){
        [motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXTrueNorthZVertical];
//        [motionManager startAccelerometerUpdates];
        NSLog(@"start updating device motion using X true north Z vertical reference frame.");
    } else {
        [motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXArbitraryZVertical];
//        [motionManager startAccelerometerUpdates];
        NSLog(@"start updating device motion using Z vertical reference frame.");
    }
}

- (void)startDeviceLocation{
    // check if the hardware has a compass
//    locationManager = [[CLLocationManager alloc] init];
    // setup delegate callbacks
    locationManager.delegate = self;
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBestForNavigation];
    locationManager.distanceFilter = 1;
    // start the compass
    [locationManager startUpdatingLocation];
    
	if ([CLLocationManager headingAvailable] == NO) {
		// No compass is available. This application cannot function without a compass,
        // so a dialog will be displayed and no magnetic data will be measured.
        NSLog(@"Magnet is not available.");
	} else {
        // heading service configuration
        locationManager.headingFilter = kCLHeadingFilterNone;
        
        [locationManager startUpdatingHeading];
    }
}

- (IBAction)stopAction:(id)sender {
    [repeatingTimer invalidate];
    self.repeatingTimer = nil;
    [self stopUpdates];
}

- (IBAction)bgTap:(id)sender {
    [self hideKeyboard:sender];
}

- (void)inertiaNavi{
    CMDeviceMotion *deviceMotion = motionManager.deviceMotion;
    INDeviceStatus *newDeviceStatus = [[INDeviceStatus alloc]initWithDeviceMotion:deviceMotion];
//    newDeviceStatus.timeTag = timeCounter;
    newDeviceStatus.timeTag = timeCounter++;
    [timeWindow setTimeCounter:timeCounter * delta_T];
    
    [newDeviceStatus checkIsStill];//:a_variance];
    [newDeviceStatus updateWithVn:oldVn];
    oldLocation = [newDeviceStatus getNewLocation:oldLocation];
    
    oldVn = newDeviceStatus.Vn;
    CLLocation *currentLocation = [locationManager location];
    if (formerLocation == nil)
        formerLocation = currentLocation;
    vec_3 gpsSpeed = [INDeviceStatus getSpeedVectorBetweenLocation1:formerLocation andLocation2:currentLocation];
    formerLocation = currentLocation;
    vec_3 deltaSpeed;
    deltaSpeed.v1 = oldVn.v1 - gpsSpeed.v1;
    deltaSpeed.v2 = oldVn.v2 - gpsSpeed.v2;
    
    if (!newDeviceStatus.isStill) {
        CLLocationCoordinate2D gpsCoor = [self getNewLocation];
        CLLocationCoordinate2D deltaCoor;
        deltaCoor.latitude = oldLocation.latitude - gpsCoor.latitude;
        deltaCoor.longitude = oldLocation.longitude - gpsCoor.longitude;
        [kalmanFilter calculateKwithF:newDeviceStatus.an deltaCoor:deltaSpeed andVe:oldVn.v1];
        
//        NSLog(@"V:%f, %f, %f\nDist:%f, %f", [kalmanFilter.X_k getMatrixValueAtRow:0 andColumn:0],
//              [kalmanFilter.X_k getMatrixValueAtRow:1 andColumn:0],
//              [kalmanFilter.X_k getMatrixValueAtRow:2 andColumn:0],
//              [kalmanFilter.X_k getMatrixValueAtRow:6 andColumn:0],
//              [kalmanFilter.X_k getMatrixValueAtRow:7 andColumn:0]);
        oldVn.v1 -= [kalmanFilter.X_k getMatrixValueAtRow:0 andColumn:0];
        oldVn.v2 -= [kalmanFilter.X_k getMatrixValueAtRow:2 andColumn:0];
//        oldLocation.latitude += [kalmanFilter.X_k getMatrixValueAtRow:6 andColumn:0];
//        oldLocation.longitude += [kalmanFilter.X_k getMatrixValueAtRow:7 andColumn:0];
        
        if (((NSInteger)(timeCounter * delta_T)) % 3 == 0){
            [self addNewLocationAndDraw];
            if (routePoints.count>1){
                CLLocation *loc1 = [routePoints objectAtIndex:routePoints.count-2];
                CLLocation *loc2 = [routePoints objectAtIndex:routePoints.count-1];
                self.move += [loc1 getDistanceFrom:loc2];
            }
        }
    }

    //update labels
    //        timeCounter ++;
    //        [timeWindow setTimeCounter:timeCounter * delta_T];
    //        xLabel.text = [NSString stringWithFormat:@"t: %.0f s", timeCounter*delta_T];
    
    distance.v1 += newDeviceStatus.Dist.v1;// + [kalmanFilter.X_k getMatrixValueAtRow:6 andColumn:0];
    distance.v2 += newDeviceStatus.Dist.v2;// + [kalmanFilter.X_k getMatrixValueAtRow:7 andColumn:0];
    distance.v3 += newDeviceStatus.Dist.v3;

    //step counting
    [stepCounting pushNewLAcc:[INMatrix modOfVec_3:newDeviceStatus.an] GAcc:newDeviceStatus.an.v3 speed:[INMatrix modOfVec_3:oldVn]];

}

- (void)addNewLocationAndDraw{
    [routePoints addObject:[[CLLocation alloc]initWithLatitude:oldLocation.latitude longitude:oldLocation.longitude]];
    [self drawLineWithLocationArray:routePoints];
}
// This delegate method is invoked when the location manager has heading data.
- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)heading {
    // Update the labels with the raw x, y, and z values.
    self.mag_x = heading.x;
    self.mag_y = heading.y;
    self.mag_z = heading.z;
    CLLocationDirection trueDir = heading.trueHeading;
//    zLabel.text = [NSString stringWithFormat:@"gama:%f", trueDir];
    
//    [self updateLabelsX:[NSString stringWithFormat:@"%f",trueDir] Y:@"-" Z:@"-"];
//    [self updateLabelsX:[NSString stringWithFormat:@"%f",heading.x] Y:[NSString stringWithFormat:@"%f", heading.y] Z:[NSString stringWithFormat:@"%f", heading.z]];
}

// This delegate method is invoked when the location managed encounters an error condition.
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if ([error code] == kCLErrorDenied) {
        // This error indicates that the user has denied the application's request to use location services.
        [manager stopUpdatingHeading];
    } else if ([error code] == kCLErrorHeadingFailure) {
        // This error indicates that the heading could not be determined, most likely because of strong magnetic interference.
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if (!wasFound){
        wasFound = YES;
    }

    if (!isStarted){
        initialLocation = newLocation;
        self.oldLocation = newLocation.coordinate;
    }

}

-(void) mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
}

- (void)drawLineWithLocationArray:(NSArray *)locationArray
{
    //    [self updateLocation];
    
    if (self.routeLine != nil){
//        [self.mapView removeOverlays:[self.mapView overlays]];
        [mapView removeOverlay:self.routeLine];
        self.routeLine = nil;
    }
    int pointCount = [locationArray count];
    CLLocationCoordinate2D *coordinateArray = (CLLocationCoordinate2D *)malloc(pointCount * sizeof(CLLocationCoordinate2D));
    
    for (int i = 0; i < pointCount; ++i) {
        CLLocation *location = [locationArray objectAtIndex:i];
        coordinateArray[i] = [location coordinate];
    }
    
    routeLine = [MKPolyline polylineWithCoordinates:coordinateArray count:pointCount];
//    [mapView setVisibleMapRect:[routeLine boundingMapRect]];
    [mapView addOverlay:routeLine];
    
    free(coordinateArray);
    coordinateArray = NULL;
}

- (void)center_map{
    //method__1_______________
//    MKCoordinateRegion region;
//    CLLocationDegrees maxLat = -90;
//    CLLocationDegrees maxLon = -180;
//    CLLocationDegrees minLat = 90;
//    CLLocationDegrees minLon = 180;
//    
//    for (int i=0; i<routePoints.count; i++){
//        CLLocation *currentLocation = [routePoints objectAtIndex:i];
//        if (currentLocation.coordinate.latitude > maxLat)
//            maxLat = currentLocation.coordinate.latitude;
//        if (currentLocation.coordinate.longitude > maxLon)
//            maxLon = currentLocation.coordinate.longitude;
//        if (currentLocation.coordinate.latitude < minLat)
//            minLat = currentLocation.coordinate.latitude;
//        if (currentLocation.coordinate.longitude < minLon)
//            minLon = currentLocation.coordinate.longitude;
//    }
//    region.center.latitude = (maxLat + minLat)/2;
//    region.center.longitude = (maxLon + minLon)/2;
//    region.span.latitudeDelta = maxLat - minLat ;
//    region.span.longitudeDelta = maxLon - minLon;
//    
//    [mapView setRegion:region animated:NO];
    
    //method__2_______________
//    float zoomLevel = 0.005;
//    MKCoordinateRegion region = MKCoordinateRegionMake(oldLocation.coordinate, MKCoordinateSpanMake(0.005, 0.0055));
////    region.center.latitude = oldLocation.coordinate.latitude;
////    region.center.longitude = oldLocation.coordinate.longitude;
////    region.span.latitudeDelta = maxLat - minLat ;
////    region.span.longitudeDelta = maxLon - minLon;
//    [mapView setRegion:[mapView regionThatFits:region] animated:NO];
    
    //method__3_______________
    CLLocationCoordinate2D mapCenter = mapView.centerCoordinate;
    mapCenter = [mapView convertPoint:
                 CGPointMake(1, (mapView.frame.size.height/2.0))
                   toCoordinateFromView:mapView];
    [mapView setCenterCoordinate:mapCenter animated:YES];
}

#pragma mark - MKMapViewDelegate

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
    MKOverlayView* overlayView = nil;
    
    if(overlay == self.routeLine)
    {
        //if we have not yet created an overlay view for this overlay, create it now.
        //        if(nil == self.routeLineView)
        //        {
        self.routeLineView = [[MKPolylineView alloc] initWithPolyline:self.routeLine];
        self.routeLineView.fillColor = [UIColor redColor];
        self.routeLineView.strokeColor = [UIColor redColor];
        self.routeLineView.lineWidth = 4;
        //        }
        
        overlayView = self.routeLineView;
        
    }
    
    return overlayView;
    
}


@end
