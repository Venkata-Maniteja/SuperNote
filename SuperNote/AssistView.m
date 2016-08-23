//
//  AssistView.m
//  SuperNote
//
//  Created by Nandamuri, Venkata on 2016-08-23.
//  Copyright © 2016 Venkata Maniteja. All rights reserved.
//

#import "AssistView.h"

@implementation AssistView


// Only override drawRect: if you perform custom drawing.
 //An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
     //Drawing code
    //// General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    UIColor* color = [UIColor colorWithRed: 0.166 green: 0.507 blue: 0.714 alpha: 1];
    
    //// Shadow Declarations
    NSShadow* shadow = [[NSShadow alloc] init];
    [shadow setShadowColor: UIColor.whiteColor];
    [shadow setShadowOffset: CGSizeMake(0.1, -0.1)];
    [shadow setShadowBlurRadius: 14];
    
    //// Oval Drawing
    UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(CGRectGetMinX(rect) + floor(CGRectGetWidth(rect) * 0.00000 + 0.5), CGRectGetMinY(rect) + floor(CGRectGetHeight(rect) * 0.00000 + 0.5), floor(CGRectGetWidth(rect) * 1.00000 + 0.5) - floor(CGRectGetWidth(rect) * 0.00000 + 0.5), floor(CGRectGetHeight(rect) * 1.00000 + 0.5) - floor(CGRectGetHeight(rect) * 0.00000 + 0.5))];
    [color setFill];
    [ovalPath fill];
    
    ////// Oval Inner Shadow
    CGContextSaveGState(context);
    UIRectClip(ovalPath.bounds);
    CGContextSetShadowWithColor(context, CGSizeZero, 0, NULL);
    
    CGContextSetAlpha(context, CGColorGetAlpha([shadow.shadowColor CGColor]));
    CGContextBeginTransparencyLayer(context, NULL);
    {
        UIColor* opaqueShadow = [shadow.shadowColor colorWithAlphaComponent: 1];
        CGContextSetShadowWithColor(context, shadow.shadowOffset, shadow.shadowBlurRadius, [opaqueShadow CGColor]);
        CGContextSetBlendMode(context, kCGBlendModeSourceOut);
        CGContextBeginTransparencyLayer(context, NULL);
        
        [opaqueShadow setFill];
        [ovalPath fill];
        
        CGContextEndTransparencyLayer(context);
    }
    CGContextEndTransparencyLayer(context);
    CGContextRestoreGState(context);
}


@end
