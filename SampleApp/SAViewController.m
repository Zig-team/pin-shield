//
//  SAViewController.m
//  SampleApp
//
//  Created by Caleb Davenport on 12/29/11.
//  Copyright (c) 2011 GUI Cocoa, LLC. All rights reserved.
//

#import "SAViewController.h"
#import "SAAppDelegate.h"
#import "GCPINViewController.h"
#import <AFNetworking/AFHTTPClient.h>
#import "libs/JSONKit/JSONKit.h"

@implementation SAViewController

AFHTTPClient *httpclient;

- (IBAction)setPIN {
    GCPINViewController *PIN = [[GCPINViewController alloc]
                                initWithNibName:nil
                                bundle:nil
                                mode:GCPINViewControllerModeCreate];
    PIN.messageText = @"Enter a passcode";
    PIN.errorText = @"The passcodes do not match";
    PIN.title = @"Set Passcode";
    PIN.verifyBlock = ^(NSString *code) {
        NSLog(@"setting code: %@", code);
        self.pin = [[NSString alloc] initWithString:code];
        return YES;
    };
    [PIN presentFromViewController:self animated:YES];
    [PIN release];
}

- (IBAction)checkPIN {
    httpclient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://tetris.ccsl.carleton.ca:3000"]];
    [httpclient setAuthorizationHeaderWithUsername:@"SwipeLock" password:@"abF34!qt"];
    [httpclient setAllowsInvalidSSLCertificate:YES];

  
    SAAppDelegate *app_delegate = (SAAppDelegate*)([UIApplication sharedApplication].delegate);
    GCPINViewController *PIN = [[GCPINViewController alloc]
                                initWithNibName:nil
                                bundle:nil
                                mode:GCPINViewControllerModeVerify];
    PIN.messageText = @"Enter your passcode";
    PIN.errorText = @"Incorrect passcode";
    PIN.title = @"Enter Passcode";
    PIN.verifyBlock = ^(NSString *code) {
      //Moved to GCPINViewController.m
      //[app_delegate stopRecording];
      NSLog(@"checking code: %@ against %@", code, self.pin);
      
      NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
      NSString *profile_name = [defaults stringForKey:@"name_preference"];
      NSString *tmp_profile_name = @"test";

      if (profile_name == (id)[NSNull null] || profile_name.length == 0) profile_name = tmp_profile_name;

      //BOOL imitation = [defaults boolForKey:@"enabled_preference"];
      BOOL imitation = [self.imitation isOn];
      
      NSDictionary *options = @{@"profile_name" : profile_name,
                                @"check"       : code,
                                @"against"  : self.pin,
                                @"imitation" : @(imitation),
                                @"times"    : PIN.timeArray,
                                @"accel":   [app_delegate toJSON:app_delegate.accelerometerPoints],
                                @"gyro":   [app_delegate toJSON:app_delegate.gyroscopePoints],
                                @"gyro_angles":   [app_delegate toJSON:app_delegate.gyroscopeAnglePoints]
                                };
      [httpclient postPath:@"addpin" parameters:options success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success!");
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failure! %@", error);
      }];
        return [code isEqualToString:self.pin];
    };
  
    //This is moved to GCPINViewController.m
    //[app_delegate startRecording];
  
    [PIN presentFromViewController:self animated:YES];
    [PIN release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return YES;
    }
    else {
        return (orientation == UIInterfaceOrientationPortrait);
    }
}

- (void)dealloc {
  [_imitation release];
  [super dealloc];
}

@end
