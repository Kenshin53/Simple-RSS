//
//  GoogleReaderSync.m
//  Simple RSS
//
//  Created by Manh Tuan Cao on 6/3/10.
//  Copyright 2010 University of Sunderland. All rights reserved.
//

#import "GoogleReaderSync.h"
#import "EGODB.h"

@implementation GoogleReaderSync

+ (BOOL) setNewsAsRead:(NSString *) newsID {
	EGODB *db = [[EGODB alloc] init];
	[db setNewsAsRead:(NSString *) newsID];
	[db release];
	
	// !!!: Fix this return later - And remember to decrement the number of unread items in the group
	return YES;
}
@end
