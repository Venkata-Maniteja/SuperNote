//
//  CustomButton.m
//  SuperNote
//
//  Created by Venkata Maniteja on 2016-01-21.
//  Copyright © 2016 Venkata Maniteja. All rights reserved.
//

#import "CustomButton.h"

@implementation CustomButton

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if(self = [super initWithCoder:aDecoder]) {
        
        _floatVal=1;
    }
    
    return self;
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    [self drawButton:_floatVal];
}


- (void)drawButton: (CGFloat)rotate
{
    //// General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    UIColor* color = self.backColor;
    UIColor* titleColor=self.butTitleColor;
    
    //// Oval Drawing
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, 50, 50);
    CGContextRotateCTM(context, -rotate * M_PI / 180);
    
    UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(-50, -50, 100, 100)];
    [color setFill];
    [ovalPath fill];
    [[UIColor colorWithRed:102/255.0 green:169/255.0 blue:251/255.0 alpha:1] setStroke];
    ovalPath.lineWidth = 53;
    CGFloat ovalPattern[] = {102, 2};
    [ovalPath setLineDash: ovalPattern count: 2 phase: 0];
    [ovalPath stroke];
    
    CGContextRestoreGState(context);
    
    
    //// Text Drawing
    CGRect textRect = CGRectMake(0, 39, _textSize.width , _textSize.height);
    {
        NSString* textContent = _butTitle;
        NSMutableParagraphStyle* textStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
        textStyle.alignment = NSTextAlignmentCenter;
        
        NSDictionary* textFontAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize: UIFont.labelFontSize], NSForegroundColorAttributeName: self.butTitleColor, NSParagraphStyleAttributeName: textStyle};
        
        CGFloat textTextHeight = [textContent boundingRectWithSize: CGSizeMake(textRect.size.width, INFINITY)  options: NSStringDrawingUsesLineFragmentOrigin attributes: textFontAttributes context: nil].size.height;
        CGContextSaveGState(context);
        CGContextClipToRect(context, textRect);
        [textContent drawInRect: CGRectMake(CGRectGetMinX(textRect), CGRectGetMinY(textRect) + (CGRectGetHeight(textRect) - textTextHeight) / 2, CGRectGetWidth(textRect), textTextHeight) withAttributes: textFontAttributes];
        CGContextRestoreGState(context);
    }
}




@end
