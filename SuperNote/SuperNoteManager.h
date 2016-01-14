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

@property (nonatomic, assign) BOOL  dataBaseCreated;
//@property (nonatomic, assign) BOOL  dataBaseCreated;


@property (nonatomic, strong) FMDatabase *database;
@property (nonatomic, strong) NSString *databasePath;

@property (nonatomic,strong) NSMutableDictionary *dataDic;
@property (nonatomic,strong) NSMutableArray *dataArray;

+ (SuperNoteManager*)sharedInstance;

-(void)createDatabaseAndTable;
-(void)queryDatabaseWithQuery:(NSString *) query;
-(void)clearDatabase;
-(void)loadDatabase;
-(BOOL)isDatabaseEmpty;
-(NSMutableArray *)getDataFromDatabase;
-(void)insertDataWithValues:(NSString *)value1 :(NSString *)value2;
@end
