//
//  DB.m
//  Simple RSS
//
//  Created by Manh Tuan Cao on 11/05/2010.
//  Copyright 2010 University of Sunderland. All rights reserved.
//

#import "DB.h"


@implementation DB

-(void) dealloc {
	[db close];
	[super dealloc];
}

- (id)init {
	if (![super init]) {
		return nil;
	}
	NSString *path = [[NSBundle mainBundle] pathForResource:@"SimpleRSS" ofType:@"db"];
	db = [FMDatabase databaseWithPath:path];
	[db setLogsErrors:YES];
	[db setTraceExecution:YES];
	
	if ([db open]) {
		NSLog(@"Database is opened successfully!");
	} else {
		NSLog(@"Database is failed to open!");
	}
	return self;
}

- (void) addFeed:(Feed *)aFeed {
	
	NSString *strQuery = [[NSString alloc] initWithFormat:@"insert into Feed (FeedID, Title, OriginalURL, UnreadCount) values ('%@', '%@', '%@', %d)",[aFeed feedID], [aFeed title], [aFeed originalURL], [[aFeed unreadCount] intValue]] ;
	[db beginTransaction];
	[db executeUpdate:@"Insert INTO Feed (FeedID, Title) VALUES (?, ?)", [aFeed feedID], [aFeed title]];
	[db commit];
	[strQuery release];
	
}

- (void) setFeed:(NSString *)feedId with:(Feed *)aFeed {
}

- (NSArray *) getFeeds {
	FMResultSet *results = [db executeQuery:@"SELECT * FROM Feed"];
	while ([results next]) {
		NSLog(@"%@ %@ %@ %d	", [results stringForColumn:@"FeedID"], [results stringForColumn:@"Title"],[results stringForColumn:@"OriginalURL"], [results intForColumn:@"UnreadCount"]);
	}
	
}

@end
