//
//  TestNavigationViewController.m
//  SuperNote
//
//  Created by Venkata Maniteja on 2016-01-26.
//  Copyright © 2016 Venkata Maniteja. All rights reserved.
//

#import "TestNavigationViewController.h"

@interface TestNavigationViewController ()

@end

@implementation TestNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *editBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(editAction)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:@selector(editAction)];
    space.width=-20;
    UIBarButtonItem *saveBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(saveAction)];
    saveBarButtonItem.width=9;
    
    self.navigationItem.leftBarButtonItems = [[NSArray alloc] initWithObjects:editBarButtonItem,space, saveBarButtonItem, nil];


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
