//
//  ArticleParser.m
//  Simple RSS
//
//  Created by Manh Tuan Cao on 13/05/2010.
//  Copyright 2010 University of Sunderland. All rights reserved.
//

#import "ArticleParser.h"
#import "EGODB.h"
#import "JSON.h"
#import "DateHelper.h"
#import "UserDefinedConst.h"
#import "EGODB.h"
#import "MySingleton.h"
@implementation ArticleParser

@synthesize delegate, parsedArticles, downloadAndParsePool, rssConnection, done, unreadItemIDs ;

- (void) dealloc {
	
	[parsedArticles release];
	[unreadItemIDs release];
	[super dealloc];
}


- (void) start {
	self.parsedArticles = [[NSMutableArray alloc ] initWithCapacity:0];
	self.unreadItemIDs = [[NSMutableArray alloc] initWithCapacity:0];
	doneListingUnread = NO;
	[NSThread  detachNewThreadSelector:@selector(downloadAndParse) toTarget:self withObject:nil];
	
}

- (void) downloadAndParse {
	
	if (done) {
		return;
	}
	downloadAndParsePool = [[NSAutoreleasePool alloc] init];
	
		//Setting Date for fetching data:
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *SID = [defaults objectForKey:@"googleSID"];	
	NSMutableURLRequest *getXMLRequest;
	NSString *cookie = [[NSString alloc] initWithFormat:@"SID=%@;Domain=.google.com;path=/;expires=1600000000",SID];
	
	if (!doneListingUnread) {

		NSInteger ck = [DateHelper getTimeStampFromNDaysAgo:1];
		NSString *urlString = [[NSString alloc] initWithFormat:kURLgetUnreadItemIDsFormat, ck];
		NSURL *url = [[NSURL alloc] initWithString:urlString];		
		getXMLRequest = [[NSMutableURLRequest alloc ] initWithURL: url ]; 
		[getXMLRequest setValue:[NSString stringWithString:cookie] forHTTPHeaderField:@"Cookie"];
		[urlString release];		
		[getXMLRequest setHTTPMethod: @"GET" ];
		[url release];
	} else {
		NSURL *url = [[NSURL alloc] initWithString:kURLGetArticleContent];		
		getXMLRequest = [[NSMutableURLRequest alloc ] initWithURL: url ]; 
		[getXMLRequest setValue:[NSString stringWithString:cookie] forHTTPHeaderField:@"Cookie"];
		[getXMLRequest setHTTPMethod: @"POST" ];
		NSString *postString = [[NSString alloc] initWithString:@"T=8QsSK0Glg1xKkRjjjdy8TA&i=-6013231960744277528&i=7377911055855070692&i=5213498259692358569&it=0&it=0&it=0"];
		
		NSString *postString2 = [[NSString alloc] init];
		NSString *tokenId = [[MySingleton sharedInstance] tokenID];
		NSLog(@"Token ID: %@",tokenId);
		
		
		postString2 = [postString2 stringByAppendingFormat:@"T=%@",tokenId];
		
		for (int i =0; i <3; i++) {
			postString2 = [postString2 stringByAppendingFormat:@"&i=%@",[unreadItemIDs objectAtIndex:i]];
			
		}
		
		for (int i =0; i<3; i++) {
			postString2= [postString2 stringByAppendingString:@"&it=0"];
		}
		
		NSLog(@"POST message: \n %@", postString2);
		NSString *msgLength = [NSString stringWithFormat:@"%d", [postString length]];
		[getXMLRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
		[getXMLRequest setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
		[postString release];
		[postString2 release];
		[url release];
	}

		
	
	
	// Testing of getting all the Unread Item in one request
	
	
	

	
	rssConnection = [[NSURLConnection alloc] initWithRequest:getXMLRequest delegate:self];
	jsonData = [[NSMutableData alloc] init];
    [self performSelectorOnMainThread:@selector(downloadStarted) withObject:nil waitUntilDone:NO];
	
#warning be careful with the done variable
	if (rssConnection != nil) {
        do {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        } while (!done);
    }
	
	[cookie release];

	[getXMLRequest release];
	self.rssConnection = nil;
	

		[downloadAndParsePool release];
		self.downloadAndParsePool = nil;
		
	
	
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    return nil;
}

// Forward errors to the delegate.
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    done = YES;
    [self performSelectorOnMainThread:@selector(parseError:) withObject:error waitUntilDone:NO];
	[jsonData release];
}

// Called when a chunk of data has been downloaded.
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	//    NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
	[jsonData appendData:data];
    // Process the downloaded chunk of data.
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self performSelectorOnMainThread:@selector(downloadEnded) withObject:nil waitUntilDone:NO];
	
    // Signal the context that parsing is complete by passing "1" as the last parameter.
	
	NSLog(@"Finished Downloading Feeds");
	done = YES; 	
	
	//  [self performSelectorOnMainThread:@selector(parseEnded) withObject:nil waitUntilDone:NO];
    // Set the condition which ends the run loop.
	
}

#pragma mark -
#pragma mark Supporting Methods

- (void)downloadStarted {
    NSAssert2([NSThread isMainThread], @"%s at line %d called on secondary thread", __FUNCTION__, __LINE__);
	NSLog(@"Download Started");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void) downloadEnded {
	NSAssert2([NSThread isMainThread], @"%s at line %d called on secondary thread", __FUNCTION__, __LINE__);
	
	
	NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
	
    NSLog(@"Downloaded %d byte", [jsonString length]* 2);
	NSLog(@"String %@:", jsonString);
    NSDictionary *results = [jsonString JSONValue];
	
	[parsedArticles removeAllObjects];
	
	
	if (!doneListingUnread) {
		NSArray *tempArray = [[NSArray alloc] initWithArray:[results objectForKey:@"itemRefs"]];
		for (NSDictionary *aItem in tempArray) {
			//NSLog(@"Printing Feed attributes");
			[self.unreadItemIDs addObject:[aItem objectForKey:@"id"]];

		}
		
		NSLog(@"Number of unread item since yesterday: %d", [self.unreadItemIDs count]);
		[tempArray release];	
		EGODB *db = [[EGODB alloc] init];
		ItemIDsFromDatabase = (NSArray *)[db getArticleIDSinceTimeStamp:1];
		[db release];
		doneListingUnread = YES;
		done = NO;
		[self downloadAndParse];
	} else 	{
		NSArray *tempArray = [[NSArray alloc] initWithArray:[results objectForKey:@"items"]];
		for (NSDictionary *aItem in tempArray) {
			//NSLog(@"Printing Feed attributes");
			NSLog(@"Title: %@",[aItem objectForKey:@"title"]);
			
		}
		
		NSLog(@"Number of unread item since yesterday: %d", [self.unreadItemIDs count]);
		[tempArray release];	
	}
		
//	//if (self.delegate != nil && [self.delegate respondsToSelector:@selector(parserDidEndParsingData:)]) {
//		[self.delegate parserDidEndParsingData:self];
//	}
	
//	[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationFinishedParsingArticles object:nil];
	

	[jsonString release];
	
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


@end
