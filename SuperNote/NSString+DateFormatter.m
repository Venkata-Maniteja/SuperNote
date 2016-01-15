//
//  NSString+DateFormatter.m
//  SuperNote
//
//  Created by Venkata Maniteja on 2016-01-15.
//  Copyright © 2016 Venkata Maniteja. All rights reserved.
//

#import "NSString+DateFormatter.h"

@implementation NSString(DateFormatter)


+(NSString *)formatDateString:(NSDate *)date{
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd EE yy"];
    
    NSMutableString *mu = [NSMutableString stringWithString:[dateFormat stringFromDate:date]];
    [mu insertString:[NSString daySuffixForDate:date] atIndex:2];
   
    return mu;

}

+ (NSString *)daySuffixForDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger dayOfMonth = [calendar component:NSCalendarUnitDay fromDate:date];
    switch (dayOfMonth) {
        case 1:
        case 21:
        case 31: return @"st";
        case 2:
        case 22: return @"nd";
        case 3:
        case 23: return @"rd";
        default: return @"th";
    }
}

@end
