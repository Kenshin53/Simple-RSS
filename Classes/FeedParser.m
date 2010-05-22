//
//  FeedParser.m
//  Simple RSS
//
//  Created by Manh Tuan Cao on 04/05/2010.
//  Copyright 2010 University of Sunderland. All rights reserved.
//

#import "FeedParser.h"
#import "JSON.h"
#import "GoogleReaderHelper.h"
#import "EGODatabase.h"
#import "Feed.h"
#import "EGODB.h"
#import "MySingleton.h"

@implementation FeedParser
@synthesize delegate, parsedFeeds, downloadAndParsePool, rssConnection, done ;

- (void) dealloc {
	
	[parsedFeeds release];
	
	[super dealloc];
}

- (void) start {
	self.parsedFeeds = [[NSMutableArray alloc ] initWithCapacity:0];
	
	[NSThread  detachNewThreadSelector:@selector(downloadAndParse) toTarget:self withObject:nil];
	
}

- (void) downloadAndParse {
	//NSString *atomURL = [NSString stringWithString:url];
	downloadAndParsePool = [[NSAutoreleasePool alloc] init];
	
	

	

	
	NSURL *url = [[NSURL alloc] initWithString:@"http://www.google.com/reader/api/0/subscription/list?allcomments=true&output=json&ck=1255643091105&client=scroll"];

	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *SID = [defaults objectForKey:@"googleSID"];
//	Code for getting TokenID	
	[[MySingleton sharedInstance] setTokenID:[GoogleReaderHelper getTokenID:SID]];
// Testing of getting all the Unread Item in one request

	
	NSMutableURLRequest *getXMLRequest = [[NSMutableURLRequest alloc ] initWithURL: url ]; 
	
	NSString *cookie = [[NSString alloc] initWithFormat:@"SID=%@;Domain=.google.com;path=/;expires=1600000000",SID];
	
	[getXMLRequest setValue:[NSString stringWithString:cookie] forHTTPHeaderField:@"Cookie"];
	[getXMLRequest setHTTPMethod: @"GET" ];
	
	rssConnection = [[NSURLConnection alloc] initWithRequest:getXMLRequest delegate:self];
	jsonData = [[NSMutableData alloc] init];
    [self performSelectorOnMainThread:@selector(downloadStarted) withObject:nil waitUntilDone:NO];
	
	if (rssConnection != nil) {
        do {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        } while (!done);
    }
	
	
	
	

	[cookie release];
	[url release];
	[getXMLRequest release];
	self.rssConnection = nil;
	
	[downloadAndParsePool release];
	self.downloadAndParsePool = nil;

}

#pragma mark - 
#pragma mark <URLConnectionDelegate> Methods

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
    NSDictionary *results = [jsonString JSONValue];
	[parsedFeeds removeAllObjects];
	
	NSArray *tempArray = [[NSArray alloc] initWithArray:[results objectForKey:@"subscriptions"]];
	
	EGODB *db = [[EGODB alloc] init];
	
	
	for (NSDictionary *aFeed in tempArray) {
		//NSLog(@"Printing Feed attributes");
		Feed *tmpFeed = [[Feed alloc] initWithDictionary:aFeed];
		[parsedFeeds addObject:tmpFeed];
#pragma mark IMPORTANT		
//might need to check if the feed is already existed
		[db addFeed:tmpFeed];
		NSLog(@"Feed ID: %@   Title: %@", [tmpFeed feedID], [tmpFeed title]);
		[tmpFeed release];
		
		
	}
	[db release];
	NSLog(@"Number of feeds: %d", [parsedFeeds count]);
	
	if (self.delegate != nil && [self.delegate respondsToSelector:@selector(parserDidEndParsingData:)]) {
		[self.delegate parserDidEndParsingData:self];
	}
	
	
	[tempArray release];
	//	[results release];
	[jsonString release];
	
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

@end
