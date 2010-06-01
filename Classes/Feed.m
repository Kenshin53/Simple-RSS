//
//  Feed.m
//  Simple RSS
//
//  Created by Manh Tuan Cao on 08/05/2010.
//  Copyright 2010 University of Sunderland. All rights reserved.
//

#import "Feed.h"


@implementation Feed

@synthesize feedID,title,originalURL, unreadCount, lastUpdate, newsItems;

- (void) dealloc {
	[feedID release];
	[title release];
	[originalURL release];
	[unreadCount release];
	[lastUpdate release];
	[newsItems release];
	
}

- (id) initWithDictionary: (NSDictionary *) aFeed {
	
	[self setFeedID:[aFeed objectForKey:@"id"]];
	[self setTitle:[aFeed objectForKey:@"title"]];
		 
	return self;
}
@end
