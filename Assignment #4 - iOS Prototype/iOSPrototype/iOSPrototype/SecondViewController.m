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
    
    taskArray = [NSMutableArray arrayWithObjects:[NSMutableArray arrayWithObjects: @"Take out the Trash",@"Take the trash out before the trash collector comes on Monday", @"May 4, 2015", @"✭✭✭✩✩", @"4", nil],
                 [NSMutableArray arrayWithObjects: @"Mow the Lawn",@"Need to get the lawnmower and mow both the front and back yard. Steve will mow the side yard", @"April 30, 2015", @"✭✩✩✩✩", @"3", nil],
                 [NSMutableArray arrayWithObjects: @"Go to the Store to Get Cat Food",@"Running out of cat food at home so go to Petco to get some wet (Fancy Feast) and dry (Purina One) cat food", @"June 22, 2015", @"✭✭✩✩✩", @"2", nil],
                 [NSMutableArray arrayWithObjects: @"Call Comcast",@"Cancel cable but make sure they do not cancel the internet too.", @"None", @"✭✭✭✭✭", @"", nil],[NSMutableArray arrayWithObjects: @"",@"", @"", @"", @"", nil],nil];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    // Save your (updated) bookmarks
    [userDefaults setObject:taskArray forKey:@"taskArray"];
    [userDefaults synchronize];
    
    [[NSUserDefaults standardUserDefaults] addObserver:self
                                            forKeyPath:@"taskArray" options:NSKeyValueObservingOptionNew
                                               context:NULL];
    
    UILongPressGestureRecognizer *longpress =
    [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(doLongPress:)];
    [self.view addGestureRecognizer:longpress];

}

// KVO handler
-(void)observeValueForKeyPath:(NSString *)aKeyPath ofObject:(id)anObject
                       change:(NSDictionary *)aChange context:(void *)aContext
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    taskArray=[NSMutableArray arrayWithArray:[userDefaults objectForKey:@"taskArray"]];
    [_tableFields reloadData];
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
    
    cell.containingViewController=self;
    cell.myIndexPath=indexPath;
    
    if ([taskArray count]-1 == indexPath.row)
    {
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.taskLabel.hidden=YES;
        cell.plusMinusButton.hidden=YES;
    }
    else
    {
        cell.selectionStyle=UITableViewCellSelectionStyleDefault;
        cell.taskLabel.hidden=NO;
        cell.plusMinusButton.hidden=NO;
    }

    if (selectedIndex == indexPath.row)
    {
        cell.contentView.backgroundColor = [UIColor colorWithRed: 199.0f/255.0f
                                                           green: 221.0f/255.0f
                                                            blue: 238.0f/255.0f
                                                           alpha: 1.0f];
        cell.taskLabel.textColor = [UIColor blackColor];
        //cell.taskLabel.backgroundColor = [UIColor whiteColor];
        cell.taskLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0];
        cell.taskDetails.textColor = [UIColor blackColor];
        cell.taskDetails.backgroundColor = [UIColor colorWithRed: 199.0f/255.0f
                                                           green: 221.0f/255.0f
                                                            blue: 238.0f/255.0f
                                                           alpha: 1.0f];
        cell.rating.textColor = [UIColor blackColor];
        cell.dueDate.textColor = [UIColor blackColor];
        cell.dueDateTitle.textColor = [UIColor blackColor];
        cell.ratingTitle.textColor = [UIColor blackColor];
        
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
        
        selectedIndex=-1;
        
        [taskArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Completed?";
}

- (void) doLongPress:(UILongPressGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    NSLog(@"%f %f",location.x, location.y);
    
    if(location.y < 60)
        return;
    //Do stuff here...
    
    [self becomeFirstResponder];
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    
    NSMutableArray *options = [NSMutableArray array];
    
    UIMenuItem *item = [[UIMenuItem alloc] initWithTitle:@"Edit"
                                                  action:@selector(doActionEditDelete)];
    [options addObject:item];
    
    UIMenuItem *item2 = [[UIMenuItem alloc] initWithTitle:@"Delete"
                                                   action:@selector(doActionEditDelete)];
    [options addObject:item2];
    
    
    CGRect rect1 = CGRectMake(location.x,location.y,10,10);
    
    [menu setMenuItems:options];
    [menu setTargetRect:rect1
                 inView:self.view];
    [menu setMenuVisible:YES animated:YES];
}

- (void) doActionEditDelete {
    NSLog(@"do action edit/delete");
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if(@selector(doActionEditDelete) == action) {
        return YES;
    }
    return NO;
}

@end
