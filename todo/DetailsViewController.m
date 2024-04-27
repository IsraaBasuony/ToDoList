//
//  DetailsViewController.m
//  todo
//
//  Created by JETSMobileLabMini1 on 17/04/2024.
//

#import "DetailsViewController.h"
#import "Task.h"
#import "TodoViewController.h"
#import "DoneViewController.h"
#import "InProgressViewController.h"
#import "UserNotifications/UserNotifications.h"


@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UITextField *taskTitle;
@property (weak, nonatomic) IBOutlet UITextView *taskDescribtion;
@property (weak, nonatomic) IBOutlet UISegmentedControl *taskPriority;
@property (weak, nonatomic) IBOutlet UISegmentedControl *taskState;
@property (weak, nonatomic) IBOutlet UIDatePicker *taskDate;
@property (weak, nonatomic) IBOutlet UIImageView *imagePriority;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;

@property NSData *decodedTasks;
@property   NSData *encodedTasks;
@property NSData *decodedInProgressTasks;
@property   NSData *encodedInProgressTasks;
@property NSData *decodedDoneTasks;
@property   NSData *encodedDoneTasks;

@property  NSMutableArray *todoTasksList;
@property  NSMutableArray *doneTasksList;
@property  NSMutableArray *inProgressTasksList;


@property NSUserDefaults *userDefault;
@property Task *myTask;


@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _userDefault = [NSUserDefaults standardUserDefaults];
    _todoTasksList   = [NSMutableArray new];
    _doneTasksList = [NSMutableArray new];
    _inProgressTasksList = [NSMutableArray new];
}

- (void)viewWillAppear:(BOOL)animated{
    
    _taskDescribtion.clipsToBounds = YES;
    _taskDescribtion.layer.cornerRadius = 12.0f;
    
    _myTask = [Task new];
    _taskDate.minimumDate =[NSDate date];
    
    _decodedTasks = [_userDefault objectForKey:@"toDoTasks"];
    _decodedInProgressTasks = [_userDefault objectForKey:@"inProgressTasks"];
    _decodedDoneTasks = [_userDefault objectForKey:@"doneTasks"];
    
     if(_decodedTasks != nil){
         _todoTasksList = [NSKeyedUnarchiver unarchiveObjectWithData:_decodedTasks];
     }
    if(_decodedInProgressTasks != nil){
         _inProgressTasksList = [NSKeyedUnarchiver unarchiveObjectWithData:_decodedInProgressTasks];
     }
    if(_decodedDoneTasks != nil){
         _doneTasksList = [NSKeyedUnarchiver unarchiveObjectWithData:_decodedDoneTasks];
     }
    
    if(_source == 1 && _process == 1){
        [self setStateWhenAdd];
        
        
    }else if(_process == 2){
        if(_source == 1){
                _myTask = [_todoTasksList objectAtIndex: self.taskIndex];
        }
        if(_source == 2){
            _myTask = [_inProgressTasksList objectAtIndex: self.taskIndex];
        }
        if(_source == 3){
            _myTask = [_doneTasksList objectAtIndex: self.taskIndex];
            [self disabledChange];
        }
        [self setDataToView];
        [self setState:_source-1];
        
        
    }
    
}

- (IBAction)done:(id)sender {
    [self getDataFromView];

    
    //from to do
    if(self.source == 1){
        if(self.process == 1){
            if([_taskTitle.text  isEqual: @""]){
            
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Invalid" message:@"You must add Task title" preferredStyle:UIAlertControllerStyleActionSheet];
                    
                    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
                    [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];

                }else{
                    [_todoTasksList addObject:_myTask];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            
            [self addNotification];
            
            
        }
        else if(self.process == 2){
           // [_todoTasksList removeObjectAtIndex:self.taskIndex];
            [_todoTasksList setObject:_myTask atIndexedSubscript:self.taskIndex];
            [self changeState:_myTask.state];
            [self.navigationController popViewControllerAnimated:YES];
        
        }
        _encodedTasks = [NSKeyedArchiver archivedDataWithRootObject:_todoTasksList];
        [_userDefault setObject:_encodedTasks forKey:@"toDoTasks"];
    }else if (_source == 2){
        if(self.process == 2){
            [_inProgressTasksList setObject:_myTask atIndexedSubscript:self.taskIndex];
            [self changeState:_myTask.state];
            [self.navigationController popViewControllerAnimated:YES];
        }
        _encodedInProgressTasks = [NSKeyedArchiver archivedDataWithRootObject:_inProgressTasksList];
        [_userDefault setObject:_encodedInProgressTasks forKey:@"inProgressTasks"];
    }
    [self addNotification];
    printf("in%lu \n done%lu\n", (unsigned long)_inProgressTasksList.count, (unsigned long)_doneTasksList.count);
}
-(void)setStateWhenAdd{
    
    [_taskState setEnabled:NO forSegmentAtIndex:1];
    [_taskState setEnabled:NO forSegmentAtIndex:2];
    [_taskState setSelectedSegmentIndex:0];
    _taskTitle.text = @"";
    _taskDescribtion.text= @"";
    [_taskPriority setSelectedSegmentIndex:0];
    [_imagePriority setImage:nil];
    

}

-(void)setState: (int) fromSource{
    [_taskState setSelectedSegmentIndex:fromSource];

    for(int i = 0 ; i<fromSource ; i++){
        [_taskState setEnabled:NO forSegmentAtIndex:i];
    }
    for(int i = fromSource; i<3; i++){
        [_taskState setEnabled:YES forSegmentAtIndex:i];
    }
}



-(void) getDataFromView{
    
   _myTask.title = _taskTitle.text;
   _myTask.describtion = _taskDescribtion.text;
   _myTask.priority = [_taskPriority titleForSegmentAtIndex:_taskPriority.selectedSegmentIndex];
   _myTask.state = [_taskState titleForSegmentAtIndex:_taskState.selectedSegmentIndex];
   _myTask.date = _taskDate.date;

}

-(void) setDataToView{
    
    _taskTitle.text =_myTask.title;
    _taskDescribtion.text = _myTask.describtion;
    for(int i =0 ;i<4 ; i++){
        if([_taskPriority titleForSegmentAtIndex:i] == _myTask.priority)
        {
            _taskPriority.selectedSegmentIndex = i;
        }
    }
    for(int i =0 ;i<3 ; i++){
        if([_taskState titleForSegmentAtIndex:i] == _myTask.state)
        {
            _taskState.selectedSegmentIndex = i;
        }
    }
    _taskDate.date = _myTask.date;
    _imagePriority.layer.cornerRadius = 10;

    if([_myTask.priority  isEqual:  @"High"]){
        _imagePriority.image = [UIImage imageNamed:@"red"];
    }
    else if ([_myTask.priority  isEqual:  @"Medium"]){
        _imagePriority.image = [UIImage imageNamed:@"blue"];
    }
    else if ([_myTask.priority  isEqual:  @"Low"]){
        _imagePriority.image = [UIImage imageNamed:@"yellow"];
    }
    else{
        _imagePriority.image = [UIImage imageNamed:@"gray"];
    }

}

-(void) changeState: (NSMutableString *) state{
    
    if(_source == 1 && ![state  isEqual: @"To Do"]){
        [_todoTasksList removeObjectAtIndex:_taskIndex];
        if([state isEqual:@"In Progress"]){
            
            [_inProgressTasksList addObject:_myTask];
            _encodedInProgressTasks = [NSKeyedArchiver archivedDataWithRootObject:_inProgressTasksList];
            [_userDefault setObject:_encodedInProgressTasks forKey:@"inProgressTasks"];
            
        }else if([state isEqual:@"Done"]){
            
            [_doneTasksList addObject:_myTask];
            _encodedDoneTasks = [NSKeyedArchiver archivedDataWithRootObject:_doneTasksList];
            [_userDefault setObject:_encodedDoneTasks forKey:@"doneTasks"];
        }
    }else if (_source == 2 && ![state  isEqual: @"In Progress"]){
            [_inProgressTasksList removeObjectAtIndex:_taskIndex];
            [_doneTasksList addObject:_myTask];
            _encodedDoneTasks = [NSKeyedArchiver archivedDataWithRootObject:_doneTasksList];
            [_userDefault setObject:_encodedDoneTasks forKey:@"doneTasks"];
        }
}

-(void) disabledChange{
    _doneBtn.hidden = YES;
    _taskDescribtion.editable = NO;
    _taskTitle.enabled = NO;
    
    for(int i =0 ;i<4 ; i++){
        if([_taskPriority titleForSegmentAtIndex:i] != _myTask.priority)
        {
            [_taskPriority setEnabled:NO forSegmentAtIndex:i];
        }
    }

}
-(void) addNotification{
    
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title= @"To-Do App";
    content.body = @"your task time is now.";
    content.sound = [UNNotificationSound defaultSound];
    
    
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSDateComponents *dateComponent = [calender components:(NSCalendarUnitYear | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:_taskDate.date];
    
    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger  triggerWithDateMatchingComponents:dateComponent repeats:NO];
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:_taskTitle.text content:content trigger:trigger];
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:nil];
    
}

@end
