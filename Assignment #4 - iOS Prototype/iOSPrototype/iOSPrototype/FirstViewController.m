//
//  FirstViewController.m
//  iOSPrototype
//
//  Created by David Schechter on 3/22/15.
//  Copyright (c) 2015 David Schechter. All rights reserved.
//

#import "FirstViewController.h"
#import "UIView+Toast.h"



@interface FirstViewController (){
    NSMutableDictionary *eventsByDate;
}
@property (weak, nonatomic) IBOutlet UIButton *todayButton;

@property (weak, nonatomic) IBOutlet UIButton *switchViewButton;

@end

@implementation FirstViewController

@synthesize selectedDateInCalendar;

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
    _tableFields.layer.borderWidth=1;
    _tableFields.layer.borderColor=[UIColor grayColor].CGColor;

    
    selectedKey = [[self dateFormatter] stringFromDate:[NSDate date]];
    
    // All modifications on calendarAppearance have to be done before setMenuMonthsView and setContentView
    // Or you will have to call reloadAppearance
    {
        self.calendar.calendarAppearance.calendar.firstWeekday = 1; // Sunday == 1, Saturday == 7 //-- ZSH Switching to standard US default of sunday first.
        self.calendar.calendarAppearance.dayCircleRatio = 9. / 10.;
        self.calendar.calendarAppearance.ratioContentMenu = 2.;
        self.calendar.calendarAppearance.focusSelectedDayChangeMode = YES;
        self.calendar.calendarAppearance.ratioContentMenu = 1;
        
        UIColor *buttonColor = [UIColor colorWithRed: 51.0f/255.0f
                                               green: 92.0f/255.0f
                                                blue: 214.0f/255.0f
                                               alpha: 1.0f];
        
        self.todayButton.backgroundColor = buttonColor;
        self.todayButton.layer.cornerRadius = 4;
        self.todayButton.titleLabel.textColor = [UIColor whiteColor];
        self.todayButton.layer.borderWidth = 2;
        self.todayButton.layer.borderColor = [[UIColor colorWithRed: 200.0f/255.0f
                                                              green: 200.0f/255.0f
                                                               blue: 200.0f/255.0f
                                                              alpha: 1.0f] CGColor];
        
        
        self.switchViewButton.backgroundColor = buttonColor;
        self.switchViewButton.layer.cornerRadius = 4;
        self.switchViewButton.titleLabel.textColor = [UIColor whiteColor];
        self.switchViewButton.layer.borderWidth = 2;
        self.switchViewButton.layer.borderColor = [[UIColor colorWithRed: 200.0f/255.0f
                                                                   green: 200.0f/255.0f
                                                                    blue: 200.0f/255.0f
                                                                   alpha: 1.0f] CGColor];
        
        
        
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
            
            //return [NSString stringWithFormat:@"%ld\n%@", comps.year, monthText]; /// Removed year by Zayd
            return [NSString stringWithFormat:@"%@", monthText];
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
    [self.calendar setSelectedDate:[NSDate date]];

    NSString *key = [[self dateFormatter] stringFromDate:[NSDate date]];
    selectedKey = [[self dateFormatter] stringFromDate:[NSDate date]];
    NSArray *events = eventsByDate[key];
    [_tableFields reloadData];
    [self.calendar reloadData];
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"kJTCalendarDaySelected" object:[NSDate date]];
    
    NSLog(@"Date: %@ - %ld events", [NSDate date], [events count]);


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
    self.selectedDateInCalendar=[NSDate dateWithTimeInterval:0 sinceDate:date];
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
    CGFloat tableNewH = 181;
    if(self.calendar.calendarAppearance.isWeekMode){
        newHeight = 75;
        tableNewY=170;
        tableNewH = 447;
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
                         self.tableViewHeight.constant=tableNewH;
                         [_tableFields beginUpdates];
                         _tableFields.frame=CGRectMake(_tableFields.frame.origin.x, tableNewY, _tableFields.frame.size.width, tableNewH);
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

- (void)viewDidAppear:(BOOL)animated{
    
    /*NSString *key = [[self dateFormatter] stringFromDate:date];
    NSArray *events = eventsByDate[key];
    [_tableFields reloadData];
    [self.calendar reloadData];*/
    
    /*NSString *key = [[self dateFormatter] stringFromDate:self.selectedDateInCalendar];
    selectedKey = [[self dateFormatter] stringFromDate:self.selectedDateInCalendar];
    NSArray *events = eventsByDate[key];
    [_tableFields reloadData];*/

    
    //self.selectedDateInCalendar=[NSDate dateWithTimeInterval:0 sinceDate:date];
    NSString *key = [[self dateFormatter] stringFromDate:self.selectedDateInCalendar];
    selectedKey = [[self dateFormatter] stringFromDate:self.selectedDateInCalendar];
    NSArray *events = eventsByDate[key];
    [_tableFields reloadData];
    
    NSLog(@"Date: %@ - %ld events", self.selectedDateInCalendar, [events count]);
    
    [self.calendar reloadData];
}


- (void)createRandomEvents
{
    eventsByDate = [NSMutableDictionary new];
    // The array having appointments that will get selected and assigned at random
    NSArray *appointments = [NSArray arrayWithObjects:@"Happy Hour",@"Homework #3 Due",@"Special Class",
                             @"Meet the Accountant",@"Meeting with Team",@"Repeating Event",
                             @"Dentist Appointment",@"CS235 Assignment Due",@"Lunch Meeting",
                             @"Go to the Movies", @"Dinner with Buddy the Cat",
                             @"Visit the Tech Museum", @"Take a Nap",
                             @"Call Bank Regarding Loan", @"Take my Medicine",
                             @"Sami Khuri Meeting", @"Grade Student Exams",nil];
    
    for(int i = 0; i < 30; ++i){
        // Generate 30 random dates between now and 60 days later
        NSDate *randomDate = [NSDate dateWithTimeInterval:(rand() % (3600 * 24 * 60)+3600*24) sinceDate:[NSDate date]];
        
        // Use the date as key for eventsByDate
        NSString *key = [[self dateFormatter] stringFromDate:randomDate];
        
        // Generate a random number to randomly select an appointment
        NSInteger randomNumber = arc4random() % 17;
        
        if(!eventsByDate[key]){
            eventsByDate[key] = [NSMutableArray new];
        }
        
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"h:mm a"];
        
        //Optionally for time zone conversions
        [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"PST"]];
        
        NSString *stringFromDate = [formatter stringFromDate:randomDate];
        
        [eventsByDate[key] addObject:[stringFromDate stringByAppendingString:[@" - " stringByAppendingString:[appointments objectAtIndex:randomNumber]]]];
    }
    
    
    for(int i = 0; i < 17; ++i){
        // Generate 30 random dates between now and 60 days later
        NSDate *randomDate = [NSDate dateWithTimeInterval:(i *4500 +1800) sinceDate:[NSDate date]];
        
        // Use the date as key for eventsByDate
        NSString *key = [[self dateFormatter] stringFromDate:randomDate];
        
        if(!eventsByDate[key]){
            eventsByDate[key] = [NSMutableArray new];
        }
        
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"h:mm a"];
        
        //Optionally for time zone conversions
        [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"PST"]];
        
        NSString *stringFromDate = [formatter stringFromDate:randomDate];
        
        [eventsByDate[key] addObject:[stringFromDate stringByAppendingString:[@" - " stringByAppendingString:[appointments objectAtIndex:i]]]];
    }
    
    for (id key in eventsByDate)
    {
        if ([eventsByDate[key] count]<3)
        {
            for(int i = 0; i < (4-[eventsByDate[key] count]); ++i)
            {
                [eventsByDate[key] addObject:@"NODATA"];
            }
        }
    }

    //if(!eventsByDate[@"26-03-2015"]){
      //  eventsByDate[@"26-03-2015"] = [NSMutableArray new];
    //}
    // [eventsByDate[@"26-03-2015"] addObject:@"2015-03-27 06:45:20 +1111"];
//    [eventsByDate[@"26-03-2015"] addObject:@"2015-03-27 06:45:20 +2222"];
//    [eventsByDate[@"26-03-2015"] addObject:@"2015-03-27 06:45:20 +3333"];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    // Save your (updated) bookmarks
    [userDefaults setObject:eventsByDate forKey:@"eventsByDate"];
    [userDefaults synchronize];
    
    [[NSUserDefaults standardUserDefaults] addObserver:self
                                            forKeyPath:@"eventsByDate" options:NSKeyValueObservingOptionNew
                                               context:NULL];
    
}


// KVO handler
-(void)observeValueForKeyPath:(NSString *)aKeyPath ofObject:(id)anObject
                       change:(NSDictionary *)aChange context:(void *)aContext
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    eventsByDate=[userDefaults objectForKey:@"eventsByDate"];
    
    [_tableFields reloadData];
}

#pragma mark UITableViewDataSource methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section {
    if ([eventsByDate[selectedKey] count]>0)
        return [eventsByDate[selectedKey] count];
    else
        return 3;
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
    if ([eventsByDate[selectedKey] count]>0)
    {
        NSString *nextText=[NSString stringWithFormat:@"%@",eventsByDate[selectedKey][indexPath.row]];
        if (!([nextText isEqual:@"NODATA"]))
        {
            cell.textLabel.text=[NSString stringWithFormat:@"%@",eventsByDate[selectedKey][indexPath.row]];
//            cell.textLabel.textAlignment=NSTextAlignmentCenter;
            cell.textLabel.textColor=[UIColor blackColor];
            cell.userInteractionEnabled=YES;
        }
        else
        {
            cell.textLabel.text=[NSString stringWithFormat:@"%@",eventsByDate[selectedKey][indexPath.row]];
            cell.textLabel.textColor=[UIColor clearColor];
            cell.userInteractionEnabled=NO;
        }
    }
    else
    {
        cell.textLabel.text=@"";
        cell.textLabel.textColor=[UIColor clearColor];
        cell.userInteractionEnabled=NO;
    }
    
////    ResturantInfo *tmpInfo=clusterdMarkersInfo[currentNumberOfItemsForTable][indexPath.row];
//    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,600,50)];
//    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 15,aView.frame.size.width-60,aView.frame.size.height/2 )];
////    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, aView.frame.size.height/2 ,aView.frame.size.width-50,aView.frame.size.height/2 )];
//    nameLabel.text=[NSString stringWithFormat:@"%@",eventsByDate[selectedKey][indexPath.row]];
////    addressLabel.text=[NSString stringWithFormat:@"%@",tmpInfo.address];
////    nameLabel.adjustsFontSizeToFitWidth = YES;
////    addressLabel.adjustsFontSizeToFitWidth = YES;
//    [aView setBackgroundColor:[UIColor whiteColor]];
//    [aView addSubview:nameLabel];
////    [aView addSubview:addressLabel];
//    [cell addSubview:aView];
    
    if(indexPath.row % 2 == 1){
        UIColor *rowGrayColor = [UIColor colorWithRed: 233.0f/255.0f
                                                green: 244.0f/255.0f
                                                 blue: 249.0f/255.0f
                                                alpha: 1.0f];
        cell.backgroundColor = rowGrayColor;
//        aView.backgroundColor = rowGrayColor;
    }
    else{
        cell.backgroundColor = [UIColor whiteColor];
//        aView.backgroundColor = [UIColor whiteColor];
    }
    
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
