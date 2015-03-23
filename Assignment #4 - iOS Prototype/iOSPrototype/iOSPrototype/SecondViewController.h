//
//  SecondViewController.h
//  iOSPrototype
//
//  Created by David Schechter on 3/22/15.
//  Copyright (c) 2015 David Schechter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExpandingCell.h"

@interface SecondViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    int selectedIndex;
}

@property (strong, nonatomic) IBOutlet UITableView *tableFields;


@end

