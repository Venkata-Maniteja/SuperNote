//
//  SuperNoteManager.h
//  SuperNote
//
//  Created by Venkata Maniteja on 2016-01-11.
//  Copyright © 2016 Venkata Maniteja. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDatabase.h>

@interface SuperNoteManager : NSObject

@property (nonatomic, strong) FMDatabase *database;

+ (SuperNoteManager*)sharedInstance;

@end
