//
//  Group.m
//  Simple RSS
//
//  Created by Manh Tuan Cao on 5/26/10.
//  Copyright 2010 University of Sunderland. All rights reserved.
//

#import "Group.h"


@implementation Group
@synthesize groupID,title, feedsDict, unreadCount, starredCount;

-(id) initWithGroupID:(NSString *)Id{
	[super init];
	
	return self;
}

@end
