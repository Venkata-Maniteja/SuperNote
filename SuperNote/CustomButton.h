//
//  CustomButton.h
//  SuperNote
//
//  Created by Venkata Maniteja on 2016-01-21.
//  Copyright © 2016 Venkata Maniteja. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomButton : UIView

@property (nonatomic, assign) CGFloat floatVal;
@property (nonatomic, weak) NSString *butTitle;
@property (nonatomic, strong) UIColor *backColor;
@property (nonatomic, strong) UIColor *butTitleColor;
@property (nonatomic, assign) CGSize textSize;

@end
