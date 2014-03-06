//
//  SAViewController.m
//  SampleApp
//
//  Created by Caleb Davenport on 12/29/11.
//  Copyright (c) 2011 GUI Cocoa, LLC. All rights reserved.
//

#import "SAViewController.h"

#import "GCPINViewController.h"
#import <AFNetworking/AFHTTPClient.h>

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
    httpclient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://134.117.225.100:3000"]];
  
    GCPINViewController *PIN = [[GCPINViewController alloc]
                                initWithNibName:nil
                                bundle:nil
                                mode:GCPINViewControllerModeVerify];
    PIN.messageText = @"Enter your passcode";
    PIN.errorText = @"Incorrect passcode";
    PIN.title = @"Enter Passcode";
    PIN.verifyBlock = ^(NSString *code) {
        NSLog(@"checking code: %@ against %@", code, self.pin);
      
      NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
      NSString *profile_name = [defaults stringForKey:@"name_preference"];
      //BOOL imitation = [defaults boolForKey:@"enabled_preference"];
      BOOL imitation = [self.imitation isOn];
      
      NSDictionary *options = @{@"profile_name" : profile_name,
                                @"check"       : code,
                                @"against"  : self.pin,
                                @"imitation" : @(imitation),
                                @"times"    : PIN.timeArray
                                };
      
      [httpclient postPath:@"addpin" parameters:options success:^(AFHTTPRequestOperation *operation, id responseObject) {
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      }];

      
        return [code isEqualToString:self.pin];
    };
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
