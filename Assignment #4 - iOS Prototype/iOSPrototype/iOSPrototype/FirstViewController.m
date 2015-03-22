//
//  FirstViewController.m
//  iOSPrototype
//
//  Created by David Schechter on 3/22/15.
//  Copyright (c) 2015 David Schechter. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController (){
    NSMutableDictionary *eventsByDate;
}

@end

@implementation FirstViewController

//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view, typically from a nib.
//}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.calendar = [JTCalendar new];
    
    _tableFields.dataSource=self;
    _tableFields.delegate=self;
    _tableFields.layer.borderWidth=2.0;
    _tableFields.layer.borderColor=[UIColor blackColor].CGColor;
    
    selectedKey = [[self dateFormatter] stringFromDate:[NSDate date]];
    
    // All modifications on calendarAppearance have to be done before setMenuMonthsView and setContentView
    // Or you will have to call reloadAppearance
    {
        self.calendar.calendarAppearance.calendar.firstWeekday = 2; // Sunday == 1, Saturday == 7
        self.calendar.calendarAppearance.dayCircleRatio = 9. / 10.;
        self.calendar.calendarAppearance.ratioContentMenu = 2.;
        self.calendar.calendarAppearance.focusSelectedDayChangeMode = YES;
        self.calendar.calendarAppearance.ratioContentMenu = 1;
        
        // Customize the text for each month
        self.calendar.calendarAppearance.monthBlock = ^NSString *(NSDate *date, JTCalendar *jt_calendar){
            NSCalendar *calendar = jt_calendar.calendarAppearance.calendar;
            NSDateComponents *comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:date];
            NSInteger currentMonthIndex = comps.month;
            
            static NSDateFormatter *dateFormatter;
            if(!dateFormatter){
                dateFormatter = [NSDateFormatter new];
                dateFormatter.timeZone = jt_calendar.calendarAppearance.calendar.timeZone;
            }
            
            while(currentMonthIndex <= 0){
                currentMonthIndex += 12;
            }
            
            NSString *monthText = [[dateFormatter standaloneMonthSymbols][currentMonthIndex - 1] capitalizedString];
            
            return [NSString stringWithFormat:@"%ld\n%@", comps.year, monthText];
        };
    }
    
    [self.calendar setMenuMonthsView:self.calendarMenuView];
    [self.calendar setContentView:self.calendarContentView];
    [self.calendar setDataSource:self];
    
    [self createRandomEvents];
    
    [self.calendar reloadData];
}

- (void)viewDidLayoutSubviews
{
    [self.calendar repositionViews];
}

#pragma mark - Buttons callback

- (IBAction)didGoTodayTouch
{
    [self.calendar setCurrentDate:[NSDate date]];
}

- (IBAction)didChangeModeTouch
{
    self.calendar.calendarAppearance.isWeekMode = !self.calendar.calendarAppearance.isWeekMode;
    
    [self transitionExample];
}

#pragma mark - JTCalendarDataSource

- (BOOL)calendarHaveEvent:(JTCalendar *)calendar date:(NSDate *)date
{
    NSString *key = [[self dateFormatter] stringFromDate:date];
    
    if(eventsByDate[key] && [eventsByDate[key] count] > 0){
        return YES;
    }
    
    return NO;
}

- (void)calendarDidDateSelected:(JTCalendar *)calendar date:(NSDate *)date
{
    NSString *key = [[self dateFormatter] stringFromDate:date];
    selectedKey = [[self dateFormatter] stringFromDate:date];
    NSArray *events = eventsByDate[key];
    [_tableFields reloadData];
    
    NSLog(@"Date: %@ - %ld events", date, [events count]);
}

- (void)calendarDidLoadPreviousPage
{
    NSLog(@"Previous page loaded");
}

- (void)calendarDidLoadNextPage
{
    NSLog(@"Next page loaded");
}

#pragma mark - Transition examples

- (void)transitionExample
{
    CGFloat newHeight = 300;
    CGFloat tableNewY = 370;
    if(self.calendar.calendarAppearance.isWeekMode){
        newHeight = 75;
        tableNewY=170;
    }
    
    [UIView animateWithDuration:.5
                     animations:^{
                         self.calendarContentViewHeight.constant = newHeight;
                         self.calendarContentView.frame=CGRectMake(self.calendarContentView.frame.origin.x, self.calendarContentView.frame.origin.y, self.calendarContentView.frame.size.width, newHeight);
                         [self.view layoutIfNeeded];
                         [_tableFields layoutIfNeeded];
                     }];
    
    [UIView animateWithDuration:.5
                     animations:^{
                         [_tableFields beginUpdates];
                         _tableFields.frame=CGRectMake(_tableFields.frame.origin.x, tableNewY, _tableFields.frame.size.width, _tableFields.frame.size.height);
                         [_tableFields endUpdates];
                     }];
    
    [UIView animateWithDuration:.25
                     animations:^{
                         self.calendarContentView.layer.opacity = 0;
                     }
                     completion:^(BOOL finished) {
                         [self.calendar reloadAppearance];
                         
                         [UIView animateWithDuration:.25
                                          animations:^{
                                              self.calendarContentView.layer.opacity = 1;
                                          }];
                     }];
}

#pragma mark - Fake data

- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"dd-MM-yyyy";
    }
    
    return dateFormatter;
}

- (void)createRandomEvents
{
    eventsByDate = [NSMutableDictionary new];
    
    for(int i = 0; i < 30; ++i){
        // Generate 30 random dates between now and 60 days later
        NSDate *randomDate = [NSDate dateWithTimeInterval:(rand() % (3600 * 24 * 60)) sinceDate:[NSDate date]];
        
        // Use the date as key for eventsByDate
        NSString *key = [[self dateFormatter] stringFromDate:randomDate];
        
        if(!eventsByDate[key]){
            eventsByDate[key] = [NSMutableArray new];
        }
        
        [eventsByDate[key] addObject:randomDate];
    }
}

#pragma mark UITableViewDataSource methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section {
    return [eventsByDate[selectedKey] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    static NSString *AutoCompleteRowIdentifier = @"CardsRowIdentifier";
    cell = [tableView dequeueReusableCellWithIdentifier:AutoCompleteRowIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AutoCompleteRowIdentifier];
    }
//    ResturantInfo *tmpInfo=clusterdMarkersInfo[currentNumberOfItemsForTable][indexPath.row];
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,600,50)];
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,aView.frame.size.width-50,aView.frame.size.height/2 )];
//    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, aView.frame.size.height/2 ,aView.frame.size.width-50,aView.frame.size.height/2 )];
    nameLabel.text=[NSString stringWithFormat:@"%@",eventsByDate[selectedKey][indexPath.row]];
//    addressLabel.text=[NSString stringWithFormat:@"%@",tmpInfo.address];
//    nameLabel.adjustsFontSizeToFitWidth = YES;
//    addressLabel.adjustsFontSizeToFitWidth = YES;
    [aView setBackgroundColor:[UIColor whiteColor]];
    [aView addSubview:nameLabel];
//    [aView addSubview:addressLabel];
    [cell addSubview:aView];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
