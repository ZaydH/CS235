//
//  ExapandingCell.m
//  iOSPrototype
//
//  Created by David Schechter on 3/22/15.
//  Copyright (c) 2015 David Schechter. All rights reserved.
//

#import "ExpandingCell.h"
#import "SecondViewController.h"

@implementation ExpandingCell

@synthesize taskDetails,taskLabel,dueDate,rating,plusMinusButton,ratingTitle,dueDateTitle,containingViewController,myIndexPath;

- (void)awakeFromNib {
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        //Initialaztion code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)clickPlusMinusButton
{
    SecondViewController *tmp=(SecondViewController*)self.containingViewController;
    [tmp tableView:tmp.tableFields didSelectRowAtIndexPath:self.myIndexPath];
}

@end
