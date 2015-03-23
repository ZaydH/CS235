//
//  SecondViewController.m
//  iOSPrototype
//
//  Created by David Schechter on 3/22/15.
//  Copyright (c) 2015 David Schechter. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController (){
    NSMutableArray *taskArray;
}

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _tableFields.dataSource=self;
    _tableFields.delegate=self;
    
    selectedIndex=-1;
    
    taskArray = [NSMutableArray arrayWithObjects:[NSMutableArray arrayWithObjects: @"Take out the trash",@"Take the trash out before the trash collector comes on Monday", @"03/22/2015", @"", @"4", nil],
                 [NSMutableArray arrayWithObjects: @"Mow the Lawn",@"Need to get the lawnmower and mow both the front and back yard. Steve will mow the side yard", @"04/01/2015", @"", @"3", nil],
                 [NSMutableArray arrayWithObjects: @" Go to the store to get cat food",@"Running out of cat food at home so go to Petco to get some wet (Fancy Feast) and dry (Purina One) cat food", @"03/22/2015", @"", @"2", nil],
                 [NSMutableArray arrayWithObjects: @"Call Comcast",@"", @"", @"", @"", nil], [NSMutableArray arrayWithObjects: @"",@"", @"", @"", @"", nil], nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark UITableViewDataSource methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section {
    return [taskArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (selectedIndex == indexPath.row)
    {
        return 180;
    }
    else
    {
        return 44;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ExpandingCell *cell = nil;
    static NSString *AutoCompleteRowIdentifier = @"expandingCell";
    cell = (ExpandingCell*)[tableView dequeueReusableCellWithIdentifier:AutoCompleteRowIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ExpandingCell" owner:self.parentViewController options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    if ([taskArray count]-1 == indexPath.row)
    {
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.taskLabel.hidden=YES;
        cell.plusMinusButton.hidden=YES;
    }

    if (selectedIndex == indexPath.row)
    {
        cell.contentView.backgroundColor = [UIColor lightGrayColor];
        cell.taskLabel.textColor = [UIColor whiteColor];
        cell.taskLabel.font = [UIFont fontWithName:@"HelvelticaNeue-Bold" size:16.0];
        cell.taskDetails.textColor = [UIColor whiteColor];
        cell.taskDetails.backgroundColor = [UIColor lightGrayColor];
        cell.rating.textColor = [UIColor whiteColor];
        cell.dueDate.textColor = [UIColor whiteColor];
        cell.dueDateTitle.textColor = [UIColor whiteColor];
        cell.ratingTitle.textColor = [UIColor whiteColor];
        
    }
    else
    {
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.taskLabel.textColor = [UIColor blackColor];
        cell.taskLabel.font = [UIFont systemFontOfSize:16.0];
        cell.taskDetails.textColor = [UIColor blackColor];
        cell.taskDetails.backgroundColor = [UIColor whiteColor];
        cell.rating.textColor = [UIColor blackColor];
        cell.dueDate.textColor = [UIColor blackColor];
        cell.dueDateTitle.textColor = [UIColor blackColor];
        cell.ratingTitle.textColor = [UIColor blackColor];
        
    }
    
    cell.taskLabel.text=taskArray[indexPath.row][0];
    cell.taskDetails.text=taskArray[indexPath.row][1];
    cell.dueDate.text=taskArray[indexPath.row][2];
    cell.rating.text=taskArray[indexPath.row][3];
    
    cell.clipsToBounds=YES;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark UITableViewDelegate methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([taskArray count]-1 == indexPath.row)
    {
        return;
    }
    //exapnd row
    if (selectedIndex == indexPath.row)
    {
        selectedIndex=-1;
        [_tableFields reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        return;
    }
    //exapnd different row
    if (selectedIndex != -1)
    {
        NSIndexPath* prevPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
        selectedIndex = (int)indexPath.row;
        [_tableFields reloadRowsAtIndexPaths:[NSArray arrayWithObject:prevPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    //click new row with no expaning;
    selectedIndex = (int)indexPath.row;
    [_tableFields reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    if (selectedIndex == indexPath.row)
    {
        return YES;
    }
    else
    {
        return FALSE;
    }
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        [taskArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}


@end
