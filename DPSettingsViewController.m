//
//  DPSettingsViewController.m
//  RemoteTransmission
//
//  Created by user on 5/10/14.
//  Copyright (c) 2014 dongo0223. All rights reserved.
//

#import "DPSettingsViewController.h"

@interface DPSettingsViewController ()

@property NSString *url;
@property NSNumber *updateInterval;
@end

@implementation DPSettingsViewController

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
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"RemoteTransmissionSettings.plist"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]){
        plistPath = [[NSBundle mainBundle] pathForResource:@"RemoteTransmissionSettings" ofType:@"plist"];
    }
    
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    NSDictionary *settings = (NSDictionary *)[NSPropertyListSerialization propertyListFromData:plistXML mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&format errorDescription:&errorDesc];
    
    if (!settings){
        NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
    }
    
    self.url = [settings objectForKey:@"transmissionURL"];
    self.urlTextField.text = self.url;
    NSLog(@"transmissionUrl: %@", self.url);
    
    self.updateInterval = [settings objectForKey:@"updateInterval"];
    self.intervalTextField.text = [self.updateInterval stringValue];
    NSLog(@"updateInterval: %@", self.updateInterval);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismissKeyboard {
    [self.urlTextField resignFirstResponder];
    [self.intervalTextField resignFirstResponder];
    
}

- (IBAction)save:(id)sender {
    
    //Get paths from root direcory.
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    //Get documents path.
    NSString *documentsPath = [paths objectAtIndex:0];
    
    //Get the path to our PList file.
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"RemoteTransmissionSettings.plist"];
    
    //Set the variables to the values in the text fields.
    self.url = self.urlTextField.text;
    self.updateInterval = [NSNumber numberWithInteger:[self.intervalTextField.text integerValue]];
    
    
    
    //Create dictionary with values in UITextFields.
    NSDictionary *plistDict = [NSDictionary dictionaryWithObjects: [NSArray arrayWithObjects: self.url, self.updateInterval, nil] forKeys:[NSArray arrayWithObjects: @"transmissionURL", @"updateInterval", nil]];
    
    NSString *error = nil;
    
    //Create NSData from dictionary.
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistDict format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
    
    //Check is plistData exists.
    if(plistData){
        
        //Write plistData to our Properity List.plist file.
        [plistData writeToFile:plistPath atomically:YES];
        
    }
    else{
        NSLog(@"Error in saveData: %@", error);
    }
    
}

- (IBAction)textFieldReturn:(id)sender {
    
    [sender resignFirstResponder];
    
}

@end
