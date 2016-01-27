//
//  EmptyNotesController.m
//  SuperNote
//
//  Created by Venkata Maniteja on 2016-01-14.
//  Copyright © 2016 Venkata Maniteja. All rights reserved.
//

#import "EmptyNotesController.h"
#import "HomeViewController.h"
#import "AppDelegate.h"
#import "SuperNoteManager.h"

@interface EmptyNotesController ()
@property (nonatomic, strong) SuperNoteManager *myManager;

@end

@implementation EmptyNotesController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    _myManager=[SuperNoteManager sharedInstance];
}





-(void)changeRootView{
    
   
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    HomeViewController *hVC=[storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
    
    UINavigationController *mNavVC=[storyboard instantiateViewControllerWithIdentifier:@"MainNavigationController"];
    
    mNavVC.viewControllers=@[hVC];
    
    [[UIApplication sharedApplication].keyWindow setRootViewController:mNavVC];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    
//    if ( [_myManager checkForDataInAllTables]) {
//        NSLog(@"All tables are empty");
//        
//        
//    }else{
//        
//        //a note is saved, show home view controller
//        //show the list view if it is empty notes
//        //dont change the root view when particular table is not empty
//        if (![_myManager isDatabaseEmpty]) {
//            [self changeRootView];
//        }
//        
//    }
    
    

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
