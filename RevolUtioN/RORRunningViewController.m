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
#import "RORPublicMethods.h"
#import "RORDBCommon.h"

#define SCALE_SMALL CGRectMake(0,0,320,155)


@interface RORRunningViewController ()

@end

@implementation RORRunningViewController
@synthesize mapView, expandButton, collapseButton, formerLocation, count, repeatingTimer, timerCount, isStarted;
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
    wasFound = NO;
    count = 0;
    timerCount = 0;
    distance = 0;
    isStarted = NO;
    [startButton setTitle:@"开始" forState:UIControlStateNormal];
    UIImage *image = [UIImage imageNamed:@"graybutton_bg.png"];
    [startButton setBackgroundImage:image forState:UIControlStateNormal];
    [endButton setEnabled:NO];
    routePoints = [[NSMutableArray alloc]init];
    [mapView removeOverlays:[mapView overlays]];
    
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
//    locationManager.distanceFilter = 2;
    [locationManager startUpdatingLocation];
}

-(void)awakeFromNib {
    [self update];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
//    if (wasFound) return;
//    wasFound = YES;
    
    double dist_cocoa = [newLocation getDistanceFrom:oldLocation];
    CLLocationCoordinate2D newLoc = [newLocation coordinate];
    CLLocationCoordinate2D oldLoc = [oldLocation coordinate];
    double dist = [self LatitudeLongitudeDist:oldLoc.longitude latitude_Y:oldLoc.latitude longtitude_X:newLoc.longitude longtitude_Y:newLoc.latitude];
    formerLocation = newLocation;
    if (isStarted && doCollect){
        [mapView removeOverlays:[mapView overlays]];
        [routePoints addObject:newLocation];
        [self drawLineWithLocationArray:routePoints];
//        preLocation = newLocation;
//        count ++;
        distance += dist;
        
        doCollect = NO;
    }
//    [self center_map];
    if (dist_cocoa >5){
    float zoomLevel = 0.005;
    MKCoordinateRegion region = MKCoordinateRegionMake(newLoc,MKCoordinateSpanMake(zoomLevel, zoomLevel));
    [mapView setRegion:[mapView regionThatFits:region] animated:NO];
    }
//    latitude.text = [NSString stringWithFormat: @"%f", loc.latitude];
//    longitude.text = [NSString stringWithFormat: @"%f", loc.longitude];

}

//center the route line
- (void)center_map{
    MKCoordinateRegion region;
    CLLocationDegrees maxLat = -90;
    CLLocationDegrees maxLon = -180;
    CLLocationDegrees minLat = 90;
    CLLocationDegrees minLon = 180;
    
    for (int i=0; i<routePoints.count; i++){
        CLLocation *currentLocation = [routePoints objectAtIndex:i];
        if (currentLocation.coordinate.latitude > maxLat)
            maxLat = currentLocation.coordinate.latitude;
        if (currentLocation.coordinate.longitude > maxLon)
            maxLon = currentLocation.coordinate.longitude;
        if (currentLocation.coordinate.latitude < minLat)
            minLat = currentLocation.coordinate.latitude;
        if (currentLocation.coordinate.longitude < minLon)
            minLon = currentLocation.coordinate.longitude;
    }
    region.center.latitude = (maxLat + minLat)/2;
    region.center.longitude = (maxLon + minLon)/2;
    region.span.latitudeDelta = maxLat - minLat ;
    region.span.longitudeDelta = maxLon - minLon;

    [mapView setRegion:region animated:YES];
}

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

- (IBAction)startButtonAction:(id)sender {
    if (!isStarted){
        isStarted = YES;
        if (self.startTime == nil){
            self.startTime = [NSDate date];
            [routePoints addObject:formerLocation];
        }
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(displayTime) userInfo:nil repeats:YES];
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

- (void)displayTime{
    doCollect = YES;

    timerCount++;
    distanceLabel.text = [NSString stringWithFormat:@"%.2lf", distance];
    timeLabel.text = [RORPublicMethods transSecondToStandardFormat:timerCount];
    speedLabel.text = [NSString stringWithFormat:@"%.1f", (float)distance/timerCount*3.6];
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
//    if ([RORPublicMethods hasLoggedIn]!=nil){
//        NSMutableDictionary *userDict = [RORPublicMethods getUserInfoPList];
//        NSNumber *userId = [userDict valueForKey:@"userId"];
//        runHistory.userId = userId;
//    } else {
    runHistory.userId = nil;
//    }
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
    
//    if (self.routeLine != nil){
////        [self.mapView removeOverlays:[self.mapView overlays]];
//        [mapView removeOverlay:self.routeLine];
//        self.routeLine = nil;
//    }
    int pointCount = [locationArray count];
    CLLocationCoordinate2D *coordinateArray = (CLLocationCoordinate2D *)malloc(pointCount * sizeof(CLLocationCoordinate2D));
    
    for (int i = 0; i < pointCount; ++i) {
        CLLocation *location = [locationArray objectAtIndex:i];
        coordinateArray[i] = [location coordinate];
    }

    routeLine = [MKPolyline polylineWithCoordinates:coordinateArray count:pointCount];
    [mapView setVisibleMapRect:[routeLine boundingMapRect]];
    [mapView addOverlay:routeLine];
    
    free(coordinateArray);
    coordinateArray = NULL;
}

- (void)drawTestLine
{
    CLLocation *location0 = [[CLLocation alloc] initWithLatitude:39.954245 longitude:116.312455];
    CLLocation *location1 = [[CLLocation alloc] initWithLatitude:30.247871 longitude:120.127683];
    NSArray *array = [NSArray arrayWithObjects:location0, location1, nil];
    [self drawLineWithLocationArray:array];
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
            self.routeLineView.lineWidth = 2;
//        }
        
        overlayView = self.routeLineView;
        
    }
    
    return overlayView;
    
}

//#pragma mark Map View Delegate Methods
//- (MKAnnotationView *) mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>) annotation {
//    
//    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"PIN_ANNOTATION"];
//    if(annotationView == nil) {
//        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
//                                                          reuseIdentifier:@"PIN_ANNOTATION"];
//    }
//    annotationView.canShowCallout = YES;
//    annotationView.pinColor = MKPinAnnotationColorRed;
//    annotationView.animatesDrop = YES;
//    annotationView.highlighted = YES;
//    annotationView.draggable = YES;
//    return annotationView;
//}

@end
