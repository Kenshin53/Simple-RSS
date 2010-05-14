//
//  EGODB.m
//  Simple RSS
//
//  Created by Manh Tuan Cao on 11/05/2010.
//  Copyright 2010 University of Sunderland. All rights reserved.
//

#import "EGODB.h"
#import "Feed.h"

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
	
	EGODatabaseResult *rs = [db executeQuery:@"SELECT FeedID, Title FROM Feed"];
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

- (NSArray *) getArticleIDSinceReferedDate: (NSInteger) days{
	return [NSArray arrayWithObjects:@"0fcf6f3da05b5bcf",nil];
}

@end
