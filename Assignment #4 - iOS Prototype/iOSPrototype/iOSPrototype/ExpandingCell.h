//
//  ExapandingCell.h
//  iOSPrototype
//
//  Created by David Schechter on 3/22/15.
//  Copyright (c) 2015 David Schechter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExpandingCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *taskLabel;
@property (strong, nonatomic) IBOutlet UITextView *taskDetails;
@property (strong, nonatomic) IBOutlet UILabel *dueDate;
@property (strong, nonatomic) IBOutlet UILabel *rating;

@property (strong, nonatomic) IBOutlet UIButton *plusMinusButton;
@property (strong, nonatomic) IBOutlet UILabel *dueDateTitle;
@property (strong, nonatomic) IBOutlet UILabel *ratingTitle;

@property (strong, nonatomic) UIViewController *containingViewController;

@property (strong, nonatomic) NSIndexPath *myIndexPath;

- (IBAction)clickPlusMinusButton;

@end
