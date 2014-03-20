//
//  SAAppDelegate.h
//  SampleApp
//
//  Created by Caleb Davenport on 12/29/11.
//  Copyright (c) 2011 GUI Cocoa, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@interface SAAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong, nonatomic) CMMotionManager *motionManager;

@property (nonatomic, retain) NSMutableArray *accelerometerPoints;
@property (nonatomic, retain) NSMutableArray *gyroscopePoints;
@property (nonatomic, assign) BOOL recording;
@property (nonatomic, retain) NSDate *startTime;

- (void) startUpdates;
- (void) startRecording;
- (void) stopRecording;
- (NSString *) toJSON: (NSMutableArray *)data;

@end
