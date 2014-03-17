//
//  SAAppDelegate.m
//  SampleApp
//
//  Created by Caleb Davenport on 12/29/11.
//  Copyright (c) 2011 GUI Cocoa, LLC. All rights reserved.
//

#import "SAAppDelegate.h"
#import "SAViewController.h"

static const NSTimeInterval kAccelUpdateInterval = 0.01;
static const NSTimeInterval kGyroUpdateInterval = 0.01;

@interface SAAppDelegate()

@property (nonatomic, retain) NSMutableArray *accelerometerPoints;
@property (nonatomic, retain) NSMutableArray *gyroscopePoints;
@property (nonatomic, assign) BOOL recording;
@property (nonatomic, retain) NSDate *startTime;

@end


@implementation SAAppDelegate

@synthesize window = _window;

- (void)dealloc {
    self.window = nil;
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)options {
    _motionManager = [[CMMotionManager alloc] init];
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    SAViewController *controller = [[[SAViewController alloc]
                                     initWithNibName:@"SAViewController"
                                     bundle:nil]
                                    autorelease];
    self.window.rootViewController = controller;
    
    [self startUpdates];

    [self.window makeKeyAndVisible];
    return YES;
}

- (void) startUpdates {
  CMMotionManager *motion = [(SAAppDelegate *)[[UIApplication sharedApplication] delegate] motionManager];

  __weak __typeof(&*self) wSelf = self;

  if ([motion isAccelerometerAvailable] == YES) {
    [motion setAccelerometerUpdateInterval:kAccelUpdateInterval];
    [motion startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData *o, NSError *error) {
      if (wSelf.recording) {
        NSDictionary *d = @{@"x": @(o.acceleration.x), @"y":@(o.acceleration.y), @"z":@(o.acceleration.z), @"t":@([[NSDate date] timeIntervalSinceDate:_startTime])};
        [wSelf.accelerometerPoints addObject:d];
      }
    }];
  }

  if ([motion isGyroAvailable] == YES) {
    [motion setGyroUpdateInterval:kGyroUpdateInterval];
    [motion startGyroUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMGyroData *obj, NSError *error) {
      if (wSelf.recording) {
        NSDictionary *d = @{@"x": @(obj.rotationRate.x), @"y":@(obj.rotationRate.y), @"z":@(obj.rotationRate.z), @"t":@([[NSDate date] timeIntervalSinceDate:_startTime])};
        [wSelf.gyroscopePoints addObject:d];
      }
    }];
  }

}

- (void) startRecording {
  self.recording = YES;
  self.accelerometerPoints = [NSMutableArray arrayWithCapacity:100];
  self.gyroscopePoints = [NSMutableArray arrayWithCapacity:100];
  self.startTime = [NSDate date];
}

- (void) stopRecording {
  self.recording = NO;
  NSLog(@"Done recording\n");
}

@end
