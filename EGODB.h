//
//  EGODB.h
//  Simple RSS
//
//  Created by Manh Tuan Cao on 11/05/2010.
//  Copyright 2010 University of Sunderland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EGODatabase.h"
#import "Feed.h"
@interface EGODB : NSObject {

	EGODatabase *db;
}
- (BOOL) addFeed:(Feed *) aFeed;
- (NSArray *) getFeeds ;
- (NSArray *) getArticleIDSinceReferedDate: (NSInteger) days;	


@end
