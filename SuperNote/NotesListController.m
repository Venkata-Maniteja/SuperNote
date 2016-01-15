
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
@interface NotesListController ()<UITableViewDelegate,UITableViewDataSource>

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


-(void)getData{
    
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:unifiedID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:unifiedID];
        
    }
    
    
    cell.textLabel.text  = [[_dataArray objectAtIndex:indexPath.row] objectForKey:@"Notes"];
    cell.detailTextLabel.text  = [[_dataArray objectAtIndex:indexPath.row] objectForKey:@"DateTime"];
    
    return cell;
    
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [_myManager deleteRowFromDatabaseWithRowID:[[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"NotesID"] intValue]];
    [_dataArray removeObjectAtIndex:indexPath.row];
    [_tableView reloadData];
    
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
