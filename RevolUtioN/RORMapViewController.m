//
//  RORMapViewController.m
//  RevolUtioN
//
//  Created by Beyond on 13-6-5.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORMapViewController.h"
#import "RORMapAnnotation.h"
#import <Foundation/Foundation.h>

@interface RORMapViewController ()

@end

@implementation RORMapViewController
@synthesize mapView, routeLine, routeLineView ,routePoints;

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
    
    [self drawLineWithLocationArray:routePoints];
    NSLog(@"%@", [routePoints description]);
    [self center_map];
    
//    [mapView setUserTrackingMode:MKUserTrackingModeFollowWithHeading animated:YES];
}

- (void)viewDidUnload{
    [self setMapView:nil];
    [self setRouteLine:nil];
    [self setRoutePoints:nil];
//    [locationManager stopUpdatingLocation];
    [super viewDidUnload];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (IBAction)update {
//    
//    locmanager = [[CLLocationManager alloc] init];
//    [locmanager setDelegate:self];
////    [locmanager setDesiredAccuracy:kCLLocationAccuracyBest];
////    
////    [locmanager startUpdatingLocation];
//}

//CLLocationManager* locmanager;
//-(void)awakeFromNib {
////    [self update];
//}

//- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
//{
//    if (wasFound) return;
//    wasFound = YES;
//}

//- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
//{
//    
//}

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
        self.routeLineView.lineWidth = 5;
        //        }
        
        overlayView = self.routeLineView;
        
    }
    
    return overlayView;
    
}

@end
