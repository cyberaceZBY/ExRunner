//
//  RORGetReadyViewController.h
//  RevolUtioN
//
//  Created by Beyond on 13-5-16.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "User_Running_History.h"

@interface RORRunningViewController : UIViewController<CLLocationManagerDelegate,MKMapViewDelegate> {
    BOOL wasFound;
    CLLocationManager* locationManager;
}

@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *endButton;
@property (retain, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *speedLabel;
@property (weak, nonatomic) IBOutlet UIButton *expandButton;
@property (weak, nonatomic) IBOutlet UIButton *collapseButton;
@property (nonatomic) CLLocation *formerLocation;
@property (nonatomic) NSInteger count;
@property (nonatomic) NSInteger timerCount;
@property (assign) NSTimer *repeatingTimer;
@property (nonatomic) BOOL isStarted;
@property (nonatomic) double distance;
@property (retain, nonatomic) NSMutableArray *routePoints;
@property (retain, nonatomic) MKPolyline *routeLine;
@property (retain, nonatomic) MKPolylineView *routeLineView;
@property (strong, nonatomic) NSDate *startTime;
@property (strong, nonatomic) NSDate *endTime;
@property (strong, nonatomic) User_Running_History* record;

@property (nonatomic) BOOL doCollect;

- (IBAction)expandAction:(id)sender;
- (IBAction)collapseAction:(id)sender;
- (IBAction)startButtonAction:(id)sender;
- (IBAction)endButtonAction:(id)sender;
-(void)backToMain;
@end
