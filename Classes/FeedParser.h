//
//  FeedParser.h
//  Simple RSS
//
//  Created by Manh Tuan Cao on 04/05/2010.
//  Copyright 2010 University of Sunderland. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FeedParser;
@protocol FeedParserDelegate <NSObject>

@optional 
-(void) parserDidEndParsingData:(FeedParser *)parser;

- (void)parser:(FeedParser *)parser didFailWithError:(NSError *)error;


@end


@interface FeedParser : NSObject {
	id <FeedParserDelegate> delegate;
	NSURLConnection *rssConnection;
	BOOL done;
	NSMutableData *jsonData;
	NSMutableArray *parsedFeeds;
	NSAutoreleasePool *downloadAndParsePool;
}


@property (nonatomic, assign) id <FeedParserDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *parsedFeeds;
@property BOOL done;
@property (nonatomic, retain) NSAutoreleasePool *downloadAndParsePool;
@property (nonatomic, retain) NSURLConnection *rssConnection;

- (void) start;
- (void)downloadStarted;
- (void) downloadEnded;



@end
