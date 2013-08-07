//
//  RORGetReadyViewController.m
//  RevolUtioN
//
//  Created by Beyond on 13-5-16.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORRunningViewController.h"
#import "RORMapPoint.h"
#import "User_Running_History.h"
#import "RORAppDelegate.h"
#import "RORMapAnnotation.h"
#import "RORUtils.h"
#import "RORDBCommon.h"
#import "RORMacro.h"

#define SCALE_SMALL CGRectMake(0,0,320,155)


@interface RORRunningViewController ()

@end

@implementation RORRunningViewController
@synthesize mapView, expandButton, collapseButton, formerLocation, count, repeatingTimer, timerCount, isStarted, latestUserLocation, offset;
@synthesize timeLabel, speedLabel, distanceLabel, startButton, endButton;
@synthesize distance, routePoints, routeLine, routeLineView;
@synthesize record;
@synthesize doCollect;

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
}

//initial all when view appears
- (void)viewDidAppear:(BOOL)animated{
    [self controllerInit];
    [self navigationInit];
}

-(void)controllerInit{
    self.mapView.delegate = self;
    [startButton setTitle:@"开始" forState:UIControlStateNormal];
    UIImage *image = [UIImage imageNamed:@"graybutton_bg.png"];
    [startButton setBackgroundImage:image forState:UIControlStateNormal];
    [endButton setEnabled:NO];
    routePoints = [[NSMutableArray alloc]init];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回首页";
    backItem.action = @selector(backToMain:);
    self.navigationItem.backBarButtonItem = backItem;
    
    collapseButton.alpha = 0;
    
    timeLabel.text = @"00:00:00";
    speedLabel.text = @"0.0";
    mapView.frame = SCALE_SMALL;
    
    doCollect = NO;
}

-(void)navigationInit{
    //    [mapView setUserTrackingMode:MKUserTrackingModeFollow];
    [mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    [mapView removeOverlays:[mapView overlays]];
    wasFound = NO;
    count = 0;
    timerCount = 0;
    distance = 0;
    offset.latitude = 0.0;
    offset.longitude = 0.0;
    isStarted = NO;
}

-(void)backToMain:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)update {
    
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    locationManager.distanceFilter = 3;
    [locationManager startUpdatingLocation];
}

-(void)awakeFromNib {
    [self update];
}

- (CLLocation *)transToRealLocation:(CLLocation *)orginalLocation{
    CLLocation *absoluteLocation = [[CLLocation alloc] initWithLatitude:orginalLocation.coordinate.latitude + offset.latitude longitude:orginalLocation.coordinate.longitude + offset.longitude];
    return absoluteLocation;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"ToLocation:%f, %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    //    NSLog(@"Device did %f meters move.", [self.latestUserLocation getDistanceFrom:newLocation]);
    self.latestUserLocation = [self transToRealLocation:newLocation];
    
    //    if (wasFound) return;
    //
    //    wasFound = YES;
    //    NSLog(@"didUpdateToLocation:%f, %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    //    double dist_cocoa = [newLocation getDistanceFrom:oldLocation];
    //    CLLocationCoordinate2D newLoc = [newLocation coordinate];
    //    CLLocationCoordinate2D oldLoc = [oldLocation coordinate];
    //    double dist = [self LatitudeLongitudeDist:oldLoc.longitude latitude_Y:oldLoc.latitude longtitude_X:newLoc.longitude longtitude_Y:newLoc.latitude];
    //    formerLocation = newLocation;
    //    if (isStarted && doCollect){
    //        [mapView removeOverlays:[mapView overlays]];
    //        [routePoints addObject:newLocation];
    //        [self drawLineWithLocationArray:routePoints];
    ////        preLocation = newLocation;
    ////        count ++;
    //        distance += dist;
    //
    //        doCollect = NO;
    //    }
    ////    [self center_map];
    //    if (dist_cocoa >5){
    //    float zoomLevel = 0.005;
    //    MKCoordinateRegion region = MKCoordinateRegionMake(newLoc,MKCoordinateSpanMake(zoomLevel, zoomLevel));
    //    [mapView setRegion:[mapView regionThatFits:region] animated:NO];
    //    }
    //    latitude.text = [NSString stringWithFormat: @"%f", loc.latitude];
    //    longitude.text = [NSString stringWithFormat: @"%f", loc.longitude];
    
}

-(void) mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation

{
    //    if (self.latestUserLocation != nil && offset.latitude == 0.0) {
    //        offset.latitude = userLocation.coordinate.latitude - self.latestUserLocation.coordinate.latitude;
    //        offset.longitude = userLocation.coordinate.longitude - self.latestUserLocation.coordinate.longitude;
    //    }
    NSLog(@"UserLocation:%f, %f", userLocation.coordinate.latitude, userLocation.coordinate.longitude);
    //    NSLog(@"Device did %f meters move.", [self.latestUserLocation getDistanceFrom:[userLocation location]]);
    //    self.latestUserLocation = [userLocation location];
    //    // 这里获得的userLocation，已经是偏移后的地位了
}
////center the route line
//- (void)center_map{
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
//    [mapView setRegion:region animated:YES];
//}

#define PI M_PI
-(double) LatitudeLongitudeDist:(double) lon1 latitude_Y:(double) lat1 longtitude_X:
(double) lon2 longtitude_Y: (double) lat2{
    double er = 6378137; // 6378700.0f;
    //ave. radius = 6371.315 (someone said more accurate is 6366.707)
    //equatorial radius = 6378.388
    //nautical mile = 1.15078
    double radlat1 = PI*lat1/180.0f;
    double radlat2 = PI*lat2/180.0f;
    //now long.
    double radlong1 = PI*lon1/180.0f;
    double radlong2 = PI*lon2/180.0f;
    if( radlat1 < 0 ) radlat1 = PI/2 + fabs(radlat1);// south
    if( radlat1 > 0 ) radlat1 = PI/2 - fabs(radlat1);// north
    if( radlong1 < 0 ) radlong1 = PI*2 - fabs(radlong1);//west
    if( radlat2 < 0 ) radlat2 = PI/2 + fabs(radlat2);// south
    if( radlat2 > 0 ) radlat2 = PI/2 - fabs(radlat2);// north
    if( radlong2 < 0 ) radlong2 = PI*2 - fabs(radlong2);// west
    //spherical coordinates x=r*cos(ag)sin(at), y=r*sin(ag)*sin(at), z=r*cos(at)
    //zero ag is up so reverse lat
    double x1 = er * cos(radlong1) * sin(radlat1);
    double y1 = er * sin(radlong1) * sin(radlat1);
    double z1 = er * cos(radlat1);
    double x2 = er * cos(radlong2) * sin(radlat2);
    double y2 = er * sin(radlong2) * sin(radlat2);
    double z2 = er * cos(radlat2);
    double d = sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2)+(z1-z2)*(z1-z2));
    //side, side, side, law of cosines and arccos
    double theta = acos((er*er+er*er-d*d)/(2*er*er));
    double dist = theta*er;
    return dist;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
}

-(void)createAnnotationWithCoords:(CLLocationCoordinate2D) coords withTitle:(NSString *)title andSubTitle:(NSString *) subTitle {
    RORMapAnnotation *annotation = [[RORMapAnnotation alloc] initWithCoordinate:
                                    coords];
    annotation.title = title;
    annotation.subtitle = subTitle;
    [mapView addAnnotation:annotation];
}

- (BOOL) compareLocation:(CLLocationCoordinate2D) locA withLocation:(CLLocationCoordinate2D) locB{
    float lat = locA.latitude - locB.latitude;
    float lon = locA.longitude - locB.longitude;
    float lat2 = lat * lat;
    float lon2 = lon * lon;
    if (lat2 + lon2 > 1e-8)
        return YES;
    return NO;
}

- (void)viewDidUnload {
    [self setMapView:nil];
    [self setDistanceLabel:nil];
    [self setTimeLabel:nil];
    [self setSpeedLabel:nil];
    [locationManager stopUpdatingLocation];
    [self setExpandButton:nil];
    [self setStartButton:nil];
    [self setEndButton:nil];
    [self setCollapseButton:nil];
    [self setRoutePoints:nil];
    [self setRouteLine:nil];
    [self setRouteLineView:nil];
    [self setStartTime:nil];
    [self setEndTime:nil];
    [self setRecord:nil];
    
    [super viewDidUnload];
}

- (IBAction)expandAction:(id)sender {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.6];
    
    expandButton.alpha = 0;
    collapseButton.alpha = 0.7;
    mapView.frame = [ UIScreen mainScreen ].bounds;
    
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationFinished)];
    [UIView commitAnimations];
    
}

- (IBAction)collapseAction:(id)sender {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.3];
    
    collapseButton.alpha = 0;
    expandButton.alpha = 0.7;
    mapView.frame = SCALE_SMALL;
    
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationFinished)];
    [UIView commitAnimations];
    
}

- (void)initOffset{
    MKUserLocation *userLocation = [mapView userLocation];
    CLLocation *cl = [locationManager location];
    offset.latitude = userLocation.coordinate.latitude - cl.coordinate.latitude;
    offset.longitude = userLocation.coordinate.longitude - cl.coordinate.longitude;
}

- (IBAction)startButtonAction:(id)sender {
    if (!isStarted){
        isStarted = YES;
        if (self.startTime == nil){
            self.startTime = [NSDate date];
            [self initOffset];
            self.latestUserLocation = [self transToRealLocation:latestUserLocation];
            self.formerLocation = self.latestUserLocation;//[locationManager location];
            [routePoints addObject:self.latestUserLocation];
            //            [self pushPoint];
        }
        
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:TIMER_INTERVAL target:self selector:@selector(timerDot) userInfo:nil repeats:YES];
        self.repeatingTimer = timer;
        UIImage *image = [UIImage imageNamed:@"redbutton_bg.png"];
        [startButton setBackgroundImage:image forState:UIControlStateNormal];
        [startButton setTitle:@"暂停" forState:UIControlStateNormal];
        [endButton setEnabled:YES];
    } else {
        [repeatingTimer invalidate];
        self.repeatingTimer = nil;
        isStarted = NO;
        
        [startButton setTitle:@"继续" forState:UIControlStateNormal];
    }
    //    [[NSRunLoop  currentRunLoop] addTimer:myTimer forMode:NSDefaultRunLoopMode];
}

- (void)timerDot{
    doCollect = YES;
    
    timerCount++;
    NSInteger time = timerCount * TIMER_INTERVAL;
    if (time % 3 == 0){
        [self pushPoint];
        distanceLabel.text = [NSString stringWithFormat:@"%.2lf m", distance];
        speedLabel.text = [NSString stringWithFormat:@"%.1f m/s", (float)distance/time*3.6];
    }
    timeLabel.text = [RORUtils transSecondToStandardFormat:time];
}

- (void)pushPoint{
    CLLocation *currentLocation = self.latestUserLocation;
    if (formerLocation != currentLocation){
        distance += [self.formerLocation getDistanceFrom:currentLocation];
        self.formerLocation = currentLocation;
        [routePoints addObject:currentLocation];
        [self drawLineWithLocationArray:routePoints];
    }
}

- (IBAction)endButtonAction:(id)sender {
    if (self.endTime == nil)
        self.endTime = [NSDate date];
    [locationManager stopUpdatingLocation];
    [repeatingTimer invalidate];
    [startButton setEnabled:NO];
    self.repeatingTimer = nil;
    
    [self saveRunInfo];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:[NSBundle mainBundle]];    // 通过storyboard id拿到目标控制器的对象
    UIViewController *viewController =  [storyboard instantiateViewControllerWithIdentifier:@"RORRunningHistoryViewController"];
    [viewController viewDidLoad];
    
    [self performSegueWithIdentifier:@"ResultSegue" sender:self];
}

- (IBAction)setUserCentered:(id)sender {
    [self centerMap];
}

- (void)saveRunInfo{
    NSError *error = nil;
    RORAppDelegate *delegate = (RORAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = delegate.managedObjectContext;
    User_Running_History *runHistory = [NSEntityDescription insertNewObjectForEntityForName:@"User_Running_History" inManagedObjectContext:context];
    runHistory.distance = [[NSNumber alloc] initWithInteger:distance];
    runHistory.duration = [[NSNumber alloc] initWithInteger:timerCount];
    runHistory.missionRoute = [RORDBCommon getStringFromRoutePoints:routePoints];
    runHistory.missionDate = [NSDate date];
    runHistory.missionEndTime = self.endTime;
    runHistory.missionStartTime = self.startTime;
    runHistory.userId = nil;
    record = runHistory;
    if (![context save:&error]) {
        NSLog(@"%@",[error localizedDescription]);
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIViewController *destination = segue.destinationViewController;
    if ([destination respondsToSelector:@selector(setDelegate:)]){
        [destination setValue:self forKey:@"delegate"];
    }
    if ([destination respondsToSelector:@selector(setRecord:)]){
        [destination setValue:record forKey:@"record"];
    }
}

- (void)drawLineWithLocationArray:(NSArray *)locationArray
{
    //    [self updateLocation];
    
    if (self.routeLine != nil){
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

- (void) centerMap{
    [mapView setCenterCoordinate:self.latestUserLocation.coordinate animated:YES];
    CLLocation *cl = [mapView userLocation].location;
    //    [self drawTestLine];
}

- (void)drawTestLine
{
    //    CLLocation *location0 = [[CLLocation alloc] initWithLatitude:31.014008 longitude:121.427551];
    ////
    ////    RORMapAnnotation *mapAnno = [[RORMapAnnotation alloc]initWithCoordinate:location0.coordinate];
    ////    mapAnno.title = @"cyberace";
    ////    mapAnno.headImage = nil;
    ////    mapAnno.subtitle = @"snail";
    ////    [mapView addAnnotation:mapAnno];
    //
    //    //31.014008,121.427551
    //    CLLocation *location1 = [[CLLocation alloc] initWithLatitude:31.014308 longitude:121.427851];
    //    NSArray *array = [NSArray arrayWithObjects:location0,location1, nil];
    //    [self drawLineWithLocationArray:array];
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
        self.routeLineView.lineWidth = 8;
        //        }
        
        overlayView = self.routeLineView;
        
    }
    
    return overlayView;
    
}

//#pragma mark Map View Delegate Methods
//- (MKAnnotationView *) mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>) annotation {
//
////    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"PIN_ANNOTATION"];
////    if(annotationView == nil) {
////        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
////                                                          reuseIdentifier:@"PIN_ANNOTATION"];
////    }
////    annotationView.canShowCallout = YES;
////    annotationView.pinColor = MKPinAnnotationColorRed;
////    annotationView.animatesDrop = YES;
////    annotationView.highlighted = YES;
////    annotationView.draggable = YES;
////    return annotationView;
//    if ([annotation isKindOfClass:[MKUserLocation class]])
//        return nil;
//    // 处理我们自定义的Annotation
//    if ([annotation isKindOfClass:[RORMapAnnotation class]]) {
//        RORMapAnnotation *travellerAnnotation = (RORMapAnnotation *)annotation;
////        static NSString* travellerAnnotationIdentifier = @"TravellerAnnotationIdentifier";
//        static NSString *identifier = @"currentLocation";
////        SVPulsingAnnotationView *pulsingView = (SVPulsingAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
//
//        MKPinAnnotationView* pulsingView = (MKPinAnnotationView *)
//        [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
//        if (!pulsingView)
//        {
//            // if an existing pin view was not available, create one
//            pulsingView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
////            MKAnnotationView* customPinView = [[MKAnnotationView alloc]
////                                                initWithAnnotation:annotation reuseIdentifier:identifier];
//            //加展开按钮
////            UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
////            [rightButton addTarget:self
////                            action:@selector(showDetails:)
////                  forControlEvents:UIControlEventTouchUpInside];
////            pulsingView.rightCalloutAccessoryView = rightButton;
////
//            UIImage *image = [UIImage imageNamed:@"smail_annotation.png"];
//            pulsingView.image = image;  //将图钉变成笑脸。
//            pulsingView.canShowCallout = YES;
////
////            UIImageView *headImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:travellerAnnotation.headImage]];
////            pulsingView.leftCalloutAccessoryView = headImage; //设置最左边的头像
//            
//            return pulsingView;
//        }
//        else
//        {
//            pulsingView.annotation = annotation;
//        }
//        return pulsingView;
//    }
//    return nil;
//}

@end
