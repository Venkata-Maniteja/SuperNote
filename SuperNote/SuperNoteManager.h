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

typedef enum {
    kInsert=10,
    kGet=11,
    kDelete=12,
    kUpdate=13,
    kCount=14,
    kGetAll=15
}QueryMode;


@property (nonatomic, assign) BOOL  dataBaseCreated;
//@property (nonatomic, assign) BOOL  dataBaseCreated;
@property (nonatomic) QueryMode queryMode;

@property (nonatomic, strong) FMDatabase *database;
@property (nonatomic, strong) NSString *databasePath;
@property (nonatomic) NSString *currentTableName;  //removed strong

@property (nonatomic,strong) NSMutableDictionary *dataDic;
@property (nonatomic,strong) NSMutableArray *dataArray;



+ (SuperNoteManager*)sharedInstance;

-(void)createDatabaseAndTable;
-(void)queryDatabaseWithQuery:(NSString *) query;
-(void)clearDatabase;
-(void)loadDatabase;
-(BOOL)isDatabaseEmpty;
-(BOOL)checkForDataInAllTables;
-(void)deleteRowFromDatabaseWithRowID:(int)value;
-(NSMutableArray *)getDataFromDatabase;
//-(void)insertDataWithValues:(NSString *)value1 :(NSString *)value2;
-(void)insertDataWithText:(NSString *)value1  withDate:(NSString *)value2 withFilePath:(NSString *)value3;
-(NSMutableDictionary *)getStringForRowWithId:(int)notesID;
-(NSString*)getFilePathForRowWIthID:(int)notedID;
-(void)updateRecordWithRowID:(int)value withText:(NSString *)string withDate:(NSString *)value2;
-(void)updateRecordWithRowID:(int )value  withText:(NSAttributedString *) string withDate:(NSString *)value2 withFilePath:(NSString *)value3;

@end
