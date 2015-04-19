//
//  ThirdViewController.m
//  iOSPrototype
//
//  Created by David Schechter on 3/22/15.
//  Copyright (c) 2015 David Schechter. All rights reserved.
//

#import "ThirdViewController.h"
#import "FirstViewController.h"
#import "UIView+Toast.h"


@interface ThirdViewController ()

@property (weak, nonatomic) IBOutlet UIButton *createAppointmentButton;

@end

@implementation ThirdViewController

RateView* rv;
UIDatePicker *datePicker;
UIDatePicker *datePicker2;
NSDate * previousDate;

@synthesize dateTextField,hourTextField,taskColorTextField,taskNameTextField,priorityTextField,addInviteesTextField,descriptionTextView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Set border format for the text view.
    self.descriptionTextView.layer.borderWidth = 0.5f;
    self.descriptionTextView.layer.cornerRadius = 4;
    self.descriptionTextView.layer.borderColor = [[UIColor colorWithRed: 200.0f/255.0f
                                                                  green: 200.0f/255.0f
                                                                   blue: 200.0f/255.0f
                                                                  alpha: 1.0f] CGColor];
    self.descriptionTextView.delegate = self;
    self.descriptionTextView.text = @"Optional";
    self.descriptionTextView.textColor = [UIColor lightGrayColor];
    self.descriptionTextView.tag = 0;
    
    
    self.createAppointmentButton.backgroundColor = [UIColor colorWithRed: 199.0f/255.0f
                                                                   green: 221.0f/255.0f
                                                                    blue: 238.0f/255.0f
                                                                   alpha: 1.0f];
    self.createAppointmentButton.layer.cornerRadius = 4;
    self.createAppointmentButton.titleLabel.textColor = [UIColor blackColor];
    self.createAppointmentButton.layer.borderWidth = 2;
    self.createAppointmentButton.layer.borderColor = [[UIColor colorWithRed: 200.0f/255.0f
                                                                      green: 200.0f/255.0f
                                                                       blue: 200.0f/255.0f
                                                                      alpha: 1.0f] CGColor];
    
    
    datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    // Improve the display of the day selection datepicker.
    datePicker.layer.borderColor = [[UIColor colorWithRed: 200.0f/255.0f
                                                    green: 200.0f/255.0f
                                                     blue: 200.0f/255.0f
                                                    alpha: 1.0f] CGColor];
    
    datePicker.layer.borderWidth = 2;
    datePicker.backgroundColor = [UIColor whiteColor];
    [datePicker addTarget:self action:@selector(updateTextField:)
         forControlEvents:UIControlEventValueChanged];
    [self.dateTextField setInputView:datePicker];
    
    //---- Preload the text field with the date.
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    
    //UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //FirstViewController *subField = [sb instantiateViewControllerWithIdentifier:@"FirstViewController"];
    
    
    [DateFormatter setDateFormat:@"MMMM d, yyyy"];
    dateTextField.text = [DateFormatter stringFromDate:[NSDate date]];
    
    
    datePicker2 = [[UIDatePicker alloc] init];
    datePicker2.datePickerMode = UIDatePickerModeTime;
    // Improve the display of the time selection datepicker.
    datePicker2.layer.borderColor = [[UIColor colorWithRed: 200.0f/255.0f
                                                     green: 200.0f/255.0f
                                                      blue: 200.0f/255.0f
                                                     alpha: 1.0f] CGColor];
    
    datePicker2.layer.borderWidth = 2;
    datePicker2.backgroundColor = [UIColor whiteColor];
    [datePicker2 addTarget:self action:@selector(updateTextField2:)
          forControlEvents:UIControlEventValueChanged];
    [self.hourTextField setInputView:datePicker2];
    
    //---- Preload the text field with the time.
    [DateFormatter setDateFormat:@"H:mm a"];
    hourTextField.text = [DateFormatter stringFromDate:[NSDate date]];
    
    // Do any additional setup after loading the view.
    rv = [RateView rateViewWithRating:1.0f];
    [self.view addSubview:rv];
    // Extra frames width, height ignored
    //    CGRect tmp=self.priorityTextField.frame;
    //    [rv setFrame:CGRectMake(self.priorityTextField.frame.origin.x, self.priorityTextField.frame.origin.y, 200, 240)];    // Customizable star normal color
    rv.starNormalColor = [UIColor grayColor];
    // Customizable star fill color
    rv.starFillColor = [UIColor redColor];
    // Customizable star fill mode
    rv.starFillMode = StarFillModeHorizontal;
    // Change rating whenever needed
    rv.rating = 1.0f;
    // Set star granularity
    rv.step = 1.0f;
    rv.starSize = 19.5;
    // Can Rate (User Interaction, as needed)
    rv.canRate = YES;
    priorityTextField.hidden = YES;
    
    
}

//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    CGRect tmp=self.priorityTextField.frame;
//    [rv setFrame:CGRectMake(self.priorityTextField.frame.origin.x, self.priorityTextField.frame.origin.y, 200, 240)];
//
//}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //    CGRect tmp=self.priorityTextField.frame;
    [rv setFrame:CGRectMake(self.priorityTextField.frame.origin.x+5, self.priorityTextField.frame.origin.y+5, 200, 240)];
    
    NSArray *tmp=[self.tabBarController viewControllers];
    FirstViewController *subField = (FirstViewController *)[tmp objectAtIndex:0];
    NSDate *dateToSet=subField.selectedDateInCalendar;
    
    if (dateToSet && previousDate != dateToSet)
    {
        NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
        [DateFormatter setDateFormat:@"MMMM d, yyyy"];
        dateTextField.text = [DateFormatter stringFromDate:dateToSet];
        datePicker.date = dateToSet;
        
        previousDate = dateToSet;
    }
    if(hourTextField.text.length == 0){
        NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
        [DateFormatter setDateFormat:@"H:mm a"];
        hourTextField.text = [DateFormatter stringFromDate:[NSDate date]];
        datePicker2.date = [NSDate date];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if(textView.tag == 0) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
        textView.tag = 1;
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if([textView.text length] == 0)
    {
        textView.text = @"Optional";
        textView.textColor = [UIColor lightGrayColor];
        textView.tag = 0;
    }
}


-(void)updateTextField:(UIDatePicker *)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"MMMM d, yyyy"];
    NSString *formattedDate = [dateFormatter stringFromDate:sender.date];
    
    self.dateTextField.text = formattedDate;
}

-(void)updateTextField2:(UIDatePicker *)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"h':'mm a"];
    NSString *formattedDate = [dateFormatter stringFromDate:sender.date];
    
    self.hourTextField.text = formattedDate;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

-(IBAction) clickCreateAppointment:(id) sender
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary *tmp=[NSMutableDictionary dictionaryWithDictionary:[userDefaults objectForKey:@"eventsByDate"]];
    
    BOOL valid_inputs = YES;
    
    
    if(taskNameTextField.text.length == 0){
        //taskNameTextField.layer.borderColor  = [[UIColor colorWithRed:151.0f/255.0f green:23/255.0f blue:43/255.0f alpha:1.0f] CGColor];
        taskNameTextField.layer.borderColor  = UIColor.redColor.CGColor;
        taskNameTextField.layer.borderWidth = 1.2f;
        taskNameTextField.layer.cornerRadius = 4;
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"Required: Name" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:151.0f/255.0f green:23/255.0f blue:43/255.0f alpha:1.0f] }];
        self.taskNameTextField.attributedPlaceholder = str;
        [self shakeName];
        //[self showErrorAlert];
        valid_inputs = NO;
    }
    else{
        taskNameTextField.layer.borderWidth = 0.0f;
        taskNameTextField.placeholder = @"Enter Name";
    }
    
    if(dateTextField.text.length == 0){
        //taskNameTextField.layer.borderColor  = [[UIColor colorWithRed:151.0f/255.0f green:23/255.0f blue:43/255.0f alpha:1.0f] CGColor];
        dateTextField.layer.borderColor  = UIColor.redColor.CGColor;
        dateTextField.layer.borderWidth = 1.2f;
        dateTextField.layer.cornerRadius = 4;
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"Required: Date" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:151.0f/255.0f green:23/255.0f blue:43/255.0f alpha:1.0f] }];
        self.dateTextField.attributedPlaceholder = str;
        [self shakeDate];
        //[self showErrorAlert];
        valid_inputs = NO;
    }
    else{
        dateTextField.layer.borderWidth = 0.0f;
        dateTextField.placeholder = @"Enter Date";
    }
    
    if(hourTextField.text.length == 0){
        //taskNameTextField.layer.borderColor  = [[UIColor colorWithRed:151.0f/255.0f green:23/255.0f blue:43/255.0f alpha:1.0f] CGColor];
        hourTextField.layer.borderColor  = UIColor.redColor.CGColor;
        hourTextField.layer.borderWidth = 1.2f;
        hourTextField.layer.cornerRadius = 4;
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"Required: Time" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:151.0f/255.0f green:23/255.0f blue:43/255.0f alpha:1.0f] }];
        self.hourTextField.attributedPlaceholder = str;
        [self shakeHour];
        //[self showErrorAlert];
        valid_inputs = NO;
    }
    else{
        hourTextField.layer.borderWidth = 0.0f;
        hourTextField.placeholder = @"Enter Time";
    }
    
    if(valid_inputs == NO) return;
    
    // Extract the description and if none is specified, fill it with none.
    NSString *descriptionInfo = @"None";
    if(descriptionTextView.text.length > 0)
        descriptionInfo = descriptionTextView.text;
    
    // Extract the due date and if none is specified, fill it with none.
    NSString *dueDateInfo = @"None";
    if(dateTextField.text.length > 0)
        dueDateInfo = dateTextField.text;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"MMMM d, yyyy"];
    NSDate *eventDate = [dateFormatter dateFromString: dateTextField.text];
    NSLog(@" event date %@",eventDate);
    [dateFormatter setDateFormat: @"dd-MM-YYYY"];
    NSString *stringEventDate = [dateFormatter stringFromDate:eventDate];
    NSLog(@" date format %@",[dateFormatter stringFromDate:eventDate]);
    NSLog(@" event date %@", stringEventDate);
    
    if(!tmp[stringEventDate]){
        tmp[stringEventDate] = [NSMutableArray new];
    }
    NSMutableArray *tmp2=[NSMutableArray arrayWithArray:tmp[stringEventDate]];
    //    [eventsByDate[key] addObject:@"NODATA"]
    if ([tmp2 count]<3)
    {
        [tmp2 addObject:[hourTextField.text stringByAppendingString:[NSString stringWithFormat: @" - %@", taskNameTextField.text]]];
        [tmp2 addObject:@"NODATA"];
        [tmp2 addObject:@"NODATA"];
    }
    else if ([tmp2 count]==3)
    {
        if ([tmp2[0] isEqual:@"NODATA"])
        {
            tmp2[0]=[hourTextField.text stringByAppendingString:[NSString stringWithFormat: @" - %@", taskNameTextField.text]];
        }
        else if ([tmp2[1] isEqual:@"NODATA"])
        {
            tmp2[1]=[hourTextField.text stringByAppendingString:[NSString stringWithFormat: @" - %@", taskNameTextField.text]];
        }
        else if ([tmp2[2] isEqual:@"NODATA"])
        {
            tmp2[2]=[hourTextField.text stringByAppendingString:[NSString stringWithFormat: @" - %@", taskNameTextField.text]];
        }
    }
    else
    {
        [tmp2 addObject:[hourTextField.text stringByAppendingString:[NSString stringWithFormat: @" - %@", taskNameTextField.text]]];
    }
    //    [tmp2 addObject:@"2015-03-27 06:45:20 +5555"];
    //    [tmp2 addObject:@"2015-03-27 06:45:20 +6666"];
    tmp[stringEventDate] = tmp2;
    
    // add this new appointment in eventsByDate dictionary of FirstViewController
    
    
    // Save your (updated) bookmarks
    [userDefaults setObject:tmp forKey:@"eventsByDate"];
    [userDefaults synchronize];
    
    
    // Reset the text fields.
    taskNameTextField.text = @"";
    dateTextField.text = @"";
    hourTextField.text = @"";
    descriptionTextView.text = @"";
    addInviteesTextField.text = @"";
    rv.rating = 1.0f;
    
    // Updating calendar date.
    NSArray *tabBar=[self.tabBarController viewControllers];
    FirstViewController *subField = (FirstViewController *)[tabBar objectAtIndex:0];
    //subField.calendar.setSelectedDate(datePicker.date);
    subField.selectedDateInCalendar = datePicker.date;
    [subField.calendar setSelectedDate:datePicker.date];
    
    
    // Change view controller to FirstViewController
    self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:0];
    
    // toast with duration, title, and position
    [self.tabBarController.selectedViewController.view makeToast:@"Appointment Created"
                                                        duration:3.0
                                                        position:CSToastPositionCenter];
    
}

- (void)shakeName
{
    [self.taskNameTextField shake: 12
                        withDelta: 5
                         andSpeed: 0.03
                   shakeDirection: ShakeDirectionHorizontal];
}

- (void)shakeDate
{
    [self.dateTextField     shake: 12
                        withDelta: 5
                         andSpeed: 0.03
                   shakeDirection: ShakeDirectionHorizontal];
}

- (void)shakeHour
{
    [self.hourTextField     shake: 12
                        withDelta: 5
                         andSpeed: 0.03
                   shakeDirection: ShakeDirectionHorizontal];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
