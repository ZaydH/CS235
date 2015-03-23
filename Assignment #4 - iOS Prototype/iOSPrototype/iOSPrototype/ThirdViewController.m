//
//  ThirdViewController.m
//  iOSPrototype
//
//  Created by David Schechter on 3/22/15.
//  Copyright (c) 2015 David Schechter. All rights reserved.
//

#import "ThirdViewController.h"

@interface ThirdViewController ()

@end

@implementation ThirdViewController

@synthesize dateTextField,hourTextField,taskColorTextField,taskNameTextField,priorityTextField,addInviteesTextField,descriptionTextView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(updateTextField:)
         forControlEvents:UIControlEventValueChanged];
    [self.dateTextField setInputView:datePicker];
    
    UIDatePicker *datePicker2 = [[UIDatePicker alloc] init];
    datePicker2.datePickerMode = UIDatePickerModeTime;
    [datePicker2 addTarget:self action:@selector(updateTextField2:)
         forControlEvents:UIControlEventValueChanged];
    [self.hourTextField setInputView:datePicker2];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateTextField:(UIDatePicker *)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"MM'/'dd'/'yyyy"];
    NSString *formattedDate = [dateFormatter stringFromDate:sender.date];
    
    self.dateTextField.text = formattedDate;
}

-(void)updateTextField2:(UIDatePicker *)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"hh':'mm a"];
    NSString *formattedDate = [dateFormatter stringFromDate:sender.date];
    
    self.hourTextField.text = formattedDate;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
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
