//
//  ThirdViewController.m
//  iOSPrototype
//
//  Created by David Schechter on 3/22/15.
//  Copyright (c) 2015 David Schechter. All rights reserved.
//

#import "ThirdViewController.h"

@interface ThirdViewController ()

@property (weak, nonatomic) IBOutlet UIButton *createAppointmentButton;

@end

@implementation ThirdViewController

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
    
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
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
    [DateFormatter setDateFormat:@"MMMM d, yyyy"];
    dateTextField.text = [DateFormatter stringFromDate:[NSDate date]];
    
    
    UIDatePicker *datePicker2 = [[UIDatePicker alloc] init];
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
    RateView* rv = [RateView rateViewWithRating:1.0f];
    [self.view addSubview:rv];
    // Extra frames width, height ignored
    rv.frame = CGRectMake(155, 340, 200, 240);    // Customizable star normal color
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    if(!tmp[@"26-03-2015"]){
        tmp[@"26-03-2015"] = [NSMutableArray new];
    }
    NSMutableArray *tmp2=[NSMutableArray arrayWithArray:tmp[@"26-03-2015"]];
    [tmp2 addObject:@"2015-03-27 06:45:20 +4444"];
//    [tmp2 addObject:@"2015-03-27 06:45:20 +5555"];
//    [tmp2 addObject:@"2015-03-27 06:45:20 +6666"];
    tmp[@"26-03-2015"] = tmp2;
    
    // Save your (updated) bookmarks
    [userDefaults setObject:tmp forKey:@"eventsByDate"];
    [userDefaults synchronize];
    
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
