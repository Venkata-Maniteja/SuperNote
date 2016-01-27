
//
//  NotesListController.m
//  SuperNote
//
//  Created by Venkata Maniteja on 2016-01-14.
//  Copyright © 2016 Venkata Maniteja. All rights reserved.
//

#import "NotesListController.h"
#import "SuperNoteManager.h"
#import "WriteNotesController.h"
#import <SWTableViewCell.h>
@interface NotesListController ()<UITableViewDelegate,UITableViewDataSource,SWTableViewCellDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic,weak) SuperNoteManager *myManager;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSMutableDictionary *dataDic;

@end

@implementation NotesListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _myManager=[SuperNoteManager sharedInstance];
    _dataArray=[[NSMutableArray alloc]init];
    
    //[_tableView setEditing:YES]; //shows red buttons to delete rows
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self getData];
    [_tableView reloadData];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

-(void)showTempraryAlert{

}

-(void)getData{
    
    _myManager.queryMode=15; //kGetAll
   _dataArray=[_myManager getDataFromDatabase];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma table view delegate methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray  count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   static NSString *unifiedID = @"CELLID";
    SWTableViewCell *cell = (SWTableViewCell *)[tableView dequeueReusableCellWithIdentifier:unifiedID];
    
    if (cell == nil) {
        cell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:unifiedID];
    }
    cell.leftUtilityButtons = [self leftButtons];
//    cell.rightUtilityButtons = [self rightButtons];
    cell.delegate = self;

    cell.textLabel.text  = [[_dataArray objectAtIndex:indexPath.row] objectForKey:@"Notes"];
    cell.detailTextLabel.text  = [[_dataArray objectAtIndex:indexPath.row] objectForKey:@"DateTime"];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self performSegueWithIdentifier:@"showDetailNotes" sender:self.tableView];
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    _myManager.queryMode=12; //kDelete
    [_myManager deleteRowFromDatabaseWithRowID:[[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"NotesID"] intValue]];
    [_dataArray removeObjectAtIndex:indexPath.row];
    [_tableView reloadData];
    
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
}

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                                title:@"More"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"Delete"];
    
    return rightUtilityButtons;
}

- (NSArray *)leftButtons
{
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     self.navigationController.navigationBar.barTintColor
                                                icon:[UIImage imageNamed:@"Plus.png"]];
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     self.navigationController.navigationBar.barTintColor
                                                icon:[UIImage imageNamed:@"Plus.png"]];
    
    return leftUtilityButtons;
}

// click event on left utility button
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index{
    
}

// click event on right utility button
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index{
    
}

// utility button open/close event
- (void)swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state{
    
}

// prevent multiple cells from showing utilty buttons simultaneously
- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell{
  
    return YES;
}

// prevent cell(s) from displaying left/right utility buttons
- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state{
    
    return YES;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"showDetailNotes"]) {
        
        NSIndexPath *indexPath=[_tableView indexPathForSelectedRow];
        WriteNotesController *wVc=segue.destinationViewController;
        wVc.notesStatus=@"UpdateNotes";
        wVc.notesID=[[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"NotesID"] intValue];
    }
    
}


@end
