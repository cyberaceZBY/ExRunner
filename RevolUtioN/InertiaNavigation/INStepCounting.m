//
//  INStepCounting.m
//  InertiaNavigation
//
//  Created by Bjorn on 13-8-12.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "INStepCounting.h"

@implementation INStepCounting
@synthesize gAccList, levelAccList, counter, dSum;

-(id)init{
    self = [super init];
    counter = 0;
    gAccTrend = 0;
    lAccTrend = 0;
    p=0;
    gAccList = [[NSMutableArray alloc]init];
    levelAccList = [[NSMutableArray alloc]init];
    
    totalPoints = 0;
    head = 0;
    tail = 0;
    duration = 0;
    dSum = 0;
    
    return self;
}

-(void)pushNewLAcc:(double)lAcc GAcc:(double)gAcc speed:(double)v{
//    p++;
//    [gAccList addObject:[[NSNumber alloc]initWithDouble:gAcc]];
//    [levelAccList addObject:[[NSNumber alloc]initWithDouble:lAcc]];
//    if (gAccList.count >2){
//        if ([self checkStep:v]){
////            NSLog(@"%d",p);
//            
//            return YES;
//        };
//    };
//    return NO;
    
     //push new point into window
    gWindow[tail] = gAcc;
    lWindow[tail] = lAcc;
    tail = (tail+1)%SC_WINDOW_SIZE;
    if (head == tail)
        head = (head+1)%SC_WINDOW_SIZE;
    totalPoints++;
    //dequeue one step if exist
    [self checkStep:v];
    
}

-(void)checkStep:(double)v{
    [self updateGAccPeak];
    [self updateLAccPeak];

    if (gHasPeak){
        if (lHasPeak){
            if (abs(gPeak-lPeak)<=2 && (duration <0 || duration > 5)){
                [self oneStepFound];
            }
        } else {
            if (tail - gPeak > 2){
                gHasPeak = NO;
                gPeak = -1;
            }
        }
    }
    if (duration>=0){
        duration++;
        if (duration>SC_WINDOW_SIZE * 0.6)
            duration = -1;
    }
}

-(void)oneStepFound{
    counter++;
    if (duration>=0)
        dSum += duration;
    head = (tail -1 + SC_WINDOW_SIZE)%SC_WINDOW_SIZE;
    duration = (tail-gPeak-1 + SC_WINDOW_SIZE)%SC_WINDOW_SIZE;
    gHasPeak = NO;
    lHasPeak = NO;
    gPeak = -1;
    lPeak = -1;
}

-(void)updateGAccPeak{
    double current = gWindow[(tail-1+SC_WINDOW_SIZE)%SC_WINDOW_SIZE];
    double former = gWindow[(tail-2+SC_WINDOW_SIZE)%SC_WINDOW_SIZE];
    if (!gHasPeak){
        if (gAccTrend<0 && current-former>0 && round(former)<-15){
            gHasPeak = YES;
            gPeak = (tail-2+SC_WINDOW_SIZE)%SC_WINDOW_SIZE;
        }
    }
    if (fabs(current-former)>=0.001)
        gAccTrend = current - former;
}

-(void)updateLAccPeak{
    double current = lWindow[(tail-1+SC_WINDOW_SIZE)%SC_WINDOW_SIZE];
    double former = lWindow[(tail-2+SC_WINDOW_SIZE)%SC_WINDOW_SIZE];
//    if (!lHasPeak){
        if (lAccTrend>0 && current-former<0 && round(former)>15){
            lHasPeak = YES;
            lPeak = (tail-2+SC_WINDOW_SIZE)%SC_WINDOW_SIZE;
        }
//    }
    if (fabs(current-former)>=0.001)
        lAccTrend = current - former;
}

@end

