//
//  InProgressViewController.m
//  todo
//
//  Created by JETSMobileLabMini1 on 17/04/2024.
//

#import "InProgressViewController.h"
#import "DetailsViewController.h"
#import "Task.h"

@interface InProgressViewController ()
@property (weak, nonatomic) IBOutlet UITableView *inProgressTable;
@property (weak, nonatomic) IBOutlet UIImageView *emptyStateImage;

@property (weak, nonatomic) IBOutlet UILabel *emptyStateLabel;

@property DetailsViewController *detailTask;
@property  NSMutableArray *inProgressTasksList;
@property NSUserDefaults *userDefault;
@property NSDate *encodedTasks;
@property Task *tempTask;
@property NSMutableArray<Task*> *lowList;
@property NSMutableArray<Task*> *medList;
@property NSMutableArray<Task*> *highList;
@property NSMutableArray<Task*> *noList;
@property BOOL isfilered;
@property NSInteger secNumbers;




@end

@implementation InProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self handleEmptyState];
    _userDefault = [NSUserDefaults standardUserDefaults];
    _inProgressTasksList   = [NSMutableArray new];
    _encodedTasks = [NSMutableArray new];
    _detailTask  = [self.storyboard instantiateViewControllerWithIdentifier:@"task"];
    _inProgressTable.delegate = self;
    _inProgressTable.dataSource = self;
    _isfilered = NO;
    _secNumbers = 1;
    
    }
- (void)viewWillAppear:(BOOL)animated{
    
     [self setTabBarItemButton];
    
     NSData *decodedTasks = [_userDefault objectForKey:@"inProgressTasks"];
    _inProgressTasksList = [NSKeyedUnarchiver unarchiveObjectWithData:decodedTasks];
    
    _lowList = [NSMutableArray new];
    _medList = [NSMutableArray new];
    _highList = [NSMutableArray new];
    _noList = [NSMutableArray new];

    
    for(Task *loopedTask in _inProgressTasksList){
        if([loopedTask.priority isEqual: @"Low"]){
            [_lowList addObject:loopedTask];
        }else if([loopedTask.priority  isEqual: @"High"]){
            [_highList addObject:loopedTask];
        }else if([loopedTask.priority  isEqual: @"Medium"]){
            [_medList addObject:loopedTask];
        }else{
            [_noList addObject:loopedTask];
        }
        
    }

    [self handleEmptyState];
    [_inProgressTable reloadData];

}



- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath { 
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
 
    UILabel *title = (UILabel *)[cell viewWithTag:1];
    UIImageView *myImage = (UIImageView *)[cell viewWithTag:2];
    UIImageView *desImage = (UIImageView *)[cell viewWithTag:3];

    myImage.layer.cornerRadius = 10;
    
    if(_secNumbers == 1){
        
       
        _tempTask = [_inProgressTasksList objectAtIndex:indexPath.row];
        
        title.text =_tempTask.title;
    
        if([_tempTask.priority  isEqual:  @"High"]){
            myImage.image = [UIImage imageNamed:@"red"];
        }
        else if ([_tempTask.priority  isEqual:  @"Medium"]){
            myImage.image = [UIImage imageNamed:@"blue"];
        
       }else if ([_tempTask.priority  isEqual:  @"Low"]){
        myImage.image = [UIImage imageNamed:@"yellow"];
       }
    else{
        myImage.image = [UIImage imageNamed:@"gray"];
    }
        
      }else if(_secNumbers == 4){
        switch(indexPath.section){
            case 3:
                title.text = [_noList objectAtIndex:indexPath.row].title;
                myImage.image  = [UIImage imageNamed:@"gray"];
                _tempTask = [_noList objectAtIndex:indexPath.row];

                break;
            case 2:
                title.text = [_lowList objectAtIndex:indexPath.row].title;
                myImage.image  = [UIImage imageNamed:@"yellow"];
                _tempTask = [_lowList objectAtIndex:indexPath.row];

                break;
            case 1:
                title.text = [_medList objectAtIndex:indexPath.row].title;
                myImage.image = [UIImage imageNamed:@"blue"];
                _tempTask = [_medList objectAtIndex:indexPath.row];


                break;
            case 0:
                title.text = [_highList objectAtIndex:indexPath.row].title;
                myImage.image  = [UIImage imageNamed:@"red"];
                _tempTask = [_highList objectAtIndex:indexPath.row];

                break;
        }
         

    }
    
    if([_tempTask.describtion  isEqual: @""]){
        desImage.image= nil;

    }else{
        desImage.image = [UIImage systemImageNamed:@"line.3.horizontal.decrease.circle"];
    }
    return  cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section { 
    
    if(_secNumbers == 1){
        return _inProgressTasksList.count;

    }else{
        switch (section) {
            case 3:
                return _noList.count;
                break;
            case 2:
                return _lowList.count;
                break;
            case 1:
                return _medList.count;
                break;
            case 0:
                return _highList.count;
                break;

        }

    }
    return _inProgressTasksList.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _secNumbers;

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(_isfilered == YES){
        
        switch (indexPath.section) {
            case 3:
                _tempTask = [_noList objectAtIndex:indexPath.row];
                break;
            case 2:
                _tempTask = [_lowList objectAtIndex:indexPath.row];
                break;
                
            case 1:
                _tempTask = [_medList objectAtIndex:indexPath.row];
                break;
               
            case 0:
                _tempTask = [_highList objectAtIndex:indexPath.row];
                
                break;
    
  
        }
    for(int i =0 ; i< _inProgressTasksList.count ; i++){
        Task *loopedTask =[_inProgressTasksList objectAtIndex:i];
        if(loopedTask ==_tempTask){
            _detailTask.taskIndex = i;
        }
    }
        
    }else{
        _detailTask.taskIndex = indexPath.row;
    }
    _detailTask.source = 2;
    _detailTask.process = 2;
   
    printf("%d", _secNumbers);

    [self.navigationController pushViewController: _detailTask animated:YES];
    [self handleEmptyState];

}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(_secNumbers == 4){
        switch (section) {
            case 3:
                return @"No";
                break;
            case 2:
                return @"Low";
                break;
            case 1:
                return @"Medium";
                break;
            case 0:
                return @"High";
                break;

        }
    }
    return @"In Progress";
}

-(void) filterTasks{
    if(_isfilered == NO){
        _isfilered = YES;
        _secNumbers = 4;
        [_lowList removeAllObjects];
        [_highList removeAllObjects];
        [_medList removeAllObjects];
        [_noList removeAllObjects];
        
        for(Task *loopedTask in _inProgressTasksList){
            if([loopedTask.priority isEqual: @"Low"]){
                [_lowList addObject:loopedTask];
            }else if([loopedTask.priority  isEqual: @"High"]){
                [_highList addObject:loopedTask];
            }else if([loopedTask.priority  isEqual: @"Medium"]){
                [_medList addObject:loopedTask];
            }else{
                [_noList addObject:loopedTask];
            }
            
        }
    }else{
        _isfilered = NO;
        _secNumbers = 1;
   
    }
    [_inProgressTable reloadData];
    [self handleEmptyState];


}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        UIContextualAction *delete = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive
                                                                                title:@"DELETE"
                                                                              handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Delete Task" message:@"Are you sure you want delete it?" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            if(self->_isfilered == NO){
                [self->_inProgressTasksList removeObjectAtIndex: indexPath.row];
                
            }else{
                switch (indexPath.section) {
                    case 3:
                        self->_tempTask = [self->_noList objectAtIndex:indexPath.row];
                        [self->_noList removeObjectAtIndex:indexPath.row];

                        break;
                    case 2:
                        self->_tempTask = [self->_lowList objectAtIndex:indexPath.row];
                        [self->_lowList removeObjectAtIndex:indexPath.row];

                        break;
                        
                    case 1:
                        self->_tempTask = [self->_medList objectAtIndex:indexPath.row];
                        [self->_medList  removeObjectAtIndex:indexPath.row];

                        break;
                       
                    case 0:
                        self->_tempTask = [self->_highList objectAtIndex:indexPath.row];
                        [self->_highList removeObjectAtIndex:indexPath.row];
                        break;
            
          
                }
                for(int i =0 ; i< self->_inProgressTasksList.count ; i++){
                    Task *loopedTask =[self->_inProgressTasksList objectAtIndex:i];
                    if(loopedTask ==self->_tempTask){
                    
                    [self->_inProgressTasksList removeObjectAtIndex: i];
                }
            }
                
            }
            
            self->_encodedTasks = [NSKeyedArchiver archivedDataWithRootObject: self->_inProgressTasksList];
            [self->_userDefault setObject:self->_encodedTasks forKey: @"inProgressTasks"];
            [self->_inProgressTable reloadData];
            [self handleEmptyState];

        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:ok];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];                                                                              }];
           
           delete.backgroundColor = [UIColor redColor];
           delete.image = [UIImage systemImageNamed:@"trash"];
           delete.title = @"delete";
          
           UISwipeActionsConfiguration *swipeActionConfig = [UISwipeActionsConfiguration configurationWithActions:@[delete]];
           swipeActionConfig.performsFirstActionWithFullSwipe = NO;
           return swipeActionConfig;
    
}

-(void) setTabBarItemButton{
    UIViewController  *view = self.navigationController.visibleViewController;
    view.navigationItem.rightBarButtonItem.hidden = YES;
    view.navigationItem.title = @"InProgress";
  view.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(filterTasks)];
    view.navigationItem.rightBarButtonItem.tintColor = [UIColor colorNamed: @"green-light"];

}
-(void) handleEmptyState{
    
    if (self.inProgressTasksList.count == 0) {
        self.inProgressTable.hidden = YES;
        self.emptyStateImage.hidden = NO;
        self.emptyStateLabel.hidden = NO;
    } else {
            self.inProgressTable.hidden = NO;
            self.emptyStateImage.hidden = YES;
        self.emptyStateLabel.hidden = YES;
        }
        }


@end
