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
#import "Group.h"
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

	//NSLog(@"Path: %@", filePath);
	db = [EGODatabase databaseWithPath:filePath];
	
	if ([db open]) {
	//	NSLog(@"Database is opened successfully!");
	} else {
		NSLog(@"Database is failed to open!");
	}
	return self;
}

- (BOOL) addFeed:(Feed *)aFeed {
	NSArray *params = [NSArray arrayWithObjects:[aFeed feedID],[aFeed title],[NSNumber numberWithInt:0], nil];
	return [db executeUpdate:@"Insert INTO Feed (FeedID, Title, UnreadCount) VALUES (?, ?, ?)" parameters:params];
}

- (NSArray *) getFeeds {
	
	EGODatabaseResult *rs = [db executeQuery:@"SELECT FeedID, Title, UnreadCount FROM Feed ORDER BY FeedID"];
	NSMutableArray *result = [[[NSMutableArray alloc] init] autorelease];
	
	for (EGODatabaseRow *row in rs) {
		Feed *aFeed = [[Feed alloc] init];
		[aFeed setFeedID:[row stringForColumn:@"FeedID"] ];
		[aFeed setTitle:[row stringForColumn:@"Title"]];
		[aFeed setUnreadCount:[NSNumber numberWithInt:[row intForColumn:@"UnreadCount"]]];
		[result addObject:aFeed];
		[aFeed release];
	}
	
	return result;
	
}

- (NSArray *) getFeedsWithGroupID:(NSString *)groupID {
	
	NSString *query = [[NSString alloc] initWithFormat:@"SELECT FeedID, Title, UnreadCount FROM Feed, Category_Feed WHERE Feed.FeedID = Category_Feed.FeedID AND GroupID= '%'",groupID];
	EGODatabaseResult *rs = [db executeQuery:query];
	NSMutableArray *result = [[[NSMutableArray alloc] init] autorelease];
	
	for (EGODatabaseRow *row in rs) {
		Feed *aFeed = [[Feed alloc] init];
		[aFeed setFeedID:[row stringForColumn:@"FeedID"] ];
		[aFeed setTitle:[row stringForColumn:@"Title"]];
		[aFeed setUnreadCount:[NSNumber numberWithInt:[row intForColumn:@"UnreadCount"]]];
		[result addObject:aFeed];
		[aFeed release];
	}
	
	[query release];
	return result;
	
}

- (NSArray *) getUnreadFeeds {
	
	EGODatabaseResult *rs = [db executeQuery:@"SELECT FeedID, Title, UnreadCount FROM Feed WHERE UnreadCount >0  ORDER BY FeedID"];
	NSMutableArray *result = [[[NSMutableArray alloc] init] autorelease];
	
	for (EGODatabaseRow *row in rs) {
		Feed *aFeed = [[Feed alloc] init];
		[aFeed setFeedID:[row stringForColumn:@"FeedID"] ];
		[aFeed setTitle:[row stringForColumn:@"Title"]];
		[aFeed setUnreadCount:[NSNumber numberWithInt:[row intForColumn:@"UnreadCount"]]];
		[result addObject:aFeed];
		[aFeed release];
	}
	
	return result;
	
}



- (BOOL) deleteFeedWithFeedID: (NSString *) feedID {
	NSString *query = [[[NSString alloc] initWithFormat:@"DELETE FROM Feed WHERE FeedID ='%@'", feedID] autorelease];
	//NSLog(@"Query : %@", query);

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
	[params release];
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
		[aNews setNewsID:[row stringForColumn:@"newsID"]];
		[aNews setTitle:[row stringForColumn:@"title"]];
		[aNews setSummary:[row stringForColumn:@"summary"]];
		[aNews setPublished:[NSDate dateWithTimeIntervalSince1970:[row intForColumn:@"published"]]];
		[result addObject:aNews];
		[aNews release];
	}
	

	[query release];
	return result;
}

- (NSArray *) getUnreadNewsItemsWithFeedID: (NSString *) feedID{
	NSString *query = [[NSString alloc] initWithFormat:@"SELECT * From NewsItem where feedID = '%@' AND unread = 1", feedID];
	EGODatabaseResult *rs = [db executeQuery:query];
	NSMutableArray *result = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
	
	NewsItem *aNews;
	for (EGODatabaseRow *row in rs ) {
	
		aNews = [[NewsItem alloc] init];
		[aNews setNewsID:[row stringForColumn:@"NewsID"]];
		[aNews setTitle:[row stringForColumn:@"title"]];
		[aNews setSummary:[row stringForColumn:@"summary"]];
		[aNews setPublished:[NSDate dateWithTimeIntervalSince1970:[row intForColumn:@"published"]]];
		[aNews setFeedID:[row stringForColumn:@"FeedID"]];
		[aNews setLink:[row stringForColumn:@"link"]];
		[aNews setUnread:[row boolForColumn:@"unread"]];
		[result addObject:aNews];
		
		[aNews release];
	}
	
	
	[query release];
	return result;
}


- (BOOL) addGroup:(NSString *)groupId withTitle:(NSString *)title{
	NSString *checkExistenceQuery = [[NSString alloc] initWithFormat:@"SELECT * FROM Category WHERE groupID ='%@'",groupId];
	EGODatabaseResult *checkResult = [db executeQuery:checkExistenceQuery];
	[checkExistenceQuery release];
	BOOL succeeded;
	if ([checkResult count] >0 ) {
	//	NSLog(@"Item already existed!");
		 
		return NO;
	}else {
		NSString *insertQuery = [[NSString alloc] initWithFormat:@"INSERT INTO Category (GroupID,title) VALUES ('%@', '%@')",groupId,title];
		succeeded = [db executeUpdate:insertQuery];
		if (!succeeded) {
			NSLog(@" %s -- at line %d with Error: %@", __FUNCTION__, __LINE__, [db lastErrorMessage]);
		}
		
		
		[insertQuery release];
	}
	

	
	
	return succeeded;
}

- (BOOL) addCategoryAndFeed:(NSString *) groupID feedID:(NSString *)feedID {
	//NSLog(@"FeedID and Group ID: %@ %@",feedID, groupID);
	NSString *checkExistenceQuery = [[NSString alloc] initWithFormat:@"SELECT * FROM Category_Feed WHERE groupID = '%@' AND feedID='%@'",groupID,feedID];
	//NSLog(@"Query %@", checkExistenceQuery);
	EGODatabaseResult *checkResults = [db executeQuery:checkExistenceQuery];
	[checkExistenceQuery release];
	BOOL succeeded = NO;
	if ([checkResults count]>0) {
	//	NSLog(@"This pair already existed");
		return NO;
		
	}else {
		NSString *insertQuery = [[NSString alloc] initWithFormat:@"INSERT INTO Category_Feed (GroupID, FeedID) VALUES ('%@', '%@')",groupID,feedID];
		succeeded = [db executeUpdate:insertQuery];
		
		if (!succeeded) {
				NSLog(@" %s -- at line %d with Error: %@", __FUNCTION__, __LINE__, [db lastErrorMessage]);
		}
		[insertQuery release];
	}

	
	return succeeded;
}

- (Group *) getGroupWithGroupID:(NSString *)groupID title:(NSString *)title{
	
	Group *aGroup = [[[Group alloc] init] autorelease];
	[aGroup setGroupID:groupID];
	[aGroup setTitle:title];
	
	NSString *getUnreadCountQuery = [[NSString alloc] initWithFormat:@"SELECT sum(Feed.UnreadCount) AS UnreadCount FROM Feed, Category, Category_Feed WHERE Category.GroupID = Category_Feed.GroupID AND Feed.FeedID = Category_Feed.FeedID AND Category.GroupID = '%@'",groupID];
	NSLog(@"Query : %@", getUnreadCountQuery);
	EGODatabaseResult *unreadRS = [db executeQuery:getUnreadCountQuery];
//Set Total Unread Count
	if ([unreadRS count] >0) {
		for (EGODatabaseRow *aRow in unreadRS ) {
			[aGroup setUnreadCount:[aRow intForColumn:@"UnreadCount"]];
			NSLog(@"Number of unread Count %d", [aGroup unreadCount]);
		}
		
	}else {
		NSLog(@"Something wrong");
		[aGroup setUnreadCount:0];
	}
//Set FeedList
	
	NSString *getFeedListQuery = [[NSString alloc] initWithFormat:@"SELECT Feed.FeedID as feedid,Feed.Title as title, Feed.UnreadCount as unreadcount FROM Feed, Category_Feed WHERE Feed.FeedID = Category_Feed.FeedID AND GroupID='%@'",groupID];
	
	EGODatabaseResult *feedListRS = [db executeQuery:getFeedListQuery];
	NSMutableDictionary *tmpFeedDict = [[NSMutableDictionary alloc] init];
	for (EGODatabaseRow *aRow in feedListRS) {
		Feed *aFeed = [[Feed alloc] init];
		[aFeed setTitle:[aRow stringForColumn:@"title"]];
		[aFeed setFeedID:[aRow stringForColumn:@"feedid"]];
		[aFeed setUnreadCount:[NSNumber numberWithInt:[aRow intForColumn:@"unreadcount"]]];
		 
		 [tmpFeedDict setObject:aFeed forKey:[aFeed feedID]];
		 [aFeed release];
	}
	
		 [aGroup setFeedsDict:[NSDictionary dictionaryWithDictionary:tmpFeedDict]];
	
	
	[tmpFeedDict release];
	[getFeedListQuery release];
	[getUnreadCountQuery release];
	return aGroup;
	
}

- (NSMutableArray *) getGroups {
	EGODatabaseResult *rs = [db executeQuery:@"SELECT * FROM Category"];
	NSMutableArray *result = [[[NSMutableArray alloc] init] autorelease];
	for (EGODatabaseRow *aRow in rs ) {
		Group *aGroup = [self getGroupWithGroupID:[aRow stringForColumn:@"GroupID"] title:[aRow stringForColumn:@"Title"]];
		[result addObject:aGroup];
		
	}
	return result;
}

- (Group *) getFullGroupWithGroupID:(NSString *)groupID {
	Group *aGroup = [[[Group alloc] init] autorelease];
	[aGroup setGroupID:groupID];

	NSString *query = [NSString stringWithFormat:@"SELECT Feed.FeedID as feedid, Feed.Title as title, feed.unreadcount as unreadcount FROM Feed, Category_Feed WHERE Feed.UnreadCount > 0 AND Feed.FeedID = Category_Feed.FeedID AND Category_Feed.GroupID ='%@'", groupID];
	aGroup.feedsList = [[NSMutableArray alloc] init];
	EGODatabaseResult *rs = [db executeQuery:query];
	for (EGODatabaseRow *aRow in rs) {
		Feed *aFeed = [[Feed alloc] init];
		[aFeed setFeedID: [aRow stringForColumn:@"feedid"] ];
		[aFeed setTitle:[aRow stringForColumn:@"title"]];
		[aFeed setUnreadCount:[NSNumber numberWithInt:[aRow intForColumn:@"unreadcount"]]];
		[aFeed setNewsItems:[NSMutableArray arrayWithArray:[self getUnreadNewsItemsWithFeedID:[aFeed feedID]]]];
		[[aGroup feedsList] addObject:aFeed];
		[aFeed release];
	}
	return aGroup;
	
}

//With options
- (NSArray *) getNewsItemsWithGroupID: (NSString *)groupID {
	NSString *getNewsItemQuery = [[NSString alloc] initWithFormat:@"SELECT NewsID, Unread, Published, Starred, Title, Summary, LInk, NewsItem.FeedID as FeedID FROM NewsItem, Category_Feed WHERE NewsItem.FeedID = Category_Feed.FeedID AND Category_Feed.GroupID = '%@' ORDER BY FeedID",groupID];
	
	EGODatabaseResult *rs = [db executeQuery:getNewsItemQuery];
	NSMutableArray *result = [[[NSMutableArray alloc] init] autorelease];
	
	for (EGODatabaseRow *aRow  in rs) {
		NewsItem *aNewsItem = [[NewsItem alloc] init];
		[aNewsItem setNewsID:[aRow stringForColumn:@"NewsID"]];
		[aNewsItem setTitle:[aRow stringForColumn:@"title"]];
	//	[aNewsItem setUnread:[aRow boolForColumn:@"unread"]];
	//	[aNewsItem setPublished:[aRow dateForColumn:@"published"]];
	//	[aNewsItem setStarred:[aRow boolForColumn:@"starred"]];
		[aNewsItem setFeedID:[aRow stringForColumn:@"FeedID"]];
		[aNewsItem setLink:[aRow stringForColumn:@"link"]];
		[aNewsItem setSummary:[aRow stringForColumn:@"summary"]];
		[result addObject:aNewsItem];
		[aNewsItem release];
	}
	
	[getNewsItemQuery release];
	return [NSArray arrayWithArray:result];
}

#pragma mark Update NewsItem
- (BOOL) setNewsAsRead:(NSString *) newsID {
	NSString *query = [NSString stringWithFormat:@"UPDATE NewsItem SET unread = 0 WHERE NewsID = '%@'", newsID];
	return [db executeUpdate:query];
	
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
