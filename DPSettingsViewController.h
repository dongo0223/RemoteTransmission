//
//  DPSettingsViewController.h
//  RemoteTransmission
//
//  Created by user on 5/10/14.
//  Copyright (c) 2014 dongo0223. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DPSettingsViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *urlTextField;
@property (strong, nonatomic) IBOutlet UITextField *intervalTextField;
- (IBAction)textFieldReturn:(id)sender;
- (IBAction)save:(id)sender;

@end
