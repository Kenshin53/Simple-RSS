//
//  EGODB.m
//  Simple RSS
//
//  Created by Manh Tuan Cao on 11/05/2010.
//  Copyright 2010 University of Sunderland. All rights reserved.
//

#import "EGODB.h"
#import "Feed.h"
#import "DateHelper.h"
#import "NewsItem.h"
@implementation EGODB

-(void) dealloc {
	[db close];
	[super dealloc];
}
-(id)init {
	if (![super init]) {
		return nil;
	}
	
	NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"SimpleRSS.sqlite"];

	NSLog(@"Path: %@", filePath);
	db = [EGODatabase databaseWithPath:filePath];
	
	if ([db open]) {
		NSLog(@"Database is opened successfully!");
	} else {
		NSLog(@"Database is failed to open!");
	}
	return self;
}

- (BOOL) addFeed:(Feed *)aFeed {
	NSArray *params = [NSArray arrayWithObjects:[aFeed feedID], [aFeed title], nil];
	[db executeUpdate:@"Insert INTO Feed (FeedID, Title) VALUES (?, ?)" parameters:params];
}

- (NSArray *) getFeeds {
	
	EGODatabaseResult *rs = [db executeQuery:@"SELECT FeedID, Title FROM Feed ORDER BY FeedID"];
	NSMutableArray *result = [[[NSMutableArray alloc] init] autorelease];
	
	for (EGODatabaseRow *row in rs) {
		Feed *aFeed = [[Feed alloc] init];
		[aFeed setFeedID:[row stringForColumn:@"FeedID"] ];
		[aFeed setTitle:[row stringForColumn:@"Title"]];
		[result addObject:aFeed];
		[aFeed release];
	}
	
	return result;
	
}

- (BOOL) deleteFeedWithFeedID: (NSString *) feedID {
	NSString *query = [[[NSString alloc] initWithFormat:@"DELETE FROM Feed WHERE FeedID ='%@'", feedID] autorelease];
	NSLog(@"Query : %@", query);

	return [db executeUpdate:query];
}

- (NSMutableSet *) getFeedID {
	
	EGODatabaseResult *rs = [db executeQuery:@"SELECT FeedID FROM Feed ORDER BY FeedID"];
	NSMutableSet *result = [[[NSMutableSet alloc] init] autorelease];
	
	for (EGODatabaseRow *row in rs) 
		[result addObject:[row stringForColumn:@"FeedID"]];
	
	
	return result;
	
}

- (NSMutableSet *) getArticleIDSinceTimeStamp: (NSInteger) timeStamp{
	NSString *query = [[NSString alloc] initWithFormat:@"SELECT newsID from NewsItem where published > %d AND unread ==1 ", timeStamp ];
	NSMutableSet *result = [[[NSMutableSet alloc] init] autorelease];
	
	//NSLog(@"Query string: %@", query);
	EGODatabaseResult *rs = [db executeQuery:query];
	for (EGODatabaseRow *row in rs) {

		NSNumber *newsID = [EGODB hexString2Number:[row stringForColumn:@"NewsID"]];
	//	NSLog(@"Hex: %@ --> Decimal: %qi",[row stringForColumn:@"NewsID"], [newsID longLongValue]);
		[result addObject:newsID];
	}
	
	[query release];
	return result;
}


- (BOOL) addNewsItem: (NewsItem *) aNewsItem {
	NSArray *params = [[NSArray alloc] initWithObjects:[aNewsItem newsID], [NSNumber numberWithInt:[aNewsItem unread]],[aNewsItem published] ,
					   [aNewsItem title],[aNewsItem link], [aNewsItem summary], [aNewsItem feedID], nil];
	
	BOOL succeeded = [db executeUpdate:@"INSERT INTO NewsItem (NewsID, unread, published, title, link, summary, FeedID) VALUES (?, ?, ?, ?, ?, ?, ?)"  parameters:params];
	if (!succeeded) {
		NSLog(@"%s Insert Error : %@",__FUNCTION__,[db lastErrorMessage]);
		
		 
	}
	return succeeded;
//	NSLog(@"Print Query: %@",query);
	
	
}

- (NSArray *) getNewsItemsWithFeedID: (NSString *) feedID{
	NSString *query = [[NSString alloc] initWithFormat:@"SELECT * From NewsItem where feedID = '%@'", feedID];
	EGODatabaseResult *rs = [db executeQuery:query];
	NSMutableArray *result = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
	
	NewsItem *aNews;
	for (EGODatabaseRow *row in rs ) {
		aNews = [[NewsItem alloc] init];
		[aNews setTitle:[row stringForColumn:@"title"]];
		[aNews setSummary:[row stringForColumn:@"summary"]];
		[aNews setPublished:[NSDate dateWithTimeIntervalSince1970:[row intForColumn:@"published"]]];
		[result addObject:aNews];
		[aNews release];
	}
	

	[query release];
	return result;
}

+ (NSNumber *) hexString2Number: (NSString *)hex {
	long long result =0;
	
	int digitValue = 0;
	for (int i=0; i < [hex length]; i++) {
		
		char currentCharacter = [hex characterAtIndex:i];
		if (currentCharacter >= '0' && currentCharacter <='9' ) {
			digitValue = currentCharacter- '0';
			
		} else if ( currentCharacter >= 'a' &&  currentCharacter <= 'f') {
			digitValue = currentCharacter - 'a' +10;
		} else 	if (currentCharacter >= 'A' && currentCharacter <= 'F') {
			digitValue = currentCharacter - 'A' + 10;
		} else {
			return [NSNumber numberWithLongLong:-1];
		}
		result = result * 16 + digitValue;
	}
	return [NSNumber numberWithLongLong:result];
}

@end
