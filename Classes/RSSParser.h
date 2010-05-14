//
//  RSSParser.h
//  Simple RSS
//
//  Created by Manh Tuan Cao on 13/05/2010.
//  Copyright 2010 University of Sunderland. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    RSSParserTypeAbstract = -1,
    RSSParserTypeNSXMLParser = 0,
	RSSParserTypeLibXMLParser
} RSSParserType;

@class RSSParser, Feed;

// Protocol for the parser to communicate with its delegate.
@protocol RSSParser <NSObject>

@optional
// Called by the parser when parsing is finished.
- (void)parserDidEndParsingData:(RSSParser *)parser;
// Called by the parser in the case of an error.
- (void)parser:(RSSParser *)parser didFailWithError:(NSError *)error;
// Called by the parser when one or more Feeds have been parsed. This method may be called multiple times.
- (void)parser:(RSSParser *)parser didParsedItems:(NSArray *)parsedItems;

@end

@interface RSSParser : NSObject {
    id <RSSParser> delegate;
    NSMutableArray *parsedSongs;
    // This time interval is used to measure the overall time the parser takes to download and parse XML.
    NSTimeInterval startTimeReference;
    NSTimeInterval downloadStartTimeReference;
    double parseDuration;
    double downloadDuration;
    double totalDuration;
	
}

@end
