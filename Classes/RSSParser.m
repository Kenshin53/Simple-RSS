//
//  RSSParser.m
//  Simple RSS
//
//  Created by Manh Tuan Cao on 13/05/2010.
//  Copyright 2010 University of Sunderland. All rights reserved.
//

#import "RSSParser.h"
#import "EGODB.h"
#import "UserDefinedConst.h"
#import "JSON.h"
#import "ASIFormDataRequest.h"
#import "ASINetworkQueue.h"
#import "MySingleton.h"
#import "NewsItem.h"

@implementation RSSParser

+ (void) processSubscription:(NSString *)jsonString {
	
	
    NSDictionary *results = [jsonString JSONValue];
	
	NSArray *tempArray = [[NSArray alloc] initWithArray:[results objectForKey:@"subscriptions"]];
	
	EGODB *db = [[EGODB alloc] init];
	NSMutableSet *existingFeedID = [db getFeedID];
	NSMutableSet *downloadedFeedID = [[NSMutableSet alloc] init];
	
	NSMutableArray *downloadedFeeds = [[NSMutableArray alloc] init];
	
	for (NSDictionary *aFeed in tempArray) {
		
		Feed *tmpFeed = [[Feed alloc] initWithDictionary:aFeed];
		[downloadedFeedID addObject:[tmpFeed feedID]];
		[downloadedFeeds addObject:tmpFeed];
		//		NSLog(@"Feed ID: %@   Title: %@", [tmpFeed feedID], [tmpFeed title]);
		[tmpFeed release];
		
	}
	
	
	NSMutableSet *toDeleteSet = [[NSMutableSet alloc] initWithSet:existingFeedID];
	NSMutableSet *toInsertSet = [[NSMutableSet alloc] initWithSet:downloadedFeedID];
	
	[toDeleteSet minusSet:downloadedFeedID];
	[toInsertSet minusSet:existingFeedID];
	
	NSLog(@"toDelete after: %d", [toDeleteSet count]);
	NSLog(@"toInsert after : %d", [toInsertSet count]);	
	
	
	for (int i = 0; i < [downloadedFeeds count]; i++) {
		
		if ([toInsertSet containsObject:[[downloadedFeeds objectAtIndex:i] feedID]] ) {
			NSLog(@"Feed need to be inserted: %@", [[downloadedFeeds objectAtIndex:i] title]);
			[db addFeed:[downloadedFeeds objectAtIndex:i]];
		} else {
			//NSLog(@"Title: %@  -- already existed", [[downloadedFeeds objectAtIndex:i] title]);
		}
		
		
	}
	
	if ([toDeleteSet count] >0) {
		for (NSString *feedID in toDeleteSet) {
			NSLog(@"Delete feed: %@", feedID);
			[db deleteFeedWithFeedID:feedID];
		}
	}
	if ([toDeleteSet count] > 0 || [toInsertSet count] >0) {
		//Sending database changed notification
		[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationFeedListDidChanged object:nil];
	}
	
	[downloadedFeeds release];
	[downloadedFeedID release];
	[toDeleteSet release];
	[toInsertSet release];
	
	[tempArray release];
	//	[results release];
	
	
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[db release];
	
}


+ (void) processUnreadItemIDs: (NSString *) jsonString withNetworkQueue: (ASINetworkQueue *)queue{
	
	
	NSDictionary *results = [[NSDictionary alloc] initWithDictionary:[jsonString JSONValue]];
	NSArray *items = [results objectForKey:@"itemRefs"];
	NSMutableSet *downloadedNewsIDSet = [[NSMutableSet alloc] init];
	NSNumber *newsID;
	for (NSDictionary *item in items) {
		newsID = [NSNumber numberWithLongLong:[[item objectForKey:@"id"] longLongValue]];
		[downloadedNewsIDSet addObject:newsID];

		
	}
	
	EGODB *db = [[EGODB alloc] init];
	NSMutableSet *toInsertSet = [[NSMutableSet alloc] initWithSet:downloadedNewsIDSet];
	
	//Get existing news since keepUnreadPeriod days ago
	NSMutableSet *existingNewsIDSet = [db getArticleIDSinceTimeStamp:0];
	
	[toInsertSet minusSet:existingNewsIDSet];
	
	NSLog(@"Downloaded: %d   Existing: %d  toInsert: %d",[downloadedNewsIDSet count], [existingNewsIDSet count], [toInsertSet count]);
	


 NSURL *url = [[NSURL alloc] initWithString:kURLGetArticleContent];
	ASIFormDataRequest *request;
	int numberOfIDsInAPOST = 20;
	int i = 0;
	NSString *tokenID = [[MySingleton sharedInstance] tokenID];
	NSMutableString *postMessage;
	NSDictionary *info;
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *SID = [defaults objectForKey:@"googleSID"];
	NSString *cookie = [[NSString alloc] initWithFormat:@"SID=%@;Domain=.google.com;path=/;expires=1600000000",SID];

	for (NSNumber *newsID in toInsertSet) {
		if (i % numberOfIDsInAPOST == 0) {
			request= [[ASIFormDataRequest alloc] initWithURL:url];
			
			[request addRequestHeader:@"Cookie" value:cookie];
			info = [[NSDictionary alloc] initWithObjectsAndKeys:@"POSTUnreadIDs", @"RequestType",nil];
			[request setUserInfo:info];
			[info release];
			[request addPostValue: tokenID forKey:@"T"];
		}
		
		[request addPostValue:[NSString stringWithFormat:@"%qi",[newsID longLongValue]] forKey:@"i"];
		
		if (i % numberOfIDsInAPOST == 19 || i == [toInsertSet count]-1) {
	
			int numberOfActualIDs = i != [toInsertSet count]-1?numberOfIDsInAPOST : [toInsertSet count] % numberOfIDsInAPOST;
			for (int k = 0; k < numberOfActualIDs; k ++) {
				
				[request addPostValue:@"0" forKey:@"it"];
			}
		
		
			[queue addOperation:request];
			[request release];
			//[postMessage release];
		}
		i++;
		NSLog(@"Posted number: %qi",[newsID longLongValue]);
		
	}

	
	[url release];
	[cookie release];
	[toInsertSet release];
	[downloadedNewsIDSet release];
	[db release];
	[results release];
}

+ (void) addNewsItemsToDatabase: (NSString *) jsonString {
	NSDictionary *rs = [jsonString JSONValue];
	NSArray *newsItems = [[NSArray alloc] initWithArray:[rs objectForKey:@"items"]];
	NewsItem *news;

	EGODB *db = [[EGODB alloc] init];
	for (NSDictionary *item in newsItems) {
		news = [[NewsItem alloc] initWithDicitonary:item];
		NSLog(@"Hex: %@",[news newsID]);
		if (![db addNewsItem:news]) {
			NSLog(@"Unique ID"); 
		}
		[news release];
	}
	
	[db release];
	[newsItems release];
	
	
}

@end
