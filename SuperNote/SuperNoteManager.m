//
//  SuperNoteManager.m
//  SuperNote
//
//  Created by Venkata Maniteja on 2016-01-11.
//  Copyright © 2016 Venkata Maniteja. All rights reserved.
//

#import "SuperNoteManager.h"
#import <FMDatabaseAdditions.h>

@implementation SuperNoteManager

+ (SuperNoteManager*)sharedInstance
{
    static SuperNoteManager *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[SuperNoteManager alloc] init];
        
//        [self createDatabase];
    });
    return _sharedInstance;
}


-(void)loadDatabase{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    _databasePath = [docsPath stringByAppendingPathComponent:@"SuperNoteDB.sqlite"];
    _database = [FMDatabase databaseWithPath:_databasePath];
    
    
    _dataDic=[[NSMutableDictionary alloc]init];
    _dataArray=[[NSMutableArray alloc]init];
    
    
}


-(void)createDatabaseAndTable{
    
    
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docsPath = [paths objectAtIndex:0];
        _databasePath = [docsPath stringByAppendingPathComponent:@"SuperNoteDB.sqlite"];
        
        _database = [FMDatabase databaseWithPath:_databasePath];
        
        [_database open];
        [_database executeUpdate:@"create table testNotes(notes text primary key, dTime text)"];
        
        _dataBaseCreated=YES;
        
        NSLog(@"Database created");
        NSLog(@"data base path is %@",_databasePath);
    
    [_dataDic removeAllObjects];
    [_dataArray removeAllObjects];
    
    _dataDic=[[NSMutableDictionary alloc]init];
    _dataArray=[[NSMutableArray alloc]init];
    
    
    
    [[NSUserDefaults standardUserDefaults]setObject:_databasePath forKey:@"DataBasePath"];
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"DatabaseCreated"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
        
    
    
    
}


-(void)queryDatabaseWithQuery:(NSString *) query{
    
    FMResultSet *results = [_database executeQuery:query];
    while([results next]) {
        NSString *notes = [results stringForColumn:@"notes"];
        NSString *dateTime  = [results stringForColumn:@"dTime"];
        NSLog(@"User: %@ - %@",notes, dateTime);
    }
    [_database close];
}


-(void)insertDataWithValues:(NSString *)value1 :(NSString *)value2{
    
    [_database open];
    [_database executeUpdate:@"insert into testNotes (notes,dTime) values (?,?)",value1,value2];
    [_database close];
}

-(void)clearDatabase{
    
    [_dataDic removeAllObjects];
    [_dataArray removeAllObjects];
    
    
    [_database open];
    [_database executeUpdate:@"delete from testNotes"];
    [_database close];
    
    
}

-(BOOL)isDatabaseEmpty{
    
    [_database open];
    
    if ([_database intForQuery:@"SELECT COUNT(notes) FROM testNotes"]==0){
        
        [_database close];
        return YES;
    }
    
    [_database close];
    return NO;
    
}



-(NSMutableArray *)getDataFromDatabase{
    
    [_dataArray removeAllObjects];
    [_dataDic removeAllObjects];
    
    [_database open];
    
    FMResultSet *results = [_database executeQuery:@"select * from testNotes"];
    while([results next]) {
        NSString *notes = [results stringForColumn:@"notes"];
        NSString *dateTime  = [results stringForColumn:@"dTime"];
        NSLog(@"User: %@ - %@",notes, dateTime);
        _dataDic=[[NSMutableDictionary alloc]init];
        [_dataDic setObject:notes forKey:@"Notes"];
        [_dataDic setObject:dateTime forKey:@"DateTime"];
        
        [_dataArray addObject:_dataDic];
    }
    [_database close];
    
    
    
    return _dataArray;
}

@end
