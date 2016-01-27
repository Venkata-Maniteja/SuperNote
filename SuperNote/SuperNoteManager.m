//
//  SuperNoteManager.m
//  SuperNote
//
//  Created by Venkata Maniteja on 2016-01-11.
//  Copyright © 2016 Venkata Maniteja. All rights reserved.
//

#import "SuperNoteManager.h"
#import <FMDatabaseAdditions.h>

NSString *const WorkTable = @"WorkTable";
NSString *const TempTable = @"TempTable";
NSString *const QucikTable = @"QuickTable";
NSString *const PersoTable = @"PersoTable";
NSString *const PassTable = @"PassTable";
NSString *const TestTable = @"TestTable";


@implementation SuperNoteManager

+ (SuperNoteManager*)sharedInstance
{
    static SuperNoteManager *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[SuperNoteManager alloc] init];
        
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

- (void)removeFile:(NSString *)fileName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
    NSError *error;
    BOOL success = [fileManager removeItemAtPath:filePath error:&error];
    if (success) {
        
        NSLog(@"FIle Deleted");
    }
    else
    {
        NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
    }
}


-(void)createDatabaseAndTable{
    
    
       [self removeFile:@"SuperNoteDB.sqlite"];
    
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docsPath = [paths objectAtIndex:0];
        _databasePath = [docsPath stringByAppendingPathComponent:@"SuperNoteDB.sqlite"];
        
        _database = [FMDatabase databaseWithPath:_databasePath];
        
        [_database open];
        [_database executeUpdate:@"create table testNotes(notesid integer primary key autoincrement, notes text , dTime text)"];
        [_database executeUpdate:@"create table work(notesid integer primary key autoincrement, notes text , dTime text)"];
        [_database executeUpdate:@"create table temp(notesid integer primary key autoincrement, notes text , dTime text)"];
        [_database executeUpdate:@"create table quickNotes(notesid integer primary key autoincrement, notes text , dTime text)"];
        [_database executeUpdate:@"create table personal(notesid integer primary key autoincrement, notes text , dTime text)"];
        [_database executeUpdate:@"create table password(passid integer primary key autoincrement, passName text , passWord text)"];
        _database.logsErrors=YES;
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

-(NSString *)getQueryStringWithQueryMode:(QueryMode )mode{
    
    switch (mode) {
            
        case kGetAll:
            
            if ([_currentTableName isEqualToString:TestTable]) {
                return @"select * from testNotes";
            }else if ([_currentTableName isEqualToString:WorkTable]) {
                return @"select * from work";
            }else if ([_currentTableName isEqualToString:TempTable]) {
                return @"select * from temp";
            }else if ([_currentTableName isEqualToString:QucikTable]) {
                return @"select * from quickNotes";
            }else if ([_currentTableName isEqualToString:PassTable]) {
                return @"select * from password";
            }else if ([_currentTableName isEqualToString:PersoTable]) {
                return @"select * from personal";
            }

            
            break;
            
        case kGet:
            
            if ([_currentTableName isEqualToString:TestTable]) {
                return @"select * from testNotes where notesid= ?";
            }else if ([_currentTableName isEqualToString:WorkTable]) {
                return @"select * from work where notesid= ?";
            }else if ([_currentTableName isEqualToString:TempTable]) {
                return @"select * from temp where notesid= ?";
            }else if ([_currentTableName isEqualToString:QucikTable]) {
                return @"select * from quickNotes where notesid= ?";
            }else if ([_currentTableName isEqualToString:PassTable]) {
                return @"select * from password where passid= ?";
            }else if ([_currentTableName isEqualToString:PersoTable]) {
                return @"select * from personal where passid= ?";
            }

            break;
        case kInsert:
            
            if ([_currentTableName isEqualToString:TestTable]) {
                return @"insert into testNotes (notes,dTime) values (?,?)";
            }else if ([_currentTableName isEqualToString:WorkTable]) {
                return @"insert into work (notes,dTime) values (?,?)";
            }else if ([_currentTableName isEqualToString:TempTable]) {
                return @"insert into temp (notes,dTime) values (?,?)";
            }else if ([_currentTableName isEqualToString:QucikTable]) {
                return @"insert into quickNotes (notes,dTime) values (?,?)";
            }else if ([_currentTableName isEqualToString:PassTable]) {
                return @"insert into password (passWord,dTime) values (?,?)";
            }else if ([_currentTableName isEqualToString:PersoTable]) {
                return @"insert into personal (notes,dTime) values (?,?)";
            }
            
            break;
            
        case kUpdate:
            
            if ([_currentTableName isEqualToString:TestTable]) {
                return @"update testNotes set notes=?,dTime=? where notesid=?";
            }else if ([_currentTableName isEqualToString:WorkTable]) {
                return @"update work set notes=?,dTime=? where notesid=?";
            }else if ([_currentTableName isEqualToString:TempTable]) {
                return @"update temp set notes=?,dTime=? where notesid=?";
            }else if ([_currentTableName isEqualToString:QucikTable]) {
                return @"update quickNotes set notes=?,dTime=? where notesid=?";
            }else if ([_currentTableName isEqualToString:PassTable]) {
                return @"update password set notes=?,dTime=? where notesid=?";
            }else if ([_currentTableName isEqualToString:PersoTable]) {
                return @"update password set passWord=?,dTime=? where passid=?";
            }
                
            
            break;
        case kDelete:
            
            if ([_currentTableName isEqualToString:TestTable]) {
                return @"delete from testNotes where notesid=%d";
            }else if ([_currentTableName isEqualToString:WorkTable]) {
                return @"delete from work where notesid=%d";
            }else if ([_currentTableName isEqualToString:TempTable]) {
                return @"delete from temp where notesid=%d";
            }else if ([_currentTableName isEqualToString:QucikTable]) {
                return @"delete from quickNotes where notesid=%d";
            }else if ([_currentTableName isEqualToString:PassTable]) {
                return @"delete from password where notesid=%d";
            }else if ([_currentTableName isEqualToString:PersoTable]) {
                return @"delete from personal where notesid=%d";
            }

            
            break;
            
        case kCount:
            
            if ([_currentTableName isEqualToString:TestTable]) {
                return @"SELECT COUNT(notes) FROM testNotes";
            }else if ([_currentTableName isEqualToString:WorkTable]) {
                return @"SELECT COUNT(notes) FROM work";
            }else if ([_currentTableName isEqualToString:TempTable]) {
                return @"SELECT COUNT(notes) FROM temp";
            }else if ([_currentTableName isEqualToString:QucikTable]) {
                return @"SELECT COUNT(notes) FROM quickNotes";
            }else if ([_currentTableName isEqualToString:PassTable]) {
                return @"SELECT COUNT(notes) FROM password";
            }else if ([_currentTableName isEqualToString:PersoTable]) {
                return @"SELECT COUNT(notes) FROM personal";
            }
            
            break;
            
        default:
            break;
    }
    
    
    return @"";
}
-(NSString *)getStringForRowWithId:(int)notesID{
    
    //check for the current table name and change the query
    
    [_database open];
    FMResultSet *results = [_database executeQuery:[self getQueryStringWithQueryMode:_queryMode],@(notesID)];
    NSString *notes;
    while([results next]) {
        if ([_currentTableName isEqualToString:TestTable]) {
             notes = [results stringForColumn:@"pass"];
        }else{
        notes = [results stringForColumn:@"notes"];
        }
    }
    if ([_database hadError]) {
        NSLog(@"DB Error %d: %@", [_database  lastErrorCode], [_database lastErrorMessage]);
    }

    [_database close];
    
    return notes;
}


-(void)insertDataWithValues:(NSString *)value1 :(NSString *)value2{
    
    [_database open];
    [_database executeUpdate:[self getQueryStringWithQueryMode:_queryMode],value1,value2];
    [_database close];
}


-(void)updateRecordWithRowID:(int)value withText:(NSString *)string withDate:(NSString *)value2{
    
    if ([_database open] != YES) {
        NSLog(@"DB Error %d: %@", [_database lastErrorCode], [_database lastErrorMessage]);
    }
    
    [_database beginTransaction];
    BOOL success =[_database executeUpdate:[self getQueryStringWithQueryMode:_queryMode],string,value2,[NSNumber numberWithInt:value]];
    
    
    if (success) {
        NSLog(@"OK");
        [_database commit];
        [_database close];
    }else {
        NSLog(@"FAIL");
         [_database close];
    }

    
}

-(void)clearDatabase{
    
    [_dataDic removeAllObjects];
    [_dataArray removeAllObjects];
    
    
    [_database open];
    [_database executeUpdate:@"delete from testNotes"];
    [_database executeUpdate:@"delete from quickNotes"];
    [_database executeUpdate:@"delete from work"];
    [_database executeUpdate:@"delete from temp"];
    [_database executeUpdate:@"delete from personal"];
    [_database executeUpdate:@"delete from password"];
    [_database close];
    
    
}

-(void)deleteRowFromDatabaseWithRowID:(int)value{
    
    [_database open];
    [_database executeUpdate:[NSString stringWithFormat:[self getQueryStringWithQueryMode:_queryMode],value]];
    [_database close];
    
    
}

-(BOOL)isDatabaseEmpty{
    
    [_database open];
    
    if ([_database intForQuery:[self getQueryStringWithQueryMode:_queryMode]]==0){
        
        [_database close];
        return YES;
    }
    
    [_database close];
    return NO;
    
}

-(BOOL)checkForDataInAllTables{
    
    [_database open];
    if (!([_database intForQuery:@"SELECT COUNT(notes) FROM testNotes"]==0&&[_database intForQuery:@"SELECT COUNT(notes) FROM work"]==0&&[_database intForQuery:@"SELECT COUNT(notes) FROM temp"]==0&&[_database intForQuery:@"SELECT COUNT(notes) FROM quickNotes"]==0&&[_database intForQuery:@"SELECT COUNT(notes) FROM personal"]==0&&[_database intForQuery:@"SELECT COUNT(pass) FROM password"]==0)){
        
        [_database close];
        return NO;
    }
    
    [_database close];
    return YES;
}



-(NSMutableArray *)getDataFromDatabase{
    
    [_dataArray removeAllObjects];
    [_dataDic removeAllObjects];
    
    [_database open];
    
    FMResultSet *results = [_database executeQuery:[self getQueryStringWithQueryMode:_queryMode]];
    while([results next]) {
        NSString *notes = [results stringForColumn:@"notes"];
        NSString *dateTime  = [results stringForColumn:@"dTime"];
        int notesID=[results intForColumn:@"notesid"];
        NSLog(@"User: %@ - %@",notes, dateTime);
        _dataDic=[[NSMutableDictionary alloc]init];
        [_dataDic setObject:[NSNumber numberWithInt:notesID] forKey:@"NotesID"];
        [_dataDic setObject:notes forKey:@"Notes"];
        [_dataDic setObject:dateTime forKey:@"DateTime"];
        
        
        
        [_dataArray addObject:_dataDic];
    }
    [_database close];
    
    
    
    return _dataArray;
}


@end
