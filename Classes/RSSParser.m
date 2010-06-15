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
		NSArray *categories = [aFeed objectForKey:@"categories"];
		for (NSDictionary *category in categories) {
			[db addCategoryAndFeed:[category objectForKey:@"id"] feedID:[tmpFeed feedID]];
		}
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
	
	
	

	[db release];
	
}


+ (void) processUnreadItemIDs: (NSString *) jsonString withNetworkQueue: (ASINetworkQueue *)queue{
	
	[queue setMaxConcurrentOperationCount:3];
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
//	NSString *tokenID = [[MySingleton sharedInstance] tokenID];
	//NSMutableString *postMessage;
	NSDictionary *info;
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *SID = [defaults objectForKey:@"googleSID"];
	
	
	NSDictionary *properties = [[NSDictionary alloc] initWithObjectsAndKeys:@"SID",NSHTTPCookieName, SID,NSHTTPCookieValue,@".google.com",NSHTTPCookieDomain, @"/",NSHTTPCookiePath,@"16000000",NSHTTPCookieExpires, nil];
	
	NSHTTPCookie *cookie = [[NSHTTPCookie alloc] initWithProperties:properties];
	if (cookie != nil ) {
		NSLog(@"Created Cookies");
	} else {
		NSLog(@"Failed Creating cookies");
	}
	
	
	NSString *tokenID = [[MySingleton sharedInstance] tokenID];
	
	

	for (NSNumber *newsID in toInsertSet) {
		if (i % numberOfIDsInAPOST == 0) {
			request= [[ASIFormDataRequest alloc] initWithURL:url];
			
			//[request addRequestHeader:@"Cookie" value:cookie];
			[request setRequestCookies:[NSMutableArray arrayWithObject:cookie]];
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
		
		
	}
	
	
	
	[url release];
	[cookie release];
	[toInsertSet release];
	[downloadedNewsIDSet release];
	[db release];
	[results release];

//	[RSSParser addFaviconRequests: queue];
}


+ (void) addFaviconRequests:(ASINetworkQueue *)queue {
	
	int oldCount = [[[MySingleton sharedInstance] faviconPaths] count];
	
						   
	EGODB *db = [[EGODB alloc] init];
	NSSet *feedIDs = [db getFeedID];
	int i =0;
	for (NSString *aFeedID in feedIDs) {
		
		i++;
	/*	if (i == 10) {
			break;
		}
	 */
		if ([[[MySingleton sharedInstance] faviconPaths] objectForKey:aFeedID] == nil) {
			
			NSURL *url = [RSSParser getFaviconURL:aFeedID];
			if (url != nil) {
				NSString *fileName = [NSString stringWithFormat:@"fav_%d.ico",i];
				NSString *actualPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:fileName];			
				ASIHTTPRequest  *request = [[[ASIHTTPRequest alloc] initWithURL:url] autorelease];
				NSDictionary *info = [[[NSDictionary alloc] initWithObjectsAndKeys:@"Favicon", @"RequestType",actualPath,@"FileName",aFeedID, @"FeedID", nil] autorelease];
				[request setDownloadDestinationPath:actualPath];
				[request setUserInfo:info];
				[request setTimeOutSeconds:60];
				[queue addOperation:request];
				
			} else {
				[[[MySingleton sharedInstance] faviconPaths] setObject:@"None" forKey:aFeedID];
			//	NSLog(@"Number of mysingleton count %d", [[[MySingleton sharedInstance] faviconPaths] count]);
			}
		}else {
			//NSLog(@"Skip this FeedID: %@ ", aFeedID);
		}
	}
	
//If the number of Key/value changed, save it to disk
	if ([[[MySingleton sharedInstance] faviconPaths] count] >oldCount) {
		NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"FaviconsPath.plist"];

		[[[MySingleton sharedInstance] faviconPaths] writeToFile:filePath atomically:YES];
	}
	[db release];
}
			




+ (void) processDownloadedFavicon:(ASIHTTPRequest *)request {
	//NSLog(@"Get Respond from POST request : %d byte", [[request responseString] length]);
//	NSLog(@"FileName : %@", [[request userInfo] objectForKey:@"FileName"]);
//	NSLog(@"The respond Code: %d", [request responseStatusCode]);
//	NSLog(@"URL: %@", [[request url] absoluteURL] );
	if ([request responseStatusCode] == 200) {
		[[[MySingleton sharedInstance] faviconPaths] setObject:[[request userInfo] objectForKey:@"FileName"] forKey:[[request userInfo] objectForKey:@"FeedID"]];
	}else if ([request responseStatusCode] == 404) {
		[[[MySingleton sharedInstance] faviconPaths] setObject:@"None" forKey:[[request userInfo] objectForKey:@"FeedID"]];
	}else {
		NSLog(@"---------------ERROR------------ %s at Line %d ", __FUNCTION__, __LINE__);
	}

		 
	

//	NSLog(@"FeedID: %@", [[request userInfo] objectForKey:@"FeedID"]);
	//[[[MySingleton sharedInstance] faviconPaths] writeToFile: atomically:<#(BOOL)useAuxiliaryFile#>]
}	

+ (void) addNewsItemsToDatabase: (NSString *) jsonString {
	NSDictionary *rs = [jsonString JSONValue];
	NSArray *newsItems = [[NSArray alloc] initWithArray:[rs objectForKey:@"items"]];
	NewsItem *news;

	EGODB *db = [[EGODB alloc] init];
	for (NSDictionary *item in newsItems) {
		news = [[NewsItem alloc] initWithDicitonary:item];
	
		if (![db addNewsItem:news]) {
			NSLog(@"%s at Line %d: Insert news item error.", __FUNCTION__, __LINE__);
		}else {
			[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNewsItemAdded object:news];
		}

		[news release];
	}
	
	[db release];
	[newsItems release];
	
	
}

+ (void) processTagList:(NSString *)jsonString {
	
	NSDictionary *rs = [jsonString JSONValue];
	NSArray *tagList = [rs objectForKey:@"tags"];
	EGODB *db = [[EGODB alloc] init];
	BOOL changed = NO;
	for (NSDictionary *tag in tagList ) {
		NSString *tagId = [[NSString alloc] initWithString: [tag objectForKey:@"id"]];
		NSRange position = [ tagId  rangeOfString:@"/" options:NSBackwardsSearch];
		
		NSString *groupTitle =[[NSString alloc] initWithString:[tagId substringFromIndex:position.location +1 ]];
		
		NSRange labelPos = [tagId rangeOfString:@"label" options:NSBackwardsSearch];
		
		if (labelPos.location != NSNotFound) {
			if ([db addGroup:tagId withTitle:groupTitle]) {
				changed = YES;
			}
		}
	
		[groupTitle release];
		[tagId release];
		
	}
	if (changed) {
		[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationAddedNewFolder object:nil];
		
	}

	[db release];
}



+ (NSURL *) getFaviconURL: (NSString *)feedID {
	NSString *urlStr = [feedID substringFromIndex:5];
	NSURL *tmpURL = [NSURL URLWithString:urlStr];
	NSString *domain = [tmpURL host];
	NSString *faviconURL = [NSString stringWithFormat:@"http://%@/favicon.ico",domain];
	//NSLog(@"Favicon URL: %@", faviconURL);
	if ([faviconURL rangeOfString:@"feedburner"].location != NSNotFound) {
		return nil;
	}
	return [NSURL URLWithString:faviconURL];
}


@end
