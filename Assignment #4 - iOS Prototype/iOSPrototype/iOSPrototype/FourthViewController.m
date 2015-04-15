//
//  FourthViewController.m
//  iOSPrototype
//
//  Created by David Schechter on 3/22/15.
//  Copyright (c) 2015 David Schechter. All rights reserved.
//

#import "FourthViewController.h"
#import "UITextField+Shake.h"
#import "UIView+Toast.h"

@interface FourthViewController ()

@property (weak, nonatomic) IBOutlet UIButton *createToDoTaskButton;
@property (weak, nonatomic) IBOutlet UIView *topRectangeBar;

@end

@implementation FourthViewController

RateView* rvTask;

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
    
    
    rvTask = [RateView rateViewWithRating:1.0f];
    [self.view addSubview:rvTask];
    // Extra frames width, height ignored
    rvTask.frame = CGRectMake(162, 302, 200, 240);    // Customizable star normal color
    rvTask.starNormalColor = [UIColor grayColor];
    // Customizable star fill color
    rvTask.starFillColor = [UIColor redColor];
    // Customizable star fill mode
    rvTask.starFillMode = StarFillModeHorizontal;
    // Change rating whenever needed
    rvTask.rating = 1.0f;
    // Set star granularity
    rvTask.step = 1.0f;
    rvTask.starSize = 19.5;
    // Can Rate (User Interaction, as needed)
    rvTask.canRate = YES;
    priorityTextField.hidden = YES;
    
    // Change view controller to SecondViewController
    self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:1];
    self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:3];
    
    
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
    
    if(taskNameTextField.text.length == 0){
        //taskNameTextField.layer.borderColor  = [[UIColor colorWithRed:151.0f/255.0f green:23/255.0f blue:43/255.0f alpha:1.0f] CGColor];
        taskNameTextField.layer.borderColor  = UIColor.redColor.CGColor;
        taskNameTextField.layer.borderWidth = 1.2f;
        taskNameTextField.layer.cornerRadius = 4;
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"Required: Task Name" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:151.0f/255.0f green:23/255.0f blue:43/255.0f alpha:1.0f] }];
        self.taskNameTextField.attributedPlaceholder = str;
        [self shake];
        return;
    }
    else{
        taskNameTextField.layer.borderWidth = 0.0f;
    }
    
    // Extract the due date and if none is specified, fill it with ßnone.
    NSString *descriptionInfo = @"None";
    if(descriptionTextView.text.length > 0)
        descriptionInfo = descriptionTextView.text;
    
    // Extract the due date and if none is specified, fill it with none.
    NSString *dueDateInfo = @"None";
    if(dateTextField.text.length > 0)
        dueDateInfo = dateTextField.text;
    
    
    NSString *starText = @"";
    int i;
    for(i = 0; i<round(rvTask.rating); i++)
        starText = [NSString stringWithFormat:@"%@%@", starText, @"✭"];
    for(;i<5;i++)
        starText = [NSString stringWithFormat:@"%@%@", starText, @"✩"];
    
    
    tmp[tmp.count-1]=[NSMutableArray arrayWithObjects: taskNameTextField.text,
                                                       descriptionInfo,
                                                       dueDateInfo,
                                                       starText, @"", nil];
    [tmp addObject:tmp2];
    
    // Save your (updated) bookmarks
    [userDefaults setObject:tmp forKey:@"taskArray"];
    [userDefaults synchronize];
    
    // Reset the text fields.
    taskNameTextField.text = @"";
    taskNameTextField.placeholder = @"Enter a Task Name";
    dateTextField.text = @"";
    descriptionTextView.text = @"";
    rvTask.rating = 1.0f;
    
    // Change view controller to FirstViewController
    self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:1];
    
    // toast with duration, title, and position
    [self.tabBarController.selectedViewController.view makeToast:@"Task Created"
                                                        duration:3.0
                                                        position:CSToastPositionCenter];
    
    
}


- (void)shake
{
    [self.taskNameTextField shake: 12
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
