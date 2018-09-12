//
//  DBManager.m
//  IonNews
//
//  Created by Himanshu Rajput on 04/06/17.
//  Copyright © 2017 mantraLabsGlobal. All rights reserved.
//

#import "DBManager.h"
static DBManager *sharedInstance = nil;
static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;

@implementation DBManager

+(DBManager*)getSharedInstance{
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL]init];
        [sharedInstance createDB];
    }
    return sharedInstance;
}

-(BOOL)createDB{
    NSString *docsDir;
    NSArray *dirPaths;
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString:
                    [docsDir stringByAppendingPathComponent: @"ionNews.db"]];
    BOOL isSuccess = YES;
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if ([filemgr fileExistsAtPath: databasePath ] == NO)
    {
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &database) == SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt = "create table if not exists ionNewsDetail (contentName text, title text, content text, image text, crawl_url text)";
            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
                != SQLITE_OK)
            {
                isSuccess = NO;
                NSLog(@"Failed to create table");
            }
            sqlite3_close(database);
            return  isSuccess;
        }
        else {
            isSuccess = NO;
            NSLog(@"Failed to open/create database");
        }
    }
    return isSuccess;
}

-(BOOL)saveData:(NSString *)contentName title:(NSString *)title content:(NSString *)content image:(NSString *)image crawl_url:(NSString *)crawl_url{
    BOOL isYes = NO;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK){
        NSString *insertSQL = [NSString stringWithFormat:@"insert into ionNewsDetail (contentName, title, content, image, crawl_url) values(\"%@\",\"%@\",\"%@\", \"%@\", \"%@\")",contentName ,title,
                               content, image, crawl_url];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        
        
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"INSERTED");
            isYes = YES;
        }
        else {
            NSLog(@"Error %s \n",sqlite3_errmsg(database));
            NSLog(@"NO INSERTED %@ \n %@ \n %@ \n %@ \n %@ \n", contentName, title, content, image, crawl_url);
            isYes = NO;
        }
        sqlite3_finalize(statement);
        return isYes;
    }
    return NO;
}


- (NSArray*) fetchDataFromSqlite
{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM ionNewsDetail "];
        const char *query_stmt = [querySQL UTF8String];
        NSMutableArray *resultArray = [[NSMutableArray alloc]init];
        if (sqlite3_prepare_v2(database,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            NSLog(@" %d, %d ",sqlite3_step(statement),SQLITE_ROW);
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                NSDictionary *dict;
                NSString *contentName = [[NSString alloc] initWithUTF8String:
                                  (const char *) sqlite3_column_text(statement, 0)];
            
                NSString *title = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 1)];
                
                NSString *content = [[NSString alloc]initWithUTF8String:
                                  (const char *) sqlite3_column_text(statement, 2)];
                
                NSString *image = [[NSString alloc]initWithUTF8String:
                                     (const char *) sqlite3_column_text(statement, 3)];
                
                NSString *crawl_url = [[NSString alloc]initWithUTF8String:
                                     (const char *) sqlite3_column_text(statement, 4)];
                dict = @{@"contentName":contentName,
                         @"title":title,
                         @"content":content,
                         @"image":image,
                         @"crawl_url":crawl_url
                         };
                
                [resultArray addObject:dict];
                }
    
            sqlite3_finalize(statement);
            return resultArray;
        }
    }
    return nil;
}

- (NSArray*) fetchDataFromSqliteOnlyContenentName
{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT contentName FROM ionNewsDetail "];
        const char *query_stmt = [querySQL UTF8String];
        NSMutableArray *resultArray = [[NSMutableArray alloc]init];
        if (sqlite3_prepare_v2(database,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            NSLog(@" %d, %d ",sqlite3_step(statement),SQLITE_ROW);
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                NSString *contentName = [[NSString alloc] initWithUTF8String:
                                         (const char *) sqlite3_column_text(statement, 0)];

                
                [resultArray addObject:contentName];
            }
            
            sqlite3_finalize(statement);
            return resultArray;
        }
    }
    return nil;
}


- (NSDictionary *)ArrangeData {
    
    NSMutableDictionary * stories = [[NSMutableDictionary alloc]init];
    
    
    NSArray * contents =[ self fetchDataFromSqliteOnlyContenentName];
    
    
    NSMutableSet * setOne = [NSMutableSet setWithArray:contents];
    NSMutableSet * setTwo = [NSMutableSet setWithArray:contents];
    [setOne unionSet:setTwo];
    NSArray * results = [setOne allObjects];
    
    if (results.count > 0) {
        NSArray * mainInfo = [self fetchDataFromSqlite];
        
        for (int i = 0; i < results.count; i++) {
            NSMutableArray * responseData = [[NSMutableArray alloc]init];
            for (int j = 0; j < mainInfo.count; j++) {
                if ([[[results objectAtIndex:i]lowercaseString ] isEqualToString:[[[mainInfo objectAtIndex:j] objectForKey:@"contentName"] lowercaseString]]) {
                    [responseData addObject:[mainInfo objectAtIndex:j]];
                }
            }
            [stories setObject:responseData forKey:[results objectAtIndex:i]];
        }
    }
    return  stories;
}


-(void)deleteAllRows{
    const char *dbpath = [databasePath UTF8String];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSString *dbPath =[documentsDir stringByAppendingPathComponent:@"ionNews.db"];
    BOOL success = [fileManager fileExistsAtPath:dbPath];
    sqlite3_stmt *selectstmt;
    if(!success)
    {
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"ionNews.db"];
        success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
        
        if (!success)
            NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        //*************** insert value in database******************************\\
        
        NSString  *sql = [NSString stringWithFormat:@"delete from ionNewsDetail"];
        const char *insert_stmt = [sql UTF8String];
        sqlite3_prepare_v2(database,insert_stmt, -1, &selectstmt, NULL);
        if(sqlite3_step(selectstmt)==SQLITE_DONE)
        {
            NSLog(@"Delete successfully");
        }
        else
        {
            NSLog(@"Delete not successfully");
            
        }
        sqlite3_finalize(selectstmt);
        sqlite3_close(database);
    }
}


@end
