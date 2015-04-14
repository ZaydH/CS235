//
//  FirstViewController.h
//  iOSPrototype
//
//  Created by David Schechter on 3/22/15.
//  Copyright (c) 2015 David Schechter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import  "QuartzCore/QuartzCore.h"

#import "JTCalendar.h"

@interface FirstViewController : UIViewController<JTCalendarDataSource,UITableViewDataSource,UITableViewDelegate>
{
    NSString *selectedKey;
}

@property (weak, nonatomic) IBOutlet JTCalendarMenuView *calendarMenuView;
@property (weak, nonatomic) IBOutlet JTCalendarContentView *calendarContentView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *calendarContentViewHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;

@property (strong, nonatomic) JTCalendar *calendar;

@property (strong, nonatomic) IBOutlet UITableView *tableFields;



@end

