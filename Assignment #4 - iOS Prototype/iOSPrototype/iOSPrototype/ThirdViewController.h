//
//  ThirdViewController.h
//  iOSPrototype
//
//  Created by David Schechter on 3/22/15.
//  Copyright (c) 2015 David Schechter. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RateView.h"

@interface ThirdViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *taskNameTextField;

@property (strong, nonatomic) IBOutlet UITextField *taskColorTextField;

@property (strong, nonatomic) IBOutlet UITextField *dateTextField;

@property (strong, nonatomic) IBOutlet UITextField *hourTextField;

@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;

@property (strong, nonatomic) IBOutlet UITextField *addInviteesTextField;

@property (strong, nonatomic) IBOutlet UITextField *priorityTextField;

-(IBAction) clickCreateAppointment:(id) sender;

@end
