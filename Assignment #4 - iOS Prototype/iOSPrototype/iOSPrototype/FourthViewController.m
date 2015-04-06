//
//  FourthViewController.m
//  iOSPrototype
//
//  Created by David Schechter on 3/22/15.
//  Copyright (c) 2015 David Schechter. All rights reserved.
//

#import "FourthViewController.h"

@interface FourthViewController ()

@end

@implementation FourthViewController

@synthesize dateTextField,taskNameTextField,priorityTextField,descriptionTextView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.descriptionTextView.layer.borderWidth = 0.5f;
    self.descriptionTextView.layer.cornerRadius = 7;
    self.descriptionTextView.layer.borderColor = [[UIColor colorWithRed: 200.0f/255.0f
                                                                  green: 200.0f/255.0f
                                                                   blue: 200.0f/255.0f
                                                                  alpha: 1.0f] CGColor];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(updateTextField:)
         forControlEvents:UIControlEventValueChanged];
    [self.dateTextField setInputView:datePicker];

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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}


-(IBAction) clickCreateTask:(id) sender
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSMutableArray *tmp=[NSMutableArray arrayWithArray:[userDefaults objectForKey:@"taskArray"]];
    
    NSMutableArray *tmp2=tmp[tmp.count-1];
    tmp[tmp.count-1]=[NSMutableArray arrayWithObjects: @"Test 1",@"", @"", @"", @"", nil];
    [tmp addObject:tmp2];
    
    // Save your (updated) bookmarks
    [userDefaults setObject:tmp forKey:@"taskArray"];
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