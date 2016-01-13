//
//  SuperNoteManager.m
//  SuperNote
//
//  Created by Venkata Maniteja on 2016-01-11.
//  Copyright © 2016 Venkata Maniteja. All rights reserved.
//

#import "SuperNoteManager.h"

@implementation SuperNoteManager

+ (SuperNoteManager*)sharedInstance
{
    static SuperNoteManager *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[SuperNoteManager alloc] init];
        
        [self createDatabase];
    });
    return _sharedInstance;
}


-(void)createDatabaseAndTable{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    NSString *path = [docsPath stringByAppendingPathComponent:@"SuperNoteDB.sqlite"];
    
    _database = [FMDatabase databaseWithPath:path];
    
    [_database open];
    [_database executeUpdate:@"create table user(name text primary key, age int)"];

}


-(void)queryDatabaseWithQuery:(NSString *) query{
    
    FMResultSet *results = [_database executeQuery:@"select * from user"];
    while([results next]) {
        NSString *name = [results stringForColumn:@"name"];
        NSInteger age  = [results intForColumn:@"age"];
        NSLog(@"User: %@ - %d",name, age);
    }
    [_database close];
}

+(void)clearDatabase{
    
}



+(NSArray *)getDataFromDatabase{
    
    NSArray *temp;
    
    return temp;
}

@end
