//
//  FourthViewController.h
//  iOSPrototype
//
//  Created by David Schechter on 3/22/15.
//  Copyright (c) 2015 David Schechter. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RateView.h"
#import "SecondViewController.h"
#import "UITextField+Shake.h"


@interface FourthViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *taskNameTextField;

@property (strong, nonatomic) IBOutlet UITextField *dateTextField;

@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;

@property (strong, nonatomic) IBOutlet UITextField *priorityTextField;

-(IBAction) clickCreateTask:(id) sender;

@end
