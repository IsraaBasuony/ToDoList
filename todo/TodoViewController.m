//
//  ViewController.m
//  todo
//
//  Created by JETSMobileLabMini1 on 17/04/2024.
//

#import "TodoViewController.h"
#import "DetailsViewController.h"
#import "Task.h"

@interface TodoViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *emptyStateImage;
@property (weak, nonatomic) IBOutlet UITableView *todoTable;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UILabel *emptySateLabel;
@property (weak, nonatomic) IBOutlet UILabel *emptyMsg;
@property DetailsViewController *detailTask;
@property  NSMutableArray  <Task*> *toDoTasksList;
@property NSUserDefaults *userDefault;
@property NSDate *encodedTasks;
@property Task *tempTask;
@property NSMutableArray <Task*> *filteredTasks;
@property BOOL isFiltered;
@end

@implementation TodoViewController

- (void)viewDidLoad {
    [self handleEmptyState];
    _userDefault = [NSUserDefaults standardUserDefaults];
    _toDoTasksList   = [NSMutableArray new];
    _encodedTasks = [NSMutableArray new];
    _detailTask  = [self.storyboard instantiateViewControllerWithIdentifier:@"task"];
    _todoTable.delegate = self;
    _todoTable.dataSource = self;
    _isFiltered = false;
    self.searchBar.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated{
    
    
    UIViewController  *view = self.navigationController.visibleViewController;
    view.navigationItem.title = @"To Do";

    view.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewTask)];
    view.navigationItem.rightBarButtonItem.tintColor = [UIColor colorNamed: @"green-light"];
    

    NSData *decodedTasks = [_userDefault objectForKey:@"toDoTasks"];
    _toDoTasksList = [NSKeyedUnarchiver unarchiveObjectWithData:decodedTasks];
    [self handleEmptyState];

    [_todoTable reloadData];
}

-(void) addNewTask{
    
    //refactor
    _detailTask.source = 1;
    _detailTask.process = 1;
    [self.navigationController pushViewController: _detailTask animated:YES];
    [self handleEmptyState];

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
    
    if(_isFiltered){
        _tempTask = [_filteredTasks objectAtIndex:indexPath.row];
    }else{
        _tempTask = [_toDoTasksList objectAtIndex:indexPath.row];
    }
    
   title.text =_tempTask.title;
    if([_tempTask.describtion  isEqual: @""]){
        desImage.image= nil;

    }else{
        desImage.image = [UIImage systemImageNamed:@"line.3.horizontal.decrease.circle"];
    }
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
    return  cell;

}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section { 
    if(_isFiltered){
        return  _filteredTasks.count;
    }
    return _toDoTasksList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
     
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if(_isFiltered == YES){
        Task *filteredTask = [_filteredTasks objectAtIndex:indexPath.row];
        for(int i =0 ; i< _toDoTasksList.count ; i++){
            Task *loopedTask =[_toDoTasksList objectAtIndex:i];
            if(loopedTask == filteredTask)
                _detailTask.taskIndex = i;
        }
    }else{
        _detailTask.taskIndex = indexPath.row;
    }
    _detailTask.source = 1;
    _detailTask.process = 2;
    [self.navigationController pushViewController: _detailTask animated:YES];
    
  
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"To Do";
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIContextualAction *delete = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive
                                                                                title:@"DELETE"
                                                                              handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Delete Task" message:@"Are you sure you want delete it?" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            if(self->_isFiltered == YES){
                Task *filteredTask = [self->_filteredTasks objectAtIndex:indexPath.row];
                for(int i =0 ; i< self->_toDoTasksList.count ; i++){
                    Task *loopedTask =[self->_toDoTasksList objectAtIndex:i];
                    if(loopedTask == filteredTask){
                        
                            [self->_filteredTasks removeObjectAtIndex:indexPath.row];
                            [self->_toDoTasksList removeObjectAtIndex:i];
                    }
                }
            }else{
                [self->_toDoTasksList removeObjectAtIndex:indexPath.row];
            }
            self->_encodedTasks = [NSKeyedArchiver archivedDataWithRootObject:self->_toDoTasksList];
            [self->_userDefault setObject:self->_encodedTasks forKey:@"toDoTasks"];
            [self handleEmptyState];
            [self->_todoTable reloadData];
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
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if(searchText.length == 0){
        _isFiltered = false;
    }else{
        _isFiltered = true;
        _filteredTasks = [[NSMutableArray alloc] init];
        for(Task *loopedTask in _toDoTasksList){
            NSRange nameRange = [loopedTask.title rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if(nameRange.location != NSNotFound){
                [_filteredTasks addObject:loopedTask];
            }
        }
    }
    [self.todoTable reloadData];
}

-(void) handleEmptyState{
    
    if (self.toDoTasksList.count == 0) {
        self.todoTable.hidden = YES;
        self.emptyStateImage.hidden = NO;
        self.emptySateLabel.text = @"Tap + to write them here.";
        self.emptyMsg.text = @"Have no idea where to organize the tasks.";
        self.emptySateLabel.hidden = NO;
        self.emptyMsg.hidden = NO;
    } else {
            self.todoTable.hidden = NO;
            self.emptyStateImage.hidden = YES;
        self.emptySateLabel.hidden = YES;
        self.emptyMsg.hidden = YES;
        }
        }

@end
