//
//  DoneViewController.m
//  todo
//
//  Created by JETSMobileLabMini1 on 17/04/2024.
//

#import "DoneViewController.h"
#import "DetailsViewController.h"
#import "Task.h"

@interface DoneViewController ()
@property (weak, nonatomic) IBOutlet UITableView *doneTable;
@property (weak, nonatomic) IBOutlet UIImageView *emptyStateImage;
@property (weak, nonatomic) IBOutlet UILabel *emptyStateLabel;


@property DetailsViewController *detailTask;
@property  NSMutableArray *doneTasksList;
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

@implementation DoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _userDefault = [NSUserDefaults standardUserDefaults];
    _doneTasksList  = [NSMutableArray new];
    _encodedTasks = [NSMutableArray new];
    _detailTask  = [self.storyboard instantiateViewControllerWithIdentifier:@"task"];
    _doneTable.delegate = self;
    _doneTable.dataSource = self;
    _isfilered = NO;
    _secNumbers = 1;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [self setTabBarItemButton];
    
    
    NSData *decodedTasks = [_userDefault objectForKey:@"doneTasks"];
    _doneTasksList = [NSKeyedUnarchiver unarchiveObjectWithData:decodedTasks];
    
    
    _lowList = [NSMutableArray new];
    _medList = [NSMutableArray new];
    _highList = [NSMutableArray new];
    _noList = [NSMutableArray new];

    
    for(Task *loopedTask in _doneTasksList){
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
    [_doneTable reloadData];
    
    
    
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
        
        
        _tempTask = [_doneTasksList objectAtIndex:indexPath.row];
        
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
        return _doneTasksList.count;
        
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
    return _doneTasksList.count;
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
        for(int i =0 ; i< _doneTasksList.count ; i++){
            Task *loopedTask =[_doneTasksList objectAtIndex:i];
            if(loopedTask ==_tempTask){
                _detailTask.taskIndex = i;
            }
        }
        
    }else{
        _detailTask.taskIndex = indexPath.row;
    }
    _detailTask.source = 3;
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
    return @"Done";
}
-(void) filterTasks{
    if(_isfilered == NO){
        _isfilered = YES;
        _secNumbers = 4;
        [_lowList removeAllObjects];
        [_highList removeAllObjects];
        [_medList removeAllObjects];
        [_noList removeAllObjects];

        
        for(Task *loopedTask in _doneTasksList){
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
    [_doneTable reloadData];
    [self handleEmptyState];

    
}


- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIContextualAction *delete = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive
                                                                         title:@"DELETE"
                                                                       handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Delete Task" message:@"Are you sure you want delete it?" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            if(self->_isfilered == NO){
                [self->_doneTasksList removeObjectAtIndex: indexPath.row];
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
                for(int i =0 ; i< self->_doneTasksList.count ; i++){
                    Task *loopedTask =[self->_doneTasksList objectAtIndex:i];
                    if(loopedTask ==self->_tempTask){
                        
                        [self->_doneTasksList removeObjectAtIndex: i];
                    }
                }
                
            }
            self->_encodedTasks = [NSKeyedArchiver archivedDataWithRootObject: self->_doneTasksList];
            [self->_userDefault setObject:self->_encodedTasks forKey: @"doneTasks"];
            [self->_doneTable reloadData];
            [self handleEmptyState];

        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:ok];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];                                                                              }];
    
    delete.backgroundColor = [UIColor redColor];
    delete.image = [UIImage systemImageNamed:@"trash"];
    
    UISwipeActionsConfiguration *swipeActionConfig = [UISwipeActionsConfiguration configurationWithActions:@[delete]];
    swipeActionConfig.performsFirstActionWithFullSwipe = NO;
    return swipeActionConfig;
    
}


-(void) setTabBarItemButton{
    UIViewController  *view = self.navigationController.visibleViewController;
    view.navigationItem.rightBarButtonItem.hidden = YES;
    view.navigationItem.title = @"Done";
    view.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(filterTasks)];
    view.navigationItem.rightBarButtonItem.tintColor = [UIColor colorNamed: @"green-light"];
    
    
}

-(void) handleEmptyState{
    
    if (self.doneTasksList.count == 0) {
        self.doneTable.hidden = YES;
        self.emptyStateImage.hidden = NO;
        self.emptyStateLabel.hidden = NO;
    } else {
            self.doneTable.hidden = NO;
            self.emptyStateImage.hidden = YES;
        self.emptyStateLabel.hidden = YES;
        }
        }

@end
