//
//  ContainerViewController.h
//  SuperNote
//
//  Created by Venkata Maniteja on 2016-01-14.
//  Copyright © 2016 Venkata Maniteja. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContainerViewController : UIViewController

@property (strong, nonatomic) NSString *currentSegueIdentifier;
@property (nonatomic, strong) UIColor *viewColor;
- (void)swapViewControllers;

@end
