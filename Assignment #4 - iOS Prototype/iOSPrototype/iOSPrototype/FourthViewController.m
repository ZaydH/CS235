//
//  FourthViewController.m
//  iOSPrototype
//
//  Created by David Schechter on 3/22/15.
//  Copyright (c) 2015 David Schechter. All rights reserved.
//

#import "FourthViewController.h"

@interface FourthViewController ()

@property (weak, nonatomic) IBOutlet UIButton *createToDoTaskButton;
@property (weak, nonatomic) IBOutlet UIView *topRectangeBar;

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
    
    self.createToDoTaskButton.backgroundColor = [UIColor colorWithRed: 199.0f/255.0f
                                                                green: 221.0f/255.0f
                                                                 blue: 238.0f/255.0f
                                                                alpha: 1.0f];
    self.createToDoTaskButton.layer.cornerRadius = 4;
    self.createToDoTaskButton.titleLabel.textColor = [UIColor blackColor];
    self.createToDoTaskButton.layer.borderWidth = 2;
    self.createToDoTaskButton.layer.borderColor = [[UIColor colorWithRed: 200.0f/255.0f
                                                                   green: 200.0f/255.0f
                                                                    blue: 200.0f/255.0f
                                                                   alpha: 1.0f] CGColor];
    
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(updateTextField:)
         forControlEvents:UIControlEventValueChanged];
    [self.dateTextField setInputView:datePicker];
    datePicker.layer.borderColor = [[UIColor colorWithRed: 200.0f/255.0f
                                                    green: 200.0f/255.0f
                                                     blue: 200.0f/255.0f
                                                    alpha: 1.0f] CGColor];
    
    datePicker.layer.borderWidth = 2;
    datePicker.backgroundColor = [UIColor whiteColor];
    
    
    RateView* rv = [RateView rateViewWithRating:1.0f];
    [self.view addSubview:rv];
    // Extra frames width, height ignored
    rv.frame = CGRectMake(120, 299, 200, 240);    // Customizable star normal color
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
    
    // Extract the due date and if none is specified, fill it with none.
    NSString *descriptionInfo = @"None";
    if(descriptionTextView.text.length > 0)
        descriptionInfo = descriptionTextView.text;
    
    // Extract the due date and if none is specified, fill it with none.
    NSString *dueDateInfo = @"None";
    if(dateTextField.text.length > 0)
        dueDateInfo = dateTextField.text;
    
    tmp[tmp.count-1]=[NSMutableArray arrayWithObjects: taskNameTextField.text,
                                                       descriptionInfo,
                                                       dueDateInfo, @"", @"", nil];
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
