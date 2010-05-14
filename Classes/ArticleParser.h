//
//  ArticleParser.h
//  Simple RSS
//
//  Created by Manh Tuan Cao on 13/05/2010.
//  Copyright 2010 University of Sunderland. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ArticleParser;

@protocol ArticleParserDelegate <NSObject>
@optional 
-(void) parserDidEndParsingData:(ArticleParser *)parser;

- (void)parser:(ArticleParser *)parser didFailWithError:(NSError *)error;


@end



@interface ArticleParser : NSObject {
	id <ArticleParserDelegate> delegate;
	NSURLConnection *rssConnection;
	BOOL done;
	NSMutableData *jsonData;
	NSMutableArray *parsedArticles;
	NSMutableArray *unreadItemIDs;
	NSArray *ItemIDsFromDatabase;
	NSAutoreleasePool *downloadAndParsePool;
	BOOL doneListingUnread;
	
}

@property (nonatomic, assign) id <ArticleParserDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *parsedArticles;
@property (nonatomic, retain) NSMutableArray *unreadItemIDs;
@property BOOL done;
@property (nonatomic, retain) NSAutoreleasePool *downloadAndParsePool;
@property (nonatomic, retain) NSURLConnection *rssConnection;

- (void) start;
- (void)downloadStarted;
- (void) downloadEnded;



@end
