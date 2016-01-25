//
//  ViewController.m
//  SuperNote
//
//  Created by Venkata Maniteja on 2016-01-11.
//  Copyright © 2016 Venkata Maniteja. All rights reserved.
//

#import "ViewController.h"
#import "ContainerViewController.h"
#import "SuperNoteManager.h"
#import "WriteNotesController.h"
@interface ViewController ()


@property (nonatomic, weak)     IBOutlet UIBarButtonItem                       *   addNotes;
@property (nonatomic, weak)     IBOutlet UIBarButtonItem                       *   settings;
@property (nonatomic, weak)              ContainerViewController               *   containerViewController;
@property (nonatomic, strong)            SuperNoteManager                      *   myManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _myManager=[SuperNoteManager sharedInstance];
    
   
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    //check data
    //load first view controller in our case it is Empty View
    
    //TODO: check data from database and load the VC based on it
    
    _myManager.currentTableName=@"TestTable";
    _myManager.queryMode=14;
    if ([_myManager isDatabaseEmpty]) {
        
        
        _containerViewController.currentSegueIdentifier=@"embedEmptyNotes";
        
    }else{
        
        _containerViewController.currentSegueIdentifier=@"embedNotesList";
    }
    //[self.containerViewController swapViewControllers];

    
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
    
}

- (IBAction)presetnSettins:(id)sender
{
    
}


@end
