//
//  DBManager.h
//  IonNews
//
//  Created by Himanshu Rajput on 04/06/17.
//  Copyright © 2017 mantraLabsGlobal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBManager : NSObject
{
    NSString *databasePath;
}

+(DBManager*)getSharedInstance;
-(BOOL)createDB;
-(BOOL)saveData:(NSString *)contentName title:(NSString *)title content:(NSString*)content image:(NSString*)image crawl_url:(NSString*)crawl_url;
-(NSArray*) fetchDataFromSqlite;
-(void)deleteAllRows;
- (NSDictionary *)ArrangeData;

@end
