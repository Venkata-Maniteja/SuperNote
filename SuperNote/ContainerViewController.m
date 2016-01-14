//
//  ContainerViewController.m
//  SuperNote
//
//  Created by Venkata Maniteja on 2016-01-14.
//  Copyright © 2016 Venkata Maniteja. All rights reserved.
//

#import "ContainerViewController.h"
#import "NotesListController.h"
#import "EmptyNotesController.h"
#import "WriteNotesController.h"

#define SegueIdentifierFirst @"embedNotesList"
#define SegueIdentifierEmptyNotes @"embedEmptyNotes"
#define SegueIdentifierWrite @"embedWriteNotes"


@interface ContainerViewController ()

@property (strong, nonatomic) NotesListController *notesListVC;
@property (strong, nonatomic) EmptyNotesController *emptyNotesVC;
@property (strong, nonatomic) WriteNotesController *writeNotesVC;

@property (assign, nonatomic) BOOL transitionInProgress;


@end

@implementation ContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.transitionInProgress = NO;

//    self.currentSegueIdentifier = SegueIdentifierEmptyNotes;
    [self performSegueWithIdentifier:self.currentSegueIdentifier sender:nil];

    
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // Instead of creating new VCs on each seque we want to hang on to existing
    // instances if we have it. Remove the second condition of the following
    // two if statements to get new VC instances instead.
    if ([segue.identifier isEqualToString:SegueIdentifierFirst]) {
        self.notesListVC = segue.destinationViewController;
    }
    
    if ([segue.identifier isEqualToString:SegueIdentifierEmptyNotes]) {
        self.emptyNotesVC = segue.destinationViewController;
    }
    
    if ([segue.identifier isEqualToString:SegueIdentifierWrite]) {
        self.writeNotesVC = segue.destinationViewController;
    }
    
    // If we're going to the first view controller.
    if ([segue.identifier isEqualToString:SegueIdentifierFirst]) {
        // If this is not the first time we're loading this.
            if (self.childViewControllers.count > 0) {
                [self swapFromViewController:[self.childViewControllers objectAtIndex:0] toViewController:self.notesListVC];
            }
            else {
                // If this is the very first time we're loading this we need to do
                // an initial load and not a swap.
                [self addChildViewController:segue.destinationViewController];
                UIView* destView = ((UIViewController *)segue.destinationViewController).view;
                destView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
                destView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                [self.view addSubview:destView];
                [segue.destinationViewController didMoveToParentViewController:self];
            }
    }
   
    else if ([segue.identifier isEqualToString:SegueIdentifierEmptyNotes]) {
        
            if (self.childViewControllers.count>0) {
                
                [self swapFromViewController:[self.childViewControllers objectAtIndex:0] toViewController:self.emptyNotesVC];
            }else{
                
                // If this is the very first time we're loading this we need to do
                // an initial load and not a swap.
                [self addChildViewController:segue.destinationViewController];
                UIView* destView = ((UIViewController *)segue.destinationViewController).view;
                destView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
                destView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                [self.view addSubview:destView];
                [segue.destinationViewController didMoveToParentViewController:self];
                
            }
        
    }
    
    else if ([segue.identifier isEqualToString:SegueIdentifierWrite]) {
        
        if (self.childViewControllers.count>0) {
            
            [self swapFromViewController:[self.childViewControllers objectAtIndex:0] toViewController:self.writeNotesVC];
        }else{
            
            // If this is the very first time we're loading this we need to do
            // an initial load and not a swap.
            [self addChildViewController:segue.destinationViewController];
            UIView* destView = ((UIViewController *)segue.destinationViewController).view;
            destView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            destView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            [self.view addSubview:destView];
            [segue.destinationViewController didMoveToParentViewController:self];
            
        }
        
    }
}

- (void)swapFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    toViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [fromViewController willMoveToParentViewController:nil];
    [self addChildViewController:toViewController];
    
    [self transitionFromViewController:fromViewController toViewController:toViewController duration:1.0 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished) {
        [fromViewController removeFromParentViewController];
        [toViewController didMoveToParentViewController:self];
        self.transitionInProgress = NO;
    }];
}

- (void)swapViewControllers
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if (self.transitionInProgress) {
        return;
    }
    
    self.transitionInProgress = YES;
    self.currentSegueIdentifier = ([self.currentSegueIdentifier isEqualToString:SegueIdentifierFirst]) ? SegueIdentifierEmptyNotes : SegueIdentifierFirst;
    
    if (([self.currentSegueIdentifier isEqualToString:SegueIdentifierFirst]) && self.notesListVC) {
        [self swapFromViewController:self.emptyNotesVC toViewController:self.notesListVC];
        return;
    }
    
    if (([self.currentSegueIdentifier isEqualToString:SegueIdentifierEmptyNotes]) && self.emptyNotesVC) {
        [self swapFromViewController:self.notesListVC toViewController:self.emptyNotesVC];
        return;
    }
    
    
    [self performSegueWithIdentifier:self.currentSegueIdentifier sender:nil];
}




@end
