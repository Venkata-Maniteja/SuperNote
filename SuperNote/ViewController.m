//
//  ViewController.m
//  SuperNote
//
//  Created by Venkata Maniteja on 2016-01-11.
//  Copyright © 2016 Venkata Maniteja. All rights reserved.
//
//
//typedef enum {
//    kInsert=10,
//    kGet=11,
//    kDelete=12,
//    kUpdate=13,
//    kCount=14,
//    kGetAll=15
//}QueryMode;

#import "ViewController.h"
#import "ContainerViewController.h"
#import "SuperNoteManager.h"
#import "WriteNotesController.h"
#import "HomeViewController.h"
@interface ViewController ()


@property (nonatomic, weak)     IBOutlet UIBarButtonItem                       *   addNotes;
@property (nonatomic, weak)     IBOutlet UIBarButtonItem                       *   settings;
@property (nonatomic, weak)     IBOutlet UINavigationItem                      *   barTitle;
@property (nonatomic, weak)              ContainerViewController               *   containerViewController;
@property (nonatomic, strong)            SuperNoteManager                      *   myManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _myManager=[SuperNoteManager sharedInstance];
    [self customiseNavBar];
    
   
}

-(void)customiseNavBar{
 
    if ([_tableName isEqualToString:@"WorkTable"]) {
        self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:220/255.0 alpha:1];
        self.barTitle.title=@"Work Notes";
        _myManager.currentTableName=@"WorkTable";
        
    }else if ([_tableName isEqualToString:@"PersoTable"]) {
        self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:54/255.0 green:11/255.0 blue:88/255.0 alpha:1];
        self.barTitle.title=@"Personal Notes";
        _myManager.currentTableName=@"PersoTable";
        
    }else if ([_tableName isEqualToString:@"TempTable"]) {
        self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:242/255.0 green:71/255.0 blue:63/255.0 alpha:1];
        self.barTitle.title=@"Temporary Notes";
        _myManager.currentTableName=@"TempTable";

    }else if ([_tableName isEqualToString:@"QuickTable"]) {
        self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed: 0.296 green: 0.463 blue: 0.767 alpha: 1];
        self.barTitle.title=@"Quick Notes";
        _myManager.currentTableName=@"QuickTable";

    }else if ([_tableName isEqualToString:@"PassTable"]) {
        self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:134/255.0 green:198/255.0 blue:124/255.0 alpha:1];
        self.barTitle.title=@"Password Notes";
        _myManager.currentTableName=@"PassTable";

    }
    
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    //check data
    //load first view controller in our case it is Empty View
    
    //TODO: check data from database and load the VC based on it
    //TODO: need to pass some parameters like background color, image based on the button selected previoiusly
    
    //TODO: here it is nill
    
//    if (_tableName==(id)[NSNull null]||_tableName.length==0) {
//        _tableName=@"QuickTable";
//    }
    
//    _myManager.currentTableName=_tableName;
//    _myManager.queryMode=14;  //kCount
    if ([_myManager checkForDataInAllTables]) {
        
        
        _containerViewController.currentSegueIdentifier=@"embedEmptyNotes";
        _containerViewController.viewColor=self.navigationController.navigationBar.barTintColor;
    }else{
        
        //Not the embedded notes list, display the home view
        //TODO:
//        [self changeRootView];
        
        //embed the home vc 
        
        _containerViewController.currentSegueIdentifier=@"embedNotesList"; //embedNotesView
        
    }
   
    
}

-(void)changeRootView{
    
    
   
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)presentAddNotes:(id)sender{
    
    [self performSegueWithIdentifier:@"pushAddNotes" sender:sender];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if ([segue.identifier isEqualToString:@"embedContainer"]) {
        self.containerViewController = segue.destinationViewController;
    }
    
    if ([segue.identifier isEqualToString:@"pushAddNotes"]) {
        
        WriteNotesController *wVC=segue.destinationViewController;
        wVC.notesStatus=@"NewNotes";
        
    }
    
    if ([segue.identifier isEqualToString:@"embedHomeView"]) {
        
        
        HomeViewController *hVC=segue.destinationViewController;//[self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
        
        UINavigationController *mNavVC=[self.storyboard instantiateViewControllerWithIdentifier:@"MainNavigationController"];
        
        mNavVC.viewControllers=@[hVC];
        
       

        
    }
    
}

- (IBAction)presetnSettins:(id)sender
{
    
}


@end
