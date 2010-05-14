//
//  DB.h
//  Simple RSS
//
//  Created by Manh Tuan Cao on 11/05/2010.
//  Copyright 2010 University of Sunderland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "Feed.h"

@interface DB : NSObject {
	FMDatabase *db;
}

- (void) addFeed:(Feed *) aFeed;
- (void) setFeed:(NSString *) feedId with:(Feed *)aFeed;
- (NSArray *) getFeeds;
@end
