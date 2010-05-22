//
//  NewsItem.m
//  Simple RSS
//
//  Created by Manh Tuan Cao on 5/20/10.
//  Copyright 2010 University of Sunderland. All rights reserved.
//

#import "NewsItem.h"


@implementation NewsItem

@synthesize newsID, feedID, title, published, link, summary, author, unread, starred;

-(id) initWithDicitonary:(NSDictionary *) aNewsItem {
	
//Set newsID
	NSString *searchString = @"/";
	NSRange position = [ [aNewsItem objectForKey:@"id"] rangeOfString:searchString options:NSBackwardsSearch];
	NSString *newsIDStr = [[aNewsItem objectForKey:@"id"] substringFromIndex:position.location +1 ];

	[self setNewsID:newsIDStr];
// Set News Titile
	[self setTitle:[aNewsItem objectForKey:@"title"]];

//Set FeedID 
	[self setFeedID:[[aNewsItem objectForKey:@"origin"] objectForKey:@"streamId"]];
	
//Set published date

	[self setPublished:[NSDate dateWithTimeIntervalSince1970:[[aNewsItem objectForKey:@"published"] doubleValue] ]];

//Set link
	[self setLink:[[[aNewsItem objectForKey:@"alternate"] objectAtIndex:0]objectForKey:@"href"]];
//Set Author
	[self setAuthor:[aNewsItem objectForKey:@"author"]];
//Set Unread
	[self setUnread:YES];
//Set Summary 
	NSDictionary *content = [aNewsItem objectForKey:@"content"] != nil ?[aNewsItem objectForKey:@"content"] : [aNewsItem objectForKey:@"summary"];
	
	[self setSummary:[content objectForKey:@"content"]];
	if ([aNewsItem objectForKey:@"content"] == nil & [aNewsItem objectForKey:@"summary"] == nil) {
		[self setSummary:@"(No Description)."];
	}
	return self;
}

-(void) dealloc {
	[newsID release];
	[feedID release];
	[title release];
	[published release];
	[link release];
	[summary release];
	[author release];
	
	
	[super dealloc];
}

@end
