//
//  SAViewController.h
//  SampleApp
//
//  Created by Caleb Davenport on 12/29/11.
//  Copyright (c) 2011 GUI Cocoa, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SAViewController : UIViewController

@property NSString *pin;

- (IBAction)setPIN;
- (IBAction)checkPIN;

@property (retain, nonatomic) IBOutlet UISwitch *imitation;

@end
