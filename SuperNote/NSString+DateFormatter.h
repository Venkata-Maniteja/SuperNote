//
//  NSString+DateFormatter.h
//  SuperNote
//
//  Created by Venkata Maniteja on 2016-01-15.
//  Copyright © 2016 Venkata Maniteja. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface  NSString(DateFormatter)
+(NSString *)formatDateString:(NSDate *)date;
+ (NSString *)daySuffixForDate:(NSDate *)date;
@end
