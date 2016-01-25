//
//  QueryMode.h
//  SuperNote
//
//  Created by Venkata Maniteja on 2016-01-25.
//  Copyright © 2016 Venkata Maniteja. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QueryMode : NSObject

typedef enum {
    kInsert=10,
    kGet=11,
    kDelete=12,
    kUpdate=13,
    kCount=14,
    kGetAll=15
}QueryModeType;



@end
